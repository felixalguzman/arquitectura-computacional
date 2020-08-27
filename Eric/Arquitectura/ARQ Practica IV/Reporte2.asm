
.model small

.stack 256



.data



;========================Variables declaradas aqui===========================
arreglo db 100 dup(0)
num db 100 dup(0)
mayus db 100 dup(0)
minus db 100 dup(0)
BufAux db 100 dup(0)
BufNuevo db 10 dup(0)
BufRemp db 10 dup(0)

numValido db "0","1","2","3","4","5","6","7","8","9"
minValido db "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"
mayValido db "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"

index dw 0
MSG0 db 0AH,"-ENTRE LA CADENA DE CARACTERES QUE DESEE: ",0AH,"$"
MSG1 db 0AH,"-SELECCIONE LA OPCION QUE DESEA: ",0AH 
MSG2 db "	*Pulse (N) para numeros", 0AH 
MSG3 db "	*Pulse (H) para mayusculas", 0AH 
MSG4 db "	*Pulse (C) para minuscula", 0AH
MSG5 db "	*Pulse (R) remplazar", 0AH
MSG11 db "	*Pulse (M) mostrar la cadena", 0AH
MSG6 db "	*Pulse (ESC) para salir$"
MSG7 db "-Inserte la cadena que desee buscar: ",0AH,"$"
MSG8 db "	*Veces que encontro la cadena: $"
MSG9 db 0AH,"	*Desea remplazar la cadena?(S para si/N para no) ",0AH,"$"
MSG10 db 0AH,"-Inserte la nueva cadena con la que se remplazara: ",0AH,"$"
cant dw 0
cantNueva dw 0
VecesEncontrado db 0
cantEncontrada db 0
cantADD dw 0
;============================================================================

.code
main:	
	mov ax,@data
	mov ds,ax
	mov es, ax                  ;set segment register
    and sp, not 3               ;align stack to avoid AC fault

	
;====================================Código==================================  
call clrscr

Mov AH, 09H
Mov DX, Offset MSG0
Int 21H

mov BX,0  ;Inicio de índice
entrarD:
	mov AH,01 ;Leer del teclado
	int 21h ;Llamar función
			;Retorno tecla pulsada
	
	CMP AL,0DH ;Salir si es igual a ENTER
	JE Salida
	mov arreglo[BX],AL ;guardo caracter tomado
	inc BX
	
	CMP BX,100d
	JNE entrarD
Salida:

MOV cant,BX ;Tamaño real de lo escrito 
CMP cant, 0
JE termin

Menu:
	MOV AH,02
	MOV DL,0Ah	;Salto de linea			
	INT 21H
	
	mov ah,9
	mov dx,OFFSET MSG1 ;Mostrar el menú 
	int 21h
	
	mov AH,08 ;Leer del teclado sin eco
	int 21h   ;Llamar función
			  ;Retorno tecla pulsada
	
	CMP AL,4EH ;igual a N
	JE nume
	CMP AL,6EH ;igual a n
	JE nume
	
	CMP AL,48H ;igual a H 
	JE may
	CMP AL,68H ;igual a h 
	JE may
	
	CMP AL,43H ; igual a C
	JE min
	CMP AL,63H ; igual a c
	JE min
	
	CMP AL,52H ; igual a R
	JE ren
	CMP AL,72H ; igual a r
	JE ren
	
	CMP AL,4DH ; igual a M
	JE mos
	CMP AL,6DH ; igual a m
	JE mos
	
	CMP AL,1BH ; igual a ESC
	JE termin
	
	call clrscr
JMP Menu

nume:
	call clrscr
	JMP numeros ;Mandando a la función de mostrar números
may:
	call clrscr
	JMP mayusculas	;Mandando a la función de mostrar mayúsculas
min:
	call clrscr
	JMP minusculas ;Mandando a la función de mostrar minúsculas
ren:
	call clrscr
	JMP remplazar ;Mandando a la función de remplazo
mos:
	call clrscr
	JMP presentar ;Mostrar la cadena insertada
termin:
	call clrscr
	JMP terminar ;Mandando a la función de terminar programa

;MOSTRAR LOS NÚMEROS
;====================================================
numeros:
	MOV BX,0 
	MOV SI,0
	L1:
		MOV DI,0
		W1:
			MOV AL,numValido[BX]
			CMP AL, arreglo[DI] ;Compara cada número del 0 al 9 de forma ordenada y los guarda de forma ascendente en el buffer
			JNE exclu1
				MOV num[SI],AL ;Guarda la caracter en el buffer
				inc SI
			exclu1:
			inc DI
			CMP DI,cant ;Termina al leer el buffer principal
		JNE W1
		inc BX
		CMP BX,10 ;Termina al leer todos los números
	JNE L1
	Mov index, SI
	
	CMP index,0
	JNE term1
		JMP Menu ;Validar arreglo vacío
	term1:
	
	MOV BX,0
	S1:
		MOV AH,02
		MOV DL,num[BX] ;Imprimir en pantalla el buffer de números caracter por caracter
		INT 21H
		inc BX
		CMP BX,index
	JNE S1
	
	MOV CX, index
	Va1:
		MOV BX,CX
		MOV num[BX],0 ;Vaciar Buffer
	LOOP Va1
JMP Menu


;MOSTRAR LAS LETRAS EN MAYÚSCULA
mayusculas:
	MOV BX,0 
	MOV SI,0
	L2:
		MOV DI,0
		W2:
			MOV AL,mayValido[BX]
			CMP AL, arreglo[DI] ;Compara cada letra del abecedario de forma ordenada y los guarda de forma ascendente en el buffer
			JNE exclu2
				MOV mayus[SI],AL ;Guarda la caracter en el buffer
				inc SI
			exclu2:
			inc DI
			CMP DI,cant ;Termina al leer el buffer principal
		JNE W2
		inc BX
		CMP BX, 26 ;Termina al leer todas las letras
	JNE L2
	Mov index, SI
	
	CMP index,0
	JNE term2
		JMP Menu ;Validar arreglo vacío
	term2:
	
	MOV BX,0
	S2:
		MOV AH,02
		MOV DL,mayus[BX] ;Imprimir en pantalla el buffer de números caracter por caracter
		INT 21H
		inc BX
		CMP BX,index
	JNE S2
	
	MOV CX, index
	Va2:
		MOV BX,CX
		MOV mayus[BX],0 ;Vaciar Buffer
	LOOP Va2
JMP Menu

;MOSTRAR LAS LETRAS EN MINÚSCULA
minusculas:
	MOV BX,0 
	MOV SI,0
	L3:
		MOV DI,0
		W3:
			MOV AL,minValido[BX]
			CMP AL, arreglo[DI] ;Compara cada letra del abecedario de forma ordenada y los guarda de forma ascendente en el buffer
			JNE exclu3
				MOV minus[SI],AL ;Guarda la caracter en el buffer
				inc SI
			exclu3:
			inc DI
			CMP DI,cant ;Termina al leer el buffer principal
		JNE W3
		inc BX
		CMP BX, 26 ;Termina al leer todas las letras
	JNE L3
	Mov index, SI
	
	CMP index,0
	JNE term3
		JMP Menu ;Validar arreglo vacío
	term3:
	
	MOV BX,0
	S3:
		MOV AH,02
		MOV DL,minus[BX] ;Imprimir en pantalla el buffer de números caracter por caracter
		INT 21H
		inc BX
		CMP BX,index
	JNE S3
	
	MOV CX, index
	Va3:
		MOV BX,CX
		MOV minus[BX],0 ;Vaciar Buffer
	LOOP Va3
JMP Menu


;PRESENTAR CADENA
presentar:
	MOV BX,0
 	present:
		MOV AH,02
		MOV DL,arreglo[BX] ;Imprimir en pantalla el buffer principal	
		INT 21H
		inc BX
		cmp BX,cant
	JNE present
JMP Menu

;MODIFICAR LA CADENA
remplazar:
	MOV AH,02
	MOV DL,0Ah	;Salto de linea			
	INT 21H
	
	mov ah,9
	mov dx,OFFSET MSG7 ;Mostrar el menú 
	int 21h
	
	MOV BX,0
	escribir:
		mov AH,01 ;Leer del teclado con eco
		int 21h   ;Llamar función
				  ;Retorno tecla pulsada
		CMP AL,0DH ;Salir si es igual a enter
		JE out4
		MOV BufRemp[BX], AL ;Guardar la frase a buscar en el buffer (Máximo 5 caracteres)
		inc BX
		CMP BX,5
	JNE escribir
	out4:
	MOV cantNueva,BX ;Guardar el tamaño
	
	
	;Buscar cuantas veces aparece la frase en el buffer
	MOV BX,0
	MOV DI,0
	MOV VecesEncontrado,0
	buscar:
		MOV AL, arreglo[BX]
		CMP AL, BufRemp[DI] ;Comparar caracter por caracter
		JNE out5
			inc DI
			CMP DI, cantNueva ;Ver si es la última letra de la frase a buscar
			JNE conti
				inc VecesEncontrado ;Aumentar el contador de veces encontrado
				MOV DI,0 ;Reiniciar el índice de búsqueda para seguir buscando
			JMP conti
		out5:
			MOV DI,0 ;Al encontrar un valor diferente, se reinicia el buffer
		conti:
		inc BX
		CMP BX, cant ;Salir al llegar a la última posición del buffer
	JNE buscar	
	
	MOV AL, VecesEncontrado
	MOV cantEncontrada, AL 
	ADD cantEncontrada,30H ;Convertir el valor en a hexadecimal para mostrarlo en ASCII
	
	mov ah,9
	mov dx,OFFSET MSG8 ;Mostrar texto
	int 21h
	
	
	MOV AH,02
	MOV DL,cantEncontrada ;Cantidad de veces que se encontró el string		
	INT 21H
	
	CMP VecesEncontrado,0
	JNE seguir1 
		JMP Menu ;Terminar el proceso de remplazo en caso de no encontrar nada
	seguir1:
	
	MOV AH,02
	MOV DL,0Ah	;Salto de linea			
	INT 21H
	
	mov ah,9
	mov dx,OFFSET MSG9 ;Mostrar texto
	int 21h
	
	;PREGUNTAR SI SE QUIERE REMPLAZAR
	SINO:
		mov AH,08 ;Leer del teclado con eco
		int 21h   ;Llamar función
				  ;Retorno tecla pulsada
		;Para el No
		CMP AL,6EH ;Salir si es igual a n
		JE NO
		CMP AL,4EH ;Salir si es igual a N
		JE NO
		
		;Para el Si
		CMP AL,73H ;Salir si es igual a s
		JE YES
		CMP AL,53H ;Salir si es igual a S
		JE YES

	JMP SINO
	NO:
		JMP Menu ;En caso de que elija no, regresa al menú
	YES:
	mov ah,9
	mov dx,OFFSET MSG10 ;Mostrar texto
	int 21h
	
	MOV BX,0
	Nuevo:
		mov AH,01 ;Leer del teclado con eco
		int 21h   ;Llamar función
				  ;Retorno tecla pulsada
		CMP AL,0DH ;Salir si es igual a enter
		JE  out6
		MOV BufNuevo[BX], AL ;Escribir en el buffer la frase nueva por la que se remplazará (Máximo 5 caracteres)
		inc BX
		CMP BX,5
	JNE Nuevo
	out6:
	MOV cantADD,BX ;Guardar tamaño de la frase nueva

	MOV BX,0
	MOV DI,0
	MOV SI,0
	buscarR:
		MOV AL, arreglo[BX]
		MOV BufAux[SI], AL ;Guardar en el nuevo buffer la frase anterior
		CMP AL, BufRemp[DI];Busca la frase a remplazar
		JNE out7
			inc DI
			CMP DI, cantNueva ;Comprueba que la frase llegue hasta el final
			JNE continuar
				MOV DI,0 ;Cambia el contador a 0 para ser usado como el índice de la frase nueva a agregar
				SUB SI, cantNueva ;Regresa el índice del buffer auxiliar para sobrescribir la parte 
				remp:
					inc SI
					MOV AL, BufNuevo[DI]
					MOV BufAux[SI], AL ;Añade la frase nueva al buffer auxiliar
					inc DI
					CMP DI, cantADD
				JNE remp
			JMP out7
		out7:
			MOV DI,0 ;Reinicia el índice para continuar la búsqueda
		continuar:
		inc BX
		inc SI
		CMP BX, cant
	JNE buscarR	
	
	
	MOV AH,02
	MOV DL,0Ah	;Salto de linea			
	INT 21H
	
	MOV BX,0
 	present2:
		MOV AH,02
		MOV DL,BufAux[BX] ;Imprimir en pantalla el buffer nuevo con el remplazo
		INT 21H
		inc BX
		cmp BX,SI
	JNE present2
	
	MOV BX,0
	vaciar:
		MOV arreglo[BX], 0 ;Vaciar Buffer original
		inc BX
		cmp BX,cant
	JNE vaciar
	
	mov cant, SI
	
	MOV BX,0
	igualar:
		MOV AL, BufAux[BX]
		MOV arreglo[BX],AL  ;Igualar Buffer principal con el nuevo
		inc BX
		cmp BX,cant
	JNE igualar
	
	
JMP Menu

;============================================================================
terminar: 

.exit
;================================Funciones aqui==============================

clrscr proc
    mov ax,0003h
    int 10h 
    ret
endp




;============================================================================
end main
