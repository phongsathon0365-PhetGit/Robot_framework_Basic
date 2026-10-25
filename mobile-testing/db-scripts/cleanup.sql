-- Cleanup Script
-- Delete test data
DELETE FROM favorites WHERE user_id IN (
    SELECT id FROM users WHERE email LIKE '%@example.com'
);

DELETE FROM accounts WHERE user_id IN (
    SELECT id FROM users WHERE email LIKE '%@example.com'
);

DELETE FROM transactions WHERE user_id IN (
    SELECT id FROM users WHERE email LIKE '%@example.com'
);

DELETE FROM users WHERE email LIKE '%@example.com';

-- Reset auto increment (optional)
-- ALTER TABLE users AUTO_INCREMENT = 1;
-- ALTER TABLE accounts AUTO_INCREMENT = 1;
