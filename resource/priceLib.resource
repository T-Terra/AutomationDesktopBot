*** Settings ***
Documentation    File with Resources for bot search products
Library    SeleniumLibrary
Library    RequestsLibrary
Library    ./../scripts/sendFile.py
Library    ./../scripts/readDotEnv.py
Library    ./../scripts/fetchEmbed.py

*** Variables ***
${MouseV1}    590436
${MouseV2}    523248
${FileName1}      product1.png
${FileName2}      product2.png

*** Keywords ***
Open Browser Web
    Open Browser    url=https://www.kabum.com.br/    browser=chrome    options=add_argument("--headless=new")
    Set Screenshot Directory    ${CURDIR}./../img/
    Set Window Size    945    1012
    Sleep    5
Check Cookies
    ${elemento_existe}    Run Keyword And Return Status    Element Should Be Visible    xpath=//button[@id="onetrust-accept-btn-handler"]
    IF    ${elemento_existe}
        Click Element    xpath=//button[@id="onetrust-accept-btn-handler"]
    ELSE
        Log To Console   O botão não existe na página.
    END
Screenshot1
    Input Text    xpath://input[@id="input-busca"]    ${MouseV1}
    Sleep    1
    Press Keys    xpath://input[@id="input-busca"]    ENTER

    Element Should Not Be Visible    xpath://b[contains(text(), "Lamentamos, nenhum produto encontrado")]    message=O Produto pesquisado nao foi encontrado
    
    Sleep    1
    ${url}    Get Element Attribute    xpath=//a[@data-smarthintproductid='${MouseV1}']    href

    Set Global Variable    ${Link}    ${url}

    Click Element    xpath:(//main/div)[1]
    Sleep    1
    Capture Page Screenshot    product1.png
    Sleep    1

    
Send Message Discord1
    ${Is_different}    Set Variable    True

    ${WEBHOOK_URL}    readDot

    ${TitleProduct1}    Get Text    (//h1)[1]
    ${Price1}    Get Text    (//h4)[1]
    
    ${PricesList}    Get Description
    
    FOR    ${price}    IN    @{PricesList}
        IF    $price == $Price1
            ${Is_different}    Set Variable    False
            Exit For Loop
        ELSE
            Log To Console    ***NÃO É igual*** ${price} -> ${Price1}
        END
    END

    IF    ${Is_different} == True
        ${COLOR}    Evaluate    int("E04428", 16)
    
        #Faz upload de uma imagem e envia pelo Webhook do Discord
        ${url_img1}    sendImage    ${FileName1}

        ${MESSAGE}    Create Dictionary     
        ...    content=
        ...    embeds=${{[{"title": "${TitleProduct1}", "description": "💸**${Price1}**", "color": ${COLOR}, "url": "${Link}", "image": {"url": "${url_img1}"}}]}}

        ${Res}    POST    ${WEBHOOK_URL}    json=${MESSAGE}

        Log To Console    ${Res}
    ELSE
        Log To Console    Nao vou enviar porque já temos o produto ||${TitleProduct1}||
    END
    
    Sleep    2
    Go Back
    Sleep    2

Screenshot2
    Input Text    xpath://input[@id="input-busca"]    ${MouseV2}
    Sleep    1
    Press Keys    xpath://input[@id="input-busca"]    ENTER

    Element Should Not Be Visible    xpath://b[contains(text(), "Lamentamos, nenhum produto encontrado")]    message=O Produto pesquisado nao foi encontrado

    Sleep    1

    ${url}    Get Element Attribute    xpath=//a[@data-smarthintproductid='${MouseV2}']    href

    Set Global Variable    ${Link}    ${url}

    Click Element    xpath:(//main/div)[1]
    Sleep    1
    Capture Page Screenshot    product2.png
    Sleep    1

Send Message Discord2
    ${Is_different}    Set Variable    True

    ${WEBHOOK_URL}    readDot

    ${TitleProduct2}    Get Text    (//h1)[1]
    ${Price2}    Get Text    (//h4)[1]
    Sleep    2
    
    ${PricesList}    Get Description
        
    FOR    ${price}    IN    @{PricesList}
        IF    $price == $Price2
            ${Is_different}    Set Variable    False
            Exit For Loop
        ELSE
            Log To Console    ***NÃO É igual*** ${price} -> ${Price2}
        END
    END
    
    IF    ${Is_different} == True
        ${COLOR}    Evaluate    int("E04428", 16)
            
        #Faz upload de uma imagem e envia pelo Webhook do Discord
        ${url_img2}    sendImage    ${FileName2}

        ${MESSAGE}    Create Dictionary     
        ...    content=
        ...    embeds=${{[{"title": "${TitleProduct2}", "description": "💸**${Price2}**", "color": ${COLOR}, "url": "${Link}", "image": {"url": "${url_img2}"}}]}}

        ${Res}    POST    ${WEBHOOK_URL}    json=${MESSAGE}

        Log To Console    ${Res}
    ELSE
        Log To Console    Nao vou enviar porque já temos o produto ||${TitleProduct2}||
    END

    Sleep    1