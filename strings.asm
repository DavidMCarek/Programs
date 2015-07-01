.Model  small
.386
.Stack  100h
Include PCMAC.Inc
.Data
    NewLine         DB 0dh, 0ah, '$'
    MaxStrLength    equ 51
    Buffer          DB MaxStrLength
                    DB ?
    CurrentString   DB 51 dup('$')

    CurrentStringMsg    DB 'The current string > ', '$'
    GetNewInputMsg  DB 'Please enter a new string of characters > ', '$'
    SelectFMsg      DB 'Please enter a number 1-9 to select a function or 0 to list the functions', 0dh, 0ah, '$'
    F1Msg   DB '1) Find the location of a characters first occurence', 0dh, 0ah, '$'
    F1InputMsg  DB 'Please enter a character to search for > ', '$'
    F2Msg   DB '2) Find the number of occurences of a character', 0dh, 0ah, '$'
    F3Msg   DB '3) Find the length of the string', 0dh, 0ah, '$'
    F4Msg   DB '4) Find the number of alpha numeric characters',0dh, 0ah, '$'
    F5Msg   DB '5) Replace every occurence of a letter with a different one', 0dh, 0ah, '$'
    F6Msg   DB '6) Capitalize all letters in the string', 0dh, 0ah, '$'
    F7Msg   DB '7) Lowercase all letter in the string', 0dh, 0ah, '$'
    F8Msg   DB '8) Toggle the case of all letters', 0dh, 0ah, '$'
    F9Msg   DB '9) Input a new String', 0dh, 0ah, '$'
    UndoMsg DB 'U) Undo the last function (only works once)', 0dh, 0ah, '$'
    ExitMsg DB 'E) Exit', 0dh, 0ah, '$'
    NoCharMatch     DB 'The character select could not be found ', 0dh, 0ah, '$'
    CharFoundAt     DB '(0 indexed) The character was found at location ', '$'
    InvalidInputMsg DB 'The input entered was not a valid function', 0dh, 0ah, '$'

.Code

    extern PutDec : near

    Main Proc
    mov ax, @Data
    mov ds, ax
    call Function9 

SelectNewFunction:

    _PutStr SelectFMsg
    _GetCh
    mov bl, al
    _PutStr NewLine
    mov al, bl

    cmp al, 'e'
    je ExitProgram
    cmp al, 'E'
    je ExitProgram

    call RunFunction
    call PrintString
    jmp SelectNewFunction

ExitProgram: 

    mov ah, 4ch
    int 21h
    Main EndP 

    RunFunction Proc
    pushf
    push ax

    cmp al, '0'
    jne NotF0
    call Function0
    jmp FunctionRun
    NotF0:

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

    Function0 Proc

        _PutStr F1Msg
        _PutStr F2Msg
        _PutStr F3Msg
        _PutStr F4Msg
        _PutStr F5Msg
        _PutStr F6Msg
        _PutStr F7Msg
        _PutStr F8Msg
        _PutStr F9Msg
        _PutStr UndoMsg
        _PutStr ExitMsg

    ret
    Function0 EndP

    Function1 Proc

    _PutStr F1InputMsg
    _GetCh
    xor ah, ah
    push ax
    _PutStr NewLine
    pop ax

    mov bx, offset CurrentString
    mov cx, -1
    dec bx
    CheckMatchForChar:
    inc cx
    inc bx
    cmp byte ptr [bx], '$'
    je NoMatch
    cmp byte ptr [bx], al
    jne CheckMatchForChar
    _PutStr CharFoundAt
    mov ax, cx
    call PutDec
    jmp MatchFound

    NoMatch:
    _PutStr NoCharMatch

    MatchFound:
    _PutStr NewLine

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

    _PutStr GetNewInputMsg
    _GetStr Buffer
    _PutStr NewLine

    ret
    Function9 EndP

    Undo Proc

    ret
    Undo EndP

    PrintString Proc

    _PutStr CurrentStringMsg
    _PutStr CurrentString
    _PutStr NewLine

    ret
    PrintString EndP


End Main
