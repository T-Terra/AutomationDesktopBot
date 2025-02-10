*** Settings ***
Documentation    File with Resources for test
Library    RPA.Windows

*** Variables ***
${PROGRAM}    notepad.exe

*** Keywords ***
Open Program 
    [Documentation]    Abre o Notepad e escreve texto automatizado
    Windows Run     ${PROGRAM}