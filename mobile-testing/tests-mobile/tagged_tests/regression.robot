*** Settings ***
Documentation    Regression Tests — full flow verification
Resource         ../../pages/auth/AuthPage.resource
Resource         ../../pages/books/BooksPage.resource
Resource         ../../pages/orders/OrdersPage.resource
Resource         ../../pages/common/BasePage.resource
Variables        ../../fixtures/testdata.${ENV}.${PLATFORM}.yaml

*** Variables ***
# กำหนดค่า Default ไว้ (เผื่อลืมใส่ตอนรัน)
${PLATFORM}    android
${ENV}         local
${HEADLESS}    false

Suite Setup       Setup Mobile Test
Suite Teardown    Teardown Mobile Test
Test Teardown     Run Keyword If Test Failed    Capture Page Screenshot

*** Test Cases ***
Regression Test - Complete Register Flow
    [Tags]    regression
    Verify Register Page Displayed
    Register With Credentials    ${USERS.valid.email}    ${USERS.valid.name}
    Verify Home Screen Displayed

Regression Test - Invalid Token Login
    [Tags]    regression
    Switch To Login Mode
    Login With Token    ${TOKEN.invalid}
    Wait For Element    xpath=//android.widget.TextView[contains(@text,'Invalid token')]

Regression Test - Create And View Order
    [Tags]    regression
    Register With Credentials    ${USERS.valid.email}    ${USERS.valid.name}
    Verify Home Screen Displayed
    Create Order For Book    1    ${ORDERS.customer.name}
    Navigate To Orders Tab
    ${order_id}=    Get First Order Id
    Verify Order Card Exists    ${order_id}

Regression Test - Logout Flow
    [Tags]    regression
    Register With Credentials    ${USERS.valid.email}    ${USERS.valid.name}
    Verify Home Screen Displayed
    Logout
    Verify Auth Screen Displayed

*** Keywords ***
Setup Mobile Test
    Open Application    ${APPIUM_URL}
    ...    platformName=${PLATFORM_NAME}
    ...    platformVersion=${PLATFORM_VERSION}
    ...    deviceName=${DEVICE_NAME}
    ...    app=${APP_PATH}
    ...    automationName=${AUTOMATION_NAME}
    ...    noReset=false

Teardown Mobile Test
    Close Application
