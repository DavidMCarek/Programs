.Model  small
.386
.Stack  100h
.Data
    NewLine         DB 0dh, 0ah, '$'
    MaxStrLength    equ 51
    Buffer          DB MaxStrLength
                    DB ?
                    DB 51 dup(?)

    GetNewInputMsg  DB 'Please enter a new string of characters > ', '$'
    FunctionList    DB 'Please enter a number 1-9 to select a function', 0dh, 0ah,
                     '1) Find the location of a characters first occurence', 0dh, 0ah,
                     '2) Find the number of occurences of a character', 0dh, 0ah,
                     '3) Find the length of the string', 0dh, 0ah,
                     '4) Find the number of alpha numeric characters', 0dh, 0ah,
                     '5) Replace every occurence of a letter with a different one', 0dh, 0ah,
                     '6) Capitalize all letters in the string', 0dh, 0ah,
                     '7) Lowercase all letter in the string', 0dh, 0ah,
                     '8) Toggle the case of all letters', 0dh, 0ah,
                     '9) Input a new String', 0dh, 0ah,
                     'U) Undo the last function (only works once)', 0dh, 0ah,
                     'E) Exit', 0dh, 0ah, '$'
    CurrentString   DB '$'
    InvalidInputMsg DB 'The input entered was not a valid function', 0dh, 0ah, '$'

.Code

    Main Proc
   ; call GetNewInput

SelectNewFunction:

    call SelectFunction

    cmp al, 'e'
    je ExitProgram
    cmp al, 'E'
    je ExitProgram

    call RunFunction
    jmp SelectNewFunction

ExitProgram: 

    mov ah, 4ch
    int 21h
    Main EndP 

    ; this proc leaves selected function in al and clears ah
    SelectFunction Proc
    push dx
    mov ah, 09h
    mov dx, offset FunctionList
    int 21h

    mov ah, 01h
    int 21h

    xor ah, ah
    pop dx
    ret
    SelectFunction EndP 

    RunFunction Proc
    pushf
    push ax
    cmp al, '1'
    jne NotF1
    call Function1
    jmp FunctionRun
    NotF1:
    
    cmp al, '2'
    jne NotF2
    call Function2
    jmp FunctionRun
    NotF2:

    cmp al, '3'
    jne NotF3
    call Function3
    jmp FunctionRun
    NotF3:

    cmp al, '4'
    jne NotF4
    call Function4
    jmp FunctionRun
    NotF4:

    cmp al, '5'
    jne NotF5
    call Function5
    jmp FunctionRun
    NotF5:

    cmp al, '6'
    jne NotF6
    call Function6
    jmp FunctionRun
    NotF6:

    cmp al, '7'
    jne NotF7
    call Function7
    jmp FunctionRun
    NotF7:

    cmp al, '8'
    jne NotF8
    call Function8
    jmp FunctionRun
    NotF8:

    cmp al, '9'
    jne NotF9
    call Function9
    jmp FunctionRun
    NotF9:

    cmp al, 'u'
    jne NotLowU
    call Undo
    jmp FunctionRun
    NotLowU:

    cmp al, 'U'
    jne NotCapU
    call Undo
    jmp FunctionRun
    NotCapU:

    mov dx, offset InvalidInputMsg
    mov ah, 09h
    int 21h

    FunctionRun:

    pop ax
    popf

    ret
    RunFunction EndP

    Function1 Proc

    ret
    Function1 EndP

    Function2 Proc

    ret
    Function2 EndP


    Function3 Proc

    ret
    Function3 EndP

    Function4 Proc

    ret
    Function4 EndP

    Function5 Proc

    ret
    Function5 EndP


    Function6 Proc

    ret
    Function6 EndP

    Function7 Proc

    ret
    Function7 EndP

    Function8 Proc

    ret
    Function8 EndP


    Function9 Proc

    ret
    Function9 EndP

    Undo Proc

    ret
    Undo EndP

End Main
