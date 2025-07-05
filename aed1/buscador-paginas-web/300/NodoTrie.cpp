#include "NodoTrie.h"

NodoTrie::NodoTrie()
{
    car = ' ';
    sig = nullptr;
    hijo = nullptr;
    lista = new list<Pagina*>;
}

NodoTrie::NodoTrie(char letra, NodoTrie* siguiente, NodoTrie* ptr)
{
    car = letra;
    sig = siguiente;
    hijo = ptr;
    lista = new list<Pagina*>;
}

NodoTrie::~NodoTrie()
{
    delete sig;
    delete hijo;
    delete lista;
}

NodoTrie* NodoTrie::consulta(char letra)
{
    NodoTrie *tmp = sig; //Declaramos un puntero temporal que apunta al nodo siguiente
    while (tmp != nullptr && tmp->car < letra)
    {
        tmp = tmp->sig; //Avanzamos al siguiente nodo hermano
    }

    if (tmp != nullptr && tmp->car == letra)
    {
        return tmp->hijo; //Si encontramos el nodo, devolvemos el puntero al hijo
    }

    return nullptr;
}

void NodoTrie::inserta(char l)
{
    NodoTrie* tmp = this; //Declaramos un puntero temporal que apunta al nodo actual
    while (tmp->sig != nullptr && tmp->sig->car < l)
    {
        tmp = tmp->sig; //Avanzamos al siguiente nodo hermano
    }

    if (tmp->sig == nullptr || tmp->sig->car != l)
    {
        tmp->sig = new NodoTrie(l, tmp->sig, new NodoTrie()); //Si no encontramos el nodo, creamos un nuevo nodo hermano con el caracter l y un nuevo nodo hijo
    }
}

bool NodoTrie::HayMarca()
{
    return car == '$';
}

void NodoTrie::PonMarca()
{
    car = '$';
}

void NodoTrie::QuitaMarca()
{
    car = ' ';
}

void NodoTrie::PonEnLista(Pagina* pag)
{
    list<Pagina*>::iterator it = lista->begin(); //Inicializamos un iterador que apunta al inicio de la lista
    //Mientras no lleguemos al final de la lista y la relevancia de la pagina a la que apunta el iterador sea mayor a la relevancia de la página pasada como parametro avanzamos en la lista
    while (it != lista->end() && (*it)->getRelevancia() > pag->getRelevancia()) 
    {           
        ++it;
    }
    //Ahora mientras la relevancia sea igual, no lleguemos al final de la lista y la URL de la página a la que apunta el iterador sea menor a la URL de la página pasada como parametro avanzamos en la lista 
    while(it != lista->end() && (*it)->getRelevancia() == pag->getRelevancia() && (*it)->getURL() < pag->getURL())
    {
        ++it;
    }
    //Si llegamos al final de la lista o la URL de la página a la que apunta el iterador es diferente a la URL de la página pasada como parametro insertamos la página en la posicion del iterador
    if (it == lista->end() || (*it)->getURL() != pag->getURL())
    {
        lista->insert(it, pag);
    }
}

list<Pagina*> *NodoTrie::getLista()
{
    return lista;
}
