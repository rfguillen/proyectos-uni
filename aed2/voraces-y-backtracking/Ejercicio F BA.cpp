#include <iostream>

using namespace std;


#define FILAS 20      // Maximo numero de prendas 1 <= C <= 20
#define COLUMNAS 23   // Maximo numero de modelos + columnas auxiliares 1 <= K <= 20 (+3)

int C;                              // Numero de prendas a comprar
int M;                              // Presupuesto disponible
int Entrada[FILAS][COLUMNAS];       // Matriz para almacenar los datos de entrada y valores auxiliares

// Funcion que avanza al siguiente modelo de prenda y actualiza el gasto acumulado
int generar(int S[], int nivel, int gasto)
{
    S[nivel] = S[nivel] + 1; // Avanzamos al siguiente modelo de la prenda actual
    if (S[nivel] == 1)
    {
        gasto = gasto + Entrada[nivel][1]; // Si es el primer modelo, sumamos su precio
    }
    else
    {
        // Si no es el primer modelo, sumamos el precio del nuevo modelo y restamos el anterior
        gasto = gasto + Entrada[nivel][S[nivel]];
        gasto = gasto - Entrada[nivel][S[nivel]-1];
    }
    return gasto;
}

// Funcion que implementa la poda, usando la ultima columna de la matriz Entrada
bool criterio(int nivel, int gasto)
{
    // Si ya estamos en la ultima prenda o el gasto supera el presupuesto, no seguimos
    if (nivel >= C-1 || gasto > M)
    {
        return false;
    }
    // Si el minimo gasto necesario para las prendas restantes ya supera el presupuesto, no seguimos
    if (Entrada[nivel+1][22] > (M-gasto))
    {
        return false;
    }
    return true;
}

// Funcion que indica si hay mas modelos (hermanos) por recorrer en la prenda actual
bool masHermanos(int S[], int nivel)
{
    return (S[nivel] < Entrada[nivel][0]);
}

// Funcion que permite retroceder al nivel anterior y actualiza el gasto acumulado
int retroceder(int S[], int nivel, int* gasto)
{
    *gasto = *gasto - Entrada[nivel][S[nivel]]; // Restamos el precio del modelo actual
    S[nivel] = 0; // Reiniciamos el modelo seleccionado en este nivel
    nivel--;      // Retrocedemos al nivel anterior
    return nivel;
}

// Funcion que determina si hemos encontrado una solución válida
bool solucion(int nivel, int gasto)
{
    // Es solucion si hemos seleccionado un modelo de cada prenda y no superamos el presupuesto
    if (nivel == C - 1 && gasto <= M)
    {
        return true;
    }
    return false;
}

// Funcion principal de Backtracking para buscar la mejor combinacion de modelos
int backTracking()
{
    int max = -1;                   // Variable para guardar la mejor solución encontrada
    int nivel = 0;                  // Nivel actual (prenda actual)
    int gasto = 0;                  // Gasto acumulado hasta el momento
    int S[FILAS];                   // Array para representar la solucion actual (modelo elegido por prenda)
    for (int i = 0; i < C; i++)
    {     // Inicializamos la solucion
        S[i] = 0;
    }
    // Si el presupuesto es menor que el minimo necesario para la primera prenda, no hay solucion
    if (M < Entrada[0][22])
    {
        return max;
    }
    do
    {
        gasto = generar(S, nivel, gasto); // Avanzamos al siguiente modelo y actualizamos el gasto
        if (solucion(nivel, gasto) && gasto > max)
        {
            if (gasto == M)
            { // Si gastamos exactamente el presupuesto, es la mejor solucion posible
                return gasto;
            }
            max = gasto; // Guardamos la mejor solucion encontrada hasta ahora
        }
        else if (criterio(nivel, gasto))
        {
            nivel = nivel + 1; // Si podemos seguir, avanzamos al siguiente nivel (prenda)
        }
        else
        {
            // Si no podemos seguir, retrocedemos hasta encontrar un nivel con más modelos por probar
            while(!masHermanos(S, nivel) && (nivel > -1))
            {
                nivel = retroceder(S, nivel, &gasto);
            }
        }
    } while(nivel > -1); // Repetimos mientras no hayamos retrocedido más alla del primer nivel
    return max;
}

int main (void) 
{
    int ncasos = 0;                 
    int K = 0;
    cin >> ncasos; // Numero de casos de prueba
    for (int i = 0; i < ncasos; i++)
    {
        cin >> M; // Presupuesto
        cin >> C; // Número de prendas
        int min = 201; // Inicializamos el mínimo a un valor mayor que el maximo posible
        // Inicializamos la matriz de entrada a cero
        for (int i = 0; i < 20; i++)
        {
            for (int j = 0; j < 23; j++)
            {
                Entrada[i][j] = 0;
            }
        }
        // Leemos los precios de los modelos de cada prenda
        for (int i = 0; i < C; i++)
        {
            cin >> K; // Numero de modelos para la prenda i
            Entrada[i][0] = K; // Guardamos el numero de modelos en la columna 0
            for (int j = 1; j <= K; j++)
            {
                cin >> Entrada[i][j]; // Leemos el precio del modelo j
                if (Entrada[i][j] < min)
                {
                    min = Entrada[i][j]; // Calculamos el precio minimo de la prenda
                }
            }
            Entrada[i][21] = min; // Guardamos el precio minimo en la columna 21
            min = 201; // Reiniciamos el minimo para la siguiente prenda
        }
        // Calculamos la suma acumulada de los minimos desde la ultima prenda hasta la actual
        int aux = 0;
        for (int i = C-1; i >= 0; i--)
        {
            aux = aux + Entrada[i][21];
            Entrada[i][22] = aux; // Guardamos la suma acumulada en la columna 22
        }
        // Llamamos al algoritmo de backtracking para encontrar la mejor solución
        int max = backTracking();
        if (max == -1)
        {
            cout << "no solution" << endl; // Si no hay solucion, lo indicamos
        }
        else
        {
            cout << max << endl; // Si hay solucion, mostramos el gasto maximo posible
        }
    }
}