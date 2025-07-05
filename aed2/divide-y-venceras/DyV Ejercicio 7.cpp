#include <iostream>
#include <set>
#include <vector>

using namespace std;

// Verifica si una subcadena de longitud 3 que comienza en 'inicio' es válida
bool esValida(const string& A, const set<char>& S, int inicio)
{
    // Verificar que hay espacio para una subcadena de longitud 3
    if (inicio + 2 >= A.size())
    {
        return false;
    }

    // Obtener los tres caracteres consecutivos
    char c1 = A[inicio];
    char c2 = A[inicio + 1];
    char c3 = A[inicio + 2];

    // Verificar que son diferentes entre sí y pertenecen al conjunto S
    return c1 != c2 && c1 != c3 && c2 != c3 && S.count(c1) && S.count(c2) && S.count(c3);
}

// Resuelve directamente el problema para segmentos pequeños (<= 4 caracteres)
vector<int> solucionDirecta(const string& A, const set<char>& S, int inicio, int fin)
{
    vector<int> posiciones;
    // Revisar cada posición posible para una subcadena de longitud 3
    for (int i = inicio; i <= fin - 2; i++)
    {
        if (esValida(A, S, i)) posiciones.push_back(i + 1); // Se suma 1 para ajustar
    }
    return posiciones;
}

// Combina las soluciones de dos subsegmentos y verifica las subcadenas que cruzan la frontera
vector<int> combinar(const string& A, const set<char>& S, vector<int> izq, vector<int> der, int mitad)
{
    // Set temporal para eliminar duplicados
    set<int> posicionesUnicas;

    // Agregar todas las posiciones del segmento izquierdo
    for (int pos : izq)
    {
        posicionesUnicas.insert(pos);
    }

    // Agregar todas las posiciones del segmento derecho
    for (int pos : der)
    {
        posicionesUnicas.insert(pos);
    }

    // Verificar las subcadenas que podrían cruzar la frontera entre segmentos
    for (int i = max(0, mitad - 2); i <= mitad; i++)
    {
        if (esValida(A, S, i))
        {
            posicionesUnicas.insert(i + 1); // Ajuste de posiciones
        }
    }

    // Convertir el set a vector para el return
    return vector<int>(posicionesUnicas.begin(), posicionesUnicas.end());
}

// Implementación principal del algoritmo
vector<int> divideYVenceras(const string& A, const set<char>& S, int inicio, int fin)
{
    // Caso base: segmento pequeño (<= 4 caracteres)
    if (fin - inicio + 1 <= 4) return solucionDirecta(A, S, inicio, fin);

    // Dividir el problema en dos partes
    int mitad = (inicio + fin) / 2;
    // Resolver recursivamente cada mitad
    vector<int> izq = divideYVenceras(A, S, inicio, mitad);
    vector<int> der = divideYVenceras(A, S, mitad + 1, fin);

    // Combinar las soluciones y manejar el caso de la frontera
    return combinar(A, S, izq, der, mitad);
}

int main()
{
    string A;
    set<char> S;

    // Lectura de la cadena de entrada
    cout << "Ingrese la cadena A: " << endl;
    cin >> A;

    // Lectura de los 5 caracteres válidos
    cout << "Ingrese los 5 caracteres distintos del conjunto S: (Ejemplo: abcde)" << endl;
    for (int i = 0; i < 5; i++)
    {
        char c;
        cin >> c;
        S.insert(c);
    }

    // Ejecutar el algoritmo y obtener resultados
    vector<int> resultado = divideYVenceras(A, S, 0, A.size() - 1);

    // Mostrar resultados
    cout << "Número de subcadenas encontradas: " << resultado.size() << endl;
    cout << "Posiciones: ";
    for (int pos : resultado) cout << pos << " ";
    cout << endl;

    return 0;
}
