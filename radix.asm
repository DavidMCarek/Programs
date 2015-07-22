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
    BackSpaceCounter        DW  0
    Addition                DB  'A + B = ', '$'
    Subtraction             DB  'A - B = ', '$'
    Multiplication          DB  'A ', 0F9h, ' B = ', '$'
    Division                DB  'A ', 0F6h, ' B = ', '$'
    Power                   DB  'A ^ B = ', '$'
    Decimal                 DB  ' Decimal ', '$'
    Base                    DB  ' Base ', '$'
    Comma                   DB  ', ', '$'
    Quotient                DB  ' Quotient, ', '$'
    Remainder               DB  ' Remainder', '$'
    StackCounter            DW  0
    
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
        mov bl, al
        _PutStr NewLine
        cmp bl, 'y'
        je GetNewInputs
        cmp bl, 'Y'
        je GetNewInputs
        cmp bl, 'n'
        je UserDone
        cmp bl, 'N'
        je UserDone

        _PutStr NewLine
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
        xor ah, ah

        cmp al, 8
        jne NotBackSpace
        cmp BackSpaceCounter, 0
        je SkipErase

        mov dl, 08h
        _PutCh 
        mov dl, 00h
        _PutCh
        mov dl, 08h
        _PutCh
        dec BackSpaceCounter

    SkipErase:
        cmp BackSpaceCounter, 0
        jne DontClearS
        xor si, si

    DontClearS:
        mov ax, bx
        xor dx, dx
        div cx
        mov bx, ax
        jmp GetNextCharacter

    NotBackSpace:

        cmp si, 'S'
        je NegNotNeeded

        cmp al, '-'
        jne NegNotNeeded
        mov si, 01h
        mov dl, '-'
        _PutCh
        inc BackSpaceCounter
        jmp GetNextCharacter

    NegNotNeeded:
        cmp si, 'S'
        jne NoSpecialCharacters

        cmp al, 'B'
        jne NotCapB
        mov bl, 2
        mov dl, al
        _PutCh
        inc BackSpaceCounter
        jmp GetNextCharacter

    NotCapB:
        cmp al, 'b'
        jne NotLowB
        mov bl, 2
        mov dl, al
        _PutCh
        inc BackSpaceCounter
        jmp GetNextCharacter

    NotLowB:
        cmp al, 'O'
        jne NotCapO
        mov bl, 8
        mov dl, al
        _PutCh
        inc BackSpaceCounter
        jmp GetNextCharacter

    NotCapO:
        cmp al, 'o'
        jne NotLowO
        mov bl, 8
        mov dl, al
        _PutCh
        inc BackSpaceCounter
        jmp GetNextCharacter

    NotLowO:
        cmp al, 'D'
        jne NotCapD
        mov bl, 10
        mov dl, al
        _PutCh
        inc BackSpaceCounter
        jmp GetNextCharacter

    NotCapD:
        cmp al, 'd'
        jne NotLowD
        mov bl, 10
        mov dl, al
        _PutCh
        inc BackSpaceCounter
        jmp GetNextCharacter

    NotLowD:
        cmp al, 'H'
        jne NotCapH
        mov bl, 16
        mov dl, al
        _PutCh
        inc BackSpaceCounter
        jmp GetNextCharacter

    NotCapH:
        cmp al, 'h'
        jne NoSpecialCharacters
        mov bl, 16
        mov dl, al
        _PutCh
        inc BackSpaceCounter
        jmp GetNextCharacter

    NoSpecialCharacters:

        cmp al, 0Dh
        je LastCharEntered


        cmp al, '0'
        jb GetNextCharacter
        cmp al, '9'
        ja CheckIfCap

        mov dl, al
        sub al, '0'
        jmp AddToValue

    CheckIfCap:
        cmp al, 'A' 
        jb GetNextCharacter
        cmp al, 'Z'
        ja CheckIfLow

        mov dl, al
        sub al, 37h
        jmp AddToValue

    CheckIfLow:
        cmp al, 'a'
        jb GetNextCharacter
        cmp al, 'z'
        ja GetNextCharacter

        mov dl, al
        sub al, 57h

    AddToValue:
        cmp al, cl
        jge GetNextCharacter
        xchg ax, bx
        push dx
        xor dx, dx
        mul cx
        add bx, ax
        pop dx
        _PutCh
        inc BackSpaceCounter
        jmp GetNextCharacter

    LastCharEntered:
        mov ax, bx
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

        ;Addition
        _PutStr Addition
        mov ax, InputA
        add ax, InputB

        mov bx, ax
        mov cx, OutputRadix
        call PutRadix
        _PutStr Base
        mov cx, 0Ah
        mov ax, OutputRadix
        call PutRadix
        _PutStr Comma
        mov ax, bx
        call PutRadix
        _PutStr Decimal
        _PutStr NewLine
    
        ;Subtraction
        _PutStr Subtraction
        mov ax, InputA
        sub ax, InputB

        mov bx, ax
        mov cx, OutputRadix
        call PutRadix
        _PutStr Base
        mov cx, 0Ah
        mov ax, OutputRadix
        call PutRadix
        _PutStr Comma
        mov ax, bx
        call PutRadix
        _PutStr Decimal
        _PutStr NewLine
    
        ;Multiplication
        _PutStr Multiplication
        mov ax, InputA
        mov bx, InputB
        imul bx
    
        mov bx, ax
        mov cx, OutputRadix
        call PutRadix
        _PutStr Base
        mov cx, 0Ah
        mov ax, OutputRadix
        call PutRadix
        _PutStr Comma
        mov ax, bx
        call PutRadix
        _PutStr Decimal
        _PutStr NewLine

        ;Division
        _PutStr Division
        mov ax, InputA
        mov bx, InputB
        cwd 
        idiv bx
        push ax
        push dx

        mov cx, OutputRadix
        call PutRadix
        _PutStr Quotient 
        pop ax
        mov bx, ax
        call PutRadix
        _PutStr Remainder
        _PutStr Base
        mov cx, 0Ah
        mov ax, OutputRadix
        call PutRadix
        _PutStr Comma
        pop ax
        call PutRadix
        _PutStr Quotient
        mov ax, bx
        call PutRadix
        _PutStr Remainder
        _PutStr Decimal
        _PutStr NewLine

        ;Power
        _PutStr Power
        mov ax, InputA
        mov bx, InputA
        mov cx, InputB
        cmp cx, 0
        jge PositivePower
        neg cx
    PositivePower:
        xor dx, dx

    PowerLoop:
        dec cx
        cmp cx, 0
        je DoneWithPower
        mul bx
        jmp PowerLoop
        
    DoneWithPower:

        mov bx, ax
        mov cx, OutputRadix
        call PutRadix
        _PutStr Base
        mov cx, 0Ah
        mov ax, OutputRadix
        call PutRadix
        _PutStr Comma
        mov ax, bx
        call PutRadix
        _PutStr Decimal
        _PutStr NewLine

        ret
    DoTheMath   EndP

;/////////////////////////////////////////////////////////

    PutRadix    Proc

        ;cx has output radix
        ;ax has value to print
        push bx
        push cx
        push dx
        push si
        pushf

        mov StackCounter, 0

        cmp ax, 0
        jge OutputIsPositive
        mov si, 1
        neg ax

    OutputIsPositive:
    ;look for this line
        xor dx, dx
        div cx

        push dx
        inc StackCounter
        cmp ax, 0
        je ValueConverted
        jmp OutputIsPositive

    ValueConverted:
        mov cx, StackCounter
        cmp si, 1
        jne PrintLoop
        mov dl, '-'
        _PutCh
        xor dx, dx
        
    PrintLoop:
        pop dx
        dec cx
        
        cmp dx, 9
        jg LetterOutput
        add dx, '0'
        _PutCh
        jcxz PrintFinish 
        jmp PrintLoop

    LetterOutput:
        add dx, 37h
        _PutCh
        jcxz PrintFinish 
        jmp PrintLoop

    PrintFinish:

        popf
        pop si 
        pop dx
        pop cx
        pop bx

        ret
    PutRadix    EndP

;/////////////////////////////////////////////////////////

    End     Radix

