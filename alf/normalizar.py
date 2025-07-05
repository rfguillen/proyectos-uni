import fechas
from coordenadas import *
import csv

# Función que normaliza un instante temporal (utilizamos funciones definidas en fechas.py)
def normalizarInstante(instante):
    if not fechas.esFechaCorrecta(instante) or not fechas.esHoraCorrecta(instante):
        return None
    return f"{instante['anyo']:04d}-{instante['mes']:02d}-{instante['dia']:02d} {instante['horas']:02d}:{instante['minutos']:02d}"

# Función que normaliza coordenadas (utilizamos funciones definidas en coordenadas.py)
def normalizarCoordenadas(coordenadas):
    if not sonCoordenadasCorrectas(coordenadas):
        return None
    return convertir_a_gps(coordenadas['latitud'], 'latitud') + ", " + convertir_a_gps(coordenadas['longitud'], 'longitud')


# Función que procesa un archivo y normaliza instantes temporales y coordenadas
def opcion_n(fichero):
    # Abrimos el fichero
    archivo = open(fichero, 'r')
    while True:
        # Leemos una linea del archivo
        linea = archivo.readline()
        if not linea:
            # Si se llega al final del archivo, salimos del bucle
            break
        else:
            # Dividimos la linea en partes usando ';' como separador y eliminamos los espacios en blanco del principio y del final
            partes = linea.strip().split(';')
            # Obtenemos la cadena de las fechas
            parte_fecha = partes[2].strip().strip('"')
            # Intentamos convertir la parte al formato1 de las fechas
            instante = fechas.convertirFormatoFecha(parte_fecha)
            if instante is not None:
                # Si la cadena coincide con alguno de los patrones de las expresiones regulares:
                instante_normalizado = normalizarInstante(instante)
                if instante_normalizado:
                    # Imprimos la fecha normalizada
                    print(instante_normalizado)
            # Mismo proceso que con las fechas, pero para las coordenadas
            parte_coordenadas = partes[3].strip().strip('"')
            coordenadas = convertirFormatoCoordenadas(parte_coordenadas)
            if coordenadas is not None:
                coordenadas_normalizadas = normalizarCoordenadas(coordenadas)
                if coordenadas_normalizadas:
                    print(coordenadas_normalizadas)

    archivo.close()