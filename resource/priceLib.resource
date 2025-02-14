*** Settings ***
Documentation    File with Resources for bot search products
Library    SeleniumLibrary

*** Variables ***
${MouseV1}    Mouse Gamer Sem Fio Redragon King 4K Pro, Wireless, 26000 DPI, 7 Botões, Preto - M916-PRO-4K
${MouseV2}    Mouse Gamer Sem Fio Redragon King Pro, 26000 DPI, 7 Botões, Wireless, Bluetooth, Preto - M916-PRO-1K

*** Keywords ***
Open Browser Web
    Open Browser    url=https://www.kabum.com.br/    browser=chrome    options=add_argument("--headless=new")
    Set Screenshot Directory    ${CURDIR}./../img/
    ${Window_Size}    Get Window Size
    Log To Console    Size of Window: ${Window_Size}
    Sleep    2
Search Product 1
    Input Text    xpath://input[@id="input-busca"]    ${MouseV1}
    Sleep    2
    Press Keys    xpath://input[@id="input-busca"]    ENTER
    Sleep    2
    Click Element    xpath:(//main/div)[1]
    Sleep    4
    Capture Page Screenshot    product1.png
    Sleep    2
    ${TitleProduct}    Get Text    (//h1)[1]
    ${Price}    Get Text    (//h4)[1]
    Sleep    4
    Log To Console    ${TitleProduct}
    Log To Console    ${Price}
    Sleep    2
    Go Back
    Sleep    2

Search Product 2
    Input Text    xpath://input[@id="input-busca"]    ${MouseV2}
    Sleep    2
    Press Keys    xpath://input[@id="input-busca"]    ENTER
    Sleep    2
    Click Element    xpath:(//main/div)[1]
    Sleep    4
    Capture Page Screenshot    product2.png
    Sleep    2
    ${TitleProduct}    Get Text    (//h1)[1]
    ${Price}    Get Text    (//h4)[1]
    Sleep    4
    Log To Console    ${TitleProduct}
    Log To Console    ${Price}
    Sleep    2
    