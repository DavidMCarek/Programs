.Model  small
.186
.Stack  100h
Include PCMAC.Inc
.Data
    NewLine                 DB  0Dh, 0Ah, '$'
    InputRadix              DW  0
    InputRadixMsg           DB  'Please enter a value between 2 and 36 for the input radix > ', '$'
    OutputRadix             DW  0
    OutputRadixMsg          DB  'Please enter a value between 2 and 36 for the output radix > ', '$'
    InputA                  DW  0
    InputB                  DW  0
    InputMsg                DB  'Please enter a value in the selected radix between -32768 and 32767 decimal > ', '$'
    RunAgain                DB  'Would you like to run again? (y/Y or n/N) > ', '$'
    InvalidInputMsg         DB  'Invalid input', '$'
    
.Code
    Radix   Proc
        
        mov ax, @Data
        mov ds, ax

    GetNewInputs:
        call GetInputs
        call DoTheMath

    InvalidChar:
        _PutStr RunAgain
        _GetCh
        cmp al, 'y'
        je GetNewInputs
        cmp al, 'Y'
        je GetNewInputs
        cmp al, 'n'
        je UserDone
        cmp al, 'N'
        je UserDone

        _PutStr InvalidInputMsg
        _PutStr NewLine
        jmp InvalidChar

    UserDone:
        _Exit   0

    Radix   EndP

;/////////////////////////////////////////////////////////

    GetInputs   Proc
    
        ;S is for accepting special characters
        mov si, 'S'
        _PutStr InputRadixMsg
        mov cl, 0Ah
        call GetRadix
        mov InputRadix, ax
        _PutStr NewLine
        _PutStr OutputRadixMsg
        call GetRadix
        mov OutputRadix, ax
        _PutStr NewLine
        xor si, si

        _PutStr InputMsg
        mov cx, InputRadix
        call GetRadix
        mov InputA, ax
        _PutStr NewLine
        _PutStr InputMsg
        call GetRadix
        mov InputB, ax
        _PutStr NewLine
        
        ret
    GetInputs   EndP

;/////////////////////////////////////////////////////////

    GetRadix    Proc
        push bx
        push dx
        push si
        pushf

        ;cl has radix for inputs
        cmp si, 'S'
        je LeaveSi
        xor si, si
    LeaveSi:
        xor ch, ch
        xor bx, bx

    GetNextCharacter:
        _GetCh  noEcho

        cmp si, 'S'
        je NegNotNeeded

        cmp al, '-'
        jne NegNotNeeded
        mov si, 01h
        jmp GetNextCharacter

    NegNotNeeded:
        cmp si, 'S'
        jne NoSpecialCharacters
        cmp al, 'B'
        jne NotCapB
        mov bl, 2

    NotCapB:
        cmp al, 'b'
        jne NotLowB
        mov bl, 2
        jmp GetNextCharacter

    NotLowB:
        cmp al, 'O'
        jne NotCapO
        mov bl, 8
        jmp GetNextCharacter

    NotCapO:
        cmp al, 'o'
        jne NotLowO
        mov bl, 8
        jmp GetNextCharacter

    NotLowO:
        cmp al, 'D'
        jne NotCapD
        mov bl, 10
        jmp GetNextCharacter

    NotCapD:
        cmp al, 'd'
        jne NotLowD
        mov bl, 10
        jmp GetNextCharacter

    NotLowD:
        cmp al, 'H'
        jne NotCapH
        mov bl, 16
        jmp GetNextCharacter

    NotCapH:
        cmp al, 'h'
        jne NoSpecialCharacters
        mov bl, 16
        jmp GetNextCharacter

    NoSpecialCharacters:

        cmp al, 0Dh
        je LastCharEntered

        cmp al, 8
        jne NotBackSpace
        mov dl, 08h
        _PutCh 
        mov dl, 00h
        _PutCh
        mov dl, 08h
        _PutCh
        mov ax, bx
        xor dx, dx
        div cx
        mov bx, ax
        jmp GetNextCharacter

    NotBackSpace:

        cmp al, '0'
        jb GetNextCharacter
        cmp al, '9'
        ja CheckIfCap

        mov dl, al
        sub al, '0'
        cmp al, cl
        jge GetNextCharacter
        jmp AddToValue

    CheckIfCap:
        cmp al, 'A' 
        jb GetNextCharacter
        cmp al, 'Z'
        ja CheckIfLow

        mov dl, al
        sub al, 37h
        cmp al, cl
        jge GetNextCharacter
        jmp AddToValue

    CheckIfLow:
        cmp al, 'a'
        jb GetNextCharacter
        cmp al, 'z'
        ja GetNextCharacter

        mov dl, al
        sub al, 57h
        cmp al, cl
        jge GetNextCharacter

    AddToValue:
        xchg ax, bx
        mul cx
        add bx, ax
        _PutCh
        jmp GetNextCharacter

    LastCharEntered:
        mov bx, ax
        cmp si, 01h
        jne DoNotNeg
        neg ax

    DoNotNeg:
        popf
        pop si
        pop dx
        pop bx

        ret
    GetRadix    EndP

;/////////////////////////////////////////////////////////

    DoTheMath   Proc

    ret
    DoTheMath   EndP

;/////////////////////////////////////////////////////////

    PutRadix    Proc

    ret
    PutRadix    EndP

;/////////////////////////////////////////////////////////

    End     Radix

