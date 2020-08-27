



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
	 db "Salir(ESC)$"
	 
msg1 db "Introduzca una cadena: $"
msg_op1 db "Su cadena ordenada por mayusculas es: $"
msg_op2 db "Su cadena ordenada por minusculas es: $"
msg_op3 db "Su cadena ordenada por numeros es: $"
BuffUpperAlfabet db 'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','$' ;BUFFER ALFABETO EN MAYUSCULA
BuffLowAlfabet db 'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','$' ;BUFFER ALFABETO EN MAYUSCULA
BuffNumbers db'1','2','3','4','5','6','7','8','9','0','$' ;BUFFER NUMEROS
BuffAux db 100 dup(0)

maximo db 100
total_real dw 0
texto db 100 dup(0)

;============================================================================

.code
main:	
	mov ax,@data
	mov ds,ax
	mov es, ax                  ;set segment register
    and sp, not 3               ;align stack to avoid AC fault

	
;====================================Código==================================  



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
MOV TEXTO[BX],"$"


MOV AH,00H ;LIMPIAR PANTALLA
MOV AL,03H
INT 10H

Inicio:

MOV AH,00H ;LIMPIAR PANTALLA
MOV AL,03H
INT 10H

MOV AH,09H
LEA DX,[menu] ;IMPRIMIMOS EL MENU
INT 21H

CALL Leer ;LEEMOS EL CARACTER INTRODUCIDO
				;SALTAMOS A LA OPCION SELECCIONADA
	 CMP AL,31H
	 JE opcion1
	 CMP AL,32H
	 JE opcion2
	 CMP AL,33H
	 JE opcion3
	 CMP AL,1BH      
	 JE salir
	 
Leer:	;LEE UN CARACTER POR PANTALLA
MOV AH,08H
INT 21H
RET

SaltoLn:
MOV AH,02H
MOV DL,0AH
INT 21H 
RET

opcion1:
MOV AH,00H ;LIMPIAR PANTALLA
MOV AL,03H
INT 10H

MOV AH,09H ;IMPRIMO EL MENSAJE PARA QUE EL USUARIO INTRODUZCA LA CADENA
LEA DX,msg_op1
INT 21H
CALL SaltoLn	
	

MOV SI,0 ;INDICE I
MOV DI,0 ;INDICE J
MOV BX,0 ;INDICE AUX
MOV CX,27 ;INDICE LOOP

Bucle:
MOV DL,texto[DI]
CMP DL,BuffUpperAlfabet[SI]
JE SAME
JNE DIFFERENT
SAME:
MOV BuffAux[BX],DL
INC BX
DIFFERENT:
INC DI 
LOOP Bucle

CMP SI,total_real
JL KO
JNL OK
KO:
INC SI 
MOV DI,0
MOV CX,27
JMP Bucle
OK:
MOV AH,09H
LEA DX,BuffAux
INT 21H



CALL Inicio
opcion2:
MOV AH,09H
LEA DX,msg_op2
INT 21H


opcion3:
MOV AH,09H
LEA DX,msg_op3
INT 21H


Salir: ;SALE DEL DOS
MOV AX,4C00H
INT 21H




;============================================================================

.exit
;================================Funciones aqui==============================






;============================================================================
end main
