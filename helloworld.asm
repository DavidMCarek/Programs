.MODEL	small
.186
.STACK	100H
.DATA	
Message	DB	'Hello World', 13, 10, '$'
.CODE
Hello	PROC
	mov	ax, @DATA
	mov	ds,ax
	mov	dx,offset Message
    mov ah, 9
    int 21h
    mov ax, 4c00h
	int	21h
Hello	ENDP	
END
