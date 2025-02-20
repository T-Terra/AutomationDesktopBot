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
${DiscordEmpty}    Sem Produtos

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
    ${WEBHOOK_URL}    readDot

    ${TitleProduct1}    Get Text    (//h1)[1]
    ${PriceSite}    Get Text    (//h4)[1]
    
    # Função que limpa a string para ser formatada
    ${CleanPriceSite}    CleanStringPrice    ${PriceSite}
    
    ${PriceFloatSite}    Convert To Number    ${CleanPriceSite}
    
    ${PricesList}    Get Description
    
    # Lógica para verificar se o discord tem produtos
    IF    $PricesList != $DiscordEmpty
        FOR    ${price}    IN    @{PricesList}
            ${CleanPriceDiscord}    CleanStringPrice    ${price}
            ${PriceFloatDiscord}    Convert To Number    ${CleanPriceDiscord}

            # Lógica para verificar se o preço do site é menor que o preço do produto que já está no discord
            IF    $PriceFloatSite < $PriceFloatDiscord
                Log To Console    ***PROMOCAO!!!!!*** ${PriceFloatDiscord} -> ${PriceSite}

                Send Message To Discord   ${TitleProduct1}    ${PriceSite}   ${WEBHOOK_URL}    ${FileName1}    🎉🎊 **PROMOÇÃO!!!** 🛍️🔥\\n\\n

            ELSE
                Log To Console    Nao vou enviar porque o produto nao esta em promocao ||${TitleProduct1}||
                Exit For Loop
            END
        END
    ELSE
        # Só é enviado caso o canal do discord não tenha produtos
        Send Message To Discord   ${TitleProduct1}    ${PriceSite}   ${WEBHOOK_URL}    ${FileName1}
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
    ${WEBHOOK_URL}    readDot

    ${TitleProduct2}    Get Text    (//h1)[1]
    ${PriceSite}    Get Text    (//h4)[1]
    Sleep    2
    
    # Função que limpa a string para ser formatada
    ${CleanPriceSite}    CleanStringPrice    ${PriceSite}
    
    ${PriceFloatSite}    Convert To Number    ${CleanPriceSite}
    
    ${PricesList}    Get Description
    
    # Lógica para verificar se o discord tem produtos
    IF    $PricesList != $DiscordEmpty
        FOR    ${price}    IN    @{PricesList}
            ${CleanPriceDiscord}    CleanStringPrice    ${price}
            ${PriceFloatDiscord}    Convert To Number    ${CleanPriceDiscord}

            # Lógica para verificar se o preço do site é menor que o preço do produto que já está no discord
            IF    $PriceFloatSite < $PriceFloatDiscord
                Log To Console    ***PROMOCAO!!!!!*** ${PriceFloatDiscord} -> ${PriceSite}

                Send Message To Discord   ${TitleProduct2}    ${PriceSite}   ${WEBHOOK_URL}    ${FileName2}    🎉🎊 **PROMOÇÃO!!!** 🛍️🔥\\n\\n

            ELSE
                Log To Console    Nao vou enviar porque o produto nao esta em promocao ||${TitleProduct2}||
                Exit For Loop
            END
        END
    ELSE
        # Só é enviado caso o canal do discord não tenha produtos
        Send Message To Discord   ${TitleProduct2}    ${PriceSite}   ${WEBHOOK_URL}    ${FileName2} 
    END

    Sleep    1
Send Message To Discord
    [Arguments]   ${TitleProduct}     ${PriceSite}    ${WEBHOOK_URL}    ${FileName}    ${Promocao}=

    ${COLOR}    Evaluate    int("E04428", 16)

    #Faz upload de uma imagem e envia pelo Webhook do Discord
    ${url_img1}    sendImage    ${FileName}

    ${MESSAGE}    Create Dictionary     
    ...    content=
    ...    embeds=${{[{"title": "${TitleProduct}", "description": "${Promocao}💸 **${PriceSite}**", "color": ${COLOR}, "url": "${Link}", "image": {"url": "${url_img1}"}}]}}

    ${Res}    POST    ${WEBHOOK_URL}    json=${MESSAGE}

    Log To Console    Status Code ${Res}