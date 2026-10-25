# Database Scripts

## Overview
SQL scripts for setting up and cleaning up test data in the database.

## Files
- `setup.sit.sql` - Setup test data for SIT environment
- `setup.uat.sql` - Setup test data for UAT environment
- `cleanup.sql` - Cleanup test data after testing

## Usage

### Using Database Helper (Python)
```python
from helpers.database_helper import DatabaseHelper

# Setup
db = DatabaseHelper(host='localhost', user='root', password='', database='testdb')
db.setup_database('sit')  # or 'uat'

# Cleanup
db.cleanup_database()
db.disconnect()
```

### Using Robot Framework
```robot
*** Settings ***
Library    helpers/database_helper.py

*** Keywords ***
Setup Test Database
    [Arguments]    ${env}=sit
    ${db}=    Create Database Helper    localhost    root    password    testdb
    Setup Database    ${env}
    
Cleanup Test Database
    Cleanup Database
    Disconnect
```

### Manual Execution
```bash
# MySQL
mysql -u root -p testdb < db-scripts/setup.sit.sql
mysql -u root -p testdb < db-scripts/cleanup.sql

# PostgreSQL
psql -U postgres -d testdb -f db-scripts/setup.sit.sql
psql -U postgres -d testdb -f db-scripts/cleanup.sql
```

## Best Practices
1. Always run cleanup after tests
2. Use transactions for data integrity
3. Keep test data separate from production
4. Use ON DUPLICATE KEY UPDATE for idempotency
5. Document any special setup requirements
