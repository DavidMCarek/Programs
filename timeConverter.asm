.Model   small
.386
.Stack  100h
.Data
    NewLine DB 0dh, 0ah, '$'
    GetInputMsg DB 'Enter the time in hours min sec > ', '$'
    RunAgain DB 'Do you want to repeat (y/n)? ', '$'
    TimeMsg DB 'The time is ', '$'
    SecMsg DB ' Seconds ', '$'
    MinMsg DB ' Minutes ', '$'
    HourMsg DB ' Hours ', '$'
    SecondsTemp DB 0h
    
.Code
    extern GetDec : near, PutDDec : near
TimeConverter   Proc

    mov ax, @Data
    mov ds, ax

GetInputs:
    mov dx, offset GetInputMsg
    mov ah, 09h
    int 21h

    xor eax, eax
    xor ebx, ebx
    xor ecx, ecx
    xor edx, edx

    ;get hours and convert to sec
    mov bx, 3600
    call GetDec
    mul bx
    mov cx, dx
    shl ecx, 10h
    mov cx, ax

    ;get mins and convert to sec
    mov bx, 60
    call GetDec
    mul bx
    shl edx, 10h
    mov dx, ax

    add ecx, edx

    xor eax, eax
    ;get secs and add all together
    call GetDec

    ;value will always fit for 16 bit inputs
    add ecx, eax


    mov ah, 09h
    mov dx, offset NewLine
    int 21h
    mov dx, offset TimeMsg
    int 21h

    mov eax, ecx
    call PutDDec

    mov dx, offset SecMsg
    mov ah, 09h
    int 21h

    mov ah, 09h
    mov dx, offset NewLine
    int 21h
    mov dx, offset TimeMsg
    int 21h

    ;convert to min sec
    xor edx, edx
    mov eax, ecx
    mov ebx, 60
    div ebx
    mov SecondsTemp, dl
    mov ecx, eax

    call PutDDec

    mov ah, 09h
    mov dx, offset MinMsg
    int 21h

    xor eax, eax
    mov al, SecondsTemp

    call PutDDec

    mov ah, 09h
    mov dx, offset SecMsg
    int 21h

    mov ah, 09h
    mov dx, offset NewLine
    int 21h
    mov dx, offset TimeMsg
    int 21h

    ;convert to hr min sec
    xor edx, edx
    mov eax, ecx
    mov ebx, 60
    div ebx
    mov ecx, edx 

    call PutDDec

    mov ah, 09h
    mov dx, offset HourMsg
    int 21h

    mov eax, ecx
    call PutDDec

    mov ah, 09h
    mov dx, offset MinMsg
    int 21h

    xor eax, eax
    mov al, SecondsTemp
    call PutDDec

    mov ah, 09h
    mov dx, offset SecMsg
    int 21h

    mov dx, offset NewLine
    int 21h

    mov dx, offset RunAgain
    int 21h

    mov ah, 01h
    int 21h
    mov bl, al

    mov ah, 09h
    mov dx, offset NewLine
    int 21h

    cmp bl, 'y'
    je GetInputs
    cmp bl, 'Y'
    je GetInputs

    mov ah, 4ch
    int 21h
TimeConverter   EndP

End TimeConverter
