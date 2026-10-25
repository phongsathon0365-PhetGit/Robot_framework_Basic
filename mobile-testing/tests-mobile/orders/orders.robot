*** Settings ***
Documentation    [PBI-003] Orders Feature
...              Test suite for Create, View, Update, and Delete orders
Resource         ../../pages/auth/AuthPage.resource
Resource         ../../pages/books/BooksPage.resource
Resource         ../../pages/orders/OrdersPage.resource
Resource         ../../pages/common/BasePage.resource
Variables        ../../fixtures/testdata.${ENV}.${PLATFORM}.yaml
Variables        ../../pages/auth/locators.${PLATFORM}.yaml
Variables        ../../pages/books/locators.${PLATFORM}.yaml
Variables        ../../pages/orders/locators.${PLATFORM}.yaml

Suite Setup      Setup Mobile Test
Suite Teardown   Teardown Mobile Test
Test Setup       Register And Go To Orders
Test Teardown    Run Keyword If Test Failed    Capture Page Screenshot

*** Variables ***
# กำหนดค่า Default ไว้ (เผื่อลืมใส่ตอนรัน)
${PLATFORM}    android
${ENV}         local
${HEADLESS}    false

*** Test Cases ***
[TC-011] User Should See Empty Orders Screen Initially
    [Documentation]    Navigate to Orders tab → empty state displayed
    [Tags]    Feature:Orders    Important:High    Scenario:Success
    # ✅ Assert
    Verify Orders Screen Displayed
    Verify Empty Orders Displayed

[TC-012] User Should Create Order Successfully
    [Documentation]    Create order for book → order appears in list
    [Tags]    Feature:Orders    Important:Critical    Scenario:Success
    # 🎬 Act
    Create Order For Book    1    ${ORDERS.customer.name}
    Navigate To Orders Tab
    # ✅ Assert
    ${order_id}=    Get First Order Id
    Verify Order Card Exists    ${order_id}

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

Register And Go To Orders
    Register With Credentials    ${USERS.valid.email}    ${USERS.valid.name}
    Verify Home Screen Displayed
    Navigate To Orders Tab
