package com.billing.users;

import com.billing.users.dto.AttenderData;
import com.billing.users.dto.AttenderSaveRequest;
import com.billing.users.dto.ChangePasswordRequest;
import com.billing.users.dto.CreateUserRequest;
import com.billing.users.dto.DiscountUpdateRequest;
import com.billing.users.dto.ModuleData;
import com.billing.users.dto.PermissionUpdateRequest;
import com.billing.users.dto.UserDiscountData;
import com.billing.users.dto.UserOptionData;
import com.billing.users.dto.UserPermissionsData;
import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.PreparedStatement;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class UserAdminService {

    private final JdbcTemplate jdbcTemplate;
    private final PasswordEncoder passwordEncoder;
    private final UserModuleCatalog userModuleCatalog;

    public List<ModuleData> modules() {
        userModuleCatalog.ensureCatalog();
        return jdbcTemplate.query(
                "SELECT m.id, m.module_name, IFNULL(m.is_group, 1) AS is_group, IFNULL(m.group_id, 0) AS group_id "
                        + "FROM user_modules m "
                        + "WHERE IFNULL(m.is_active, 1) = 1 "
                        + "AND (IFNULL(m.is_group, 1) = 1 OR IFNULL(m.group_id, 0) = 0 OR EXISTS ("
                        + "  SELECT 1 FROM user_modules g WHERE g.id = m.group_id AND IFNULL(g.is_active, 1) = 1"
                        + ")) "
                        + "ORDER BY IF(IFNULL(m.is_group,1)=1, m.id, m.group_id), IFNULL(m.is_group,1) DESC, m.id",
                (rs, i) -> {
                    ModuleData row = new ModuleData();
                    row.setId(rs.getLong("id"));
                    row.setName(rs.getString("module_name"));
                    row.setIsGroup(rs.getInt("is_group"));
                    row.setGroupId(rs.getInt("group_id"));
                    return row;
                }
        );
    }

    public List<UserOptionData> users() {
        return jdbcTemplate.query(
                "SELECT id, user_name, IFNULL(fullName,'') AS fullName " +
                        "FROM users WHERE is_active = 1 ORDER BY fullName, user_name",
                (rs, i) -> mapUserOption(rs.getLong("id"), rs.getString("user_name"), rs.getString("fullName"))
        );
    }

    @Transactional
    public void createUser(CreateUserRequest request) {
        String fullName = required(request.getFullName(), "Full name is required");
        String userName = required(request.getUserName(), "Username is required");
        String password = required(request.getPassword(), "Password is required");
        Integer existing = jdbcTemplate.query(
                "SELECT id FROM users WHERE user_name = ?",
                rs -> rs.next() ? rs.getInt(1) : 0,
                userName
        );
        if (existing != null && existing > 0) {
            throw new RuntimeException("Username already exists!");
        }
        KeyHolder keys = new GeneratedKeyHolder();
        jdbcTemplate.update(con -> {
            PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO users(user_name, password, is_active, fullName) VALUES (?, ?, 1, ?)",
                    Statement.RETURN_GENERATED_KEYS
            );
            ps.setString(1, userName);
            ps.setString(2, passwordEncoder.encode(password));
            ps.setString(3, fullName);
            return ps;
        }, keys);
        Number key = keys.getKey();
        if (key == null) {
            throw new RuntimeException("Failed to create user");
        }
        long uid = key.longValue();
        saveModulePermissions(uid, request.getModuleIds());
    }

    public UserPermissionsData modulePermissions(Long userId) {
        UserPermissionsData data = new UserPermissionsData();
        data.setUserId(userId);
        data.setName(userDisplayName(userId));
        data.setAll(modules());
        data.setSelectedIds(expandPermissions(jdbcTemplate.query(
                "SELECT module_id FROM user_permission WHERE uid = ?",
                (rs, i) -> rs.getLong(1),
                userId
        )));
        return data;
    }

    @Transactional
    public void updateModulePermissions(Long userId, PermissionUpdateRequest request) {
        requireUser(userId);
        jdbcTemplate.update("DELETE FROM user_permission WHERE uid = ?", userId);
        saveModulePermissions(userId, request == null ? null : request.getIds());
    }

    public UserPermissionsData specialPermissions(Long userId) {
        UserPermissionsData data = new UserPermissionsData();
        data.setUserId(userId);
        data.setName(userDisplayName(userId));
        data.setAll(jdbcTemplate.query(
                "SELECT id, content FROM special_permission ORDER BY id",
                (rs, i) -> {
                    ModuleData row = new ModuleData();
                    row.setId(rs.getLong("id"));
                    row.setName(rs.getString("content"));
                    return row;
                }
        ));
        data.setSelectedIds(jdbcTemplate.query(
                "SELECT content_id FROM user_special_permission WHERE user_id = ?",
                (rs, i) -> rs.getLong(1),
                userId
        ));
        return data;
    }

    @Transactional
    public void updateSpecialPermissions(Long userId, PermissionUpdateRequest request) {
        requireUser(userId);
        jdbcTemplate.update("DELETE FROM user_special_permission WHERE user_id = ?", userId);
        List<Long> ids = request == null || request.getIds() == null ? List.of() : request.getIds();
        for (Long permissionId : ids) {
            if (permissionId == null) {
                continue;
            }
            jdbcTemplate.update(
                    "INSERT INTO user_special_permission (content_id, user_id) VALUES (?, ?)",
                    permissionId, userId
            );
        }
    }

    public List<AttenderData> attenders() {
        return jdbcTemplate.query(
                "SELECT id, name, code, is_active FROM attender ORDER BY name",
                (rs, i) -> {
                    AttenderData row = new AttenderData();
                    row.setId(rs.getLong("id"));
                    row.setName(rs.getString("name"));
                    row.setCode(rs.getString("code") == null ? "" : rs.getString("code"));
                    row.setIsActive(rs.getInt("is_active"));
                    return row;
                }
        );
    }

    @Transactional
    public void saveAttender(AttenderSaveRequest request) {
        String name = required(request.getName(), "Name is required");
        String code = request.getCode() == null ? "" : request.getCode().trim();
        if (request.getId() != null && request.getId() > 0) {
            int updated = jdbcTemplate.update(
                    "UPDATE attender SET name = ?, code = ? WHERE id = ?",
                    name, code, request.getId()
            );
            if (updated == 0) {
                throw new RuntimeException("Attender not found");
            }
        } else {
            jdbcTemplate.update("INSERT INTO attender (name, code, is_active) VALUES (?, ?, 1)", name, code);
        }
    }

    @Transactional
    public void setAttenderActive(Long id, boolean active) {
        int updated = jdbcTemplate.update("UPDATE attender SET is_active = ? WHERE id = ?", active ? 1 : 0, id);
        if (updated == 0) {
            throw new RuntimeException("Attender not found");
        }
    }

    @Transactional
    public void changePassword(Long uid, ChangePasswordRequest request) {
        if (request == null) {
            throw new RuntimeException("Missing required parameters.");
        }
        String oldPassword = required(request.getOldPassword(), "Existing password is required");
        String newPassword = required(request.getNewPassword(), "New password is required");
        String confirm = request.getConfirmPassword() == null ? "" : request.getConfirmPassword();
        if (oldPassword.equals(newPassword)) {
            throw new RuntimeException("Old password and new password should not match!");
        }
        if (!confirm.equals(newPassword)) {
            throw new RuntimeException("New password and confirm password should match!");
        }
        List<String> rows = jdbcTemplate.query(
                "SELECT password FROM users WHERE id = ? AND is_active = 1",
                (rs, i) -> rs.getString(1),
                uid
        );
        if (rows.isEmpty() || !passwordEncoder.matches(oldPassword, rows.get(0))) {
            throw new RuntimeException("Your existing password is wrong!");
        }
        jdbcTemplate.update("UPDATE users SET password = ? WHERE id = ?", passwordEncoder.encode(newPassword), uid);
    }

    public List<UserDiscountData> discounts() {
        return jdbcTemplate.query(
                "SELECT id, user_name, IFNULL(fullName,'') AS fullName, IFNULL(disc_per, 100) AS disc_per " +
                        "FROM users WHERE is_active = 1 ORDER BY user_name",
                (rs, i) -> {
                    UserDiscountData row = new UserDiscountData();
                    row.setId(rs.getLong("id"));
                    row.setUserName(rs.getString("user_name"));
                    row.setFullName(rs.getString("fullName"));
                    row.setDiscPer(rs.getInt("disc_per"));
                    return row;
                }
        );
    }

    @Transactional
    public void updateDiscount(Long userId, DiscountUpdateRequest request) {
        requireUser(userId);
        int discPer = request == null || request.getDiscPer() == null ? -1 : request.getDiscPer();
        if (discPer < 0 || discPer > 100) {
            throw new RuntimeException("Discount must be between 0 and 100");
        }
        jdbcTemplate.update("UPDATE users SET disc_per = ? WHERE id = ?", discPer, userId);
    }

    private void saveModulePermissions(Long uid, List<Long> moduleIds) {
        if (moduleIds == null) {
            return;
        }
        for (Long moduleId : normalizePermissions(moduleIds)) {
            jdbcTemplate.update(
                    "INSERT INTO user_permission (uid, module_id, date, time) VALUES (?, ?, NOW(), NOW())",
                    uid, moduleId
            );
        }
    }

    /** Old users with only a main-menu id get every submenu of that group. */
    private List<Long> expandPermissions(List<Long> raw) {
        Set<Long> selected = new LinkedHashSet<>();
        if (raw != null) {
            for (Long id : raw) {
                if (id != null) {
                    selected.add(id);
                }
            }
        }
        List<ModuleData> all = modules();
        Map<Long, List<Long>> children = all.stream()
                .filter(m -> m.getIsGroup() != null && m.getIsGroup() == 0 && m.getGroupId() != null && m.getGroupId() > 0)
                .collect(Collectors.groupingBy(
                        m -> m.getGroupId().longValue(),
                        Collectors.mapping(ModuleData::getId, Collectors.toList())
                ));
        for (Map.Entry<Long, List<Long>> e : children.entrySet()) {
            boolean hasChild = e.getValue().stream().anyMatch(selected::contains);
            if (selected.contains(e.getKey()) && !hasChild) {
                selected.addAll(e.getValue());
            }
            if (hasChild) {
                selected.add(e.getKey());
            }
        }
        return new ArrayList<>(selected);
    }

    private List<Long> normalizePermissions(List<Long> moduleIds) {
        Set<Long> selected = new LinkedHashSet<>();
        for (Long id : moduleIds) {
            if (id != null) {
                selected.add(id);
            }
        }
        Map<Long, Long> childToParent = modules().stream()
                .filter(m -> m.getIsGroup() != null && m.getIsGroup() == 0 && m.getGroupId() != null && m.getGroupId() > 0)
                .collect(Collectors.toMap(ModuleData::getId, m -> m.getGroupId().longValue(), (a, b) -> a));
        Set<Long> parents = new HashSet<>();
        for (Long id : List.copyOf(selected)) {
            Long parent = childToParent.get(id);
            if (parent != null) {
                parents.add(parent);
            }
        }
        selected.addAll(parents);
        return new ArrayList<>(selected);
    }

    private void requireUser(Long userId) {
        Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM users WHERE id = ?",
                Integer.class,
                userId
        );
        if (count == null || count == 0) {
            throw new RuntimeException("User not found");
        }
    }

    private String userDisplayName(Long userId) {
        List<UserOptionData> rows = jdbcTemplate.query(
                "SELECT id, user_name, IFNULL(fullName,'') AS fullName FROM users WHERE id = ?",
                (rs, i) -> mapUserOption(rs.getLong("id"), rs.getString("user_name"), rs.getString("fullName")),
                userId
        );
        if (rows.isEmpty()) {
            throw new RuntimeException("User not found");
        }
        return rows.get(0).getName();
    }

    private UserOptionData mapUserOption(Long id, String userName, String fullName) {
        UserOptionData row = new UserOptionData();
        row.setId(id);
        row.setUserName(userName);
        row.setFullName(fullName);
        String display = fullName == null || fullName.isBlank()
                ? userName
                : fullName + " (" + userName + ")";
        row.setName(display);
        return row;
    }

    private String required(String value, String message) {
        if (value == null || value.trim().isEmpty()) {
            throw new RuntimeException(message);
        }
        return value.trim();
    }
}
