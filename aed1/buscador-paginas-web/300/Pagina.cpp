#include "Pagina.h"
#include <iostream>

void Pagina::leer()
{
    cin >> relevancia;
    cin.ignore();
    getline(cin, URL);
    getline(cin, titulo);
}

void Pagina::escribir() const
{
    cout << URL << ", " << titulo << ", Rel. " << relevancia << endl;
}

string Pagina::getURL() const
{
    return URL;
}

int Pagina::getRelevancia() const
{
    return relevancia;
}

string Pagina::getTitulo() const
{
    return titulo;
}

void Pagina::setRelevancia(int nuevaRelevancia)
{
    relevancia = nuevaRelevancia;
}

void Pagina::setTitulo(const string& nuevoTitulo)
{
    titulo = nuevoTitulo;
}

