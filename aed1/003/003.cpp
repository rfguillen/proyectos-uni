#include <iostream>
#include <string>
using namespace std;

int contadorPaginas = 0;

string normalizar(string cadena)
{
    string salida;
    for (unsigned i = 0; i < cadena.length(); i++)
    {
        char primerByte = cadena[i];
        if (primerByte == '\xC3')
        {
            char segundoByte = cadena[i + 1];
            switch(segundoByte)
            {
            case '\xA1': // á
            case '\x81': // Á
                salida.push_back('a');
                break;

            case '\xA9': // é
            case '\x89': // É
                salida.push_back('e');
                break;

            case '\xAD': // í
            case '\x8D': // Í
                salida.push_back('i');
                break;

            case '\xB3': // ó
            case '\x93': // Ó
                salida.push_back('o');
                break;

            case '\xBA': // ú
            case '\xBC': // ü
            case '\x9A': // Ú
            case '\x9C': // Ü
                salida.push_back('u');
                break;

            case '\x91': // Ñ
            case '\xB1': // ñ
                salida.push_back(0xC3);
                salida.push_back(0xB1); // ñ minuscula
                break;

            default:
                // otro símbolo con dos bytes
                salida.push_back(static_cast<char>(primerByte));
                salida.push_back(static_cast<char>(segundoByte));
                break;
            }
            i++;
        }
        else
        {
            salida.push_back(tolower(primerByte)); // Mayúsculas a minúsculas
        }
    }
    return salida;
}

void insertar()
{
    string url, titulo, palabra;
    int relevancia;
    int contadorPalabras = 0;

    cin >> relevancia;
    cin.ignore();
    getline(cin, url);
    getline(cin, titulo);

    while (cin >> palabra && normalizar(palabra) != "findepagina")
    {
        contadorPalabras++;
    }

    contadorPaginas++;
    cout << contadorPaginas << ". " << url << ", " << titulo << ", Rel. " << relevancia << endl;
    cout << contadorPalabras << " palabras\n";
}

void buscar_URL(const string& url)
{
    cout << "u " << url << endl;
    cout << "Total: 0 resultados\n";
}

void buscar_palabra(const string& palabra)
{
    cout << "b " << normalizar(palabra) << endl;
    cout << "Total: 0 resultados\n";
}

void buscar_and()
{
    string palabras;
    getline(cin, palabras);
    cout << "a " << normalizar(palabras) << "\nTotal: 0 resultados\n";
}

void buscar_or()
{
    string palabras;
    getline(cin, palabras);
    cout << "o " << normalizar(palabras) << "\nTotal: 0 resultados\n";
}

void autocompletar()
{
    string palabra;
    getline(cin, palabra);
    cout << "p " << normalizar(palabra) << "\nTotal: 0 resultados\n";
}

void salir()
{
    cout << "Saliendo...\n";
    exit(0);
}

void interprete(const string& comando)
{
    if (comando == "i")
    {
        insertar();
    }
    else if (comando == "u")
    {
        string URL;
        cin >> URL;
        buscar_URL(URL);
    }
    else if (comando == "b")
    {
        string palabra;
        cin >> palabra;
        buscar_palabra(palabra);
    }
    else if (comando == "a")
    {
        cin.ignore();
        buscar_and();
    }
    else if (comando == "o")
    {
        cin.ignore();
        buscar_or();
    }
    else if (comando == "p")
    {
        cin.ignore();
        autocompletar();
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

int main()
{
    string comando;
    while (cin >> comando)
    {
        interprete(comando);
    }
    return 0;
}