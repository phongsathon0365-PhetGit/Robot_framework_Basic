*** Settings ***
# ระบุ library, Page Object และข้อมูลที่ test suite ต้องใช้
Documentation    Web login smoke test using the Login Page Object.
Library          SeleniumLibrary
Resource         ../pages/web/LoginPage.resource
Resource         ../fixtures/testdata.web.resource
# เปิดหน้า Login แยก browser ใหม่ก่อนแต่ละ test และปิด browser เมื่อ suite ทำงานเสร็จ
Test Setup       Open Login Page
Suite Teardown   Close All Browsers
# ถ้า test ล้มเหลว ให้ถ่ายภาพหน้าเว็บไว้ช่วยตรวจสอบ
Test Teardown    Teardown Web Test

*** Test Cases ***
# ทดสอบล็อกอินด้วยบัญชีที่ถูกต้อง แล้วตรวจผลลัพธ์หลังส่งแบบฟอร์ม
User Should Login Successfully With Valid Credentials
    [Documentation]    Sign in with a registered account and verify that the Home page is displayed.
    # กำหนด tag เพื่อจัดกลุ่มและเลือก test ตอนสั่งรัน
    [Tags]    Feature:Auth    Important:Critical    Scenario:Success
    # กรอกข้อมูลบัญชีทดสอบและยืนยันว่าออกจากหน้า Login แล้ว
    Login With Credentials    ${WEB_VALID_EMAIL}    ${WEB_VALID_PASSWORD}
    Verify Home Page Displayed

# ทดสอบล็อกอินโดยไม่ใส่ password แล้วตรวจผลลัพธ์
User Should Not Login Without Password
    [Documentation]        Sign in without providing a password and verify that login fails.
    [Tags]    Feature:Auth    Important:Critical    Scenario:Failure
    Verify Login Failed Without Password    ${WEB_VALID_EMAIL}
    Verify Login Failed

# ทดสอบล็อกอินโดยไม่ใส่ email แล้วตรวจผลลัพธ์
User Should Not Login Without Email
    [Documentation]        Sign in without providing an email and verify that login fails.
    [Tags]    Feature:Auth    Important:Critical    Scenario:Failure
    Verify Login Failed Without Email    ${WEB_VALID_PASSWORD}
    Verify Login Failed

# ทดสอบล็อกอินโดยไม่ใส่ email และ password แล้วตรวจผลลัพธ์
User Should Not Login Without Email And Password
    [Documentation]        Sign in without providing an email and password and verify that login fails.
    [Tags]    Feature:Auth    Important:Critical    Scenario:Failure
    Verify Login Failed Without Email And Password
    Verify Login Failed

# ทดสอบรูปแบบ email ที่มีตัวอักษร ตัวเลข และอักขระ _ . @
User Should Accept Supported Email Characters
    [Documentation]    Email field accepts letters, digits, underscore, dot, and @ in a valid email format.
    [Tags]    Feature:Auth    Important:High    Scenario:Validation
    Verify Email Format Accepted    ${WEB_EMAIL_WITH_SUPPORTED_CHARACTERS}

# ทดสอบ email ที่รูปแบบไม่ถูกต้องทั้งสามแบบตามข้อมูลทดสอบ
User Should Reject Invalid Email Formats
    [Documentation]    Reject email without @, non-English text, and a phone number as invalid email formats.
    [Tags]    Feature:Auth    Important:High    Scenario:Validation
    FOR    ${invalid_email}    IN    @{WEB_INVALID_EMAILS}
        Verify Invalid Email Is Rejected    ${invalid_email}
    END

# ทดสอบว่า password ที่มีความยาวมากกว่า 5 ตัวอักษรถูกยอมรับ
User Should Accept Password Longer Than Five Characters
    [Documentation]    Verify that passwords longer than 5 characters are accepted.
    [Tags]    Feature:Auth    Important:High    Scenario:Validation
    Verify Password Length Greater Than Five    ${WEB_VALID_EMAIL}    ${WEB_PASSWORD_LONGER_THAN_FIVE}

# ทดสอบว่า password ที่มีความยาวน้อยกว่า 5 ตัวอักษรถูกปฏิเสธ
User Should Reject Password Shorter Than Five Characters
    [Documentation]    Verify that passwords shorter than 5 characters are rejected.
    [Tags]    Feature:Auth    Important:High    Scenario:Validation
    Verify Password Length Less Than Five    ${WEB_VALID_EMAIL}    ${WEB_PASSWORD_LESS_THAN_FIVE}

# ทดสอบการล็อกอินด้วยบัญชีที่ไม่มีการลงทะเบียน
User Should Not Login With Unregistered Credentials
    [Documentation]    Sign in with unregistered email and password and verify that login fails.
    [Tags]    Feature:Auth    Important:Critical    Scenario:Failure
    Verify Login Failed With Unregistered Credentials    ${WEB_EMPTY_NAME_EMAIL}    ${WEB_EMPTY_NAME_PASSWORD}
   
# ตรวจสอบการกด Hyperlink Create an account
User Should Be Able To Click Create Account Hyperlink
    [Documentation]    Verify that clicking the "Create an account" hyperlink navigates to the registration page.
    [Tags]    Feature:Auth    Important:High    Scenario:Navigation
    Verify Create Account Hyperlink

*** Keywords ***
Teardown Web Test
    Run Keyword If Test Failed    Capture Page Screenshot
    Close All Browsers