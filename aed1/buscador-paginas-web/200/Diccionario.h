#ifndef _DICCIONARIO
#define _DICCIONARIO

#include "Pagina.h"
#include "TablaHash.h"
#include <iostream>
#include <string>
#include <list>
using namespace std;

class DicPaginas
{
    private:
        TablaHash* T;

    public:
        DicPaginas();

        void insertar(Pagina nueva);
        
        Pagina* consultar_url(const string& URL);

        int numElem() const;
};

#endif

