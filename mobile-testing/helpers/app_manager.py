import json
from pathlib import Path
from typing import Dict, Optional

class AppManager:
    """Helper class for managing mobile app binaries"""
    
    def __init__(self):
        self.base_dir = Path(__file__).parent.parent
        self.apps_dir = self.base_dir / 'apps'
        self.versions_file = self.apps_dir / 'versions.json'
    
    def get_app_path(self, platform: str, env: str, device_type: str = 'simulator') -> str:
        """
        Get app path for testing
        
        Args:
            platform: 'android' or 'ios'
            env: 'sit' or 'uat'
            device_type: 'simulator' or 'device' (iOS only)
        
        Returns:
            Path to app file
        """
        versions = self._load_versions()
        
        if platform == 'android':
            return versions['android'][env]['path']
        elif platform == 'ios':
            return versions['ios'][env][device_type]
        else:
            raise ValueError(f"Invalid platform: {platform}")
    
    def check_app_exists(self, platform: str, env: str) -> bool:
        """Check if app file exists"""
        try:
            app_path = self.get_app_path(platform, env)
            return Path(app_path).exists()
        except Exception:
            return False
    
    def get_app_version(self, platform: str, env: str) -> Dict:
        """Get app version information"""
        versions = self._load_versions()
        return versions[platform][env]
    
    def _load_versions(self) -> Dict:
        """Load versions.json file"""
        with open(self.versions_file, 'r') as f:
            return json.load(f)
