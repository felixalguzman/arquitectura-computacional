



.model small

.stack 256



.data



;========================Variables declaradas aqui===========================
var 	dW 8				;VARIABLE TIPO BYTE
var2 	dW 9
var3	db 10H
leido 	dw  0
	
	
buffer 	db 103 dup ('$')
buffer2	db 'hola'

		






;============================================================================

.code
main:	
	mov ax,@data

	mov ds,ax
	mov es, ax                  ;set segment register
    and sp, not 3               ;align stack to avoid AC fault

	
;====================================Código==================================  

mov bx,0						;indice de buffer
mov buffer[0],100

mov ah,0aH						;para la lectura de un string
mov dx, offset buffer			;direccion del buffer.
int 21H
mov al,buffer[1]				;tomo el total leido

;_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
;TOMA E VALOR DE LA CANTIDAD LEIDA REAL
;_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

mov cl,buffer[1]				;tomo el valor de caracteres recibidos
mov ch,0
mov leido,cx					;cantidad leida

call compare
call copy_buf

ok:
mov dl,buffer[bx+2]				;tomo dato del buffer
mov ah,02						;desplegar un caracter
int 21H

mov cl,buffer[1]				;tomo el valor de caracteres recibidos
mov ch,0
cmp bx,cx						;verifico si imprimí todo
inc bx							;apunto a próximo caracter
jne ok

fin:
;============================================================================

.exit
;================================Funciones aqui==============================

copy_buf:

push ax bx

mov bx,0
kk:
mov al,buffer[bx]					;leo buffer 1
mov buffer2[bx],al					;escribo en  buffer 2
inc bx
cmp al,'$'
jne kk 
 
pop bx ax 
ret

compare:

push ax bx di

ll:
mov al,buffer[bx]					;leo buffer 1
cmp al,buffer2[di]
je incremento
inc bx 

cmp bx, leido
je sall
jmp ll

incremento:							;apunto a próximo caracter en el buffer.
inc bx				
inc di								;

cmp bx, leido
je sall
jmp ll

sall:

pop di bx ax
ret

;============================================================================
end main
