.Model small
.186
.Stack 100h
Include PCMAC.inc
.Data
    NewLine     DB 0dh, 0ah, '$'
    Input1Msg   DB 'Enter the first number > ', '$'
    Input2Msg   DB 'Enter the second number > ', '$'
    Input1      DW 0
    Input2      DW 0
    Product     DB 'Product > ', '$'
    Quotient    DB 'Quotient Remainder > ', '$'
    Remainder   DB ' R ', '$'
    Sum         DB 'Absolute value of the sum > ', '$'
    Difference  DB 'Absolute value of the Difference > ', '$'
    RepeatMsg   DB 'Y or y to repeat, any other key to exit > ', '$'

.Code

    extern PutUDec : near, GetDec : near

    Midterm Proc

        mov ax, @Data
        mov ds, ax

    GetInput:
        _PutStr Input1Msg
        call GetDec
        mov Input1, ax
        _PutStr Input2Msg
        call GetDec
        mov Input2, ax

        cmp Input1, 0
        jl NegativeInput
        cmp Input2, 0
        jl NegativeInput

        _PutStr Quotient
        xor dx, dx
        mov ax, Input1
        mov bx, Input2
        div bx
        mov bx, dx

        call PutUDec
        _PutStr Remainder
        mov ax, bx
        call PutUDec
        _PutStr NewLine

        _PutStr Product
        mov ax, Input1
        mov bx, Input2
        mul bx
        call PutUDec
        _PutStr NewLine

        jmp RunAgain

    NegativeInput:
        _PutStr Sum
        mov ax, Input1
        mov bx, Input2
        add ax, bx
        cmp ax, 0
        jge DontNeg
        neg ax

    DontNeg:
        call PutUDec
        _PutStr NewLine

        _PutStr Difference
        mov ax, Input1
        sub ax, bx
        cmp ax, 0
        jge PositiveDiff
        neg ax

    PositiveDiff:
        call PutUDec
        _PutStr NewLine

    RunAgain:
        _PutStr RepeatMsg
        _GetCh
        mov bl, al
        _PutStr NewLine
        cmp bl, 'Y'
        je GetInput
        cmp bl, 'y'
        je GetInput

        _Exit 0
    Midterm EndP

End Midterm
