#ifndef _TABLA_HASH_H
#define _TABLA_HASH_H

#include "Diccionario.h"
#include "Pagina.h"
#include <list>

const int B = 50000;

class TablaHash
{
    private:
        list<Pagina*> *T;
        int nElem;
        int funcion_hash(const string& url);

    public:
        TablaHash();

        ~TablaHash();

        Pagina* insertar(Pagina* nueva);

        Pagina* consultar(const string& url);

        int numElem();
};

#endif


