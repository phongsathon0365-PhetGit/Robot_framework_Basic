import pymysql
from pathlib import Path
from typing import Optional

class DatabaseHelper:
    """Helper class for database operations"""
    
    def __init__(self, host: str = 'localhost', port: int = 3306, 
                 user: str = 'root', password: str = '', database: str = 'testdb'):
        self.host = host
        self.port = port
        self.user = user
        self.password = password
        self.database = database
        self.connection: Optional[pymysql.Connection] = None
    
    def connect(self):
        """Establish database connection"""
        self.connection = pymysql.connect(
            host=self.host,
            port=self.port,
            user=self.user,
            password=self.password,
            database=self.database,
            charset='utf8mb4',
            cursorclass=pymysql.cursors.DictCursor
        )
    
    def disconnect(self):
        """Close database connection"""
        if self.connection:
            self.connection.close()
            self.connection = None
    
    def execute_script(self, script_path: str):
        """Execute SQL script file"""
        if not self.connection:
            self.connect()
        
        with open(script_path, 'r', encoding='utf-8') as f:
            sql_script = f.read()
        
        with self.connection.cursor() as cursor:
            for statement in sql_script.split(';'):
                if statement.strip():
                    cursor.execute(statement)
        
        self.connection.commit()
    
    def setup_database(self, env: str = 'sit'):
        """Setup database for testing"""
        base_dir = Path(__file__).parent.parent
        script_path = base_dir / 'db-scripts' / f'setup.{env}.sql'
        self.execute_script(str(script_path))
    
    def cleanup_database(self):
        """Cleanup database after testing"""
        base_dir = Path(__file__).parent.parent
        script_path = base_dir / 'db-scripts' / 'cleanup.sql'
        self.execute_script(str(script_path))
