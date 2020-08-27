



.model small

.stack 256



.data



;========================Variables declaradas aqui===========================
RUTA DB "skellexe.asm",0 		;RUTA DEL ARCHIVO QUE SE VA A LEER
handler dw 0
dataBuffer db 1000 dup('$') 	;BUFFER EN EL QUE SE VA A GUARDAR EL CONTENIDO DEL ARCHIVO
writeBuffer db 1000 dup('$') 	;BUFFER EN EL QUE SE VAN A PROCESAR LOS DATOS DEL ARCHIVO
lineController dw 0
startingLine dw 0
msj_0 db "Introduzca la palabra a buscar: "
	  db 10,13
	  
maximoBuffSearch db 50
total_real_search dw 0
palabra_search db 50 dup('$')
;============================================================================

.code
main:	
	mov ax,@data
	mov ds,ax
	mov es, ax                  ;set segment register
    and sp, not 3               ;align stack to avoid AC fault

	
;====================================Código==================================  
call clearScreen
call OPEN
call READ
call PROCESSBUFFER

printScreen:
call clearScreen
MOV AX,0b800h					;segmento
MOV ES,AX						; segmento en es
MOV BX,0						;DESPLAZAMIENTO
MOV DI,startingLine				;INDICE PARA RECORRER EL BUFFER

ok:
MOV DL,writeBuffer[DI]			;CONSIGO EL PRIMER CARACTER DEL BUFFER A LEER			
CMP DL,'$'						;COMPARO SI ES IGUAL AL CARACTER DE FINAL							
JE kk							;SI ES IGUAL...
CMP DL,0AH						;COMPARO SI ES IGUAL A SALTO DE LINEA
JE endLine						;SI LO ES...

MOV byte ptr es:[bx],dl			;PASO EL CARACTER AL SEGMENTO
INC DI							;PASO AL SIGUIENTE CARACTER DEL BUFFER 
ADD BX,2						;MUEVO A LA POSICION DEL SIGUIENTE CARACTER EL SEGMENTO
ADD lineController,2

checkSize:
CMP BX,2000						;COMPARO SI BX A COMPLETADO LA PANTALLA
JE fin							;SI ES ASI,TERMINO
JMP checkLine					;SI NO ES ASI,REPITO EL CICLO
					
checkLine:
CMP lineController,160			;COMPARO PARA VER SI SE COMPLETO UNA LINEA	
JNE ok							;SI NO ES ASI,REPITO EL CICLO
MOV lineController,0			;REINICIO EL CONTADOR DEL CONTROLADOR DE LINEA	
JMP ok	

endLine:
MOV CX,160 						;PONGO EN CX EL TAMANO MAXIMO DE LINEA
SUB CX,lineController			; LE RESTO A EL MAXIMO LO QUE LLEVA RECORRIDO
ADD BX,CX						;LE SUMO LA DIFERENCIA PARA QUE PASE DE LINEA
MOV lineController,0			;COMO ES UNA NUEVA LINEA REINICIO EL CONTROLADOR DE LINEA
ADD DI,1 						;PASO AL SIGUIENTE CARACTER DEL BUFFER 
JMP checkSize
kk:

readKey:
MOV AH,08H				
INT 21H
CMP AL,119
JE UP
CMP AL,115
JE DOWN
CMP AL,98
;JE buscar
;buscar:
;JMP SEARCH
CMP AL,27
JE fin
JMP readKey
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
mov cx,2000
int 21h
mov handler,bx
ret

PROCESSBUFFER:
MOV DI,0	;INDICE PARA RECORRER EL BUFFER DE DATOS
MOV SI,0 	;INDICE PARA RECORRER EL BUFFER MODIFICADO
Repetir:
MOV DL,dataBuffer[DI]	;COJO EL CARACTER DEL BUFFER DE DATOS
	CMP DL,09H				;COMPARO PARA VER SI ES UN TAB
	JE Tabs					;SI ES IGUAL..
	CMP DL,'$'				;COMPARO PARA VER SI LLEGO AL CARACTER DE FINAL
	JE FINALIZE				;SI ES ASI...
	
INC DI					;PASO A LA SIGUIENTE POSICION DEL BUFFER DE DATOS
MOV writeBuffer[SI],DL	;SI EL CARACTER NO ES ESPECIAL,LO ESCRIBO EN EL BUFFER A MODIFICAR 
INC SI					;PASO A LA SIGUIENTE POSICION DEL BUFFER A MODIFICAR
JMP Repetir				;REPITO EL PROCESO

Tabs:
MOV CX,4				;INICIO EL CICLO EN 4
Ciclo:
	MOV writeBuffer[SI],20H	;GUARDO UN ESPACIO
	INC SI					;PASO A LA SIGUIENTE POSICION
LOOP Ciclo					;REPITO EL CICLO
INC DI
JMP Repetir					;REPITO EL PROCESO
FINALIZE:					;SI FINALIZO
RET							;VUELVO AL PROCESO ANTERIOR A LA LLAMADA

UP:
MOV BX,startingLine			;ALMACENO EL INICIO DE LINEA EN BX
CMP BX,0					;COMPARO CON CERO
JNG fin1						;SI NO ES MAYOR,TERMINO 
MOV CX,80					;ALMACENO EL TOTAL DE CARACTERES DE UNA LINEA
Repetir1:
CMP writeBuffer[BX],0AH		;SI EL CARACTER ES UN SALTO DE LINEA
JE send						;SI ES IGUAL...
DEC BX						;DECREMENTO BX
JMP Repetir1
send:
MOV startingLine,BX			;ENVIO EL NUEVO INICIO DE LINEA DE LECTURA
fin1:
JMP printScreen

;DOWN:
;MOV BX,startingLine			;ALMACENO EL INICIO DE LINEA EN BX
;CMP BX,2000					;COMPARO CON CERO
;JNG fin2						;SI NO ES MAYOR,TERMINO 
;	MOV CX,80					;ALMACENO EL TOTAL DE CARACTERES DE UNA LINEA
;	Repetir2:
;		dec CX
;		cmp CX,0
;		JE send1
;		CMP writeBuffer[BX],0AH		;SI EL CARACTER ES UN SALTO DE LINEA
;		JE send1						;SI ES IGUAL...
;			DEC BX						;DECREMENTO BX
;	JMP Repetir2
	
;	send1:
;	MOV startingLine,BX			;ENVIO EL NUEVO INICIO DE LINEA DE LECTURA
;fin2:
;JMP printScreen

Down:
	MOV CX,0
	MOV BX,startingLine
	L1:
		MOV AH,writeBuffer[BX]
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
	MOV startingLine, BX
JMP printScreen


SEARCH:
CALL clearScreen

MOV AH,09H ;IMPRIMO EL MENSAJE PARA QUE EL USUARIO INTRODUZCA LA PALABRA A BUSCAR
LEA DX,msj_0
INT 21H

MOV DI,0
repetir3:
MOV AH,01H ;GUARDA LOS CARACTERES EN AL
INT 21H

CMP AL,13
JE DONE
MOV palabra_search[DI],AL
INC DI
MOV total_real_search,DI
CMP DI,51
JNE repetir3
DONE:
clearScreen:
    MOV AX,3H
    INT 10H 
	RET

;============================================================================
end main
