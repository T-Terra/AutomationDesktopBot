*** Settings ***
Resource    ${CURDIR}./../resource/priceLib.resource

*** Test Cases ***
Init Bot
    Open Browser Web
Check For Search
    Search Product 1
    Search Product 2
Finish Check price
    Close Browser
    