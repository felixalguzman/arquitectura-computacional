



.model small

.stack 256



.data



;========================Variables declaradas aqui===========================
letrero db "hola mundo$"
RUTA DB "skellexe.asm",0;
handler dw 0
indexLinea DW 0
BufLeido db 1000 dup ('$')
BufMostrar db 1000 dup ('$')
Inicio dw 0



;============================================================================

.code
main:	
	mov ax,@data
	mov ds,ax
	mov es, ax                  ;set segment register
    and sp, not 3               ;align stack to avoid AC fault

	
;====================================Código==================================  
call LimpiarPantalla
call open
call read
call ProcesarBuf

MOSTRAR:

mov ax,0b800h					;segmento
mov es,ax						; segmento en es
mov bx,0						;desplazamiento
mov di,0						;índice para acceder al buffer
ok:
	mov dl,BufMostrar[di]
	cmp dl,'$'
	je kk
		CMP dl, 0AH
		JE saltos
		mov byte ptr es:[bx],dl
		inc di
		add bx,2
		add indexLinea,2

		cont1:
		cmp bx,2010
		jge fin
		
		CMP indexLinea, 160
		JNE ok
			MOV indexLinea,0
		jmp ok 
	kk:
	
	saltos: 
		MOV CX,160
		SUB CX, indexLinea
		ADD BX,CX
		ADD DI,2
		MOV indexLinea,0
	JMP cont1
	
	LeerT:
		mov AH,08 ;Leer del teclado sin eco
		int 21h   ;Llamar función
				  ;Retorno tecla pulsada
		;Para el arriba
		CMP AL, 0ADH ;Salir si es igual a arriba
		JE Up

		
		;Para el abajo
		CMP AL,0AFH ;Salir si es igual a abajo
		;JE Down
	JMP LeerT
	
	Up:
		SUB Inicio,160

	
JMP MOSTRAR

fin:

;============================================================================

.exit
;================================Funciones aqui==============================

OPEN:

MOV AH,3DH			
mov al,0			
MOV DX,OFFSET RUTA
int 21h
mov handler,ax
ret

read:

MOV AH,3fH			
mov bx,handler			
MOV DX,OFFSET BufLeido
mov cx,2000
int 21h
mov handler,bx
ret

ProcesarBuf:
	MOV DI,0
	MOV BX,0
	COP:
		MOV AL,BufLeido[DI]
		inc DI
		CMP AL,'$'
		JE out1
		CMP AL,09H
		JNE out2
			MOV cx,4
			R1:
				MOV BufMostrar[BX],20H
				inc BX
			LOOP R1
			JMP COP
		out2:
		MOV BufMostrar[BX],AL
		inc BX
	JMP COP
	out1:
ret

LimpiarPantalla proc
    mov ax,03H
    int 10h 
    ret
endp


;============================================================================
end main
