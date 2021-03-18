org 100h
   
    call initJuego
    call jugar
    call guardarDatos
ret
    
  
proc initJuego
    call printMap       
    call printJuegaP1
    call pedirCoordenadasP1
    call clear
    call printMap       
    call printJuegaP2
    call pedirCoordenadasP2
    call clear
    
    
    ;call imprimirNum
    ret
        
endp

proc clear
    mov ah, 0
    mov al, 03h
    int 10h
    ret
endp    

proc jugar
    up:
    call printMap
    call printJuegaP1
    call pedirMisil ;jugador1 
    inc cantUSA
    call borrarMap
    call controlar
    cmp termino, 0
    jne santiguti
    call clear
    call printMap
    call printJuegaP2
    call pedirMisil ;jugador2
    inc cantURSS
    call borrarMap
    call controlar
    cmp termino, 0
    jne santiguti
    call clear
    jmp up        
    santiguti:
    ret
endp    

proc printJuegaP1
    mov ah, 09
    mov dx, offset juegaP1
    int 21h
    ret
endp

proc printJuegaP2    
    mov ah, 09
    mov dx, offset juegaP2
    int 21h
    ret
endp


proc printMap
    ; se imprime el mapa en dos partes
    mov ah,09
    mov dx,offset mapaArriba
    int 21h
    ;mov ah,09
    ;mov dx,offset mapaAbajo
    ;int 21h
    ret
endp

proc borrarMap
    mov ax, 0
    mov al, misilX
    mov bx, ax
    dec bx
    mov al, misilY
    mov dl, 76
    mul dl
    sub ax, 76
    mov si, ax
    
    
    
    mov dh, 0
    ciclo1:
    
    mov dl, 0
    ciclo2:
    mov cl, mapaArriba[bx+si]                     
    cmp cl, "W"
    je borrarW
    segir:
    mov mapaArriba[bx+si], " "
    
    add si, 76    
    inc dl
    cmp dl, 2    
    jbe ciclo2
    mov si, ax
    inc bx
    mov dl, 0
    inc dh
    cmp dh, 2
    jbe ciclo1  
    
    jmp volvimo
    
    
    borrarW:
    
    cmp bx, 33
    ja borrarWURSS
    dec wUSA
    inc cantwURSS
    jmp segir              
    
    borrarWURSS:
    
    dec wURSS
    inc cantwUSA
    jmp segir
    
    volvimo:
    
    ret
endp



proc pedirCoordX
    mov dx, offset coordX
    mov ah, 9    
    int 21h
    ret
endp

proc pedirCoordY
    mov dx, offset coordY
    mov ah, 9    
    int 21h
    ret
endp

proc baseSecUSA
    mov dx, offset StartP1
    mov ah, 9
    int 21h
    ret
endp    
    
proc baseSecURSS
    mov dx, offset StartP2
    mov ah, 9
    int 21h
    ret
endp

proc pedirCoordenadasP1
    call baseSecUSA
    whileXP1:
    
    call pedirCoordX
    call pedirNumero
    cmp aux, 33
    ja whileXP1
    cmp aux, 2
    jbe whileXP1    
    mov bl, aux
    mov xPlay1, bl
    whileYP1:
    call pedirCoordY
    call pedirNumero
    cmp aux, 16
    ja whileYP1
    mov bl, aux
    mov yPlay1, bl
    ret
endp    
    
proc pedirCoordenadasP2
    call baseSecURSS
    whileXP2:
    
    call pedirCoordX
    call pedirNumero
    cmp aux, 33
    jb whileXP2
    cmp aux, 72
    ja whileXP2    
    mov bl, aux
    mov xPlay2, bl
    whileYP2:
    call pedirCoordY
    call pedirNumero
    cmp aux, 16
    ja whileYP2
    mov bl, aux
    mov yPlay2, bl
    ret
endp 

proc usaW ;X 10 - 26 Y 2 - 7
    mov bx, 8
    for2:
    mov dl, 2 
    
    for1:
        mov al, dl
        mov cl, 76
        mul cl
        mov si, ax
        cmp mapaArriba[bx+si],"W"
        je sumaUSA
        
        continue:
        inc dl
        cmp dl, 9
        ja sale
        jmp for1
        
        sumaUSA:
        inc wUSA
        jmp continue
        
        sale:
        inc bx
        cmp bx, 28
        jbe for2
    
    
    ret
    
endp    

proc urssW ;X 10 - 26 Y 2 - 7
    mov bx, 30
    for21:
    mov dl, 1 
    
    for11:
        mov al, dl
        mov cl, 76
        mul cl
        mov si, ax
        cmp mapaArriba[bx+si],"W"
        je sumaURSS
        
        continue1:
        inc dl
        cmp dl, 6
        ja sale1
        jmp for11
        
        sumaURSS:
        inc wURSS
        jmp continue1
        
        sale1:
        inc bx
        cmp bx, 74
        jbe for21
    
    
    ret
    
endp

proc controlar
    
    cmp wUSA, 0
    jle lossP1
    cmp wURSS, 0
    jle lossP2
    
    mov ax, 0
    mov al, xPlay1
    mov bx, ax
    mov al, yPlay1
    mov cl, 76
    mul cl    
    mov si, ax
    mov cl, offset mapaArriba[bx+si]
    cmp cl, 32
    
    je j1Lose
    
    mov ax, 0
    mov al, xPlay2
    mov bx, ax
    mov al, yPlay2
    mov cl, 76
    mul cl    
    mov si, ax
    mov cl, offset mapaArriba[bx+si]
    cmp cl, 32
    je lossP2
    jmp continua
    j1Lose: 
    
        mov ax, 0
        mov al, xPlay2
        mov bx, ax
        mov al, yPlay2
        mov cl, 76
        mul cl    
        mov si, ax
        mov cl, offset mapaArriba[bx+si]
        cmp cl, 32
        je empate
        jmp lossP1
    empate:     
        mov termino, 1
        mov ganador[0], "E"
        mov ganador[1], "M"
        mov ganador[2], "P"
        mov ganador[3], "A"
        mov ganador[4], "T"
        mov ganador[5], "E"
        call clear
        call printMap
        call printEmpate        
        ret
    
    lossP1:          
        mov termino, 1
        mov ganador[0], "U"
        mov ganador[1], "R"
        mov ganador[2], "S"
        mov ganador[3], "S"
        call clear
        call printMap
        call printLossP1
        ret
        
    lossP2:               
        mov termino, 1
        mov ganador[0], "U"
        mov ganador[1], "S"
        mov ganador[2], "A"
        call clear
        call printMap
        call printLossP2    
    continua:    
    ret
endp

proc printLossP1
    
    mov dx, offset perdioP1
    mov ah, 9    
    int 21h
    

    ret
endp

proc printLossP2
    
    mov dx, offset perdioP2
    mov ah, 9    
    int 21h

    ret
endp

proc printEmpate
    
    mov dx, offset nogana
    mov ah, 9    
    int 21h

    ret
endp


proc pedirNumero
    mov aux, 0
    mov bl, 0
    mov dx, 0
    while:
        cmp bl, 2
        ja end
        mov ah, 7
        int 21h
        cmp al, 13
        je enter
        cmp bl, 1    
        ja soloenter        
        
        mov ah, 2
        mov dl, al
        int 21h
        
        sub al, 48
        mov cl, al        
        mov al, aux
        mov dl, 10
        mul dl
        add al, cl
        mov aux, al
        inc bl
        jmp while
        
        
    enter:
        cmp aux, 0
        je while
        jmp end
    soloenter:
        mov ah, 7
        int 21h
        cmp al, 13
        je end
        jmp soloenter
    end:     
    ret
endp            
    
proc pedirMisil
    
    whileX:
    call pedirCoordX
    call pedirNumero
    cmp aux, 75
    ja whileX
    cmp aux, 5
    jbe whileX    
    mov bl, aux
    mov misilX, bl
    whileY:
    call pedirCoordY
    call pedirNumero
    cmp aux, 15
    ja whileY
    mov bl, aux             
    mov misilY, bl
        
    ret
endp
    
proc guardarDatos
    
    call pasarAString
    
    call abrir
    
    call leer
 
    call escribir
    
    call cerrar
    ret
endp    

proc abrir
    mov al,2h
    mov dx,offset pathFile
    mov ah,3dh
    int 21h
    mov handle,ax
    ret
endp

proc leer
    mov dx,offset linea_leida
    mov cx, 2000
    mov bx,handle
    mov ah,3fh
    int 21h
    ret
endp

proc escribir
    mov bx,handle
    mov cx,145
    mov ah,40h
    mov dx,offset estadistica
    int 21h    
    ret
endp

proc cerrar
    mov bx,handle
    mov ah,3eh
    int 21h
    ret
endp

proc pasarAString
    mov ax, 0
    mov al, cantUSA
    mov cl, 10
    div cl 
    add al, 48
    add ah, 48
    mov cantUSAStr[0], al
    mov cantUSAStr[1], ah
    
    mov ax, 0
    mov al, cantURSS
    mov cl, 10
    div cl
    add al, 48
    add ah, 48
    mov cantURSSStr[0], al
    mov cantURSSStr[1], ah
    
    mov ax, 0
    mov al, cantwUSA
    mov cl, 10
    div cl 
    add al, 48
    add ah, 48
    mov cantwUSAStr[0], al
    mov cantwUSAStr[1], ah
    
    mov ax, 0
    mov al, cantwURSS
    mov cl, 10
    div cl    
    add al, 48
    add ah, 48
    mov cantwURSSStr[0], al
    mov cantwURSSStr[1], ah
    
    ret
endp    
    

        
misilX db 0
misilY db 0    
xPlay1 db 0
yPlay1 db 0
xPlay2 db 0
yPlay2 db 0
           
handle dw ?

auxDato dw ?

cantUSA db 0
cantwUSA db 0
cantURSS db 0
cantwURSS db 0

estadistica db "Ganador: "
ganador db "      ",13
movimientosUSA db "Cantidad de movimientos USA: "
cantUSAStr db "  ",13
movimientosURSS db "Cantidad de movimientos URSS: "
cantURSSStr db "  ",13
cantidadWUSA db "Cantidad de W perdidas URSS: "
cantwUSAStr db "  ",13
cantidadWURSS db "Cantidad de W perdidas USA: "
cantwURSSStr db "  ",10,13,13




pathFile db "c:\stats.txt",0
linea_leida db 145 dup('$')



aux db 0    
coordX db 10,13,"Ingrese coordenada X: $"
coordY db 10,13,"Ingrese coordenada Y: $",10,13

wUSA db 40
wURSS db 54



mapaArriba db 10,13,"00..........................WAR GAMES -1983...............................",10,13,"01.......-.....:**:::*=-..-++++:............:--::=WWW***+-++-.............",10,13,"02...:=WWWWWWW=WWW=:::+:..::...--....:=+W==WWWWWWWWWWWWWWWWWWWWWWWW+-.....",10,13,"03..-....:WWWWWWWW=-=WW*.........--..+::+=WWWWWWWWWWWWWWWWWWWW:..:=.......",10,13,"04.......+WWWWWW*+WWW=-:-.........-+*=:::::=W*W=WWWW*++++++:+++=-.........",10,13,"05......*WWWWWWWWW=..............::..-:--+++::-++:::++++++++:--..-........",10,13,"06.......:**WW=*=...............-++++:::::-:+::++++++:++++++++............",10,13,"07........-+:...-..............:+++++::+:++-++::-.-++++::+:::-............",10,13,"08..........--:-...............::++:+++++++:-+:.....::...-+:...-..........",10,13
mapaAbajo db "09..............-+++:-..........:+::+::++++++:-......-....-...---.........",10,13,"10..............:::++++:-............::+++:+:.............:--+--.-........",10,13,"11..............-+++++++++:...........+:+::+................--.....---....",10,13,"12................:++++++:...........-+::+::.:-................-++:-:.....",10,13,"13.................++::+-.............::++:..:...............++++++++-....",10,13,"14.................:++:-...............::-..................-+:--:++:.....",10,13,"15.................:+-............................................-.....--",10,13,"16.................:....................................................--",10,13,"17.......UNITED STATES.........................SOVIET UNION...............$"
coordXP1 db 0
startP1 db 10,13,"Ingrese base secreta USA$"
startP2 db 10,13,"Ingrese base secreta URSS$"
juegaP1 db 10,13,"Juega USA$"
juegaP2 db 10,13,"Juega URSS$"
perdioP1 db 10,13,"Gano URSS$"
perdioP2 db 10,13,"Gano USA$"
nogana db 10,13,"Empataron gg ez$"
termino db 0