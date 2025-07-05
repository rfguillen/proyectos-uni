#include "Diccionario.h"
#include "TablaHash.h"
#include <iostream>
#include <string>
#include <list>
using namespace std;

DicPaginas::DicPaginas()
{
    T = new TablaHash();
}

void DicPaginas::insertar(Pagina nueva)
{
    T->insertar(nueva);
}

Pagina* DicPaginas::consultar_url(const string& URL)
{
    return T->consultar(URL);
}

int DicPaginas::numElem() const
{
    return T->numElem();
}


