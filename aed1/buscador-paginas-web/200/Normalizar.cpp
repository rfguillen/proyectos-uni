#include "Normalizar.h"
#include <iostream>
#include <string>
using namespace std;

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

