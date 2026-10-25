-- UAT Database Setup Script
-- Create test users
INSERT INTO users (username, password, email, role, created_at) VALUES
('uatuser@example.com', 'hashed_password_1', 'uatuser@example.com', 'user', NOW()),
('uatadmin@example.com', 'hashed_password_2', 'uatadmin@example.com', 'admin', NOW())
ON DUPLICATE KEY UPDATE updated_at = NOW();

-- Create test accounts
INSERT INTO accounts (user_id, account_number, balance, created_at) VALUES
(1, '9876543210', 5000.00, NOW()),
(2, '1234567890', 25000.00, NOW())
ON DUPLICATE KEY UPDATE updated_at = NOW();

-- Create test favorites
INSERT INTO favorites (user_id, name, account_number, created_at) VALUES
(1, 'Jane Smith', '9876543210', NOW())
ON DUPLICATE KEY UPDATE updated_at = NOW();
