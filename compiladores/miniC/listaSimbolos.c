#include "listaSimbolos.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <assert.h>

//extern Lista l; // Declarada en el .y

struct PosicionListaRep {
  Simbolo dato;
  struct PosicionListaRep *sig;
};

struct ListaRep {
  PosicionLista cabecera;
  PosicionLista ultimo;
  int n;
};

typedef struct PosicionListaRep *NodoPtr;

Lista creaLS() {
  Lista nueva = malloc(sizeof(struct ListaRep));
  nueva->cabecera = malloc(sizeof(struct PosicionListaRep));
  nueva->cabecera->sig = NULL;
  nueva->ultimo = nueva->cabecera;
  nueva->n = 0;
  return nueva;
}

void liberaLS(Lista lista) {
  while (lista->cabecera != NULL) {
    NodoPtr borrar = lista->cabecera;
    lista->cabecera = borrar->sig;
    free(borrar);
  }
  free(lista);
}

void insertaLS(Lista lista, PosicionLista p, Simbolo s) {
  NodoPtr nuevo = malloc(sizeof(struct PosicionListaRep));
  nuevo->dato = s;
  nuevo->sig = p->sig;
  p->sig = nuevo;
  if (lista->ultimo == p) {
    lista->ultimo = nuevo;
  }
  (lista->n)++;
}

void suprimeLS(Lista lista, PosicionLista p) {
  assert(p != lista->ultimo);
  NodoPtr borrar = p->sig;
  p->sig = borrar->sig;
  if (lista->ultimo == borrar) {
    lista->ultimo = p;
  }
  free(borrar);
  (lista->n)--;
}

Simbolo recuperaLS(Lista lista, PosicionLista p) {
  assert(p != lista->ultimo);
  return p->sig->dato;
}



/*PosicionLista buscaLS(Lista lista, char *nombre) {
  NodoPtr aux = lista->cabecera;
  while (aux->sig != NULL) {
    // Separamos las 2 comprobaciones para que no de violacion de core
    if (strcmp(aux->sig->dato.nombre, nombre) == 0) {
      return aux;
    }
    aux = aux->sig;
  }
  return NULL;
}*/

PosicionLista buscaLS(Lista lista, char *nombre) {
  NodoPtr aux = lista->cabecera;
  while(aux->sig != NULL && strcmp(aux->sig->dato.nombre, nombre) != 0) {
    aux = aux->sig;
  }
  return aux;
}

void asignaLS(Lista lista, PosicionLista p, Simbolo s) {
  assert(p != lista->ultimo);
  p->sig->dato = s;
}

int longitudLS(Lista lista) {
  return lista->n;
}

PosicionLista inicioLS(Lista lista) {
  return lista->cabecera;
}

PosicionLista finalLS(Lista lista) {
  return lista->ultimo;
}

PosicionLista siguienteLS(Lista lista, PosicionLista p) {
  assert(p != lista->ultimo);
  return p->sig;
}




int perteneceTablaS(Lista l, char *nombre) {

  PosicionLista p = buscaLS(l, nombre);
  if (p != finalLS(l)){
    return 1;
  }
  else{
    return 0;
  }
  
}


void insertaTablaIdentificador(Lista l, char *nombre, Tipo tipo) {
  Simbolo s;
  s.nombre = nombre;
  s.tipo = tipo;
  s.valor = 0;
  insertaLS(l, finalLS(l), s);
}



void insertaTablaString(Lista l, char *nombre, Tipo tipo, int valor) {
  Simbolo s;
  s.nombre = strdup(nombre);
  s.tipo = tipo;
  s.valor = valor;
  insertaLS(l, finalLS(l), s);
}

int esConstante(Lista l, char *nombre) {
  PosicionLista pos = buscaLS(l, nombre);
  if (pos != NULL) {
      Simbolo s = recuperaLS(l, pos);
      if ( s.tipo == CONSTANTE){
        return 1;
      }
  }
  return 0;
}

/*
Usado primero para comprobar funcionamiento

void imprimirTablaLS(Lista l) {
  PosicionLista p = inicioLS(l);
  while (p != finalLS(l)) {
      Simbolo s = recuperaLS(l, p);
      printf("Nombre: %s, Tipo: %d, Valor: %d\n", s.nombre, s.tipo, s.valor);
      p = siguienteLS(l, p);
  }
}
*/
void imprimirTablaLS(Lista l){
  printf("##################\n# Seccion de datos\n .data\n");
  PosicionLista p = inicioLS(l);
  while(p!= finalLS(l)){
    Simbolo aux = recuperaLS(l, p);
    if(aux.tipo==CADNA){
      printf("$str%d: .asciiz %s\n", aux.valor, aux.nombre);
    } else{
      printf("_%s: .word %d\n", aux.nombre, aux.valor);
    }
    p = siguienteLS(l,p);
  }
}

/*
void liberaTS() {
  liberaLS(l);
}
*/

