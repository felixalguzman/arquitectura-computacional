



.model small

.stack 256



.data



;========================Variables declaradas aqui===========================

var1    db 8			;variable tipo byte con valor inicial ascci
buffer 	db 10 dup (9)		;buffer de 10 bytes.
mensaje db 10 "Hola amigos$"


buffer2 	db 9
			db 9
			db 9
			db 9
			db 9
			db 9
			db 9
			db 9
			db 9
			db 9
			jose db  76					;variable tipo byte con valor inicial decimal
joswa db  76h				;variable tipo byte con valor inicial hexadecimal
binario db 101b				;variable tipo byte con valor inicial binario
octal db 7o					;variable tipo byte con valor inicial octal
josegran dw 0ffffh			;variable de 16bits







;============================================================================

.code
main:	
	mov ax,@data
	mov ds,ax
	mov es, ax                  ;set segment register
    and sp, not 3               ;align stack to avoid AC fault

	
;====================================Código==================================  

nop
mov al,jose




;============================================================================

.exit
;================================Funciones aqui==============================

MOV AH,09h
LEA DX,mensaje
INT 21H




;============================================================================
end main
