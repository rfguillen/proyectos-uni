#include "Diccionario.h"
#include "TablaHash.h"
#include <iostream>
using namespace std;

int TablaHash::funcion_hash(const string& url)
{
    unsigned long hk = 0;
    int primo = 31;
    int desplazamiento = 7;

    for (size_t i = 0; i < url.size(); ++i)
    {
        hk = hk * primo + (url[i] + desplazamiento);
    }

    return hk % B;
}

TablaHash::TablaHash()
{
    T = new list<Pagina>[B];
    nElem = 0;
}

TablaHash::~TablaHash()
{
    delete[] T;
}

void TablaHash::insertar (Pagina nueva)
{
    int posicion = funcion_hash(nueva.getURL());

    list<Pagina>::iterator it = T[posicion].begin();
    while (it != T[posicion].end() && it->getURL() != nueva.getURL()) 
    {
        ++it;
    }

    if (it != T[posicion].end() && it->getURL() == nueva.getURL()) 
    {
        it->setTitulo(nueva.getTitulo());
        it->setRelevancia(nueva.getRelevancia());
    }

    else 
    {
        T[posicion].push_back(nueva);
        nElem++;
    }
}

Pagina* TablaHash::consultar (string url)
{
    int posicion = funcion_hash(url);
    list<Pagina>::iterator it = T[posicion].begin();
    while (it != T[posicion].end() && it->getURL() != url)
    {
        ++it;
    }

    if (it != T[posicion].end())
    {
        return &(*it);
    }

    return nullptr;
}

int TablaHash::numElem()
{
    return nElem;
}