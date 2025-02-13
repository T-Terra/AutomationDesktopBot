*** Settings ***
Documentation    File with Resources for bot search products
Library    SeleniumLibrary

*** Variables ***
${MouseV1}    Mouse Gamer Sem Fio Redragon King 4K Pro, Wireless, 26000 DPI, 7 Botões, Preto - M916-PRO-4K
${MouseV2}    Mouse Gamer Sem Fio Redragon King Pro, 26000 DPI, 7 Botões, Wireless, Bluetooth, Preto - M916-PRO-1K

*** Keywords ***
Open Browser Web
    Open Browser    url=https://www.kabum.com.br/    browser=chrome
    ${Window_Size}    Get Window Size
    Log To Console    Size of Window: ${Window_Size}
    Sleep    3
Search
    Input Text    xpath://input[@id="input-busca"]    ${MouseV1}
    Sleep    2
    Press Keys    xpath://input[@id="input-busca"]    ENTER
    Sleep    10
    