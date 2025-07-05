#ifndef _ARBOLTRIE_H
#define _ARBOLTRIE_H

#include "Pagina.h"
#include "NodoTrie.h"
#include <iostream>
#include <list>

class ArbolTrie
{
    private:
        NodoTrie* raiz;
    public:
        ArbolTrie();
        ~ArbolTrie();
        void insertar(string palabra, Pagina *pag);
        list<Pagina*> * buscar(string palabra);
};


#endif

