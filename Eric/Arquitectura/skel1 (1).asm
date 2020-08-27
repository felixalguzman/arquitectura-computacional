



.model small

.stack 256



.data



;========================Variables declaradas aqui===========================
var 	dW 8				;VARIABLE TIPO BYTE
var2 	dW 9
var3	db 10H

;BUFFER  DB   10 DUP (0)

BUFFER 	DB   0
		DB	 0
		DB 	 0
		DB   0
		DB   0
		DB   0
		DB   0
		DB   0
		DB   0
		DB   0







;============================================================================

.code
main:	
	mov ax,@data
	mov ds,ax
	mov es, ax                  ;set segment register
    and sp, not 3               ;align stack to avoid AC fault

	
;====================================Código==================================  


;PARA RESTAR VAR+VAR2
MOV BX,VAR				;TOMO EL PRIMER OPERANDO
MOV AX,1000				;ASIGNNO VALOR DE OPERACION INICIAL
SUB AX,BX				;RESTO AL MIL LA PRIMERA VARIABLE
MOV DI,AX				;SALVO EL RESULTADO

SHR AX,08				; ME QUEDO CON EL DIGITO MAS SIGNIFICATIVO
ADD AX,30H				; CONVIERTO A ASCII


MOV AH,02
MOV DL,AL				;TOMO CENTENA
INT 21H

MOV AX,DI				;RECUPERO EL RESULTADO
AND AX, 00F0H			;FILTRO LA DECENA
SHR AX,4				;COLOCA LA DECENA EN LA POSICION INDICADA PARA CONVERTIR ASCII
ADD AX,55				;

MOV AH,02
MOV DL,AL				;TOMO CENTENA
INT 21H

MOV AX,DI				;RECUPERO EL RESULTADO
AND AX, 000FH			;FILTRO LA UNIDAD
CMP AX,9				;PARA VERIFICAR COMO DEBO DE AJUSTAR.
JNG KO
ADD AX,7				;
KO:
ADD AX,30H				;

MOV AH,02
MOV DL,AL				;TOMO CENTENA
INT 21H


;============================================================================

.exit
;================================Funciones aqui==============================






;============================================================================
end main
