# JuegoViboritaAssembler
ARM Assembly

En el presente trabajo, se busca implementar el juego “La viborita” la cual está compuesta
por asteriscos que forman su cuerpo y un “@” la cual es su cabeza esta viborita se puede
mover en un mapa determinado, para poder mover la viborita se utilizan las teclas ‘a’,’w’,’d’
y ‘s’ seguido por la tecla ‘enter’, cuando esta toca con una pared o su propio cuerpo se le
restan 10 puntos. Además en el mapa se encuentra una manzana la cual al comerla se le
sumarán 20 puntos y seguido de eso se generará otra manzana en el mapa, al llegar a los 50
puntos se subirá al nivel 2 en el cual aparecen 4 obstáculos, los cuales la viborita deberá
esquivar y en el caso de que colisione con estos pierde el juego. El juego se gana si la viborita
acumular 150 puntos, y pierde si su puntaje desciende a un número negativo en cualquiera de
los dos niveles. Para que este juego funcione correctamente seguimos con las condiciones
dadas en el enunciado, en primer lugar se explicará en pseudocódigo el funcionamiento de
cada parte del código del juego, un desarrollo de los problemas encontrados al modificarlo y
por último se dará una breve conclusión del trabajo realizado.
Los procedimientos que se desarrollaron son:

● En sección .global main:

main: En esta etiqueta comienza el juego, lo que hace es imprimir el mapa por primera vez y
luego se realiza un salto de línea hacia jugar en donde se realizan ciclos hasta que termine el
juego, en esta parte del código también se encuentra la etiqueta fin en donde se termina la
ejecución del programa con una interrupción del sistema.

● En sección .text:

Jugar: Es una de las funciones más importantes del proyecto, ya que lleva el control de todo
el juego. Es el encargado de ejecutar los procedimientos que hacen que el programa funcione
correctamente, como leerTecla, moverViborita e imprimirMapa.
leerTeclado: Es el procedimiento cuya función es detectar las teclas que se presionaron
desde el teclado. Luego de detectar la tecla que se presionó, guarda el código ASCII que
generó esa acción, y lo guarda en letraDireccion, acto seguido se llama a una interrupción del
sistema.

moverViborita: Este procedimiento tiene como finalidad manejar toda la lógica que conlleva
el movimiento de la viborita, es decir, se encarga de verificar la posición actual de la víbora
extrayendo las coordenadas ‘x’ e ‘y’ en las direcciones de memoria y para luego en las
siguiente funciones poder obtener posiciones haciendo el calculo del indice multiplicando la
‘y’(filas) por la cantidad de columnas total (51) y luego sumándole la cantidad de columnas
(‘x’), el método de direccionamiento elegido consiste en sumar este índice calculado al
puntero del mapa y de esa forma recorrer la matriz formada por el mapa utilizando el modo
de direccionamiento relativo a registro. Esta función también se encarga de guardar la
posición anterior(porque la misma debe modificarse en la pantalla) y posteriormente dirigirse
a las funciones con retorno: obtenerNuevaPosicion, hayManzana, hayPared, completar,
avanzarANuevaPosicion y actualizarNivel y finalmente retorna a la función jugar.

avanzarANuevaPosicion: Esta función trae las coordenadas de la nueva posición de la
viborita, que se encuentra en datos y allí coloca la cabeza de la viborita utilizando el modo de
direccionamiento relativo a registro mencionado en la función moverViborita.
completar: Esta función completa el cuerpo de la viborita que se desplazó hacia una posición
del mapa, completa la parte en la que antes se encontraba la cabeza de la viborita ‘@’ y la
reemplaza por el cuerpo ‘*’.

obtenerNuevaPosición: En primer lugar, obtiene las coordenadas de la posición actual de la
viborita, y toma la información que se guardó en la variable antes mencionada letraDireccion
y verifica el movimiento que debe hacerse (W-A-S-D). Una vez que tomó la información de
la variable, suma o resta el valor de X o Y (desplazamiento vertical, horizontal). Y por
último, se guarda el contenido de la coordenada adquirida en la variable obstáculo para
futuras comparaciones.

hayManzana: Verifica el contenido de la variable obstáculo si este coincide con “M” el flujo
del programa saltará al procedimiento generarManzana y actualizarInfoBar y finalmente
retorna a función que la llamó.

hayPared: Se encarga de recopilar la información que se encuentra en obstáculo y lo
compara con los siguientes objetos ‘|’ ,’ -’ , ‘*’ y ‘<’ si el obstáculo posee algún dato que
represente a esos símbolos entonces se terminará el juego o se restará el puntaje, dependiendo
de la ocasión. En esta función también se modifica la variable modificarPuntaje dándole el
valor de la constante 10, para luego seguir con un salto de línea a actualizarInfoBar en donde
verifica que el valor de modificarPuntaje es 10 y se resta al puntaje del usuario, cuando se
retorna a hayPared se reinicia el valor de modificarPuntaje.

generarManzana: En principio esta función le otorga a la variable modificarPuntaje el
inmediato 20 para que luego la función actualizarInfoBar haga la correspondiente suma de
puntaje. También este procedimiento obtiene la posición de la manzana que se encuentra
activa en el mapa, le suma 15 bytes(que representan cada posición real del mapa) y compara
la posición final, si esta supera los límites del mapa (se compara con un índice calculado) se
le resta un índice y si esta cae sobre un obstáculo, se realiza otra vez la suma hasta encontrar
una posición correcta para colocar la nueva manzana.

actualizarInfoBar: Recolecta la información que posee la variable puntaje y modifica su
valor dependiendo de la última acción que tuvo el juego (suma de puntos por alcanzar una
manzana, o resta por haber tocado el cuerpo de la víbora) esta suma es realizada en
complemento a2, luego de esta acción inmediatamente la vuelve a guardar en la posición en
memoria correspondiente.

Este procedimiento logra su cometido descomponiendo el número que se encuentra en
puntaje en unidades, decenas, centenas. Y convierte cada parte del número decimal en un
código ASCII que lo representa para luego poder ubicarlo en el mapa. En esta función
también se verifica si se ganó o perdió el juego según el puntaje actualizado del jugador.
actualizarNivel: Esta función revisa el puntaje y si este llegó a 50 o más revisa el flag que
me permite que se suba de nivel si este está encendido se salta hacia la etiqueta subeNivel el
cual apaga el flag para subir de nivel ya que solo se puede subir de nivel 1 vez en este juego,
y luego modifica la variable nivel en datos, ubica el vector de índices en donde irán ubicados
los obstáculos y comienza el ciclo en donde se imprimirán 4 obstáculos, si el índice traído del
vector no es adecuado se le suma 5 y se vuelve a revisar si está en condiciones de ubicarse en
el mapa, si lo esta entonces se ubica en el mapa, se le resta un 1 a la cantidad de obstáculos
que deben imprimirse y le suma 4 bytes al puntero del vector para continuar con el siguiente
índice. Luego de este procedimiento sigue a la etiqueta imprimirNivel a la cual se hubiera
dirigido directamente si el flag para cambiar nivel estuviese apagado (en 0), esta última
etiqueta de la función trae el numero del nivel en que se encuentra lo pasa a código Ascii para
luego imprimirlo en un lugar determinado del mapa.

gameOver: A esta función se accede en el caso de perder el juego, dentro de ella se accede a
la funciones completar, avanzarANuevaPosicion e imprimirMapa, ya que son las últimas
acciones requeridas para actualizar el cuerpo de la viborita y el mapa, por último imprime el
mensaje “Game Over” y produce un salto de línea hacia la etiqueta “fin” en donde se termina
el juego.

gana: Esta función es similar a gameOver lo único que cambia es que en vez de mostrar el
mensaje de juego perdido, se muestra el mensaje de juego ganado.
imprimirMapa: Esta función limpia la pantalla de los caracteres que pudieron mostrarse
antes y vuelve a imprimir el mapa actualizado, acto seguido se llama a una interrupción del
sistema.

Cabe aclarar que cada función implementada tiene su respectivo resguardo de la dirección de
retorno en la pila del stack en caso de que esta fuese llamada desde otra función. Y que
además al utilizar el GDB fue necesaria la conversión de las bases decimal a binario para el
control de flags en el registro CPSR y de hexadecimal a decimal para controlar valores
obtenidos en los registros.
