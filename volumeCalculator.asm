.Model small    ;use util when compiling
.386       
.Stack 100h
.Data
    NewLine DB 0dh, 0ah, '$'
    LengthMessage DB 'Enter a side length >', '$'
    ResultMessage DB 'The volume is ', '$' 
    CubicFeet DB ' Cubic feet and ', '$'
    CubicInches DB ' Cubic inches', '$'
    FrontHalfOfInput DD 0h
    BackHalfOfInput DD 0h
    FrontHalfOfCuFt DD 0h
    BackHalfOfCuFt DD 0h
    RemainingCuIn Dw 0h
    Counter DB 0h
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
        cwde 

        mul ebx      
        ;result in edx:eax
        
        mov ebx, 0ah
        mov ecx, eax 
        ; this will hold the lower half of the number for now
        
        mov BackHalfOfInput, ecx
        mov eax, edx    
        ; move upper half into eax

        mov FrontHalfOfInput, eax
        xor edx, edx
        ; clear edx

        div ebx
        mov eax, ecx
    
    ConvertBackHalfToDec:
        div ebx
        push dx
        xor edx, edx
        inc Counter
        cmp eax, 0h
        jg ConvertBackHalfToDec
        
        mov eax, FrontHalfOfInput

    ConvertFrontHalfToDec:
        div ebx
        push dx
        xor edx, edx
        inc Counter
        cmp eax, 0h
        jg ConvertFrontHalfToDec
    
        mov dx, offset ResultMessage
        mov ah, 09h
        int 21h

    PrintLoopInches:
        pop ax
        dec Counter
        call PutUDec
        cmp Counter, 0h
        jg PrintLoopInches
        
        mov dx, offset CubicInches
        mov ah, 09h
        int 21h

        mov dx, offset NewLine
        mov ah, 09h
        int 21h

        mov eax, FrontHalfOfInput
        xor edx, edx
        mov ebx, 1728
        div ebx
        mov FrontHalfOfCuFt, eax

        mov eax, BackHalfOfInput
        div ebx
        mov BackHalfOfCuFt, eax
        mov RemainingCuIn, dx

        mov eax, FrontHalfOfCuft
        mov ebx, 0ah
        xor edx, edx
        div ebx

        mov eax, BackHalfOfCuFt
    ConvertBackCuFtToDec:
        div ebx
        push dx
        inc Counter
        xor edx, edx
        cmp eax, 0h
        jg ConvertBackCuFtToDec

        mov eax, FrontHalfOfCuFt
    ConvertFrontCuFtToDec:
        div ebx
        push dx
        inc Counter
        xor edx, edx
        cmp eax, 0h
        jg ConvertFrontCuFtToDec

        mov dx, offset ResultMessage
        mov ah, 09h
        int 21h

    PrintLoopFt:
        pop ax
        dec Counter
        Call PutUDec
        cmp Counter, 0h
        jg PrintLoopFt

        mov dx, offset CubicFeet
        mov ah, 09h
        int 21h
        
        mov ax, RemainingCuIn
        xor dx, dx 
    ConvertRemainingCuInToDec:
        div bx    
        push dx
        inc Counter
        xor dx, dx
        cmp ax, 0h
        jg ConvertRemainingCuInToDec

    PrintRemainingCuIn:
        pop ax
        dec Counter
        Call PutUDec
        cmp Counter, 0h
        jg PrintRemainingCuIn

        mov dx, offset CubicInches
        mov ah, 09h
        int 21h

        mov ax, 4c00h
        int 21h
VolumeCalculator EndP

    End VolumeCalculator
