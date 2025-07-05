#include "Diccionario.h"
#include "TablaHash.h"
#include <iostream>
using namespace std;

int TablaHash::funcion_hash(const string& url)
{
    unsigned long hk = 0; //(valor hash) Asigna la posicion en la tabla en la que se almacena o busca el elemento
    int primo = 31; //(número primo) Se utiliza para calcular el valor hash
    int desplazamiento = 7; //(número entero) Se suma a cada carácter de la URL para calcular el valor hash

    for (size_t i = 0; i < url.size(); ++i)
    {
        hk = hk * primo + (url[i] + desplazamiento);
    }

    return hk % B; // Devuelve la posicion en la tabla hash
}

TablaHash::TablaHash()
{
    T = new list<Pagina*>[B]; //Declara una lista de punteros a Pagina de tamaño B
    nElem = 0;
}

TablaHash::~TablaHash()
{
    delete[] T;
}

Pagina* TablaHash::insertar(Pagina* nueva)
{
    int posicion = funcion_hash(nueva->getURL()); // Calcula la posicion en la tabla hash con la URL de la pagina

    list<Pagina*>::iterator it = T[posicion].begin(); // Inicializa el it en el indice calculado
    while (it != T[posicion].end() && (*it)->getURL() < nueva->getURL()) // Recorre la lista de paginas del indice
    {
        ++it;
    }

    if (it == T[posicion].end() || (*it)->getURL() != nueva->getURL()) //Si no encuentra la pagina en la lista, la inserta
    {
        T[posicion].insert(it, nueva);
        nElem++;
        return nueva;
    }

    else 
    {
        (*it)->setTitulo(nueva->getTitulo()); //Si encuentra la pagina, actualiza el titulo
        delete nueva;
        return *it;
    }
}

Pagina* TablaHash::consultar(const string& url)
{
    int posicion = funcion_hash(url); // Calcula la posicion en la tabla hash con la URL de la pagina
    list<Pagina*>::iterator it = T[posicion].begin(); // Inicializa el it en el indice calculado
    while (it != T[posicion].end() && (*it)->getURL() < url) // Recorre la lista de paginas del indice
    {
        ++it;
    }

    if (it == T[posicion].end() || (*it)->getURL() != url) //Si no encuentra la pagina en la lista, devuelve nullptr
    {
        return nullptr;
    }

    return *it;
}

int TablaHash::numElem()
{
    return nElem;
}

