#ifndef _DICCIONARIO
#define _DICCIONARIO

#include <iostream>
#include <string>
#include <list>
using namespace std;

class Pagina
{
    private:
        int relevancia;
        string URL, titulo;

    public:
        void leer();
        
        void escribir() const;
        // Getters
        string getURL() const;

        string getTitulo() const;

        int getRelevancia() const;
        // Setters
        void setRelevancia(int nuevaRelevancia);

        void setTitulo(const string& Titulo);
};

class DicPaginas
{
    private:
        list<Pagina> lista;

    public:
        DicPaginas();

        void insertar(Pagina nueva);
        
        Pagina* consultar_url(const string& URL);

        int numElem() const;
};

#endif
