package com.billing.core.license;

/**
 * Validates application license before login.
 * heading.is_active = 1 (or missing) uses heading.starting_date + heading.active.
 * heading.is_active = 0 skips that check.
 */
public interface LicenseValidator {

    void validateForLogin();
}
