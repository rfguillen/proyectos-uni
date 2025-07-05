#ifndef _PAGINA_H
#define _PAGINA_H

#include <iostream>
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

#endif

