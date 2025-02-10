*** Settings ***
Documentation    File with Resources for test
Library    RPA.Windows

*** Variables ***
${PROGRAM}    notepad.exe
${KEYS}    Isso é uma automação robot framework

*** Keywords ***
Open Program 
    [Documentation]    Abre o Notepad e escreve texto automatizado
    Windows Run     ${PROGRAM}
Entry Text
    Send Keys    class:RichEditD2DPT    keys=${KEYS}   interval=0.1    send_enter=True