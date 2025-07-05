a.out: Normalizar.o Pagina.o Diccionario.o Interprete.o TablaHash.o main.o
	g++ Normalizar.o Pagina.o Diccionario.o Interprete.o TablaHash.o main.o

Normalizar.o: Normalizar.cpp Normalizar.h
	g++ -c Normalizar.cpp

Pagina.o: Pagina.cpp Pagina.h Normalizar.h
	g++ -c Pagina.cpp

Diccionario.o: Diccionario.cpp Diccionario.h Normalizar.h Pagina.h
	g++ -c Diccionario.cpp

Interprete.o: Interprete.cpp Interprete.h Normalizar.h Pagina.h Diccionario.h
	g++ -c Interprete.cpp
	
TablaHash.o: TablaHash.cpp TablaHash.h Normalizar.h Pagina.h Diccionario.h Interprete.h
	g++ -c TablaHash.cpp

main.o: main.cpp Normalizar.h Pagina.h Diccionario.h Interprete.h TablaHash.h
	g++ -c main.cpp

