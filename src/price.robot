*** Settings ***
Resource    ${CURDIR}./../resource/priceLib.resource

*** Test Cases ***
Init Bot
    Open Browser Web
Check For Search
    Check Cookies
    Screenshot And Search
Finish Check price
    Close Browser
    