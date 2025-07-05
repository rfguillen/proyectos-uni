a.out: Normalizar.o Pagina.o TablaHash.o NodoTrie.o ArbolTrie.o Diccionario.o Interprete.o main.o
	g++ Normalizar.o Pagina.o TablaHash.o NodoTrie.o ArbolTrie.o Diccionario.o Interprete.o main.o

Normalizar.o: Normalizar.cpp Normalizar.h
	g++ -c Normalizar.cpp

Pagina.o: Pagina.cpp Pagina.h Normalizar.h
	g++ -c Pagina.cpp

TablaHash.o: TablaHash.cpp TablaHash.h Normalizar.h Pagina.h
	g++ -c TablaHash.cpp

NodoTrie.o: NodoTrie.cpp NodoTrie.h Normalizar.h Pagina.h TablaHash.h
	g++ -c NodoTrie.cpp

ArbolTrie.o: ArbolTrie.cpp ArbolTrie.h Normalizar.h Pagina.h TablaHash.h NodoTrie.h
	g++ -c ArbolTrie.cpp

Diccionario.o: Diccionario.cpp Diccionario.h Normalizar.h Pagina.h TablaHash.h NodoTrie.h ArbolTrie.h
	g++ -c Diccionario.cpp

Interprete.o: Interprete.cpp Interprete.h Normalizar.h Pagina.h TablaHash.h NodoTrie.h ArbolTrie.h Diccionario.h
	g++ -c Interprete.cpp

main.o: main.cpp Normalizar.h Pagina.h TablaHash.h NodoTrie.h ArbolTrie.h Diccionario.h Interprete.h 
	g++ -c main.cpp

