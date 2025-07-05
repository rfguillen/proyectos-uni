import sys

from telefono import opcion_sphone
from dni import opcion_snif
from fechas import opcion_stime
from normalizar import opcion_n


def opcion_slocation(desde, hasta, fichero):
    return print("Opcion no implementada")


def main():
    if len(sys.argv) < 2:
        print("Uso incorrecto. Sintaxis: python main.py <opcion> [parametros]")
        return

    opcion = sys.argv[1]

    # -n <fichero>
    if opcion == '-n' and len(sys.argv) == 3:
        opcion_n(sys.argv[2])

    # -sphone <telefono> <fichero>
    elif opcion == '-sphone' and len(sys.argv) == 4:
        opcion_sphone(sys.argv[2], sys.argv[3])

    # -snif <NIF> <fichero>
    elif opcion == '-snif' and len(sys.argv) == 4:
        opcion_snif(sys.argv[2], sys.argv[3])

    # -stime <desde> <hasta> <fichero>
    elif opcion == '-stime' and len(sys.argv) == 5:
        opcion_stime(sys.argv[2], sys.argv[3], sys.argv[4])

    # -slocation <desde> <hasta> <fichero>    
    elif opcion == '-slocation' and len(sys.argv) == 5:
        opcion_slocation(sys.argv[2], sys.argv[3], sys.argv[4])

    else:
        print("Opción no válida o parámetros incorrectos.")


if __name__ == "__main__":
    main()

