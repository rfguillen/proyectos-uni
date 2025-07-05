#include <stdlib.h>  // Funcion exit
#include <string.h>  // Funcion memset
#include <iostream>  // Variables cin y cout
#include <queue>
#include <list>
using namespace std;

#define MAX_NODOS 20000

//////////////////////////////////////////////////////////////
////////////        VARIABLES GLOBALES        ////////////////
//////////////////////////////////////////////////////////////

int nnodos;                   // Numero de nodos del grafo
bool visitado[MAX_NODOS];     // Marcas de nodos visitados
list<int> lista[MAX_NODOS]; // Lista de adyacencia
queue<int> C; // Cola

//////////////////////////////////////////////////////////////
////////////     FUNCIONES DEL PROGRAMA       ////////////////
//////////////////////////////////////////////////////////////

void leeGrafo (void)
// Procedimiento para leer un grafo de la entrada
{
  cin >> nnodos;
  if (nnodos < 0 || nnodos > MAX_NODOS) 
  {
    cerr << "Numero de nodos (" << nnodos << ") no valido\n";
    exit(0);
  }
  for (int i = 0; i < nnodos; i++)
  {
    lista[i].clear();
  }
  char c1;
  int aux = 0;
    for (int i = 0; i < nnodos; i++) 
    {
        cin >> aux;
        int tmp = 0;
        lista[i].push_back(aux-1);
        c1 = cin.get();
        tmp++;
        while(c1 == ' ' && tmp <= 10)
        {
            cin >> aux;
            lista[i].push_back(aux - 1);
            c1 = cin.get();
            tmp++;
        }
    }
}

bool bp(int v)
// Procedimiento recursivo de la busqueda en profuncidad
{
    visitado[v] = true;
    C.push(v);

    if(v == nnodos-1)
    {
        return true;
    }
    
    for (unsigned i = 0; i < lista[v].size(); i++)
    {
        int vecino = lista[v].front();
        lista[v].pop_front();
        lista[v].push_back(vecino);
        
        if(!visitado[vecino])
        {
            if(bp(vecino))
            {
                return true;
            }
            C.push(v);
        }
    }
    return false;
}

void imprimir()
{
    cout << C.size() << endl;
    while(!C.empty())
    {
        cout << C.front() + 1 << endl;
        C.pop();
    }
}

void vaciarC()
{
    while(!C.empty())
    {
        C.pop();
    }
}

//////////////////////////////////////////////////////////////
////////////        PROGRAMA PRINCIPAL        ////////////////
//////////////////////////////////////////////////////////////

int main (void)
{
  int ncasos;
  cin >> ncasos;
  for (int i = 0; i < ncasos; i++) 
  {
    cout << "Caso " << i + 1 << endl;
    memset(visitado, 0, sizeof(visitado));
    leeGrafo();
    if(!bp(0))
    {
        cout << "INFINITO" << endl;
        vaciarC();
    }
    else
    {
        imprimir();
    }
  }
}