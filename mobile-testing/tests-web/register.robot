*** Settings ***
# ระบุ library, Page Object และข้อมูลที่ test suite ต้องใช้
Documentation    Web register smoke test using the Register Page Object.
Library          SeleniumLibrary
Resource         ../pages/web/registerPage.resource
Resource         ../pages/web/registerPage.resource
Resource         ../fixtures/testdata.web.resource
# ปิด browser เมื่อ suite ทำงานเสร็จ
Suite Teardown   Close All Browsers
# ถ้า test ล้มเหลว ให้ถ่ายภาพหน้าเว็บไว้ช่วยตรวจสอบ
Test Teardown    Teardown Web Test

*** Test Cases ***
# Open Register Page Test
Open Register Page Test
    [Documentation]    Verify that the register page is opened successfully.
    Open Register Page
    Location Should Be    ${REGISTER_URL}
    Verify Register Page Displayed

Verify Page Title Test
    [Documentation]    Verify that the page title is correct.
    Verify Page Title

Verify Click Reset Hyperlink
    [Documentation]    Verify that clicking the reset hyperlink clears the form fields.
    Verify Click Reset Hyperlink

Verify Firstname input field
    [Documentation]    Verify that the firstname input field works correctly.
    Verify Firstname input field

Verify Firstname not input field
    [Documentation]    Verify that the firstname input field shows an error when not filled.
    Verify Firstname not input field    

Verify Lastname input field
    [Documentation]    Verify that the lastname input field works correctly.
    Verify Lastname input field

Verify Lastname not input field
    [Documentation]    Verify that the lastname input field shows an error when not filled.
    Verify Lastname not input field

Verify Email input field
    [Documentation]    Verify that the email input field works correctly.
    Verify Email input field    

Verify Email invalid input field
    [Documentation]    Verify that the email input field shows an error when an invalid email is entered.
    FOR    ${email}    IN    @{WEB_INVALID_EMAILS}
        Verify Email invalid input field    ${email}
    END

Verify Email not input field
    [Documentation]    Verify that the email input field shows an error when not filled.
    Verify Email not input field

Verify Password input field
    [Documentation]    Verify that the password input field works correctly.
    Verify Password input field

Verify Password not input field
    [Documentation]    Verify that the password input field shows an error when not filled.
    Verify Password not input field

Verify Mobile Phone input field
    [Documentation]    Verify that the mobile phone input field works correctly.
    Verify Mobile Phone input field    

Verify Mobile Phone not input field
    [Documentation]    Verify that the mobile phone input field shows an error when not filled.
    Verify Mobile Phone not input field

Verify Gender radio buttons
    [Documentation]    Verify that the gender radio buttons work correctly.
    Verify Gender radio buttons        

Verify Checkbox SQL
    [Documentation]    Verify that the SQL checkbox works correctly.
    Verify Checkbox SQL

Verify Checkbox Manual
    [Documentation]    Verify that the Manual checkbox works correctly.
    Verify Checkbox Manual

Verify Checkbox Automate Test
    [Documentation]    Verify that the Automate Test checkbox works correctly.
    Verify Checkbox Automate Test

Verify Checkbox Automate Test2
    [Documentation]    Verify that the Automate Test2 checkbox works correctly.
    Verify Checkbox Automate Test2

Verify Dropdown Nationlity
    [Documentation]    Verify that the nationality dropdown works correctly.
    Verify Dropdown Nationlity

Verify Dropdown Role
    [Documentation]    Verify that the role dropdown works correctly.
    Verify Dropdown Role

Verify Dropdown Plan
    [Documentation]    Verify that the plan dropdown works correctly.
    Verify Dropdown Plan

Verify Checkbox All
    [Documentation]    Verify that selecting all checkboxes works correctly.
    Verify Checkbox All

Verify Checkbox None
    [Documentation]    Verify required-field errors appear after an empty submission and no course checkboxes are selected.
    Verify Checkbox None

Verify Register button is present
    [Documentation]    Verify that the register button is present on the page.
    Verify Register button is present

*** Keywords ***
Teardown Web Test
    Run Keyword If Test Failed    Capture Page Screenshot
    Close All Browsers
