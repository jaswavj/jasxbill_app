package com.billing.users;

import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

/**
 * Main menus are is_group=1. Sub menus are is_group=0 with group_id = parent id.
 * Existing shops keep ids 1–12; leaf screens are seeded from 101.
 */
@Component
@Order(Ordered.HIGHEST_PRECEDENCE)
@RequiredArgsConstructor
public class UserModuleCatalog {

    private final JdbcTemplate jdbcTemplate;

    private static final Object[][] MODULES = {
            {1, "Billing", 1, 0},
            {2, "Master", 1, 0},
            {3, "Stock Reports", 1, 0},
            {4, "User management", 1, 0},
            {5, "Inventory", 1, 0},
            {6, "Account Report", 1, 0},
            {7, "Admin", 1, 0},
            {8, "Statistics", 1, 0},
            {10, "Credit Management", 1, 0},
            {11, "Order list", 1, 0},
            {12, "Expense", 1, 0},

            {101, "Category", 0, 2},
            {102, "Brands", 0, 2},
            {103, "Product", 0, 2},
            {104, "Config Product Material", 0, 2},
            {105, "Product Master", 0, 2},
            {106, "Stock Management", 0, 2},
            {107, "Customers", 0, 2},
            {108, "Cafe Tables", 0, 2},
            {109, "Units", 0, 2},
            {110, "Bar Code", 0, 2},

            {111, "Supplier", 0, 5},
            {112, "Purchase Entry", 0, 5},
            {113, "Purchase Return", 0, 5},
            {114, "Purchase Report", 0, 5},
            {115, "Purchase Return Report", 0, 5},
            {116, "Supplier Payment Report", 0, 5},

            {117, "Profit Analysis Report", 0, 8},
            {118, "Dashboard", 0, 8},
            {119, "Category Sales Statistics", 0, 8},
            {120, "Product Analysis Report", 0, 8},

            {121, "Current Stock", 0, 3},
            {122, "Zero Stock Report", 0, 3},
            {123, "Product Transaction", 0, 3},
            {124, "Stock Adjustment", 0, 3},

            {125, "Sales Report", 0, 6},
            {126, "Sales by Category", 0, 6},
            {127, "Sales by Department", 0, 6},
            {128, "Sales by Product", 0, 6},
            {129, "Sales by Customer", 0, 6},
            {130, "Sales by Attender", 0, 6},
            {131, "Day Book", 0, 6},
            {132, "Commission Report", 0, 6},
            {133, "GSTR-1", 0, 6},
            {134, "Sales Summary", 0, 6},
            {135, "Bill Wise Sales GST", 0, 6},
            {136, "Item Wise Sales GST", 0, 6},
            {137, "HSN Sales GST", 0, 6},
            {138, "Purchase GST", 0, 6},
            {139, "Purchase GST Summary", 0, 6},

            {140, "Customers Balance", 0, 10},
            {141, "Supplier Payment", 0, 10},

            {142, "Create User", 0, 4},
            {143, "Module Permission", 0, 4},
            {144, "Special Permission", 0, 4},
            {145, "Attender Management", 0, 4},
            {146, "User Discount", 0, 4},

            {147, "Company Details", 0, 7},
            {148, "Edit Bill", 0, 7},
            {149, "Edit Log", 0, 7},
            {150, "Exchange", 0, 7},
            {151, "Exchange & Return Report", 0, 7},

            {152, "Expense Type", 0, 12},
            {153, "Expense Entry", 0, 12},
            {154, "Expense Report", 0, 12},
    };

    @PostConstruct
    public void ensureCatalog() {
        ensureColumn("is_group", "int NOT NULL DEFAULT 1");
        ensureColumn("group_id", "int NOT NULL DEFAULT 0");
        ensureColumn("is_active", "int NOT NULL DEFAULT 1");
        for (Object[] row : MODULES) {
            upsert((int) row[0], (String) row[1], (int) row[2], (int) row[3]);
        }
        try {
            jdbcTemplate.execute("ALTER TABLE user_modules AUTO_INCREMENT = 200");
        } catch (Exception ignored) {
            // shop DBs without ALTER privilege still have the seeded rows
        }
    }

    private void upsert(int id, String name, int isGroup, int groupId) {
        Integer exists = jdbcTemplate.query(
                "SELECT id FROM user_modules WHERE id = ?",
                rs -> rs.next() ? rs.getInt(1) : 0,
                id
        );
        if (exists != null && exists > 0) {
            jdbcTemplate.update(
                    "UPDATE user_modules SET module_name = ?, is_group = ?, group_id = ? WHERE id = ?",
                    name, isGroup, groupId, id
            );
            return;
        }
        if (hasColumn("is_active")) {
            jdbcTemplate.update(
                    "INSERT INTO user_modules (id, module_name, is_group, group_id, is_active) VALUES (?, ?, ?, ?, 1)",
                    id, name, isGroup, groupId
            );
            return;
        }
        jdbcTemplate.update(
                "INSERT INTO user_modules (id, module_name, is_group, group_id) VALUES (?, ?, ?, ?)",
                id, name, isGroup, groupId
        );
    }

    private void ensureColumn(String name, String definition) {
        if (hasColumn(name)) {
            return;
        }
        try {
            jdbcTemplate.execute("ALTER TABLE user_modules ADD COLUMN " + name + " " + definition);
        } catch (Exception ignored) {
            // older shop DBs keep working until the column is added
        }
    }

    private boolean hasColumn(String name) {
        try {
            Integer count = jdbcTemplate.queryForObject(
                    "SELECT COUNT(*) FROM information_schema.COLUMNS "
                            + "WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'user_modules' AND COLUMN_NAME = ?",
                    Integer.class,
                    name
            );
            return count != null && count > 0;
        } catch (Exception ignored) {
            return false;
        }
    }
}
