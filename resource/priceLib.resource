*** Settings ***
Documentation    File with Resources for bot search products
Library    SeleniumLibrary
Library    RequestsLibrary
Library    ./../scripts/sendFile.py
Library    ./../scripts/readDotEnv.py

*** Variables ***
${MouseV1}    Mouse Gamer Sem Fio Redragon King 4K Pro, Wireless, 26000 DPI, 7 Botões, Preto - M916-PRO-4K
${MouseV2}    Mouse Gamer Sem Fio Redragon King Pro, 26000 DPI, 7 Botões, Wireless, Bluetooth, Preto - M916-PRO-1K
${FileName1}      product1.png
${FileName2}      product2.png

*** Keywords ***
Open Browser Web
    Open Browser    url=https://www.kabum.com.br/    browser=chrome    options=add_argument("--headless=new")
    Set Screenshot Directory    ${CURDIR}./../img/
    Sleep    1
Screenshot1
    Input Text    xpath://input[@id="input-busca"]    ${MouseV1}
    Sleep    1
    Press Keys    xpath://input[@id="input-busca"]    ENTER
    Sleep    1
    Click Element    xpath:(//main/div)[1]
    Sleep    1
    Capture Page Screenshot    product1.png
    Sleep    1

Send Message Discord1
    ${WEBHOOK_URL}    readDot

    ${TitleProduct1}    Get Text    (//h1)[1]
    ${Price1}    Get Text    (//h4)[1]
    Sleep    2
    
    ${COLOR}    Evaluate    int("E04428", 16)
     
    #Faz upload de uma imagem e envia pelo Webhook do Discord
    ${url_img1}    sendImage    ${FileName1}

    ${MESSAGE}    Create Dictionary     
    ...    content=
    ...    embeds=${{[{"title": "${TitleProduct1}", "description": "💸**${Price1}**", "color": ${COLOR}, "image": {"url": "${url_img1}"}}]}}

    ${Res}    POST    ${WEBHOOK_URL}    json=${MESSAGE}

    Log To Console    ${Res}

    Sleep    2
    Go Back
    Sleep    2

Screenshot2
    Input Text    xpath://input[@id="input-busca"]    ${MouseV2}
    Sleep    1
    Press Keys    xpath://input[@id="input-busca"]    ENTER
    Sleep    1
    Click Element    xpath:(//main/div)[1]
    Sleep    1
    Capture Page Screenshot    product2.png
    Sleep    1

Send Message Discord2
    ${WEBHOOK_URL}    readDot

    ${TitleProduct2}    Get Text    (//h1)[1]
    ${Price2}    Get Text    (//h4)[1]
    Sleep    2
    
    ${COLOR}    Evaluate    int("E04428", 16)
        
    #Faz upload de uma imagem e envia pelo Webhook do Discord
    ${url_img2}    sendImage    ${FileName2}

    ${MESSAGE}    Create Dictionary     
    ...    content=
    ...    embeds=${{[{"title": "${TitleProduct2}", "description": "💸**${Price2}**", "color": ${COLOR}, "image": {"url": "${url_img2}"}}]}}

    ${Res}    POST    ${WEBHOOK_URL}    json=${MESSAGE}

    Log To Console    ${Res}

    Sleep    1