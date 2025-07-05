#include "Diccionario.h"
#include "TablaHash.h"
#include "ArbolTrie.h"
#include <iostream>
#include <string>
#include <list>
using namespace std;

Pagina* DicPaginas::insertar(Pagina* nueva)
{
    return T.insertar(nueva);
}

Pagina* DicPaginas::consultar_url(const string& URL)
{
    return T.consultar(URL);
}

int DicPaginas::numElem()
{
    return T.numElem();
}

void DicPaginas::insertar(string palabra, Pagina *pag)
{
    Arbol.insertar(palabra, pag);
}

list<Pagina *>* DicPaginas::consultar(string palabra)
{
    return Arbol.buscar(palabra);
}

