*** Settings ***
Resource    ${CURDIR}./../resource/lib.resource

*** Test Cases ***
Open Notepad
    Open Program
Click In Text Editor
    Click    class:RichEditD2DPT     timeout=5

Write Text
    Send Keys    class:RichEditD2DPT    keys=Gabriel é lindo!    interval=0.1    send_enter=True
    Send Keys    class:RichEditD2DPT    keys=Isso é uma automação robot framework    interval=0.1    send_enter=True
    Sleep    3
Close Window
    Close Window    class:Notepad