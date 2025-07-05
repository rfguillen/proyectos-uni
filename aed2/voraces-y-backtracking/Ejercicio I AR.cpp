#include <iostream>
#include <vector>
using namespace std;

// Número de alumnos
int N;

// Vector para guardar las parejas que se van formando en la solución
vector<int> parejas;

// Función que busca entre todos los alumnos libres la pareja (i, j) que maximiza el beneficio.
pair<int, int> seleccionar(const vector<vector<int>>& amistad, const vector<vector<int>>& trabajo, const vector<bool>& libres) 
{
    int beneficioMax = -1; // Beneficio máximo encontrado hasta el momento
    int mejorI = -1;        // Índice del primer alumno de la mejor pareja
    int mejorJ = -1;        // Índice del segundo alumno de la mejor pareja
    for (int i = 0; i < N; ++i) 
    {
        if (!libres[i]) continue; // Saltamos si el alumno i ya está emparejado
        for (int j = i + 1; j < N; ++j) 
        {
            if (!libres[j]) continue; // Saltamos si el alumno j ya está emparejado
            // Calculamos el beneficio de emparejar a i y j
            int beneficio = (amistad[i][j] + amistad[j][i]) * (trabajo[i][j] + trabajo[j][i]);
            // Si es el mayor beneficio encontrado, actualizamos la mejor pareja
            if (beneficio > beneficioMax) 
            {
                beneficioMax = beneficio;
                mejorI = i;
                mejorJ = j;
            }
        }
    }
    return {mejorI, mejorJ};
}

// Función que añade la pareja (i, j) al vector de solución y marca a ambos alumnos como no libres.
void insertar(int i, int j, vector<bool>& libres) 
{
    parejas.push_back(i);
    parejas.push_back(j);
    libres[i] = false;
    libres[j] = false;
}

// Función que comprueba si se han formado todas las parejas posibles
bool solucion(int parejasFormadas) 
{
    return parejasFormadas >= N / 2;
}

// Función que implementa el algoritmo voraz para formar parejas maximizando el beneficio total.
int voraz(const vector<vector<int>>& amistad, const vector<vector<int>>& trabajo, vector<bool>& libres) 
{
    int valor = 0;            // Beneficio total acumulado
    int parejasFormadas = 0;  // Número de parejas formadas hasta el momento
    // Mientras no se hayan formado todas las parejas posibles
    while (!solucion(parejasFormadas)) 
    {
        // Seleccionamos la mejor pareja disponible
        pair<int, int> mejor_pareja = seleccionar(amistad, trabajo, libres);
        int i = mejor_pareja.first;
        int j = mejor_pareja.second;
        if (i == -1 || j == -1) break; // No quedan parejas posibles
        // Calculamos el beneficio de la pareja seleccionada
        int beneficio = (amistad[i][j] + amistad[j][i]) * (trabajo[i][j] + trabajo[j][i]);
        // Insertamos la pareja en la solución y marcamos como no libres
        insertar(i, j, libres);
        valor += beneficio;   // Sumamos el beneficio al total
        parejasFormadas++;    // Incrementamos el número de parejas formadas
    }
    // Si el número de alumnos es impar, dejamos al alumno restante solo
    if (N % 2 == 1)
    {
        for (int k = 0; k < N; ++k) 
        {
            if (libres[k]) 
            {
                parejas.push_back(k);
                break;
            }
        }
    }
    return valor;
}

int main() 
{
    int num_casos = 0; // Número de casos de prueba
    cin >> num_casos;
    for (int caso = 0; caso < num_casos; ++caso) 
    {
        cin >> N; // Leemos el número de alumnos para este caso
        // Matrices de amistad y trabajo, inicializadas a 0
        vector<vector<int>> amistad(N, vector<int>(N, 0));
        vector<vector<int>> trabajo(N, vector<int>(N, 0));
        parejas.clear(); // Limpiamos el vector de parejas para el nuevo caso
        vector<bool> libres(N, true); // Todos los alumnos están inicialmente libres

        // Leemos la matriz de amistad (solo para i != j)
        for (int i = 0; i < N; ++i) 
        {
            for (int j = 0; j < N; ++j) 
            {
                if (i != j) 
                {
                    cin >> amistad[i][j];
                }
            }
        }
        // Leemos la matriz de trabajo (solo para i != j)
        for (int i = 0; i < N; ++i) 
        {
            for (int j = 0; j < N; ++j) 
            {
                if (i != j) 
                {
                    cin >> trabajo[i][j];
                }
            }
        }

        // Ejecutamos el algoritmo voraz y mostramos el resultado
        int valor = voraz(amistad, trabajo, libres);
        cout << valor << endl;
        for (size_t indice = 0; indice < parejas.size(); ++indice) 
        {
            cout << parejas[indice] << " ";
        }
        cout << endl;
    }
}