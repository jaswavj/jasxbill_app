package com.billing.license;

import com.billing.core.license.LicenseValidator;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class HeadingLicenseService implements LicenseValidator {

    public static final String EXPIRED_MESSAGE =
            "Your license is expired please Contact JasXbill no-8667214152";

    private final JdbcTemplate jdbcTemplate;

    @PostConstruct
    public void init() {
        ensureStartingDateColumn();
    }

    @Override
    public void validateForLogin() {
        Long id = headingId();
        if (id == null) {
            return;
        }
        LocalDate start = ensureStartingDate(id);
        int activeDays = activeDays(id);
        if (activeDays < 0) {
            throw new RuntimeException(EXPIRED_MESSAGE);
        }
        LocalDate today = LocalDate.now();
        LocalDate lastValidDay = start.plusDays(activeDays);
        if (today.isAfter(lastValidDay)) {
            throw new RuntimeException(EXPIRED_MESSAGE);
        }
    }

    private Long headingId() {
        List<Long> ids = jdbcTemplate.query(
                "SELECT id FROM heading ORDER BY id LIMIT 1",
                (rs, rowNum) -> rs.getLong("id")
        );
        return ids.isEmpty() ? null : ids.get(0);
    }

    private LocalDate ensureStartingDate(long id) {
        Object raw = columnValue(id, "starting_date");
        if (raw == null) {
            raw = columnValue(id, "date");
        }
        LocalDate start = toLocalDate(raw);
        if (start == null) {
            start = LocalDate.now();
        }
        if (hasColumn("starting_date") && columnValue(id, "starting_date") == null) {
            jdbcTemplate.update("UPDATE heading SET starting_date = ? WHERE id = ?", start, id);
        }
        return start;
    }

    private int activeDays(long id) {
        Integer active = jdbcTemplate.queryForObject(
                "SELECT active FROM heading WHERE id = ?",
                Integer.class,
                id
        );
        return active == null ? 0 : active;
    }

    private Object columnValue(long id, String column) {
        if (!hasColumn(column)) {
            return null;
        }
        List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                "SELECT `" + column + "` FROM heading WHERE id = ?",
                id
        );
        if (rows.isEmpty()) {
            return null;
        }
        return rows.get(0).get(column);
    }

    private void ensureStartingDateColumn() {
        if (hasColumn("starting_date")) {
            return;
        }
        try {
            jdbcTemplate.execute("ALTER TABLE heading ADD COLUMN starting_date date DEFAULT NULL");
            if (hasColumn("date")) {
                jdbcTemplate.update(
                        "UPDATE heading SET starting_date = `date` "
                                + "WHERE starting_date IS NULL AND `date` IS NOT NULL "
                                + "AND CAST(`date` AS CHAR) NOT IN ('', '0000-00-00', '0000-00-00 00:00:00')"
                );
            }
        } catch (Exception ignored) {
            // older shop DBs keep working via the date fallback
        }
    }

    private boolean hasColumn(String name) {
        try {
            Integer count = jdbcTemplate.queryForObject(
                    "SELECT COUNT(*) FROM information_schema.COLUMNS "
                            + "WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'heading' AND COLUMN_NAME = ?",
                    Integer.class,
                    name
            );
            return count != null && count > 0;
        } catch (Exception ignored) {
            return false;
        }
    }

    private static LocalDate toLocalDate(Object raw) {
        if (raw == null) {
            return null;
        }
        if (raw instanceof LocalDate date) {
            return date;
        }
        if (raw instanceof java.sql.Date sqlDate) {
            return sqlDate.toLocalDate();
        }
        if (raw instanceof java.util.Date utilDate) {
            return new java.sql.Date(utilDate.getTime()).toLocalDate();
        }
        String value = String.valueOf(raw).trim();
        if (value.isEmpty() || value.startsWith("0000-00-00") || "null".equalsIgnoreCase(value)) {
            return null;
        }
        if (value.length() >= 10) {
            value = value.substring(0, 10);
        }
        try {
            return LocalDate.parse(value);
        } catch (DateTimeParseException ignored) {
            return null;
        }
    }
}
