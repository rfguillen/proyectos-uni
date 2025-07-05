#ifndef _INTERPRETE
#define _INTERPRETE

#include "Diccionario.h"
#include <iostream>
#include <string>
using namespace std;

class Interprete
{
    public:
        void procesar_comando(const string& comando, DicPaginas& diccionario);
        
    private:
    /* Métodos declarados privados porque no deberían de ser accesibles desde fuera de la clase, 
    ya que solo son utilizados internamente por procesar_comando */
        void insertar(DicPaginas& diccionario);

        void buscar_URL(DicPaginas& diccionario);
        
        void buscar_palabra(DicPaginas& diccionario);

        void buscar_and(DicPaginas& diccionario);

        void buscar_or(DicPaginas& diccionario);

        void autocompletar(DicPaginas& diccionario);

        void salir();

};

#endif
