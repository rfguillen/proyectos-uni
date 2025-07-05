#include "Diccionario.h"
#include <iostream>
#include <string>
#include <list>
using namespace std;

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

DicPaginas::DicPaginas()
{
    lista = list<Pagina>();
}

void DicPaginas::insertar(Pagina nueva)
{
    if (lista.empty())
    {
        lista.push_back(nueva);
        return;
    }

    list<Pagina>::iterator it = lista.begin();
    while (it != lista.end() && it->getURL() < nueva.getURL()) 
    {
        ++it;
    }

    if (it != lista.end() && it->getURL() == nueva.getURL()) 
    {
        it->setTitulo(nueva.getTitulo());
        it->setRelevancia(nueva.getRelevancia());
    }

    else 
    {
        lista.insert(it, nueva);
    }
}

Pagina* DicPaginas::consultar_url(const string& URL)
{
    list<Pagina>::iterator it = lista.begin();
    while (it != lista.end() && it->getURL() != URL)
    {
        ++it;
    }

    if (it != lista.end())
    {
        return &(*it);
    }

    return nullptr;
}

int DicPaginas::numElem() const
{
    return lista.size();
}

