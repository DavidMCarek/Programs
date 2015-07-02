.Model  small
.186
.Stack  100h
Include PCMAC.Inc
.Data
    NewLine         DB 0dh, 0ah, '$'
    MaxStrLength    equ 51

    Buffer          DB MaxStrLength
    StringLength    DB ?
    CurrentString   DB MaxStrLength dup('$')
                    DB '$'
    PrevStrLength   DB ?
    PrevString      DB MaxStrLength dup('$')

    CurrentStringMsg    DB 'The current string > ', '$'
    GetNewInputMsg  DB 'Please enter a new string of characters > ', '$'
    SelectFMsg      DB 'Please enter a number 1-9 to select a function or 0 to list the functions', 0dh, 0ah, '$'
    F1Msg   DB '1) Find the location of a characters first occurence', 0dh, 0ah, '$'
    F2Msg   DB '2) Find the number of occurences of a character', 0dh, 0ah, '$'
    F3Msg   DB '3) Find the length of the string', 0dh, 0ah, '$'
    F4Msg   DB '4) Find the number of alphanumeric characters',0dh, 0ah, '$'
    F5Msg   DB '5) Replace every occurence of a letter with a different one', 0dh, 0ah, '$'
    F6Msg   DB '6) Capitalize all letters in the string', 0dh, 0ah, '$'
    F7Msg   DB '7) Lowercase all letter in the string', 0dh, 0ah, '$'
    F8Msg   DB '8) Toggle the case of all letters', 0dh, 0ah, '$'
    F9Msg   DB '9) Input a new String', 0dh, 0ah, '$'
    UndoMsg DB 'U) Undo the last function (cannot undo more than 1 function)', 0dh, 0ah, '$'
    ExitMsg DB 'E) Exit', 0dh, 0ah, '$'
    ReplaceeChar    DB 'Please enter the character to be replaced > ', '$'
    ReplacerChar    DB 'Please enter the character to replace the one above > ', '$'
    NmbrOfCharsMsg  DB 'Number of alphanumeric characters > ', '$' 
    FindCharMsg     DB 'Please enter a character to search for > ', '$'
    NoCharMatch     DB 'The character selected could not be found ', 0dh, 0ah, '$'
    CharFoundAt     DB 'Character location (0 indexed) > ', '$'
    CharOccurences  DB 'Character occurences > ', '$'
    LengthMsg       DB 'String length > ', '$'
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

    _Exit   0
    Main EndP 

;/////////////////////////////////////////////////

    RunFunction Proc

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
    call StoreString
    call Function6
    jmp FunctionRun
NotF6:

    cmp al, '7'
    jne NotF7
    call StoreString
    call Function7
    jmp FunctionRun
NotF7:

    cmp al, '8'
    jne NotF8
    call StoreString
    call Function8
    jmp FunctionRun
NotF8:

    cmp al, '9'
    jne NotF9
    call StoreString
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

    ret
    RunFunction EndP

;/////////////////////////////////////////////////

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

;/////////////////////////////////////////////////

    Function1 Proc

    _PutStr FindCharMsg 
    _GetCh
    mov bl, al
    _PutStr NewLine
    mov al, bl

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

;/////////////////////////////////////////////////

    Function2 Proc

    _PutStr FindCharMsg
    _GetCh
    mov bl, al
    _PutStr NewLine
    mov al, bl
    
    mov cx, 0
    mov bx, offset CurrentString
    dec bx

CheckChar:
    inc bx
    cmp byte ptr [bx], '$'
    je DoneCounting
    cmp byte ptr [bx], al
    jne CheckChar
    inc cx
    jmp CheckChar

DoneCounting:
    _PutStr CharOccurences
    mov ax, cx
    call putDec 
    _PutStr NewLine

    ret
    Function2 EndP

;/////////////////////////////////////////////////

    Function3 Proc

    _PutStr LengthMsg
    xor ah, ah
    mov al, StringLength
    call PutDec
    _PutStr NewLine
    
    ret
    Function3 EndP

    Function4 Proc

    _PutStr NmbrOfCharsMsg

    mov cx, 0
    mov bx, offset CurrentString
    dec bx

    CheckNextChar:
    inc bx
    cmp byte ptr [bx], '$'
    je DoneCountingChars

    cmp byte ptr [bx], '0'
    jb Not0_9
    cmp byte ptr [bx], '9'
    ja Not0_9
    inc cx
    jmp CheckNextChar

    Not0_9:

    cmp byte ptr [bx], 'A'
    jb NotCapA_Z
    cmp byte ptr [bx], 'Z'
    ja NotCapA_Z
    inc cx
    jmp CheckNextChar

    NotCapA_Z:

    cmp byte ptr [bx], 'a'
    jb NotLowA_Z
    cmp byte ptr [bx], 'z'
    ja NotLowA_Z
    inc cx

    NotLowA_Z:

    jmp CheckNextChar

    DoneCountingChars:

    mov ax, cx
    call PutDec
    _PutStr NewLine

    ret
    Function4 EndP

;/////////////////////////////////////////////////

    Function5 Proc

    _PutStr ReplaceeChar
    _GetCh
    mov bl, al
    _PutStr NewLine

    _PutStr ReplacerChar
    _GetCh
    mov bh, al
    _PutStr NewLine
    mov ax, bx

    mov bx, offset CurrentString
    dec bx

    ReplaceNext:
    inc bx
    cmp byte ptr [bx], '$'
    je DoneReplacing

    cmp byte ptr [bx], al
    jne ReplaceNext
    mov byte ptr [bx], ah
    jmp ReplaceNext

    DoneReplacing:
    ret
    Function5 EndP

;/////////////////////////////////////////////////

    Function6 Proc

    mov bx, offset CurrentString
    dec bx

    CheckIfLower:
    inc bx
    cmp byte ptr [bx], '$'
    je DoneCapping

    cmp byte ptr [bx], 'a'
    jb CheckIfLower
    cmp byte ptr [bx], 'z'
    ja CheckIfLower
    and byte ptr [bx], 11011111B
    jmp CheckIfLower

    DoneCapping:

    ret
    Function6 EndP

;/////////////////////////////////////////////////

    Function7 Proc

    mov bx, offset CurrentString
    dec bx

    CheckIfUpper:
    inc bx
    cmp byte ptr [bx], '$'
    je DoneLowering

    cmp byte ptr [bx], 'A'
    jb CheckIfUpper
    cmp byte ptr [bx], 'Z'
    ja CheckIfUpper
    or byte ptr [bx], 00100000B
    jmp CheckIfUpper

    DoneLowering:

    ret
    Function7 EndP

;/////////////////////////////////////////////////

    Function8 Proc

    mov bx, offset CurrentString
    dec bx

    CheckIfAlpha:
    inc bx
    cmp byte ptr [bx], '$'
    je DoneCheckingAlpha

    cmp byte ptr [bx], 'A'
    jb CheckIfAlpha
    cmp byte ptr [bx], 'Z'
    ja NotCapAorZ 
    or byte ptr [bx], 00100000B
    jmp CheckIfAlpha

    NotCapAorZ:
    cmp byte ptr [bx], 'a'
    jb CheckIfAlpha
    cmp byte ptr [bx], 'z'
    ja CheckIfAlpha
    and byte ptr [bx], 11011111B
    jmp CheckIfAlpha

    DoneCheckingAlpha:

    ret
    Function8 EndP

;/////////////////////////////////////////////////

    Function9 Proc

    mov cl, StringLength
    mov bx, offset CurrentString

    ClearNextByte:
    cmp cl, 0
    je Cleared
    mov byte ptr [bx], '$'
    inc bx
    dec cl
    jmp ClearNextByte

    Cleared:
    _PutStr GetNewInputMsg
    _GetStr Buffer
    _PutCh 0ah

    ret
    Function9 EndP

;/////////////////////////////////////////////////

    Undo Proc

    mov dl, PrevStrLength
    mov StringLength, dl
    
    mov bx, offset CurrentString
    mov si, offset PrevString

    mov cx, MaxStrLength

    CopyNextByte:
    mov al, byte ptr [si]
    mov byte ptr [bx], al 
    inc bx
    inc si
    dec cx
    jnz CopyNextByte

    ret
    Undo EndP

;/////////////////////////////////////////////////

    StoreString Proc

    mov dl, StringLength
    mov PrevStrLength, dl
    
    mov bx, offset CurrentString
    mov si, offset PrevString

    mov cx, MaxStrLength

    CopyByte:
    mov al, byte ptr [bx]
    mov byte ptr [si], al 
    inc bx
    inc si
    dec cx
    jnz CopyByte

    ret
    StoreString EndP

;/////////////////////////////////////////////////

    PrintString Proc

    _PutStr CurrentStringMsg
    _PutStr CurrentString
    _PutStr NewLine

    ret
    PrintString EndP


End Main
