*** Settings ***
Documentation    Search job in linkedin
Library    SeleniumLibrary
Library    ../scripts/readDotEnv.py

*** Variables ***
${URL}    https://www.linkedin.com/
${JOB_DEV}    Desenvolvedor Python

*** Keywords ***
Open Browser Web
    ${HEADLESS}    readLinkedinEnv

    IF    $HEADLESS == True
        Open Browser    url=${URL}   browser=chrome    options=add_argument("--headless=new")
    ELSE
        Open Browser    url=${URL}   browser=chrome
    END
    
    Set Screenshot Directory    ${CURDIR}./../img/
    Set Window Size    1200    1012
    Sleep    5
Login
    Click Element    xpath=//a[contains(text(), "Sign in with email")]
    Sleep    2
    ${CREDENTIALS}    readLinkedinLogin
    
    Sleep    1
    
    Input Text    xpath=//input[contains(@id, "username")]    ${CREDENTIALS}[0]

    Sleep    2

    Input Text    xpath=//input[contains(@id, "password")]    ${CREDENTIALS}[1]

    Sleep    2

    Click Element    xpath=//button[contains(text(), "Sign in")]

    Sleep    10
Search job
    ${ELEMENT_EXISTS_EN}    Run Keyword And Return Status     Page Should Contain Element   xpath=//input[contains(@placeholder, "Search")]
    ${ELEMENT_EXISTS_PT}    Run Keyword And Return Status     Page Should Contain Element   xpath=//input[contains(@placeholder, "Pesquisar")]
    Sleep    3

    Run Keyword If    ${ELEMENT_EXISTS_EN} == True    Input Text    xpath=//input[contains(@placeholder, "Search")]    ${JOB_DEV}\ue007
    Run Keyword If    ${ELEMENT_EXISTS_PT} == True    Input Text    xpath=//input[contains(@placeholder, "Pesquisar")]    ${JOB_DEV}\ue007

    Sleep    2
Get Data
    ${ELEMENT_EXISTS_PT}    Run Keyword And Return Status     Page Should Contain Element   xpath=//li/a[text()="Remoto"]
    
    Sleep    2

    Run Keyword If    ${ELEMENT_EXISTS_PT} == True    Click Element    xpath=//li/a[text()="Remoto"]

    Sleep    5