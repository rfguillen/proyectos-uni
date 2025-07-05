#ifndef _INTERPRETE
#define _INTERPRETE

#include "Diccionario.h"
#include <iostream>
#include <string>
using namespace std;

class Interprete
{
    public:
        void procesar_comando(const string& comando);
        
    private:
    /* Métodos declarados privados porque no deberían de ser accesibles desde fuera de la clase, 
    ya que solo son utilizados internamente por procesar_comando */
        void insertar(string palabra);

        void buscar_URL(string URL);
        
        void buscar_palabra(string palabra);

        void buscar_and(string palabra);

        void buscar_or(string palabra);

        void autocompletar(string prefijo);

        void salir();

};

#endif

