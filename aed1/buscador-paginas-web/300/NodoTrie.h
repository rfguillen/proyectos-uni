#ifndef _NODOTRIE_H
#define _NODOTRIE_H

#include "Pagina.h"
#include <iostream>
#include <list>
using namespace std;

class NodoTrie
{
    private:
        char car;
        NodoTrie *sig;
        NodoTrie *hijo;
        list<Pagina*> *lista;

    public:
        NodoTrie();
        NodoTrie(char letra, NodoTrie* siguiente, NodoTrie* hijo);
        ~NodoTrie();
        NodoTrie* consulta(char letra);
        void inserta(char l);
        bool HayMarca();
        void PonMarca();
        void QuitaMarca();
        void PonEnLista(Pagina* pag);
        list<Pagina*> *getLista();
};


#endif
