-- SIT Database Setup Script
-- Create test users
INSERT INTO users (username, password, email, role, created_at) VALUES
('testuser@example.com', 'hashed_password_1', 'testuser@example.com', 'user', NOW()),
('admin@example.com', 'hashed_password_2', 'admin@example.com', 'admin', NOW())
ON DUPLICATE KEY UPDATE updated_at = NOW();

-- Create test accounts
INSERT INTO accounts (user_id, account_number, balance, created_at) VALUES
(1, '1234567890', 10000.00, NOW()),
(2, '9876543210', 50000.00, NOW())
ON DUPLICATE KEY UPDATE updated_at = NOW();

-- Create test favorites
INSERT INTO favorites (user_id, name, account_number, created_at) VALUES
(1, 'John Doe', '1234567890', NOW())
ON DUPLICATE KEY UPDATE updated_at = NOW();
