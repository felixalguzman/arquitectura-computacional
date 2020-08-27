



.model small

.stack 256



.data



;========================Variables declaradas aqui===========================
letrero db "hola mundo$"
RUTA DB "skellexe.asm",0;
handler dw 0
indexLinea DW 0
BufLeido db 2010 dup ('$')
BufMostrar db 2010 dup ('$')
BufBuscar db 100 dup('S')
Inicio dw 0
CantBuscar dw 0



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
call LimpiarPantalla
mov ax,0b800h					;segmento
mov es,ax						; segmento en es
mov bx,0						;desplazamiento
mov di,Inicio					;índice para acceder al buffer
mov si,0
buscar:
	mov dl,BufMostrar[di]
	cmp dl,'$'
	je out5
		CMP dl, 0AH
		JNE exclu1
			JMP saltos
		exclu1:
		mov byte ptr es:[bx],dl
		inc di
		add bx,2
		add indexLinea,2

		cont1:
		cmp bx,2000
		jge LeerT
		
		CMP indexLinea, 160
		JNE buscar
			MOV indexLinea,0
		jmp buscar
	out5:
	
	
	LeerT:
		mov AH,08 ;Leer del teclado sin eco
		int 21h   ;Llamar función
				  ;Retorno tecla pulsada
		;Para el arriba
		CMP AL, 061H;0ADH ;Salir si es igual a arriba
		JE UpC

		;Para el abajo
		CMP AL, 064H;0AFH ;Salir si es igual a abajo
		JE DownC
		
		;Para ESC
		CMP AL,01BH;Salir del programa
		JE Terminar
	JMP LeerT
	
	UpC:
		call Up
	DownC:
		call Down
	Terminar:
		Call Fin
	
	;============Funcion Scroll Abajo=============
	Down:
		MOV CX,0
		MOV BX,Inicio
		L1:
			MOV AH,BufMostrar[BX]
			inc BX
			inc CX
			CMP BX,2000
			JL Menor
				MOV BX,2000
			Menor:
			CMP AH,0AH
			JE out3
			CMP CX,80
		JNE L1
		out3:
		MOV Inicio, BX
	JMP MOSTRAR
	
	;============Funcion Scroll Arriba=============
	UP:
		MOV CX,80
		MOV BX,Inicio
		L2:
			MOV AH,BufMostrar[BX]
			dec CX
			dec BX
			CMP BX,0
			JGE Mayor
				MOV BX,0
			Mayor:
			CMP AH,0AH
			JE out4
			CMP CX,0
		JNE L2
		out4:
		MOV Inicio, BX
	JMP MOSTRAR
	
	;============Funcion Buscar=============
	AddFrase:
		MOV BX,0
		vaciar:
			MOV BufBuscar[BX], '$' ;Vaciar Buffer original
			inc BX
			cmp BX,CantBuscar
		JNE vaciar
	
		entrarF:
			mov AH,01 ;Leer del teclado
			int 21h ;Llamar función
					;Retorno tecla pulsada
			
			CMP AL,0DH ;Salir si es igual a ENTER
			JE out6
			mov BufBuscar[BX],AL ;guardo caracter tomado
			inc BX
			CMP BX,100d
		JNE entrarF
		out6:
		
		MOV CantBuscar,BX
	JMP MOSTRAR
	
	saltos: 
		MOV CX,160
		SUB CX, indexLinea
		ADD BX,CX
		ADD DI,2
		MOV indexLinea,0
	JMP cont1


;============================================================================
Fin:
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
