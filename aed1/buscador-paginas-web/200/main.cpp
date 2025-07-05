#include "Normalizar.h"
#include "Interprete.h"
#include "Diccionario.h"
#include <iostream>
#include <string>
#include <list>
using namespace std;

int main()
{
    string comando;
    Interprete interprete;
    while (cin >> comando)
    {
        interprete.procesar_comando(comando);
    }
    return 0;
}


