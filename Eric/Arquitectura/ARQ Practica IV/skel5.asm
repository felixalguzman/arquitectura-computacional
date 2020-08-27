



.model small

.stack 256



.data



;========================Variables declaradas aqui===========================
letrero db "hola mundo$"
RUTA DB "skellexe.asm",0 		;RUTA DEL ARCHIVO QUE SE VA A LEER
handler dw 0
dataBuffer db 1000 dup('$') 	;BUFFER EN EL QUE SE VA A GUARDAR EL CONTENIDO DEL ARCHIVO
writeBuffer db 1000 dup('$') 	;BUFFER EN EL QUE SE VAN A PROCESAR LOS DATOS DEL ARCHIVO

;============================================================================

.code
main:	
	mov ax,@data
	mov ds,ax
	mov es, ax                  ;set segment register
    and sp, not 3               ;align stack to avoid AC fault

	
;====================================Código==================================  
call open
call read

mov ax,0b800h					;segmento
mov es,ax						; segmento en es
mov bx,0						;DESPLAZAMIENTO
mov di,0						;INDICE PARA RECORRER EL BUFFER

ok:
mov dl,dataBuffer[di]			;CONSIGO EL PRIMER CARACTER DEL BUFFER A LEER			
cmp dl,'$'						;COMPARO SI ES IGUAL AL CARACTER DE FINAL
je kk							;SI ES IGUAL...
mov byte ptr es:[bx],dl			;PASO EL CARACTER AL SEGMENTO
inc di							;PASO AL SIGUIENTE CARACTER DEL BUFFER 
add bx,2						;MUEVO A LA POSICION DEL SIGUIENTE CARACTER EL SEGMENTO


cmp bx,2000						;COMPARO SI BX A COMPLETADO LA PANTALLA
je fin							;SI ES ASI,TERMINO
jmp ok							;SI NO ES ASI,REPITO EL CICLO 

kk:

fin:

;============================================================================

.exit
;================================Funciones aqui==============================

OPEN:	;ABRE EL ARCHIVO DE LA RUTA ESPECIFICADA

MOV AH,3DH			
mov al,0			
MOV DX,OFFSET RUTA
int 21h
mov handler,ax
ret

READ:

MOV AH,3fH			
mov bx,handler			
MOV DX,OFFSET dataBuffer
mov cx,99
int 21h
mov handler,bx
ret


;============================================================================
end main
