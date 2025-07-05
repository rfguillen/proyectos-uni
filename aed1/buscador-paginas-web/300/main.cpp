#include "Interprete.h"
#include "Diccionario.h"
#include <iostream>
#include <string>
#include <list>
using namespace std;

int main()
{
    string comando;
    DicPaginas diccionario;
    Interprete interprete;
    while (cin >> comando)
    {
        interprete.procesar_comando(comando, diccionario);
    }
    return 0;
}