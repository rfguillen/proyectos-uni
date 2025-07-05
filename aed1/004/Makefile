a.out: Normalizar.o Diccionario.o Interprete.o main.o
	g++ Normalizar.o Diccionario.o Interprete.o main.o

Normalizar.o: Normalizar.cpp Normalizar.h
	g++ -c Normalizar.cpp

Diccionario.o: Diccionario.cpp Diccionario.h Normalizar.h
	g++ -c Diccionario.cpp

Interprete.o: Interprete.cpp Interprete.h Normalizar.h Diccionario.h
	g++ -c Interprete.cpp

main.o: main.cpp Normalizar.h Diccionario.h Interprete.h
	g++ -c main.cpp
