



.model small

.stack 256



.data



;========================Variables declaradas aqui===========================
menu db "Seleccione una opcion: "
	 db 10,13
	 db "1.Ordenar mayusculas"
	 db 10,13
	 db "2.Ordenar minusculas"
	 db 10,13
	 db "3.Ordenar numeros"
	 db 10,13
	 db "4.Reemplazar cadena"
	 db 10,13
	 db "Salir(ESC)$"
	 db 10
	 
msg1 db "Introduzca una cadena: $"
msg_op1 db "Su cadena ordenada por mayusculas es: $"
msg_op2 db "Su cadena ordenada por minusculas es: $"
msg_op3 db "Su cadena ordenada por numeros es: $"
msg_op4 db "Introduzca la cadena a reemplazar: $"
dialog_1 db "La frase que se repite ha sido encontrada en el texto: $"

BuffUpperAlfabet db 'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z' ;BUFFER ALFABETO EN MAYUSCULA
BuffLowAlfabet db 'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z' ;BUFFER ALFABETO EN MAYUSCULA
BuffNumbers db '0','1','2','3','4','5','6','7','8','9' ;BUFFER NUMEROS

BuffAuxUpper db 101 dup('$')
BuffAuxLow db 101 dup('$')
BuffAuxNumbers db 101 dup('$')
;TEXTO A INTRODUCIR POR EL USUARIO
maximo db 101
total_real dw 0
texto db 101 dup('$')
;BUFF CON LA CADENA A REEMPLAZAR
maximoBuffReemplazo db 101
total_real_reemplazo dw 0
frase_reemplazo db 101 dup('$')
repeticiones db 0 

;============================================================================

.code
main:	
	mov ax,@data
	mov ds,ax
	mov es, ax                  ;set segment register
    and sp, not 3               ;align stack to avoid AC fault

	
;====================================C�digo==================================  



MOV AH,09H ;IMPRIMO EL MENSAJE PARA QUE EL USUARIO INTRODUZCA LA CADENA
LEA DX,msg1
INT 21H
CALL SaltoLn

MOV DI,0
Repetir:
MOV AH,01H ;GUARDA LOS CARACTERES EN AL
INT 21H
CMP AL,13
JE DONE
MOV texto[DI],AL
INC DI
MOV total_real,DI
CMP DI,99
JNE Repetir
DONE:
MOV BX,total_real



MOV AH,00H ;LIMPIAR PANTALLA
MOV AL,03H
INT 10H

Inicio:

MOV AH,09H
LEA DX,[menu] ;IMPRIMIMOS EL MENU
INT 21H

CALL Leer ;LEEMOS EL CARACTER INTRODUCIDO
				;SALTAMOS A LA OPCION SELECCIONADA
	 CMP AL,31H
	 JE OP1
	 CMP AL,32H
	 JE OP2
	 CMP AL,33H
	 JE OP3
	 CMP AL,34H
	 JE OP4
	 CMP AL,27
	 JE OPESC
	 
CALL SaltoLn
OP1:
JMP opcion1
OP2:
JMP opcion2
OP3:
JMP opcion3
OP4:
JMP opcion4
OPESC:
JMP salir

opcion1:
MOV AH,00H ;LIMPIAR PANTALLA
MOV AL,03H
INT 10H

MOV AH,09H ;IMPRIMO EL MENSAJE PARA QUE EL USUARIO INTRODUZCA LA CADENA
LEA DX,msg_op1
INT 21H
CALL SaltoLn	
	
MOV DI,0 ;INDICE I
MOV SI,0 ;INDICE J
MOV BX,0 ;INDICE AUX
MOV CX,total_real ;INDICE LOOP

Ciclo:
MOV AL,BuffUpperAlfabet[SI] ;OBTENGO LA LETRA DEL ALFABETO EN MAYUSCULA
MOV DL,texto[DI]			;OBTENGO EL CARACTER DEL TEXTO
CMP DL,AL					;COMPARO
JE SAME						;SI SON IGUALES...
JNE DIFFERENT
SAME:							
MOV BuffAuxUpper[BX],DL		;GUARDO EL CARACTER DEL TEXTO EN EL BUFFER AUXILIAR DE MAYUSCULAS
INC BX						;PASO A LA SIGUIENTE POSICION DEL BUFFER AUXILIAR
INC DI						;PASO A LA SIGUIENTE LETRA DEL TEXTO
JMP JI						;VUELVO A REPETIR EL BUCLE
DIFFERENT:					;SI SON DIFERENTES...
INC DI						;PASO A LA SIGUIENTE LETRA DEL TEXTO
JMP JI						;VUELVO A REPETIR EL BUCLE
JI:
LOOP Ciclo					;HAGO EL LOOP

CMP SI,25					; COMPRUEBO SI ESTAMOS EN LA ULTIMA LETRA DEL ALFABETO
JNE KO						;SI NO ES IGUAL...
JE OK						;SI ES IGUAL...
KO:				
INC SI						;PASO A LA SIGUIENTE LETRA DEL ALFABETO EN MAYUSCULAS
MOV CX,0					;INICIALIZO EL CONTADOR DEL LOOP EN CERO
MOV CX,total_real			;LE ASIGNO EL VALOR DEL NUMERO DE LETRAS DEL TEXTO	
MOV DI,0					;COLOCO EL INDICE DEL TEXTO EN LA PRIMERA POSICION
CALL Ciclo					;REPITO EL CICLO
OK:
MOV AH,09H					;LLAMO A LA INSTRUCCION 09
LEA DX,BuffAuxUpper			;PASO EN DX LA CADENA DE MAYUSCULAS A IMPRIMIR	 
INT 21H	
							;EJECUTO LA INSTRUCCION INT 21H
CALL SaltoLn
CALL SaltoLn

JMP Inicio

opcion2:
MOV AH,00H ;LIMPIAR PANTALLA
MOV AL,03H
INT 10H

MOV AH,09H ;IMPRIMO EL MENSAJE PARA QUE EL USUARIO INTRODUZCA LA CADENA
LEA DX,msg_op2
INT 21H
CALL SaltoLn	
	
MOV DI,0 ;INDICE I
MOV SI,0 ;INDICE J
MOV BX,0 ;INDICE AUX
MOV CX,total_real ;INDICE LOOP

Ciclo1:
MOV AL,BuffLowAlfabet[SI] 	;OBTENGO LA LETRA DEL ALFABETO EN MINUSCULAS
MOV DL,texto[DI]			;OBTENGO EL CARACTER DEL TEXTO
CMP DL,AL					;COMPARO
JE SAME1					;SI SON IGUALES...
JNE DIFFERENT1				;SI SON DIFERENTES...
SAME1:
MOV BuffAuxLow[BX],DL		;GUARDO EL CARACTER EN EL BUFFER AUXILIAR DE MINUSCULAS			
INC BX						;PASO A LA SIGUIENTE POSICION DE ESTE ARREGLO 
INC DI						;AVANZO A LA SIGUIENTE LETRA DEL TEXTO
JMP JI1						;REPITO EL PROCESO
DIFFERENT1:
INC DI						;PASO A LA SIGUIENTE LETRA DEL TEXTO
JMP JI1						;VUELVO AL CICLO 
JI1:
LOOP Ciclo1

CMP SI,25					;COMPARO PARA VER SI ES LA ULTIMA LETRA DEL ALFABETO
JNE KO1						;SI ES DIFERENTE...
JE OK1						;SI ES IGUAL...
KO1:
INC SI						;AVANZO A LA SIGUIENTE LETRA MINUSCULA
MOV CX,0					;INICIALIZO CX
MOV CX,total_real			;GUARDO EN CX LA CANTIDAD DE LETRAS DEL TEXTO
MOV DI,0					;EMPIEZO DESDE EL PRIMER CARACTER DEL TEXTO
CALL Ciclo1					;REPITO EL CICLO
OK1:
MOV AH,09H					;LLAMO A LA INSTRUCCION 09
LEA DX,BuffAuxLow			;IMPRIMO EL BUFFER AUXILIAR DE MINUSCULAS
INT 21H						;EJECUTO LA INSTRUCCION INT 21H

CALL SaltoLn				;SALTOS DE LINEA
CALL SaltoLn

JMP Inicio					;VUELVO AL MENU

opcion3:

MOV AH,00H ;LIMPIAR PANTALLA
MOV AL,03H
INT 10H

MOV AH,09H ;IMPRIMO EL MENSAJE PARA QUE EL USUARIO INTRODUZCA LA CADENA
LEA DX,msg_op3
INT 21H
CALL SaltoLn	
	
MOV DI,0 ;INDICE I
MOV SI,0 ;INDICE J
MOV BX,0 ;INDICE AUX
MOV CX,total_real ;INDICE LOOP

Ciclo2:
MOV AL,BuffNumbers[SI] 	;OBTENGO EL NUMERO
MOV DL,texto[DI]			;OBTENGO EL  CARACTER DEL TEXTO
CMP DL,AL					;COMPARO
JE SAME2					;SI SON IGUALES...
JNE DIFFERENT2				;SI SON DIFERENTES...
SAME2:
MOV BuffAuxNumbers[BX],DL	;GUARDO EL NUMERO EN EL BUFFER AUXILIAR DE NUMEROS
INC BX						;PASO A LA SIGUIENTE POSICION DEL BUFFER AUXILIAR
INC DI						;AVANZO AL SIGUIENTE CARACTER DEL TEXTO
JMP JI2						;REPITO EL BUCLE 
DIFFERENT2:
INC DI						;PASO AL SIGUIENTE CARACTER DEL TEXTO
JMP JI2
JI2:
LOOP Ciclo2					;REPITO EL CICLO

CMP SI,9					;COMPARO PARA VER SI ES EL ULTIMO NUMERO 
JNE KO2						;SI NO ES IGUAL
JE OK2						;SI ES IGUAL
KO2:
INC SI						;PASO AL SIGUIENTE NUMERO
MOV CX,0					;INICIALIZO CX
MOV CX,total_real			;GUARDO EN CX EL VALOR DE CARACTERES DEL TEXTO
MOV DI,0					;EMPIEZO EN EL PRIMER CARACTER DEL TEXTO
CALL Ciclo2					;REPITO EL CICLO
OK2:
MOV AH,09H					;LLAMO A LA INSTRUCCION 09
LEA DX,BuffAuxNumbers		;IMPRIMO EL BUFFER AUXILIAR DE NUMEROS
INT 21H						;EJECUTO LA INSTRUCCION INT 21

CALL SaltoLn
CALL SaltoLn

JMP Inicio

Opcion4:

MOV AH,00H ;LIMPIAR PANTALLA
MOV AL,03H
INT 10H

MOV AH,09H ;IMPRIMO EL MENSAJE PARA QUE EL USUARIO INTRODUZCA LA CADENA A BUSCAR
LEA DX,msg_op4
INT 21H
CALL SaltoLn	

MOV DI,0
Repetir1:
MOV AH,01H ;GUARDA LOS CARACTERES EN AL
INT 21H
CMP AL,13
JE DONE1
MOV frase_reemplazo[DI],AL
INC DI
MOV total_real_reemplazo,DI
CMP DI,total_real
JNE Repetir1
DONE1:
MOV BX,total_real_reemplazo
CALL SaltoLn

MOV AH,09H ;IMPRIMO EL DIALOGO DE MOSTRAR NUMERO DE REPETICIONES DE LA FRASE
LEA DX,dialog_1
INT 21H
CALL SaltoLn	

MOV DI,0 ;INDICE I
MOV SI,0 ;INDICE J
MOV BX,total_real_reemplazo ;INDICE 
Ciclo3:
MOV DL,texto[SI]  ;SE GUARDA EL CARACTER DEL TEXTO
CMP DL,frase_reemplazo[DI] ;SE GUARDA EL CARACTER DE LA FRASE DE REEMPLAZO
JNE FIN						; SI NO SON IGUALES,SALTA A FIN
INC DI						;SI SON IGUALES,PASO AL SIGUIENTE CARACTER DE LA FRASE DE REEMPLAZO
CMP DI,total_real_reemplazo	;COMPRUEBO SI SE HA LLEGADO A LA CANTIDAD TOTAL DE CARACTERES DE LA FRASE DE REEMPLAZO
JNE FIN2					;SI NO ES IGUAL,SALTA A FIN2
INC repeticiones			;SI ES IGUAL,SIGNIFICA QUE SE HA ENCONTRADO LA FRASE DE REEMPLAZO
FIN:
MOV DI,0					;SE INICIALIZA DI PARA EMPEZAR POR EL PRIMER CARACTER DE LA FRASE DE REEMPLAZO
FIN2:
INC SI						;PASO AL SIGUIENTE CARACTER DEL TEXTO
CMP SI,total_real			;COMPARO SI LLEGA AL TOTAL DEL TEXTO
JNE Ciclo3					;SI NO ES ASI REPITO EL CICLO


ADD repeticiones,48d		;PASO EL NUMERO A ASCII
MOV AH,02
MOV DL,repeticiones
INT 21H

CALL SaltoLn

JMP Inicio					

Salir: ;SALE DEL DOS
MOV AX,4C00H
INT 21H

Leer:	;LEE UN CARACTER POR PANTALLA
MOV AH,08H
INT 21H
RET

SaltoLn:
MOV AH,02H
MOV DL,0AH
INT 21H 
RET




;============================================================================

.exit
;================================Funciones aqui==============================






;============================================================================
end main