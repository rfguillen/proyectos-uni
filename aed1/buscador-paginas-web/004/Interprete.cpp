#include "Interprete.h"
#include "Normalizar.h"
#include "Diccionario.h"
#include <iostream>
#include <string>
using namespace std;

void Interprete::procesar_comando(const string& comando, DicPaginas& diccionario)
{
    if (comando == "i")
    {
        insertar(diccionario);
    }

    else if (comando == "u")
    {
        buscar_URL(diccionario);
    }

    else if (comando == "b")
    {
        buscar_palabra(diccionario);
    }

    else if (comando == "a")
    {
        cin.ignore();
        buscar_and(diccionario);
    }

    else if (comando == "o")
    {
        cin.ignore();
        buscar_or(diccionario);
    }

    else if (comando == "p")
    {
        cin.ignore();
        autocompletar(diccionario);
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

void Interprete::insertar(DicPaginas& diccionario)
{
    Pagina nueva;
    nueva.leer();
    string palabra;
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

void Interprete::buscar_URL(DicPaginas& diccionario)
{
    string URL;
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

void Interprete::buscar_palabra(DicPaginas& diccionario)
{
    string palabra;
    cin >> palabra;

    cout << "b " << normalizar(palabra) << endl;
    cout << "Total: 0 resultados\n";
}

void Interprete::buscar_and(DicPaginas& diccionario)
{
    string palabras;
    getline(cin, palabras);
    cout << "a " << normalizar(palabras) << "\nTotal: 0 resultados\n";
}

void Interprete::buscar_or(DicPaginas& diccionario)
{
    string palabras;
    getline(cin, palabras);
    cout << "o " << normalizar(palabras) << "\nTotal: 0 resultados\n";
}

void Interprete::autocompletar(DicPaginas& diccionario)
{
    string palabra;
    getline(cin, palabra);
    cout << "p " << normalizar(palabra) << "\nTotal: 0 resultados\n";
}

void Interprete::salir()
{
    cout << "Saliendo...\n";
    exit(0);
}

