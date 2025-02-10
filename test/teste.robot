*** Settings ***
Resource    ${CURDIR}./../resource/lib.resource

*** Test Cases ***
Open Notepad
    Open Program
Click In Text Editor
    Click    class:RichEditD2DPT     timeout=5

Write Text
    Entry Text
    Sleep    5
Close Window
    Close Window    class:Notepad