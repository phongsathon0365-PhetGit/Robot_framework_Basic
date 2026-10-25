# Mobile Testing with Robot Framework + Appium

## Overview
Mobile testing framework using Robot Framework and Appium with Page Object Model, multi-environment support (LOCAL/SIT), and organized test structure.

## Key Features
- ✅ **Page Object Model** - Locators + Keywords in one place
- ✅ **Multi-Environment** - LOCAL, SIT via fixtures yaml
- ✅ **Multi-Platform** - Android & iOS support
- ✅ **Test Organization** - Feature-based structure with tags
- ✅ **Database Integration** - SQL scripts for test data
- ✅ **CI/CD Ready** - Azure DevOps pipelines
- ✅ **Parallel Execution** - Run tests concurrently

## Project Structure

```
tests/mobile-testing/
├── requirements.txt              # Python dependencies
│
├── pipelines/
│   └── mobile-pipeline.yaml
│
├── pages/                        # Page Object Model
│   ├── common/
│   │   └── BasePage.resource
│   ├── web/
│   │   ├── locators.yaml
│   │   └── LoginPage.resource
│   ├── auth/
│   │   ├── locators.android.yaml     # Auth locators — Android
│   │   ├── locators.ios.yaml         # Auth locators — iOS
│   │   └── AuthPage.resource         # Keywords only
│   ├── books/
│   │   ├── locators.android.yaml     # Books locators — Android
│   │   ├── locators.ios.yaml         # Books locators — iOS
│   │   └── BooksPage.resource        # Keywords only
│   └── orders/
│       ├── locators.android.yaml     # Orders locators — Android
│       ├── locators.ios.yaml         # Orders locators — iOS
│       └── OrdersPage.resource       # Keywords only
│
├── fixtures/                     # Test data + Appium capabilities per env/platform
│   ├── testdata.local.android.yaml
│   ├── testdata.local.ios.yaml
│   ├── testdata.sit.android.yaml
│   ├── testdata.sit.ios.yaml
│   └── testdata.web.resource
│
├── db-scripts/
│   ├── setup.local.sql
│   ├── setup.sit.sql
│   ├── cleanup.sql
│   └── README.md
│
├── helpers/
│   └── database_helper.py
│
├── apps/
│   ├── app-release.apk             # Android build
│   └── ios-debug.app/              # iOS debug build
│
├── tests-mobile/
│   ├── auth/
│   │   └── auth.robot
│   ├── books/
│   │   └── books.robot
│   ├── orders/
│   │   └── orders.robot
│   └── tagged_tests/
│       ├── smoke.robot
│       └── regression.robot

└── tests-web/
    └── login.robot
```

## Prerequisites

### Required
- Python 3.8+
- Node.js 16+ (for Appium)
- Java JDK 8+

### Platform Specific
- **Android**: Android SDK
- **iOS**: Xcode (macOS only)

## Installation

```bash
cd tests/mobile-testing
pip install -r requirements.txt

npm install -g appium
appium driver install uiautomator2  # Android
appium driver install xcuitest      # iOS (macOS only)
```

## Environment Configuration

### Available Environments
| Environment | File | Platform |
|-------------|------|----------|
| Local Android | `fixtures/testdata.local.android.yaml` | Android |
| Local iOS | `fixtures/testdata.local.ios.yaml` | iOS |
| SIT Android | `fixtures/testdata.sit.android.yaml` | Android |
| SIT iOS | `fixtures/testdata.sit.ios.yaml` | iOS |

### Fixture File Structure
```yaml
# === Appium Capabilities ===
APPIUM_URL: http://localhost:4723
PLATFORM_NAME: Android
PLATFORM_VERSION: "16"
DEVICE_NAME: emulator-5554
APP_PATH: ./apps/app-release.apk
AUTOMATION_NAME: UiAutomator2

# === API ===
BASE_URL: http://localhost:5000

# === Test Data ===
USERS:
  valid:
    email: "testuser@local.com"
    name: "Test User"
```

## Running Tests

### Web Login Test

The web suite uses SeleniumLibrary and the Page Object in `pages/web/`.
Chrome is the default browser; override it with `--variable BROWSER:firefox` if needed.

```bash
robot tests-web/
```

### Start Appium Server
```bash
appium
```

### Basic Test Execution

**Command format:** `robot --variable ENV:<env> --variable PLATFORM:<platform> [options] <suite>`

ทุก `.robot` มี default variables (`ENV=local`, `PLATFORM=android`) ไว้แล้ว สามารถ override ได้ผ่าน `--variable`:

```bash
# Android Local (default - no variables needed)
robot --outputdir results/android-local tests-mobile/

# Android SIT
robot --variable ENV:sit --outputdir results/android-sit tests-mobile/

# iOS Local
robot --variable PLATFORM:ios --outputdir results/ios-local tests-mobile/

# iOS SIT
robot --variable ENV:sit --variable PLATFORM:ios --outputdir results/ios-sit tests-mobile/
```

### Run Specific Suite
```bash
robot --variable ENV:local --variable PLATFORM:android tests-mobile/auth/auth.robot
robot --variable ENV:local --variable PLATFORM:android tests-mobile/books/books.robot
robot --variable ENV:local --variable PLATFORM:android tests-mobile/orders/orders.robot
robot --variable ENV:sit   --variable PLATFORM:android tests-mobile/
robot --variable ENV:sit   --variable PLATFORM:ios     tests-mobile/
```

### Run with Tags
```bash
robot --variable ENV:local --variable PLATFORM:android --include smoke              tests-mobile/
robot --variable ENV:local --variable PLATFORM:android --include regression         tests-mobile/
robot --variable ENV:sit   --variable PLATFORM:android --include Feature:Auth       tests-mobile/
robot --variable ENV:sit   --variable PLATFORM:android --include Important:Critical tests-mobile/
```

### Run with Output Directory

> ⚠️ ถ้าไม่กำหนด `--outputdir` ไฟล์ `output.xml`, `log.html`, `report.html` จะถูกสร้างใน current directory และ**ทับกันทุกครั้ง**ที่รัน แนะนำให้กำหนดเสมอ

```bash
robot --variable ENV:local --variable PLATFORM:android --outputdir results/android-local tests-mobile/
robot --variable ENV:sit   --variable PLATFORM:ios     --outputdir results/ios-sit       tests-mobile/
```

### Parallel Execution
```bash
pip install robotframework-pabot

pabot --processes 2 --variable ENV:local --variable PLATFORM:android tests-mobile/
pabot --processes 2 --variable ENV:sit   --variable PLATFORM:ios     tests-mobile/
```

## Page Object Model

### Example: Test Case
```robot
*** Settings ***
Resource    ../../pages/auth/AuthPage.resource
Resource    ../../pages/common/BasePage.resource
Variables   ../../fixtures/testdata.${ENV}.${PLATFORM}.yaml
Variables   ../../pages/auth/locators.${PLATFORM}.yaml

Suite Setup      Setup Mobile Test
Suite Teardown   Teardown Mobile Test

*** Variables ***
# กำหนดค่า Default ไว้ (เผื่อลืมใส่ตอนรัน)
${PLATFORM}    android
${ENV}         local

*** Test Cases ***
User Should Register Successfully
    Register With Credentials    ${USERS.valid.email}    ${USERS.valid.name}
    Verify Home Screen Displayed
```

## Test Tags

| Tag | Usage |
|-----|-------|
| `Feature:Auth` | `--include Feature:Auth` |
| `Feature:Books` | `--include Feature:Books` |
| `Feature:Orders` | `--include Feature:Orders` |
| `Important:Critical` | `--include Important:Critical` |
| `Important:High` | `--include Important:High` |
| `Scenario:Success` | `--include Scenario:Success` |
| `Scenario:Alternative` | `--include Scenario:Alternative` |

## Device Management

### Android
```bash
adb devices
adb kill-server && adb start-server
```

### iOS
```bash
xcrun simctl list devices
xcrun simctl boot "iPhone 14"
xcrun simctl shutdown "iPhone 14"
```

## Reports

```bash
# Windows
start results\android-local\report.html

# macOS/Linux
open results/android-local/report.html
```

### Report Files
- **HTML Report**: `results/report.html`
- **Log File**: `results/log.html`
- **Output XML**: `results/output.xml`

## Troubleshooting

### Verify Appium Installation
```bash
appium-doctor --android
appium-doctor --ios
```

### Common Issues

| Issue | Solution |
|-------|----------|
| App not found | Check `APP_PATH` in fixture yaml |
| Device not connected | Verify device/emulator is running |
| Element not found | Check locator strategy and wait times |
| Appium not starting | Check port 4723 is available |
| Connection refused | Ensure Appium server is running |

## Additional Resources

- [Robot Framework Documentation](https://robotframework.org/)
- [Appium Documentation](https://appium.io/docs/)
- [AppiumLibrary Keywords](https://serhatbolsu.github.io/robotframework-appiumlibrary/AppiumLibrary.html)
- [CI/CD Pipelines](pipelines/)
- [Database Scripts](db-scripts/README.md)

## Project Structure

```
tests/mobile-testing/
├── .env.local                    # Local environment config (API URLs, DB Credentials)
├── .env                          # SIT environment config (Default)
├── .env.uat                      # UAT environment config
├── android_caps.yaml             # Android Appium Capabilities (Device Name, App Package) - เทียบเท่า playwright.config.ts
├── ios_caps.yaml                 # iOS Appium Capabilities (UDID, Bundle ID) - เทียบเท่า playwright.config.ts
├── requirements.txt              # Python dependencies (Appium-Python-Client, robotframework)
│
├── pipelines/                    # CI/CD pipeline configurations
│   └── mobile-pipeline.yaml      # Pipeline for running mobile tests
│
├── pages/                        # Page Object Model (Shared logic for Flutter)
│   ├── common/
│   │   └── BasePage.resource     # Common Keywords (Wait, Swipe, Click)
│   ├── auth/
│   │   └── LoginPage.resource    # Login locators & keywords (Accessibility IDs)
│   └── dashboard/
│       └── DashboardPage.resource
│
├── fixtures/                     # Test data per environment (Loaded based on .env)
│   ├── testdata.sit.yaml         # SIT test data (User accounts, Products)
│   ├── testdata.local.yaml       # Local test data
│   └── testdata.uat.yaml         # UAT test data
│
├── db-scripts/                   # Database setup scripts (Shared with Web if possible)
│   ├── setup.sit.sql
│   ├── setup.local.sql
│   ├── setup.uat.sql
│   ├── cleanup.sql
│   └── README.md
│
├── helpers/                      # Utility functions
│   ├── env_loader.py             # Script to load .env files into Robot variables
│   ├── database_helper.py        # Database connection & query execution
│   └── app_manager.py            # Helper to download/install APK or IPA files
│
├── apps/                         # App binaries (Should be git-ignored)
│   ├── .keep                     # Placeholder to keep folder structure
│   └── (app-release.apk / app.ipa)
│
└── tests-mobile/                 # Test files organized by features (No Android/iOS subfolders)
    ├── auth/                     # Authentication Tests
    │   └── login.robot           # Test Logic (Runs on both OS)
    ├── profile/                  # User Profile Tests
    │   └── profile.robot
    └── tagged_tests/             # Smoke & Regression suites
        ├── smoke.robot
        └── regression.robot
```

## Prerequisites

### Required
- Python 3.8+
- Node.js 16+ (for Appium)
- Java JDK 8+

### Platform Specific
- **Android**: Android SDK
- **iOS**: Xcode (macOS only)

## Installation

### 1. Install Python Dependencies
```bash
cd tests/mobile-testing
pip install -r requirements.txt
```

### 2. Install Appium
```bash
npm install -g appium
appium driver install uiautomator2  # Android
appium driver install xcuitest      # iOS (macOS only)
```

### 3. Verify Installation
```bash
appium --version
robot --version
```

## Environment Configuration

### Available Environments
| Environment | File | Description |
|-------------|------|-------------|
| Local | `.env.local` | Local development environment |
| SIT (default) | `.env` | System Integration Testing |
| UAT | `.env.uat` | User Acceptance Testing |

### Environment Variables
```bash
# Platform Configuration
PLATFORM_NAME=Android          # Android/iOS
PLATFORM_VERSION=11            # OS version
DEVICE_NAME=emulator-5554      # Device/emulator name
AUTOMATION_NAME=UiAutomator2   # UiAutomator2/XCUITest

# App Configuration
APP_PATH=./apps/app-release.apk
APP_PACKAGE=com.example.app
APP_ACTIVITY=.MainActivity     # Android only
APP_BUNDLE_ID=com.example.app  # iOS only

# Test Configuration
NO_RESET=true
FULL_RESET=false
```

### Platform-Specific Capabilities

**Android** - Configure in `android_caps.yaml`:
```yaml
platformName: Android
platformVersion: "11"
deviceName: emulator-5554
app: ./apps/app-release.apk
appPackage: com.example.app
appActivity: .MainActivity
automationName: UiAutomator2
noReset: true
```

**iOS** - Configure in `ios_caps.yaml`:
```yaml
platformName: iOS
platformVersion: "15.0"
deviceName: iPhone 13
app: ./apps/app-release.ipa
bundleId: com.example.app
automationName: XCUITest
noReset: true
```

## Running Tests

### Start Appium Server
```bash
appium
```

### Run All Tests (Both Platforms)
```bash
# SIT environment (default) - uses platform from .env
robot tests-mobile/

# Local environment
robot --variable ENV:local tests-mobile/

# UAT environment
robot --variable ENV:uat tests-mobile/
```

### Run Tests by Platform

**Android:**
```bash
# Method 1: Environment Variable (Linux/macOS)
export PLATFORM_NAME=Android
robot tests-mobile/

# Method 1: Environment Variable (Windows)
set PLATFORM_NAME=Android
robot tests-mobile/

# Method 2: Robot Variable
robot --variable PLATFORM_NAME:Android tests-mobile/

# Method 3: Use android_caps.yaml
robot --variable CAPS_FILE:android_caps.yaml tests-mobile/
```

**iOS:**
```bash
# Method 1: Environment Variable (Linux/macOS)
export PLATFORM_NAME=iOS
robot tests-mobile/

# Method 1: Environment Variable (Windows)
set PLATFORM_NAME=iOS
robot tests-mobile/

# Method 2: Robot Variable
robot --variable PLATFORM_NAME:iOS tests-mobile/

# Method 3: Use ios_caps.yaml
robot --variable CAPS_FILE:ios_caps.yaml tests-mobile/
```

### Run Specific Features
```bash
# Authentication tests
robot tests-mobile/auth/

# Profile tests
robot tests-mobile/profile/

# Specific test file
robot tests-mobile/auth/login.robot
```

### Run with Tags
```bash
# Smoke tests only
robot --include smoke tests-mobile/tagged_tests/smoke.robot

# Regression tests
robot --include regression tests-mobile/tagged_tests/regression.robot

# Specific feature tag
robot --include auth tests-mobile/

# Multiple tags
robot --include smokeANDauth tests-mobile/
```

### Parallel Execution
```bash
# Install pabot
pip install robotframework-pabot

# Run with 2 processes
pabot --processes 2 tests-mobile/

# Run specific features in parallel
pabot --processes 2 tests-mobile/auth/ tests-mobile/profile/
```

### Generate Reports
```bash
# Generate reports in custom directory
robot --outputdir results tests-mobile/

# Generate with custom report name
robot --outputdir results --report mobile-report.html tests-mobile/
```

## Page Object Model

### Structure
- **Locators** - Element identifiers
- **Keywords** - Reusable actions
- **All in one file** - Easy maintenance

### Example: LoginPage.resource
```robot
*** Settings ***
Resource    ../common/BasePage.resource

*** Variables ***
# Locators using Accessibility IDs (Flutter compatible)
${LOGIN_USERNAME_FIELD}    accessibility_id=username_field
${LOGIN_PASSWORD_FIELD}    accessibility_id=password_field
${LOGIN_BUTTON}            accessibility_id=login_button
${LOGIN_ERROR_MESSAGE}     accessibility_id=error_message

*** Keywords ***
Input Username
    [Arguments]    ${username}
    Input Text Safe    ${LOGIN_USERNAME_FIELD}    ${username}

Input Password
    [Arguments]    ${password}
    Input Text Safe    ${LOGIN_PASSWORD_FIELD}    ${password}

Click Login Button
    Click Element Safe    ${LOGIN_BUTTON}

Get Error Message
    ${message}=    Get Text Safe    ${LOGIN_ERROR_MESSAGE}
    RETURN    ${message}

Verify Login Page Displayed
    Wait For Element    ${LOGIN_USERNAME_FIELD}
    Wait For Element    ${LOGIN_PASSWORD_FIELD}
    Wait For Element    ${LOGIN_BUTTON}

Login With Credentials
    [Arguments]    ${username}    ${password}
    Verify Login Page Displayed
    Input Username    ${username}
    Input Password    ${password}
    Click Login Button
```

### Example: Test Case
```robot
*** Settings ***
Resource    ../../pages/auth/LoginPage.resource
Variables   ../../fixtures/testdata.sit.yaml

Suite Setup       Setup Mobile Test
Suite Teardown    Teardown Mobile Test

*** Test Cases ***
Login With Valid User Should Success
    [Tags]    smoke    auth    login
    Verify Login Page Displayed
    Input Username    ${USERS.valid.username}
    Input Password    ${USERS.valid.password}
    Click Login Button
    Sleep    2s

*** Keywords ***
Setup Mobile Test
    Open Application    http://localhost:4723/wd/hub
    ...    platformName=${PLATFORM_NAME}
    ...    platformVersion=${PLATFORM_VERSION}
    ...    deviceName=${DEVICE_NAME}
    ...    app=${APP_PATH}
    ...    automationName=${AUTOMATION_NAME}
    ...    noReset=${NO_RESET}

Teardown Mobile Test
    Close Application
```

## Test Data Management

### YAML Files (Recommended)
```yaml
# fixtures/testdata.sit.yaml
USERS:
  valid:
    username: testuser@example.com
    password: Test@1234
  admin:
    username: admin@example.com
    password: Admin@1234
  invalid:
    username: invalid@example.com
    password: wrongpassword

PAYMENT:
  transfer:
    amount: "1000"
    recipient: "0812345678"
    note: "Test transfer"
  favorites:
    name: "John Doe"
    account: "1234567890"

PROFILE:
  user:
    firstName: "Test"
    lastName: "User"
    email: "testuser@example.com"
    phone: "0812345678"
```

### Loading Test Data in Robot
```robot
*** Settings ***
Variables   ../../fixtures/testdata.sit.yaml

*** Test Cases ***
Example Test
    Log    ${USERS.valid.username}
    Log    ${USERS.valid.password}
    Log    ${PAYMENT.transfer.amount}
```

## Test Tags

| Tag | Purpose | Usage |
|-----|---------|-------|
| `smoke` | Critical tests for quick validation | `robot --include smoke tests-mobile/` |
| `regression` | Full regression test suite | `robot --include regression tests-mobile/` |
| `auth` | Authentication tests | `robot --include auth tests-mobile/` |
| `payment` | Payment tests | `robot --include payment tests-mobile/` |
| `profile` | Profile tests | `robot --include profile tests-mobile/` |
| `critical` | Business critical functionality | `robot --include critical tests-mobile/` |

## Reports

```bash
# Generate reports in custom directory
robot --outputdir results tests-mobile/android/
```

### Report Files
- `report.html` - Test execution report
- `log.html` - Detailed test log
- `output.xml` - Machine-readable results
- Screenshots captured on failure

## Best Practices

1. **Page Object Model** - Store locators + keywords in pages/
2. **Test Data Files** - Use YAML files in fixtures/
3. **Tag Your Tests** - Use @smoke, @regression, @critical
4. **Feature-Based** - Organize tests by features (auth/, payment/)
5. **Multi-Environment** - Use .env files for LOCAL/SIT/UAT
6. **Explicit Waits** - Use Wait For Element instead of Sleep
7. **Screenshots** - Automatically captured on failure
8. **Parallel Execution** - Use pabot for faster execution

## Locator Strategies

### Recommended: Accessibility IDs (Flutter Compatible)
```robot
# ✅ BEST - Works on both Android and iOS
accessibility_id=username_field
accessibility_id=login_button
accessibility_id=error_message
```

### Platform-Specific Locators

**Android:**
```robot
id=com.example.app:id/elementId                 # Resource ID
xpath=//android.widget.Button[@text='Login']    # XPath
android=new UiSelector().text("Login")          # UiAutomator
```

**iOS:**
```robot
accessibility_id=elementId                       # Accessibility ID (Recommended)
id=elementId                                     # Element ID
xpath=//XCUIElementTypeButton[@name='Login']    # XPath
ios_predicate=name == 'Login'                   # iOS Predicate
ios_class_chain=**/XCUIElementTypeButton[`name == 'Login'`]  # Class Chain                       # Accessibility ID (Recommended)
xpath=//XCUIElementTypeButton[@name='Login']     # XPath
ios_predicate=name == "Login"                    # Predicate
ios_class_chain=**/XCUIElementTypeButton[`name == "Login"`]  # Class Chain
```

## Dependencies

```txt
# Core
robotframework==6.0.1
robotframework-appiumlibrary==2.0.0
appium-server==2.11.5

# Test Data
PyYAML==6.0.1
python-dotenv==1.0.0

# Database (Optional)
pymysql==1.1.0

# Parallel Execution (Optional)
robotframework-pabot==2.16.0
```

## Troubleshooting

### Check Devices
```bash
# Android
adb devices

# iOS
xcrun simctl list devices
```

### Common Issues

| Issue | Solution |
|-------|----------|
| App not found | Check APP_PATH in .env file |
| Device not connected | Verify device/emulator is running |
| Element not found | Check locator strategy and wait times |
| Session timeout | Increase timeout in .env |
| Appium not starting | Check port 4723 is available |

### View Appium Logs
```bash
appium --log-level debug
```

## Additional Resources

- [Robot Framework Documentation](https://robotframework.org/)
- [Appium Documentation](https://appium.io/docs/)
- [AppiumLibrary Keywords](https://serhatbolsu.github.io/robotframework-appiumlibrary/AppiumLibrary.html)
- [CI/CD Pipelines](pipelines/)
- [Database Scripts](db-scripts/README.md)
- [App Management](apps/README.md)
