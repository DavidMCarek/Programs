.Model small    ;use util when compiling
.386       
.Stack 100h
.Data
    NewLine DB 0dh, 0ah, '$'
    LengthMessage DB 'Enter a side length >', '$'
    ResultMessage DB 'The volume is', '$' 
    CubicFeet DB 'Cubic feet', '$'
    CubicInches DB 'Cubic inches', '$'
    CubicInchesHex DQ 0h 
    ExtendedTemp DD 0h 
    DivisionCarry DB 0h
    Counter DB 0h
    Printer DW 0h
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
        EndM
        pop ax
        pop bx
        mul bx
        mov bx, dx 
        shl ebx, 16
        mov bx, ax
        pop ax
        cwde 
        mul ebx         ;result in edx:eax
        ; need to hold edx:eax somewhere
        mov ebx, 0ah
        mov ecx, eax    ; this will hold the lower half of the number for now
        mov eax, edx    ; move upper half into eax
        mov ExtendedTemp, eax
        xor edx, edx    ; clear edx
        div ebx
        mov DivisionCarry, dl   ; carry will never be more than 10
        mov eax, ecx
    ; convert the back half of the number to dec
    DivideLoop1:
        div ebx
        push dx
        inc Counter
        cmp eax, 0h
        jg DivideLoop1
        
        mov eax, ExtendedTemp

    DivideLoop2:
        div ebx
        push dx
        inc Counter
        cmp eax, 0h
        jg DivideLoop2
    
    PrintLoop1:
        pop ax
        dec Counter
        call PutUDec
        cmp Counter, 0h
        jg PrintLoop1
        

        mov ax, 4c00h
        int 21h
VolumeCalculator EndP

    End VolumeCalculator
