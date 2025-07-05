#ifndef _DICCIONARIO
#define _DICCIONARIO

#include "Pagina.h"
#include "TablaHash.h"
#include "ArbolTrie.h"
#include <iostream>
#include <string>
#include <list>
using namespace std;

class DicPaginas
{
    private:
        TablaHash T;
        ArbolTrie Arbol;

    public:
        Pagina* insertar(Pagina* nueva);
        Pagina* consultar_url(const string& URL);
        int numElem();

        void insertar(string palabra, Pagina *pag);
        list<Pagina*> *consultar(string palabra);
};

#endif

