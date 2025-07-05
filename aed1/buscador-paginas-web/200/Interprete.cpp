#include "Interprete.h"
#include "Normalizar.h"
#include "Diccionario.h"
#include <iostream>
#include <string>
using namespace std;

DicPaginas diccionario = DicPaginas();

void Interprete::procesar_comando(const string& comando)
{
    if (comando == "i")
    {
        insertar(comando);
    }

    else if (comando == "u")
    {
        buscar_URL(comando);
    }

    else if (comando == "b")
    {
        buscar_palabra(comando);
    }

    else if (comando == "a")
    {
        cin.ignore();
        buscar_and(comando);
    }

    else if (comando == "o")
    {
        cin.ignore();
        buscar_or(comando);
    }

    else if (comando == "p")
    {
        cin.ignore();
        autocompletar(comando);
    }

    else if (comando == "s")
    {
        salir();
    }

    else
    {
        cout << "Comando no reconocido.\n";
    }
}

void Interprete::insertar(string palabra)
{
    Pagina nueva;
    nueva.leer();
    int contadorPalabras = 0;

    while (cin >> palabra && normalizar(palabra) != "findepagina") 
    {
        contadorPalabras++;
    }

    diccionario.insertar(nueva);
    cout << diccionario.numElem() << ". ";
    nueva.escribir();
    cout << contadorPalabras << " palabras\n";
}

void Interprete::buscar_URL(string URL)
{
    cin >> URL;
    cout << "u " << URL << endl;
    Pagina* pagina = diccionario.consultar_url(URL);
    if (pagina != nullptr)
    {
        cout << "1. ";
        pagina->escribir();
        cout << "Total: 1 resultados\n"; 
    } 
    else 
    {
        cout << "Total: 0 resultados\n";
    }
}

void Interprete::buscar_palabra(string palabra)
{
    cin >> palabra;

    cout << "b " << normalizar(palabra) << endl;
    cout << "Total: 0 resultados\n";
}

void Interprete::buscar_and(string palabra)
{
    getline(cin, palabra);
    cout << "a " << normalizar(palabra) << "\nTotal: 0 resultados\n";
}

void Interprete::buscar_or(string palabra)
{
    getline(cin, palabra);
    cout << "o " << normalizar(palabra) << "\nTotal: 0 resultados\n";
}

void Interprete::autocompletar(string prefijo)
{
    getline(cin, prefijo);
    cout << "p " << normalizar(prefijo) << "\nTotal: 0 resultados\n";
}

void Interprete::salir()
{
    cout << "Saliendo...\n";
    exit(0);
}


