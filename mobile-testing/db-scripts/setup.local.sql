-- Local Database Setup Script
-- Create test users
INSERT INTO users (username, password, email, role, created_at) VALUES
('local_user@example.com', 'hashed_password_1', 'local_user@example.com', 'user', NOW()),
('local_admin@example.com', 'hashed_password_2', 'local_admin@example.com', 'admin', NOW())
ON DUPLICATE KEY UPDATE updated_at = NOW();

-- Create test accounts
INSERT INTO accounts (user_id, account_number, balance, created_at) VALUES
(1, '1111111111', 5000.00, NOW()),
(2, '2222222222', 10000.00, NOW())
ON DUPLICATE KEY UPDATE updated_at = NOW();

-- Create test favorites
INSERT INTO favorites (user_id, name, account_number, created_at) VALUES
(1, 'Local Test', '1111111111', NOW())
ON DUPLICATE KEY UPDATE updated_at = NOW();
