*** Settings ***
Resource    ${CURDIR}./../resource/priceLib.resource

*** Test Cases ***
Init Bot
    Open Browser Web
Check For Search
    Check Cookies
    Screenshot1
    Send Message Discord1
    Screenshot2
    Send Message Discord2
Finish Check price
    Close Browser
    