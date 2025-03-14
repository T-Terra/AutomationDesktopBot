*** Settings ***
Resource    ${CURDIR}./../../resource/linkedin.resource

*** Test Cases ***
Init Bot
    Open Browser Web
    Login
    Search job
Finish
    Close Browser