; ---------------------------------------------------------------
; Nom alumne 1: Guillem Devesa
; Nom alumne 2: Edmon Alcoceba
; Grup Pràctiques: 
; Pràctica: Pràctica 2 - Tres en ratlla
; Data: 12/05/2025
; --------------------------------------------------------------- 

TECLAT EQU 0B000h
PANTALLA EQU 0A000h

ORIGEN 100h
INICIO ini

.DATOS
    fila1 VALOR 0,0,0
    fila2 VALOR 0,0,0
    fila3 VALOR 0,0,0

.CODIGO
ini:

start:
;inicialitzacio de registres a 0
XOR R0, R0, R0
XOR R1, R1, R1
XOR R2, R2, R2
XOR R3, R3, R3
XOR R4, R4, R4
XOR R5, R5, R5

;crides de funcions mitjançant els registres
MOVH R6, BYTEALTO DIRECCION clearBuffer
MOVL R6, BYTEBAJO DIRECCION clearBuffer
CALL R6

MOVH R6, BYTEALTO DIRECCION clearScreen
MOVL R6, BYTEBAJO DIRECCION clearScreen
CALL R6

MOVH R6, BYTEALTO DIRECCION printScreen
MOVL R6, BYTEBAJO DIRECCION printScreen 
CALL R6

bucle_principal:
    MOVH R6, BYTEALTO DIRECCION player1        
    MOVL R6, BYTEBAJO DIRECCION player1
    CALL R6

    MOVH R6, BYTEALTO DIRECCION readKeyboard
    MOVL R6, BYTEBAJO DIRECCION readKeyboard
    CALL R6

    MOVH R6, BYTEALTO DIRECCION markX
    MOVL R6, BYTEBAJO DIRECCION markX
    CALL R6

    MOVH R6, BYTEALTO DIRECCION checkWinner
    MOVL R6, BYTEBAJO DIRECCION checkWinner
    CALL R6

    OR R0, R0, R0
    BRNZ question
    MOVH R6, BYTEALTO DIRECCION isBoardFull
    MOVL R6, BYTEBAJO DIRECCION isBoardFull
    CALL R6                        
    ;si el tauler esta ple finalitzem la patrtida
    XOR R6, R6, R6
    MOVL R6, 1h
    COMP R0, R6
    BRZ question

    MOVH R6, BYTEALTO DIRECCION player2        
    MOVL R6, BYTEBAJO DIRECCION player2
    CALL R6

    MOVH R6, BYTEALTO DIRECCION readKeyboard
    MOVL R6, BYTEBAJO DIRECCION readKeyboard
    CALL R6

    MOVH R6, BYTEALTO DIRECCION markO
    MOVL R6, BYTEBAJO DIRECCION markO
    CALL R6

    MOVH R6, BYTEALTO DIRECCION checkWinner
    MOVL R6, BYTEBAJO DIRECCION checkWinner
    CALL R6

    OR R0, R0, R0
    BRNZ question

JMP bucle_principal
question:
    MOVH R6, BYTEALTO DIRECCION keep_playing
    MOVL R6, BYTEBAJO DIRECCION keep_playing
    CALL R6

    MOVH R6, BYTEALTO DIRECCION readKeepPlaying
    MOVL R6, BYTEBAJO DIRECCION readKeepPlaying
    CALL R6

    MOVH R6, BYTEALTO DIRECCION fila1
    MOVL R6, BYTEBAJO DIRECCION fila1
    XOR R2, R2, R2
    XOR R0, R0, R0
    MOVL R2, 9h
    clear_board:
    MOV [R6], R0        ;escrivim 0 a la posicio actual
    INC R6              ;avancem a la següent posicio
    DEC R2              ;decrementem el contador
    BRNZ clear_board
    JMP start

end:
    MOVH R6, BYTEALTO DIRECCION clearScreen
    MOVL R6, BYTEBAJO DIRECCION clearScreen
    CALL R6

    MOVH R6, BYTEALTO DIRECCION endingMessage
    MOVL R6, BYTEBAJO DIRECCION endingMessage
    CALL R6

    finalitzacio:
    JMP finalitzacio

;----- FUNCIONS -----

; Uses: R0, R1, R2
clearBuffer:
PUSH R0
PUSH R1
PUSH R2
    MOVH R0, BYTEALTO TECLAT
    MOVL R0, BYTEBAJO TECLAT
    INC R0
    MOVH R2, 00000000b  ;byte alt de R2 a 0
    MOVL R2, 00000100b  ;byte baix amb el bit correspontn per buidar el buffer
    MOV [R0], R2        ;escriu el valor de control a l'adreca del registre de control 
POP R2
POP R1
POP R0
RET

; Uses: R0, R1
clearScreen:
PUSH R0
PUSH R1
    MOVH R0, BYTEALTO PANTALLA
    MOVL R0, BYTEBAJO PANTALLA

    ;calcul despalçament dins la pantalla
    MOVH R1, 00h        ; byte alt R1 = 00h
    MOVL R1, 78h        ; byte baix R1 = 78h (desplaçament concret dins la pantalla)
    ADD R0, R0, R1      ;afegim a R0 la posicio concreta de la pantalla

    MOVH R1, 11111111b  ;combinacio bonaria per fer clear screen
    MOVL R1, 11111111b  
    MOV [R0], R1
POP R1
POP R0
RET

; Uses: R0, R1, R2
printScreen:
PUSH R0
PUSH R1
PUSH R2
    MOVH R0, BYTEALTO PANTALLA
    MOVL R0, BYTEBAJO PANTALLA

    ;taulell de joc
    MOVL R1, 2Fh        ; 2Fh = posicio inicial en pantalla
    ADD R0, R0, R1      ; POSICIO
    MOVH R2, 000110b    ; COLOR
    MOVL R2, 'C'        ; LLETRA
    MOV [R0], R2        ; INSTERTAR A PANTALLA

    INC R0
    MOVL R2, 'O'
    MOV [R0], R2

    INC R0
    MOVL R2, 'L'
    MOV [R0], R2

    INC R0

    INC R0
    MOVL R2, '1'
    MOV [R0], R2

    INC R0
    MOVL R2, '2'
    MOV [R0], R2

    INC R0
    MOVL R2, '3'
    MOV [R0], R2

    INC R0

    MOVL R1, 9h
    ADD R0, R0, R1
    MOVL R2, 'F'
    MOV [R0], R2

    INC R0

    INC R0
    MOVL R2, '1'
    MOV [R0], R2

    INC R0
    MOVH R2, 110100b
    MOVL R2, ' '
    MOV [R0], R2

    INC R0
    MOVL R2, ' '
    MOV [R0], R2

    INC R0
    MOVL R2, ' '
    MOV [R0], R2

    INC R0

    MOVL R1, 9h
    ADD R0, R0, R1
    MOVH R2, 000110b
    MOVL R2, 'I'
    MOV [R0], R2

    INC R0

    INC R0
    MOVL R2, '2'
    MOV [R0], R2

    INC R0
    MOVH R2, 110100b
    MOVL R2, ' '
    MOV [R0], R2

    INC R0
    MOVL R2, ' '
    MOV [R0], R2

    INC R0
    MOVL R2, ' '
    MOV [R0], R2

    INC R0

    MOVL R1, 9h
    ADD R0, R0, R1
    MOVH R2, 000110b
    MOVL R2, 'L'
    MOV [R0], R2

    INC R0

    INC R0
    MOVL R2, '3'
    MOV [R0], R2

    INC R0
    MOVH R2, 110100b
    MOVL R2, ' '
    MOV [R0], R2

    INC R0
    MOVL R2, ' '
    MOV [R0], R2

    INC R0
    MOVL R2, ' '
    MOV [R0], R2

    ;tornar a escriure a la posicio inicial de la pantalla
    MOVH R0, BYTEALTO PANTALLA
    MOVL R0, BYTEBAJO PANTALLA

    INC R0              
    MOVH R2, 000110b   
    MOVL R2, 'T'        
    MOV [R0], R2       

    INC R0
    MOVL R2, 'O'
    MOV [R0], R2

    INC R0
    MOVL R2, 'R'
    MOV [R0], R2

    INC R0
    MOVL R2, 'N'
    MOV [R0], R2

    INC R0

    INC R0
    MOVL R2, 'J'
    MOV [R0], R2

    INC R0
    MOVL R2, 'U'
    MOV [R0], R2

    INC R0
    MOVL R2, 'G'
    MOV [R0], R2

    INC R0
    MOVL R2, 'A'
    MOV [R0], R2

    INC R0
    MOVL R2, 'D'
    MOV [R0], R2

    INC R0
    MOVL R2, 'O'
    MOV [R0], R2
    
    INC R0
    MOVL R2, 'R'
    MOV [R0], R2
    
    INC R0
    INC R0

    INC R0
    MOVL R2, 'E'
    MOV [R0], R2
    
    INC R0
    MOVL R2, 's'
    MOV [R0], R2
    
    INC R0
    MOVL R2, 'c'
    MOV [R0], R2

    INC R0
    MOVL R2, 'r'
    MOV [R0], R2

    INC R0
    MOVL R2, 'i'
    MOV [R0], R2

    INC R0
    MOVL R2, 'u'
    MOV [R0], R2
POP R2
POP R1
POP R0
RET

;Uses: R0, R1
player1:
PUSH R0
PUSH R1
    MOVH R0, BYTEALTO PANTALLA
    MOVL R0, BYTEBAJO PANTALLA

    MOVH R1, 0h
    MOVL R1, 0Eh        ;posicio concreta a la pantalla
    ADD R0, R0, R1      
    MOVH R1, 000110b    
    MOVL R1, '1'        ;valor caselles ocupades pel jugador1
    MOV [R0], R1       
POP R1
POP R0
RET

;Uses: R0, R1
player2:
PUSH R0
PUSH R1
    MOVH R0, BYTEALTO PANTALLA
    MOVL R0, BYTEBAJO PANTALLA

    MOVH R1, 0h
    MOVL R1, 0Eh        ;posicio concreta a la pantalla
    ADD R0, R0, R1      
    MOVH R1, 000110b    
    MOVL R1, '2'        ;valor caselles ocupades pel jugador2    
    MOV [R0], R1        
POP R1
POP R0
RET

; Uses: R0, R1, R2
paint_fil:
PUSH R0
PUSH R1
PUSH R2
    MOVH R0, BYTEALTO PANTALLA
    MOVL R0, BYTEBAJO PANTALLA

    MOVH R1, 00h
    MOVL R1, 16h        ;posicio concreta a la pantalla
    ADD R0, R0, R1      
    MOVH R2, 000110b    
    MOVL R2, 'F'        
    MOV [R0], R2        
    
    INC R0
    MOVL R2, 'I'
    MOV [R0], R2
    
    INC R0
    MOVL R2, 'L'
    MOV [R0], R2

    INC R0
    MOVL R2, ':'
    MOV [R0], R2
POP R2
POP R1
POP R0
RET

; Uses: R0, R1, R2
paint_col:
PUSH R0
PUSH R1
PUSH R2
    MOVH R0, BYTEALTO PANTALLA
    MOVL R0, BYTEBAJO PANTALLA

    MOVH R1, 00h
    MOVL R1, 16h        ;posicio concreta a la pantalla
    ADD R0, R0, R1      
    MOVH R2, 000110b    
    MOVL R2, 'C'        
    MOV [R0], R2        
    
    INC R0
    MOVL R2, 'O'
    MOV [R0], R2
    
    INC R0
    MOVL R2, 'L'
    MOV [R0], R2

    INC R0
    MOVL R2, ':'
    MOV [R0], R2
POP R2
POP R1
POP R0
RET

; Uses: R0, R1, R2, R3, R4, R5, R6
; Output: R0, R5
readKeyboard:
PUSH R1
PUSH R2
PUSH R3
PUSH R4

    checkpoint:
    MOVH R0, BYTEALTO TECLAT
    MOVL R0, BYTEBAJO TECLAT

    CALL paint_fil

    read_fila:
        MOV R3, [R0]        ; guarda el valor del teclat en R0
        XOR R2, R2, R2
        MOVL R2, 0FFh       ; només byte baix
        AND R3, R3, R2      ; elimina el byte alt per poder fer servir els dos teclats (mateix codi asci en els dos teclats)

        MOVL R2, '1'        ; 31 (posicio fila 1)
        COMP R3, R2
        BRZ fila_ok
        MOVL R2, '2'        ; 32 (posicio fila 2)
        COMP R3, R2
        BRZ fila_ok
        MOVL R2, '3'        ; 33 (posicio fila 3)
        COMP R3, R2
        BRZ fila_ok
    JMP read_fila           ; repetim en cas de que cap valor sigui correcte  
    fila_ok:

    CALL paint_col

    read_col:
        MOV R4, [R0]
        MOVL R2, 0FFh
        AND R4, R4, R2       ;només byte baix 

        MOVL R2, '1'        ; 31 (posicio columna 1)     
        COMP R4, R2
        BRZ col_ok
        MOVL R2, '2'        ; 32 (posicio columna 2)      
        COMP R4, R2
        BRZ col_ok
        MOVL R2, '3'        ; 33 (posicio columna 3)  
        COMP R4, R2
        BRZ col_ok
    JMP read_col            ; repetim en cas de que cap valor sigui correcte
    col_ok:

    XOR R2, R2, R2
    XOR R6, R6, R6

    MOVH R0, BYTEALTO PANTALLA
    MOVL R0, BYTEBAJO PANTALLA

    MOVH R5, BYTEALTO DIRECCION fila1       ; assignacio de valor a les variables
    MOVL R5, BYTEBAJO DIRECCION fila1

    ; calcular desplaçament vertical (fila)
    MOVL R2, '1'
    COMP R3, R2
    BRNZ f2
    MOVL R1, 3Ch    ;posicio exacta fila 1
    MOVL R6, 0h
    
    JMP j1

    f2:
    MOVL R2, '2'
    COMP R3, R2
    BRNZ f3
    MOVL R1, 4Bh    ;posicio exacta fila 2
    MOVL R6, 3h
    JMP j1

    f3:
    MOVL R1, 5Ah    ;posicio exacta fila 3
    MOVL R6, 6h

    j1:
    ADD R0, R0, R1
    ADD R5, R5, R6  ;sumem el la posicio exacta a la posicio de la pantalla

    ; calcular desplaçament horitzontal (columna)
    MOVL R2, '1'
    COMP R4, R2
    BRNZ c2
    MOVL R1, 6h     ;posicio exacta columna 1
    MOVL R6, 0h
    JMP j2

    c2:
    MOVL R2, '2'
    COMP R4, R2
    BRNZ c3
    MOVL R1, 7h     ;posicio exacta columna 2
    MOVL R6, 1h
    JMP j2

    c3:
    MOVL R1, 8h    ;posicio exacta columna 3
    MOVL R6, 2h
    
    j2:
    ADD R0, R0, R1
    ADD R5, R5, R6  ;sumem la posicio de les columnes a la posicio de la pantalla

    XOR R2, R2, R2

    ;verificar si la casella esta ocupada
    MOV R1, [R5]             ; carreguem el valor de la casella a R1
    MOVL R2, 0h       
    COMP R1, R2              ; comparem amb 0h
    BRZ casilla_libre        ; si es 0h, la casella esta lliure 
    JMP checkpoint           ; si no tornem a llegir un valor
    casilla_libre:
POP R4
POP R3
POP R2
POP R1
RET

; Uses: R0, R1, R2, R5
; Input: R0, R5
markX:
PUSH R1
PUSH R2
    MOVH R1, 110100b
    MOVL R1, 'X'
    MOV [R0], R1
    
    ;actualitza la matriu     
    MOVL R2, 1h     ;valor que representa la casella ocupada pel jugador1        
    MOV [R5], R2    ;escriu a la posicio de memoria del tauler 
POP R2
POP R1
RET

; Uses: R0, R1, R2, R5
; Input: R0, R5
markO:
PUSH R1
PUSH R2
    MOVH R1, 110100b
    MOVL R1, 'O'
    MOV [R0], R1

    ;actualitza la matriu 
    MOVL R2, 5h     ;valor que representa la casella ocupada pel jugador2
    MOV [R5], R2    ;escriu a la posicio de memoria del tauler
POP R2
POP R1
RET

; Uses: R0, R1, R2
; Output: R0 (1 si el tablero está lleno, 0 si no lo está)
isBoardFull:
PUSH R1
PUSH R2
    MOVH R0, BYTEALTO DIRECCION fila1   
    MOVL R0, BYTEBAJO DIRECCION fila1
    MOVL R1, 9                          ; numero total de pisicions (100 a 108)
    XOR R2, R2, R2                      

    check_position:
        MOV R2, [R0]                        ; carregar el valor de la posició actual
        XOR R3, R3, R3                      
        COMP R2, R3                         
        BRZ not_full                        ; si alguna posició és 0, el tauler no està ple
        INC R0                              ; avançar a la següent posició
        DEC R1                              ; decrementar el contador
    BRNZ check_position                     ; ho repetim fins comprovar el valor de cada una de les posicions 

    ;en cas d'estar ple fem la crida de diverses funcions per finalitzar el joc
    XOR R1, R1, R1
    MOVH R6, BYTEALTO DIRECCION clearScreen
    MOVL R6, BYTEBAJO DIRECCION clearScreen
    CALL R6   

    MOVH R6, BYTEALTO DIRECCION draw
    MOVL R6, BYTEBAJO DIRECCION draw
    CALL R6

    XOR R0, R0, R0
    MOVL R0, 1h     ; el tauler està ple
    JMP exit        ;saltem al final

    not_full:                      
    XOR R0, R0, R0      ;si no esta ple retablim el valor de R0 i sortim
    exit:
POP R2
POP R1
RET

paint_jugador:
PUSH R0
PUSH R1
PUSH R2
    MOVH R0, BYTEALTO PANTALLA
    MOVL R0, BYTEBAJO PANTALLA

    ;escriure jugador
    MOVL R1, 25h        ; posicio conecreta a la pantalla
    ADD R0, R0, R1      
    MOVH R2, 000110b    
    MOVL R2, 'J'        
    MOV [R0], R2        

    INC R0
    MOVL R2, 'U'
    MOV [R0], R2

    INC R0
    MOVL R2, 'G'
    MOV [R0], R2

    INC R0
    MOVL R2, 'A'
    MOV [R0], R2

    INC R0
    MOVL R2, 'D'
    MOV [R0], R2

    INC R0
    MOVL R2, 'O'
    MOV [R0], R2

    INC R0
    MOVL R2, 'R'
    MOV [R0], R2
POP R2
POP R1
POP R0
RET

winScreen:
PUSH R0
PUSH R1
PUSH R2
    MOVH R0, BYTEALTO PANTALLA
    MOVL R0, BYTEBAJO PANTALLA

    ;missatge jugador 1 guanyador
    MOVL R1, 1Eh        ; posicio conecreta a la pantalla
    ADD R0, R0, R1      
    MOVH R2, 000110b    
    MOVL R2, 'C'        
    MOV [R0], R2        

    INC R0
    MOVL R2, 'A'
    MOV [R0], R2

    INC R0
    MOVL R2, 'M'
    MOV [R0], R2

    INC R0
    MOVL R2, 'P'
    MOV [R0], R2

    INC R0
    MOVL R2, 'I'
    MOV [R0], R2

    INC R0
    MOVL R2, 'O'
    MOV [R0], R2

    INC R0

POP R2
POP R1
POP R0
RET

player1win:
PUSH R0
PUSH R1
PUSH R2
    MOVH R0, BYTEALTO PANTALLA
    MOVL R0, BYTEBAJO PANTALLA

    CALL winScreen
    CALL paint_jugador

    MOVL R1, 2Ch        ; posicio concreta a la pantalla
    ADD R0, R0, R1      
    MOVH R2, 000110b    
    MOVL R2, '1'        
    MOV [R0], R2        

POP R2
POP R1
POP R0
RET

player2win:
PUSH R0
PUSH R1
PUSH R2
    MOVH R0, BYTEALTO PANTALLA
    MOVL R0, BYTEBAJO PANTALLA

    CALL winScreen
    CALL paint_jugador

    MOVL R1, 2Ch        ; posicio conecreta a la pantalla
    ADD R0, R0, R1       
    MOVH R2, 000110b    
    MOVL R2, '2'       
    MOV [R0], R2       
POP R2
POP R1
POP R0
RET

draw:
PUSH R0
PUSH R1
PUSH R2
    MOVH R0, BYTEALTO PANTALLA
    MOVL R0, BYTEBAJO PANTALLA

    MOVL R1, 23h    ; posicio conecreta a la pantalla
    ADD R0, R0, R1
    MOVH R2, 000110b  
    MOVL R2, 'E' 
    MOV [R0], R2

    INC R0
    MOVL R2, 'M'
    MOV [R0], R2

    INC R0
    MOVL R2, 'P'
    MOV [R0], R2

    INC R0
    MOVL R2, 'A'
    MOV [R0], R2

    INC R0
    MOVL R2, 'T'
    MOV [R0], R2
POP R2
POP R1
POP R0
RET

;empat diferent de 3 i 15
;15 = guanyadpor jugador 2
;3 = guanyador jugador 1

checkWinner:
PUSH R1  
PUSH R2
PUSH R3  
PUSH R4  
PUSH R5  

    ; Obtenim l’adreça de l’inici del tauler (fila1)
    MOVH R1, BYTEALTO DIRECCION fila1
    MOVL R1, BYTEBAJO DIRECCION fila1
    XOR R0, R0, R0

    ;fila 0,1,2
    MOV R3, R1              ; R3 adreça casella 0
    MOV R2, [R3]            ; R2 valor casella 0

    INC R3                  ; R3 adreça casella 1
    MOV R4, [R3]
    ADD R2, R2, R4          ; suma: pos0 + pos1

    INC R3                  ; R3 adreça casella 2
    MOV R4, [R3]
    ADD R2, R2, R4          ; suma final: pos0 + pos1 + pos2

    CALL check_sum          ; comprovem si el resultat de la suma es guanyadora
    OR R0, R0, R0           ;si es = 0 s'omet el BRNZ, sino s'executa
    BRNZ exit_checkWinner   ;suma valida sortim de la funcio

    ;fila 3,4,5 
    MOV R3, R1
    MOVL R4, 3h
    ADD R3, R3, R4          
    MOV R2, [R3]

    INC R3
    MOV R4, [R3]
    ADD R2, R2, R4

    INC R3
    MOV R4, [R3]
    ADD R2, R2, R4

    CALL check_sum
    OR R0, R0, R0
    BRNZ exit_checkWinner

    ;fila 6,7,8
    MOV R3, R1
    MOVL R4, 6h
    ADD R3, R3, R4          
    MOV R2, [R3]

    INC R3
    MOV R4, [R3]
    ADD R2, R2, R4

    INC R3
    MOV R4, [R3]
    ADD R2, R2, R4

    CALL check_sum
    OR R0, R0, R0
    BRNZ exit_checkWinner

    ;columna 0,3,6
    MOV R3, R1
    MOV R2, [R3]            ; valor casella 0

    MOVL R4, 3h
    ADD R5, R3, R4
    MOV R4, [R5]            ; valor casella 3
    ADD R2, R2, R4

    MOVL R4, 3h
    ADD R5, R5, R4
    MOV R4, [R5]            ; valor casella 6
    ADD R2, R2, R4

    CALL check_sum
    OR R0, R0, R0
    BRNZ exit_checkWinner

    ;columna 1,4,7
    MOV R3, R1
    INC R3                  ; R3 ← adreça casella 1
    MOV R2, [R3]

    MOVL R4, 3h
    ADD R5, R3, R4
    MOV R4, [R5]            ; casella 4
    ADD R2, R2, R4

    MOVL R4, 3h
    ADD R5, R5, R4
    MOV R4, [R5]            ; casella 7
    ADD R2, R2, R4

    CALL check_sum
    OR R0, R0, R0
    BRNZ exit_checkWinner

    ; columna 2,5,8
    MOV R3, R1
    MOVL R4, 2h
    ADD R3, R3, R4          ; R3 ← casella 2
    MOV R2, [R3]

    MOVL R4, 3h
    ADD R5, R3, R4
    MOV R4, [R5]            ; casella 5
    ADD R2, R2, R4

    MOVL R4, 3h
    ADD R5, R5, R4
    MOV R4, [R5]            ; casella 8
    ADD R2, R2, R4

    CALL check_sum
    OR R0, R0, R0
    BRNZ exit_checkWinner

    ;diagonal 0,4,8
    MOV R3, R1
    MOV R2, [R3]            ; casella 0

    MOVL R4, 4h
    ADD R5, R3, R4
    MOV R4, [R5]            ; casella 4
    ADD R2, R2, R4

    MOVL R4, 4h
    ADD R5, R5, R4
    MOV R4, [R5]            ; casella 8
    ADD R2, R2, R4

    CALL check_sum
    OR R0, R0, R0
    BRNZ exit_checkWinner

    ;diagonal 2,4,6
    MOV R3, R1
    MOVL R4, 2h
    ADD R3, R3, R4          ; R3 ← casella 2
    MOV R2, [R3]

    MOVL R4, 2h
    SUB R3, R3, R4          ; tornem a casella 0

    MOVL R4, 4h
    ADD R5, R3, R4
    MOV R4, [R5]            ; casella 4
    ADD R2, R2, R4

    MOVL R4, 2h
    ADD R5, R5, R4
    MOV R4, [R5]            ; casella 6
    ADD R2, R2, R4

    CALL check_sum
    exit_checkWinner:

    MOVH R1, 0h
    MOVL R1, 1h
    COMP R0, R1     ;compara el resultat de la suma amb 1 (R0)
    BRNZ check_2    ;si no es 1, saltem a la comprovacio del player2

        MOVH R6, BYTEALTO DIRECCION clearScreen
        MOVL R6, BYTEBAJO DIRECCION clearScreen
        CALL R6

        MOVH R6, BYTEALTO DIRECCION player1win
        MOVL R6, BYTEBAJO DIRECCION player1win
        CALL R6

    check_2:
    MOVL R1, 5h
    COMP R0, R1     ;compara el resultat de la suma amb 5 (R0)
    BRNZ exit_end   ;si no coicideix, sortim
        MOVH R6, BYTEALTO DIRECCION clearScreen
        MOVL R6, BYTEBAJO DIRECCION clearScreen
        CALL R6

        MOVH R6, BYTEALTO DIRECCION player2win
        MOVL R6, BYTEBAJO DIRECCION player2win
        CALL R6
    exit_end:
POP R5
POP R4
POP R3
POP R2
POP R1
RET

check_sum:
    XOR R0, R0, R0
    ; comprova si la suma correspon a jugador 1 (1 + 1 + 1 = 3)
    MOVL R0, 3h
    COMP R2, R0
    ; ; si és igual → jugador 1 guanya
    BRZ jugador1guanya

    ; comprova si la suma correspon a jugador 2 (5 + 5 + 5 = 15)
    MOVL R0, 0Fh
    COMP R2, R0
    BRZ jugador2guanya

    ; si no és cap dels dos, sortir
    MOVL R0, 0h     ; cap guanyador
    JMP sortir_sum

    jugador1guanya:
    MOVL R0, 1h     ; valor que representa guanyador jugador 1
    JMP sortir_sum

    jugador2guanya:
    MOVL R0, 5h     ; valor que representa guanyador jugador 2

    sortir_sum:
RET

keep_playing:
PUSH R0
PUSH R1
PUSH R2
    MOVH R0, BYTEALTO PANTALLA
    MOVL R0, BYTEBAJO PANTALLA

    MOVL R1, 3Fh        ;posicio concreta a la pantalla
    ADD R0, R0, R1      
    MOVH R2, 000110b    
    MOVL R2, 'C'        
    MOV [R0], R2        

    INC R0
    MOVL R2, 'O'
    MOV [R0], R2

    INC R0
    MOVL R2, 'N'
    MOV [R0], R2

    INC R0
    MOVL R2, 'C'
    MOV [R0], R2

    INC R0
    MOVL R2, 'L'
    MOV [R0], R2

    INC R0
    MOVL R2, 'O'
    MOV [R0], R2

    INC R0
    MOVL R2, 'U'
    MOV [R0], R2

    INC R0
    MOVL R2, 'R'
    MOV [R0], R2

    INC R0
    MOVL R2, 'E'
    MOV [R0], R2

    MOVL R1, 0Ah        ;posicio concreta a la pantalla    
    ADD R0, R0, R1       
    MOVL R2, 'J'         
    MOV [R0], R2         

    INC R0
    MOVL R2, 'O'
    MOV [R0], R2

    INC R0
    MOVL R2, 'C'
    MOV [R0], R2

    MOVL R1, 0Ch        ; posicio concreta a la pantalla
    ADD R0, R0, R1       
    MOVL R2, '('         
    MOV [R0], R2         

    INC R0
    MOVH R2, 000010b     
    MOVL R2, 'S'         
    MOV [R0], R2        

    INC R0
    MOVH R2, 000110b     
    MOVL R2, '/'         
    MOV [R0], R2         

    INC R0
    MOVH R2, 000100b     
    MOVL R2, 'N'         
    MOV [R0], R2        

    INC R0
    MOVH R2, 000110b     
    MOVL R2, ')'        
    MOV [R0], R2        

POP R0
POP R1
POP R2
RET

readKeepPlaying:
PUSH R1
PUSH R2
PUSH R3
PUSH R4
        MOVH R0, BYTEALTO TECLAT
        MOVL R0, BYTEBAJO TECLAT

    wait_key:
        MOV R3, [R0]        ; Llegim la tecla
        XOR R2, R2, R2  

        readS:
        ; Comprovar si és 'S'
        MOVH R2, 15h ;s
        MOVL R2, 73h
        COMP R3, R2
        BRZ exitgame     ; Si és 'S' → rep
        MOVL R2, 53h
        COMP R3, R2
        BRZ exitgame

        readN:
        ; Comprovar si és 'N'
        MOVH R2, 24h ;n
        MOVL R2, 4Eh
        COMP R3, R2
        BRZ keepplaying        ; Si és 'N' → end
        MOVL R2, 6Eh
        COMP R3, R2
        BRZ keepplaying

        ; Si no és ni 'S' ni 'N', tornar a llegir
        JMP wait_key

    exitgame:
        MOVH R6, BYTEALTO DIRECCION end
        MOVL R6, BYTEBAJO DIRECCION end
        JMP R6
    
    keepplaying:
POP R1
POP R2
POP R3
POP R4
RET

endingMessage:
PUSH R0
PUSH R1
PUSH R2
    MOVH R0, BYTEALTO PANTALLA
    MOVL R0, BYTEBAJO PANTALLA

    MOVL R1, 1Eh        ;posicio concreta a la pantalla
    ADD R0, R0, R1       
    MOVH R2, 000110b   
    INC R0  
    MOVL R2, 'F'         
    MOV [R0], R2        

    INC R0
    MOVL R2, 'I'
    MOV [R0], R2

    INC R0
    MOVL R2, 'N'
    MOV [R0], R2

    INC R0
    MOVL R2, 'S'
    MOV [R0], R2

    INC R0

    INC R0
    MOVL R2, 'U'
    MOV [R0], R2

    INC R0
    MOVL R2, 'N'
    MOV [R0], R2

    INC R0

    INC R0
    MOVL R2, 'A'
    MOV [R0], R2

    INC R0
    MOVL R2, 'L'
    MOV [R0], R2

    INC R0
    MOVL R2, 'T'
    MOV [R0], R2

    INC R0
    MOVL R2, 'R'
    MOV [R0], R2

    INC R0
    MOVL R2, 'A'
    MOV [R0], R2
POP R0
POP R1
POP R2
RET

FIN