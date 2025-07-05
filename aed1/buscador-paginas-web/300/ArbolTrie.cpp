#include "NodoTrie.h"
#include "ArbolTrie.h"
#include <iostream>

ArbolTrie::ArbolTrie()
{
    raiz = new NodoTrie();
}

ArbolTrie::~ArbolTrie()
{
    delete raiz;
}

void ArbolTrie::insertar(string palabra, Pagina *pag)
{
    NodoTrie* aux = raiz; // Nodo auxiliar al que se le asigna la raiz
    int i = 0;
    while (i < palabra.length())
    {
        NodoTrie* tmp = aux->consulta(palabra[i]);   // Comprobamos si existe un nodo que tenga el caracter actual de la palabra, si existe,
        if (tmp == nullptr)                          // tmp apunta al nodo hijo del consultado, si no existe a tmp se le asigna nullptr 
        {
            aux->inserta(palabra[i]);                // Como no existe un nodo con el caracter actual, se crea un nodo hijo con el caracter
            tmp = aux->consulta(palabra[i]);         // Se vuelve a consultar para que tmp apunte al nodo recien creado
        }
        aux = tmp;                                   // Actualizamos aux para que apunte al nodo hijo del caracter actual
        i++;
    }
    aux->PonMarca();        // Se pone la marca de fin ($)
    aux->PonEnLista(pag);   // Se agrega la pagina a la lista de paginas
}

list<Pagina*> *ArbolTrie::buscar(string palabra)
{
    NodoTrie* aux = raiz;   // Nodo auxiliar al que se le asigna la raiz
    int i = 0;
    while (i < palabra.length())
    {
        aux = aux->consulta(palabra[i]);    // Comprobamos si existe un nodo que tenga el caracter actual de la palabra, si existe,
        if (aux == nullptr)                 // aux apunta al nodo hijo del consultado, si no existe a aux se le asigna nullptr
        {
            return nullptr;
        }
        i++;
    }
    
    if (aux->HayMarca())                    // Si aux tiene la marca de fin ($), devuelve la lista de paginas asociada al nodo aux
    {
        return aux->getLista();
    }
    return nullptr;
}
