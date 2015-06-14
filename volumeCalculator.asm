.Model small    ;use util when compiling
.386       
.Stack 100h
.Data
    NewLine DB 0dh, 0ah, '$'
    LengthMessage DB 'Enter a side length >', '$'
    ResultMessage DB 'The volume is ', '$' 
    CubicFeet DB ' Cubic feet and ', '$'
    CubicInches DB ' Cubic inches', '$'
    FrontHalfOfReg DD 0h
    BackHalfOfReg DD 0h
    FrontTemp DD 0h
    BackTemp DD 0h
    RemainingCuIn Dw 0h
    StackCounter DB 0h
.Code
    extern PutUDec : NEAR , GetDec : NEAR
VolumeCalculator Proc
        mov ax, @Data
        mov ds, ax
        Repeat 3
            mov dx, offset LengthMessage
            mov ah, 09h
            int 21h
            call GetDec ;result goes to ax
            mov bx, 12
            mul bx      ;result goes to dx:ax
            mov bx, ax  
            call GetDec
            add ax, bx
            push ax
            mov dx, offset NewLine
            mov ah, 09h
            int 21h
        EndM
        pop ax
        pop bx
        mul bx
        mov bx, dx 
        shl ebx, 16
        mov bx, ax
        pop ax
        mul ebx      
        ;result in edx:eax
        
        mov FrontHalfOfReg, edx
        mov FrontTemp, edx
        mov BackHalfOfReg, eax
        mov BackTemp, eax

        mov ebx, 0ah
        xor edx, edx

    ConvertInchesToDec:
        mov eax, FrontTemp
        div ebx
        mov FrontTemp, eax

        mov eax, BackTemp
        div ebx
        mov BackTemp, eax
        push dx
        xor edx, edx
        inc StackCounter

        cmp FrontTemp, 0h
        jne ConvertInchesToDec
        cmp BackTemp, 0h
        jne ConvertInchesToDec
        


        mov dx, offset ResultMessage
        mov ah, 09h
        int 21h

    PrintLoopInches:
        pop ax
        dec StackCounter
        call PutUDec
        cmp StackCounter, 0h
        jne PrintLoopInches
        


        mov dx, offset CubicInches
        mov ah, 09h
        int 21h

        mov dx, offset NewLine
        mov ah, 09h
        int 21h

        mov eax, FrontHalfOfReg
        xor edx, edx
        mov ebx, 1728
        div ebx
        mov FrontTemp, eax

        mov eax, BackHalfOfReg
        div ebx
        mov BackTemp, eax
        mov RemainingCuIn, dx


        mov ebx, 0ah
        xor edx, edx
    ConvertCuFtToDec:
        mov eax, FrontTemp
        div ebx
        mov FrontTemp, eax

        mov eax, BackTemp
        div ebx
        mov BackTemp, eax
        push dx
        inc StackCounter
        xor edx, edx

        cmp FrontTemp, 0h
        jne ConvertCuFtToDec
        cmp BackTemp, 0h
        jne ConvertCuFtToDec



        mov dx, offset ResultMessage
        mov ah, 09h
        int 21h

    PrintLoopFeet:
        pop ax
        dec StackCounter
        Call PutUDec
        cmp StackCounter, 0h
        jne PrintLoopFeet



        mov dx, offset CubicFeet
        mov ah, 09h
        int 21h
        
        mov ax, RemainingCuIn
        xor dx, dx 
    ConvertRemainingCuInToDec:
        div bx    
        push dx
        inc StackCounter
        xor dx, dx
        cmp ax, 0h
        jne ConvertRemainingCuInToDec

    PrintRemainingCuIn:
        pop ax
        dec StackCounter
        Call PutUDec
        cmp StackCounter, 0h
        jne PrintRemainingCuIn

        mov dx, offset CubicInches
        mov ah, 09h
        int 21h

        mov ax, 4c00h
        int 21h
VolumeCalculator EndP

    End VolumeCalculator
