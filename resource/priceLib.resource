*** Settings ***
Documentation    File with Resources for bot search products
Library    SeleniumLibrary
Library    RequestsLibrary
Library    ./../scripts/sendFile.py
Library    ./../scripts/readDotEnv.py
Library    ./../scripts/fetchEmbed.py
Library    ./../scripts/readFiles.py

*** Variables ***
${DiscordEmpty}    Sem Produtos
${UnavailableProduct}    ProdutoIndisponível

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
Screenshot And Search
    ${ProductsCodeList}    Read File Products
    FOR    ${Product}    IN    @{ProductsCodeList}
        Input Text    xpath://input[@id="input-busca"]    ${Product}
        Sleep    1
        Press Keys    xpath://input[@id="input-busca"]    ENTER

        Element Should Not Be Visible    xpath://b[contains(text(), "Lamentamos, nenhum produto encontrado")]    message=O Produto pesquisado nao foi encontrado
        
        Sleep    1
        ${url}    Get Element Attribute    xpath=//a[@data-smarthintproductid='${Product}']    href

        Set Global Variable    ${Link}    ${url}

        Click Element    xpath:(//main/div)[1]
        Sleep    1
        Capture Page Screenshot    ${Product}.png
        Sleep    1

        Send Message    ${Product}.png    ${Product}
    END
Send Message
    [Arguments]    ${NameFile}    ${IdProduct}=

    ${WEBHOOK_URL}    readDot

    ${TitleProduct1}    Get Text    (//h1)[1]
    ${PriceSite}    Get Text    (//h4)[1]
    
    # Função que limpa a string que vem do site para ser formatada
    ${CleanPriceSite}    CleanStringPrice    ${PriceSite}
    
    # Agora se o cleanprice retornar None quer dizer que o produto está indisponínel
    IF    $CleanPriceSite == $None
        Send Message To Discord    ${TitleProduct1}    **Produto Indisponível**    ${WEBHOOK_URL}    ${NameFile}    Código do Produto: **${IdProduct}**
        Log To Console    Produto indisponivel ||${TitleProduct1}||
    ELSE
        ${PriceFloatSite}    Convert To Number    ${CleanPriceSite}
        
        ${PricesList}    Get Description

        If Send message or No    ${PricesList}    ${PriceFloatSite}    ${TitleProduct1}    ${PriceSite}    ${WEBHOOK_URL}    ${NameFile}
    END

    Sleep    2
    Go Back
    Sleep    2
Send Message To Discord
    [Arguments]   ${TitleProduct}     ${PriceSite}    ${WEBHOOK_URL}    ${FileName}    ${Content}=    ${Promocao}=

    ${COLOR}    Evaluate    int("E04428", 16)

    #Faz upload de uma imagem e envia pelo Webhook do Discord
    ${url_img1}    sendImage    ${FileName}

    ${MESSAGE}    Create Dictionary     
    ...    content=${Content}
    ...    embeds=${{[{"title": "${TitleProduct}", "description": "${Promocao}💸 **${PriceSite}**", "color": ${COLOR}, "url": "${Link}", "image": {"url": "${url_img1}"}}]}}

    ${Res}    POST    ${WEBHOOK_URL}    json=${MESSAGE}

    Log To Console    Status Code ${Res}
Read File Products
    ${ProductsList}    Open Files    products_code.txt    r    utf-8
    RETURN    ${ProductsList}
If Send message or No
    [Arguments]    ${PricesList}    ${PriceFloatSite}    ${TitleProduct}    ${PriceSite}    ${WEBHOOK_URL}    ${NameFile}
    
    # Lógica para verificar se o discord tem produtos
    IF    $PricesList != $DiscordEmpty
        FOR    ${price}    IN    @{PricesList}
            IF    $price != $UnavailableProduct
                ${CleanPriceDiscord}    CleanStringPrice    ${price}
                ${PriceFloatDiscord}    Convert To Number    ${CleanPriceDiscord}

                # Lógica para verificar se o preço do site é menor que o preço do produto que já está no discord
                IF    $PriceFloatSite < $PriceFloatDiscord
                    Log To Console    ***PROMOCAO!!!!!*** ${PriceFloatDiscord} -> ${PriceSite}

                    Send Message To Discord   ${TitleProduct}    ${PriceSite}   ${WEBHOOK_URL}    ${NameFile}    🎉🎊 **PROMOÇÃO!!!** 🛍️🔥\\n\\n

                ELSE
                    Log To Console    Nao vou enviar porque o produto nao esta em promocao ||${TitleProduct}||
                    Exit For Loop
                END
            ELSE
                Log To Console    Not is a valid price
            END
        END
    ELSE
        # Só é enviado caso o canal do discord não tenha produtos
        Send Message To Discord   ${TitleProduct}    ${PriceSite}   ${WEBHOOK_URL}    ${NameFile}
    END
