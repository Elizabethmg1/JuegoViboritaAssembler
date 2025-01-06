
.data
  /* Definicion de datos */
mapa: .asciz "+------------------------------------------------+\n|               ****************                 |\n|               *** VIBORITA ***                 |\n|               ****************                 |\n+------------------------------------------------+\n|                                                |\n|                                                |\n|         @***                                   |\n|                                                |\n|                    M                           |\n|                                                |\n|                                                |\n|                                                |\n|                                                |\n+------------------------------------------------+\n| Puntaje:                      Nivel:           |\n+------------------------------------------------+\n"      @ \n enter
longitud= .-mapa
letraDireccion: .ascii "w"
gameover: .asciz "                   ___GAME OVER___               \n"      @/n enter
largogameover= .-gameover
gano: .asciz "                  ___ GANASTE! ___               \n"      @/n enter
largogano= .-gano
cls: .asciz "\x1b[H\x1b[2J"
lencls = .-cls
puntaje: .word 0
xPuntaje: .word 10
yPuntaje: .word 15
x: .word 10
y: .word 7
obstaculo: .ascii "w"
xPosAnterior: .word 0
yPosAnterior: .word 0
modificarPuntaje: .word 0
nivel: .word 1
modificarNivel: .word 1 //si modificaNivel es =1 se puede subir el nivel hacia el 2
vectorIndices: .word 270,311,450,600

.text

jugar:
.fnstart
	bl leerTecla
	bl moverViborita
	bl imprimirMapa
	b jugar
.fnend

leerTecla:
.fnstart
	push {lr}
        mov r7,#3 //lectura por teclado
        mov r0,#0 //ingreso de cadena
        mov r2,#1 //leer 1 caracter
        ldr r1,=letraDireccion //cargo en letraDireccion la cadena
	swi 0
	pop {lr}
	bx lr
.fnend

moverViborita:
.fnstart
	push {lr}
	ldr r1,=x
	ldrb r1,[r1]  //traigo coordenada x
	ldr r3,=xPosAnterior
	str r1,[r3] //resguardo coordenada x anterior ya que luego se modificara
	ldr r2,=y
	ldrb r2,[r2] //traigo coordenada y
	ldr r4,=yPosAnterior
	str r2,[r4] //resguardo coordenada y anterior ya que luego se modificara
	bl obtenerNuevaPosicion
	bl hayManzana
	bl hayPared
	bl completar
	bl avanzarANuevaPosicion
	bl actualizarNivel
	pop {lr}
	bx lr
.fnend

obtenerNuevaPosicion:
.fnstart
	push {lr}
	ldr r1,=x
	ldrb r1,[r1]  //traigo coordenada x
	ldr r2,=y
	ldrb r2,[r2]   //traigo coordenada y
	ldr r0,=letraDireccion
	ldrb r0,[r0] //traigo el byte de la letra en r0
	cmp r0,#'w' //si la letra ingresada es la 'w' se activa el flag z
	subeq r2,#1 //si se activa el flag z se resta 1 a la coordenada Y
	cmp r0,#'s' //si la letra ingresada es 's' se activa el flag z
	addeq r2,#1 //si se activa el flag z se suma 1 a la coordenada y
	ldr r4,=y  //traigo puntero de coordenada y
	strb r2,[r4]  //guardo la coordenada que fue  modificada o no
	cmp r0,#'a' //si la letra ingresada es 'a' se activa el flag z
	subeq r1,#1 //si se activa el flag z se resta 1 a la coordenada x
	cmp r0,#'d'  //si la letra ingresada es 'd' se activa el flag z
	addeq r1,#1 //si se activa el flag z se suma 1 a la coordenada x
	ldr r3,=x   //traigo puntero de coordenada x
	strb r1,[r3]  //guardo la coordenada que fue modificada o no
	ldr r5,=obstaculo
	mov r4,#51
	mul r4,r2
	add r4,r1
	ldr r3,=mapa
	add r3,r4
	ldr r6,[r3]
	strb r6,[r5] //luego de obtener la siguiente posicion guardo el obstaculo que podria llegar a tener en su camino
	pop {lr}
	bx lr
.fnend

avanzarANuevaPosicion:
.fnstart
	push {lr}
	ldr r1,=x
	ldrb r1,[r1] //traigo coordenada x
	ldr r2,=y
	ldrb r2,[r2] //traigo coordenada y
	mov r3,#51
	mul r3,r2
	add r3,r1
	mov r4,#'@'
	ldr r0,=mapa
	add r0,r3
	strb r4,[r0] //agrego la cabeza a la viborita
	pop {lr}
	bx lr
.fnend

hayManzana:
.fnstart
	push {lr}
	ldr r5,=obstaculo
	ldrb r6,[r5]
	cmp r6,#'M' //me fijo si en la nueva posicion hay una manzana
	beq generaManzana
	b vuelve
generaManzana:
	bl generarManzana
	bl actualizarInfoBar
vuelve:
	pop {lr}
	bx lr
.fnend

hayPared:
.fnstart
	push {lr}
	ldr r5,=obstaculo
	ldrb r6,[r5]
	cmp r6,#'-'
	beq asignarPuntaje
	cmp r6,#'|'
	beq asignarPuntaje
	cmp r6,#'*'
	beq asignarPuntaje
	cmp r6,#'<'
	beq gameOver
	b sinModificarPuntaje
asignarPuntaje:
	mov r5,#10
	ldr r6,=modificarPuntaje
	strb r5,[r6]
	bl actualizarInfoBar
sinModificarPuntaje:
	mov r4,#0
	ldr r6,=modificarPuntaje
	strb r4,[r6] //vuelvo a poner modificarPuntaje en 0
	pop {lr}
	bx lr
.fnend

generarManzana:
.fnstart
	push {lr}
	mov r3,#20
	ldr r4,=modificarPuntaje
	strb r3,[r4] //se guarda el puntaje por comer manzana
	ldr r1,=x
	ldrb r1,[r1]  //traigo coordenada x de la manzana comida
	ldr r2,=y
	ldrb r2,[r2] //traigo coodenada y de la manzana comida
	mov r6,#51
	mul r6,r2
	add r6,r1  //calculo en r6 el indice
	mov r5,#100
	mov r2,#7
	mul r5,r2 //calculo en r5 el numero del indice limite para colocar manzanas
ciclo:
	add r6,#15  //le sumo 15 a la ubicacion de la manzana comida
	cmp r6,r5   //si posicion de la nueva manzana esta fuera de los limites se le resta 400
	bgt resta
	b continua  //si la  posicion de la nueva manzana esta dentro de los limites posibles se continua
resta:
	mov r1,#150
	mov r9,#2
	mul r9,r1 //calculo en r9 el numero que le voy a restar al indice en caso de pasarse de los limites
	mov r6,r9
continua:
	ldr r3,=mapa  // se trae el puntero del mapa
	add r3,r6   //se le suma el nuevo indice
	ldrb r4,[r3]  //se trae el objeto de la nueva posicion
	cmp r4,#'|'   //se compara el objeto con los objetos que no puede reemplazar
	beq ciclo
	cmp r4,#'*'
	beq ciclo
	cmp r4,#'@'
	beq ciclo
	cmp r4,#'<'
	beq ciclo
	mov r5,#'M'
	strb r5,[r3] //si no hay nada en el camino se coloca la nueva manzana en el mapa
	pop {lr}
	bx lr
.fnend

completar:
.fnstart
	push {lr}
	ldr r1,=xPosAnterior
	ldrb r1,[r1]
	ldr r2,=yPosAnterior
	ldrb r2,[r2]
	mov r6,#51
	mul r6,r2  //multiplico las filas por el largo de las columnas para obtener la fila
	add r6,r1 //sumo la columna a la fila obtenida
	mov r0,#'*'  //coloco en r0 el cuerpo de la viborita
	ldr r4,=mapa  //traigo el puntero de mapa
	add r4,r6
	strb r0,[r4]  //al puntero del mapa le sumo el indice
	pop {lr}
	bx lr
.fnend

actualizarNivel:
.fnstart
	push {lr}
	ldr r3,=puntaje
	ldr r3,[r3]
	cmp r3,#45
	bgt revisaFlag
	b imprimirNivel
revisaFlag:
	Ldr r1,=modificarNivel
	Ldrb r2,[r1]
	cmp r2,#1
	beq subeNivel
	b imprimirNivel
subeNivel:
	mov r3,#0
	str r3,[r1] //apago flag para subir nivel
	ldr r1,=nivel
	mov r3,#2
	strb r3,[r1]  //guardo el 2 en la variable nivel
	ldr r1,=vectorIndices
	mov r4,#4  //cantidad de indices, obstaculo para colocar
cicloObstaculo:
	cmp r4,#0
	beq imprimirNivel
	ldr r2,[r1]
	ldr r3,=mapa
	add r3,r2
comparar:
	ldr r5,[r3]   //traigo el objeto del puntero r3 y lo comparo con objetos para que no los pise
	cmp r5,#'*'
	beq sumarAIndice
	cmp r5,#'@'
	beq sumarAIndice
	cmp r5,#'-'
	beq sumarAIndice
	cmp r5,#'|'
	beq sumarAIndice  //si el objeto traido coincide con algun objeto del mapa le sumo 5 al indice
	b imprimeObstaculo
sumarAIndice:
	add r3,#5
	b comparar // vuelvo a comparar
imprimeObstaculo:
	mov r6,#60
	strb r6,[r3]
	sub r4,#1  //le resto a la cantidad de obstaculos un 1
	add r1,#4  //le sumo al vector de obstaculos 4 byte para apuntar al siguiente indice
	b cicloObstaculo
imprimirNivel:
	ldr r1,=nivel
	ldrb r2,[r1]
	add r2,#48
	mov r3,#51
	mov r4,#15
	mul r3,r4
	add r3,#38 //queda en r3 el indice
	ldr r1,=mapa
	add r1,r3
	strb r2,[r1] //guardo nivel en la pantalla
	pop {lr}
	bx lr
.fnend

actualizarInfoBar:
.fnstart
	push {lr}
	ldr r5,=modificarPuntaje
	ldrb r5,[r5] //traigo puntaje a restar o sumar
	ldr r0,=puntaje
	ldrb r1,[r0] //traigo puntaje acumulado
	cmp r5,#20
	beq hagoLaSuma //si el puntaje a restar o sumar es positivo hago la suma
	sub r1,r5  //sino hago la resta
	b guardarPuntaje
hagoLaSuma:
	add r1,r5
guardarPuntaje: //guardo el nuevo puntaje y veo si pierde o gana
	strb r1,[r0] //modifico puntaje acumulado
	cmp r1,#0
	blt gameOver
	mov r3,#0 //contador de centenas
	mov r4,#48
centenas:
	cmp r1,#100
	blt convertirCentenas
	sub r1,#100
	add r3,#1
	b centenas
convertirCentenas:
	add r3,#48 //r3 contiene el codigo ascii de la centena
	mov r4,#0  //contador decenas
decenas:
	cmp r1,#10
	blt convertirDecenas
	sub r1,#10
	add r4,#1
	b decenas
convertirDecenas:
	add r4,#48 //r4 contiene el codigo ascii de la decena
convertirUnidades:
	add r1,#48 //r1 contiene el codigo ascii de las unidades
imprimirPuntaje:
	ldr r2,=xPuntaje
	ldrb r2,[r2]
	ldr r5,=yPuntaje
	ldr r5,[r5]
	mov r6,#51
	mul r6,r5
	add r6,r2
	ldr r8,=mapa
	add r8,r6
	strb r3,[r8]
	add r8,#1
	strb r4,[r8]
	add r8,#1
	strb r1,[r8]
	ldr r1,=puntaje  //traigo el puntaje para comprobar si gana
	ldrb r1,[r1]
	cmp r1,#150
	bge gana //si el nuevo puntaje es mayor o igual a 150 gana el juego
	pop {lr}
	bx lr
.fnend

gana:
.fnstart
	push {lr}
	bl completar
	bl avanzarANuevaPosicion
	bl imprimirMapa
	mov r7,#4
	mov r0,#1
	ldr r2,=largogano
	ldr r1,=gano
	swi 0
	b fin
.fnend

gameOver:
.fnstart
	push {lr}
	bl completar
	bl avanzarANuevaPosicion
	bl imprimirMapa
	mov r7,#4
	mov r0,#1
	ldr r2,=largogameover
	ldr r1,=gameover
	swi 0
	b fin
.fnend

imprimirMapa:
.fnstart
	push {lr}
//borrar pantalla
	mov r0, #1
        ldr r1, =cls
        ldr r2, =lencls
        mov r7, #4
        swi #0
//imprimir pantalla
	mov r7,#4 //salida por pantalla
	mov r0,#1 // indicamos que sera una cadena
	ldr r2,=longitud //tamano de la cadena
	ldr r1,=mapa //cargamos en r1 la direccion del mensaje
	swi 0
	pop {lr} //traigo sexta direccion de retorno
	bx lr //vuelvo a sexta direccion de retorno
.fnend

.global main

main:
	bl imprimirMapa
	b jugar
fin:
	mov r7,#1
	swi 0
