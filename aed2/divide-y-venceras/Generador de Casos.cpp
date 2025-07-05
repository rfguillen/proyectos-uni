#include <iostream>
#include <fstream>
#include <set>
#include <vector>
#include <ctime> // Usa la hora actual como semilla
#include <cstdlib> // Genera numeros aleatorios: rand(), srand()

using namespace std;

// Genera un conjunto S de 5 letras minúsculas distintas
set<char> generarConjuntoS()
{
    set<char> S;
    while (S.size() < 5)
    {
        char c = 'a' + rand() % 26;
        S.insert(c);
    }
    return S;
}

// Guarda el conjunto S en un archivo con nombre según el tipo de caso
void guardarConjuntoS(const set<char>& S, const string& tipo, int n)
{
    ofstream archivo("conjunto_S_" + tipo + "_" + to_string(n) + ".txt");
    for (char c : S)
    {
        archivo << c;
    }
    archivo.close();
}

// Genera una cadena de longitud n según el tipo de caso
string generarCadena(int n, const set<char>& S, const string& tipo)
{
    string resultado;
    vector<char> letras(S.begin(), S.end());

    if (tipo == "peor")
    {
        // Alternar 3 letras distintas para maximizar subcadenas válidas
        for (int i = 0; i < n; i++)
        {
            resultado += letras[i % 3];
        }
    }
    else if (tipo == "mejor")
    {
        // Repetir una sola letra para que no haya subcadenas válidas
        for (int i = 0; i < n; i++)
        {
            resultado += letras[0];
        }
    }
    else
    {
        // Promedio: aleatorio
        for (int i = 0; i < n; i++)
        {
            resultado += letras[rand() % letras.size()];
        }
    }

    return resultado;
}

// Guarda la cadena en un archivo con nombre según el tipo de caso
void guardarCadena(const string& cadena, const string& tipo, int n)
{
    ofstream archivo(tipo + "_" + to_string(n) + ".txt");
    archivo << cadena;
    archivo.close();
}

int main()
{
    srand(time(0)); // Semilla para rand()

    vector<string> tipos = {"mejor", "promedio", "peor"};

    // Longitudes: 10^2, 10^3, ..., 10^6
    for (int exp = 2; exp <= 6; exp++)
    {
        int n = 1;
        for (int i = 0; i < exp; i++) n *= 10;

        for (const string& tipo : tipos)
        {
            cout << "Generando caso " << tipo << " para n = " << n << "..." << endl;

            set<char> S = generarConjuntoS();
            guardarConjuntoS(S, tipo, n);

            string cadena = generarCadena(n, S, tipo);
            guardarCadena(cadena, tipo, n);

            cout << "Archivos generados: " << tipo << "_" << n << ".txt y conjunto_S_" << tipo << "_" << n << ".txt" << endl;
            cout << "-----------------------------" << endl;
        }
    }

    return 0;
}
