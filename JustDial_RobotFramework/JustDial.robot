*** Settings ***
Library           SeleniumLibrary
Library           Collections
Library           OperatingSystem
Library           keywords/system_keywords/Collections/CollectionSupport.py
Library           keywords/system_keywords/Generic/SeleniumWeb.py
Resource          keywords/robot_keywords/generic_keywords/kw-seleniumsupport.txt

*** Test Cases ***
Read data from JustDial using webdriver
    [Tags]    webdriver
    ${options} =    Evaluate    selenium.webdriver.ChromeOptions()    modules=selenium, selenium.webdriver
    Call Method    ${options}    add_argument    --disable-geolocation
    Call Method    ${options}    add_argument    --disable-notifications
    Call Method    ${options}    add_argument    --disable-popup-blocking
    Log    ${options}
    Create Webdriver    Chrome    options=${options}
    ${instance}    Get Library Instance    SeleniumLibrary
    log    ${instance}
    Maximize Browser Window
    Go To    https://www.justdial.com/
    Wait Until Element Is Visible    //input[@id='city']    timeout=40s
    Click Element    //input[@id='city']
    Wait Until Page Contains Element    //div[@class="hm_srch"]/span/ul    timeout=45s
    Click Element    //li[@id="Delhi"]
    Wait Until Element Is Enabled    //*[@id='srchbx']
    Input Text    //*[@id='srchbx']    Schools
    Click Button    //button[@class="search-button"]
    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    //span[@class="jbt"][contains(text(),'Fill this form')]/../../span[@class="jcl"]    timeout=20s
    Run Keyword If    ${status}    Click Element    //*[@id='best_deal_div']/section/span[text()='X']
    Comment    Wait Until Element Is Not Visible    //*[@id='best_deal_div']/section/span    timeout=30s
    Capture Page Screenshot
    Scroll To End On Dynamic Page
    &{school_dict}    Create Dictionary    //div[@id="tab-5"]/ul[contains(@class,'col-md-12')]/li[@class="cntanr"]
    ${count}    Get Element Count    //h2[@class="store-name"]/span/a/span[@class="lng_cont_name"]
    FOR    ${i}    IN RANGE    1    ${count}+1
        ${school_name}    Get Text    (//h2[@class="store-name"]/span/a/span[@class="lng_cont_name"])[${i}]
        ${scholl_address}    Get Text    (//p[contains(@class,'address-info')]/span/span)[${i}]
        Set To Dictionary    ${school_dict}    ${school_name}=${scholl_address}
    END
    Log    ${school_dict}
    [Teardown]    Close Browser
