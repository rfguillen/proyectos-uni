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
    Pagina* nueva = new Pagina(); //Creo una nueva página
    nueva->leer();                //Leemos la informacion página

    Pagina* pagina = diccionario.insertar(nueva); //Puntero a la página que se ha insertado o a la que ya estaba en el diccionario (funcion insertar de la tabla)

    string palabra;
    int contadorPalabras = 0;
    while (cin >> palabra && normalizar(palabra) != "findepagina") 
    {
        diccionario.insertar(normalizar(palabra), pagina); //Insertamos una palabra y la asociamos a la pagina (funcion insertar del arbol)
        contadorPalabras++;
    }

    cout << diccionario.numElem() << ". ";      //Imprimimos el número de elementos en el diccionario
    pagina->escribir();                         //Imprimimos la información de la página
    cout << contadorPalabras << " palabras\n";  //Imprimimos el número de palabras que se han insertado
}

void Interprete::buscar_URL(DicPaginas& diccionario)
{
    string URL;
    cin >> URL;
    cout << "u " << URL << endl;
    Pagina* pagina = diccionario.consultar_url(URL); //Puntera a la página que se ha encontrado o nullptr si no se ha encontrado (funcion consultar_url de la tabla)
    if (pagina == nullptr)
    {
        cout << "Total: 0 resultados\n";
    } 

    else 
    {
        cout << "1. ";
        pagina->escribir();
        cout << "Total: 1 resultados\n"; 
    }
}

void Interprete::buscar_palabra(DicPaginas& diccionario)
{
    string palabra;
    cin >> palabra;

    cout << "b " << normalizar(palabra) << endl;
    
    int contador = 1;
    list<Pagina*> * lista = diccionario.consultar(normalizar(palabra)); //Un puntero a una lista de punteros a páginas que contienen la palabra (funcion consultar del arbol)
    if(lista != nullptr)
    {
        list<Pagina*>::iterator it = lista->begin();
        while(it != lista->end())
        {
            cout << contador << ". ";
            (*it)->escribir();
            contador++;
            it++;
        }
    }
    cout << "Total: " << contador - 1 << " resultados\n";
}

void Interprete::buscar_and(DicPaginas& diccionario)
{
    string palabra;
    getline(cin, palabra);
    cout << "a " << normalizar(palabra) << "\nTotal: 0 resultados\n";
}

void Interprete::buscar_or(DicPaginas& diccionario)
{
    string palabra;
    getline(cin, palabra);
    cout << "o " << normalizar(palabra) << "\nTotal: 0 resultados\n";
}

void Interprete::autocompletar(DicPaginas& diccionario)
{
    string prefijo;
    getline(cin, prefijo);
    cout << "p " << normalizar(prefijo) << "\nTotal: 0 resultados\n";
}

void Interprete::salir()
{
    cout << "Saliendo...\n";
    exit(0);
}
