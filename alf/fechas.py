import regex as re
import normalizar
import csv

# Diccionario que asigna a los meses sus números correspondientes
meses = {
    "January": "01", "February": "02", "March": "03", "April": "04",
    "May": "05", "June": "06", "July": "07", "August": "08",
    "September": "09", "October": "10", "November": "11", "December": "12"
}

# Función que determina si un año es bisiesto
def bisiesto(anyo):
    if (anyo % 4 == 0 and anyo % 100 != 0) or (anyo % 400 == 0):
        return True
    else:
        return False

# Función que verifica si una fecha es correcta
def esFechaCorrecta(instante):
    if instante['mes'] < 1 or instante['mes'] > 12:
        return False
    elif instante['mes'] in [1, 3, 5, 7, 8, 10, 12]:
        if instante['dia'] < 1 or instante['dia'] > 31:
            return False
    elif instante['mes'] in [4, 6, 9, 11]:
        if instante['dia'] < 1 or instante['dia'] > 30:
            return False
    elif instante['mes'] == 2:
        if bisiesto(instante['anyo']):
            if instante['dia'] < 1 or instante['dia'] > 29:
                return False
        else:
            if instante['dia'] < 1 or instante['dia'] > 28:
                return False
    return True

# Función que verifica si una hora es correcta
def esHoraCorrecta(instante):
    if instante['horas'] < 0 or instante['horas'] > 23:
        return False
    if instante['minutos'] < 0 or instante['minutos'] > 59:
        return False
    if instante['segundos'] < 0 or instante['segundos'] > 59:
        return False
    return True

# Función que compara dos instantes temporales
def compararInstTemp(instante1, instante2):
    if not esFechaCorrecta(instante1) or not esHoraCorrecta(instante1):
        return "El Primer Instante Temporal introducido es incorrecto."
    elif not esFechaCorrecta(instante2) or not esHoraCorrecta(instante2):
        return "El Segundo Instante Temporal introducido es incorrecto."
    else:
        if instante1['anyo'] > instante2['anyo']:
            return 1  # El segundo instante es más antiguo.
        elif instante1['anyo'] < instante2['anyo']:
            return -1  # El primer instante es más antiguo.
        else:
            if instante1['mes'] > instante2['mes']:
                return 1  # El segundo instante es más antiguo.
            elif instante1['mes'] < instante2['mes']:
                return -1  # El primer instante es más antiguo.
            else:
                if instante1['dia'] > instante2['dia']:
                    return 1  # El segundo instante es más antiguo.
                elif instante1['dia'] < instante2['dia']:
                    return -1  # El primer instante es más antiguo.
                else:
                    if instante1['horas'] > instante2['horas']:
                        return 1  # El segundo instante es más antiguo.
                    elif instante1['horas'] < instante2['horas']:
                        return -1  # El primer instante es más antiguo.
                    else:
                        if instante1['minutos'] > instante2['minutos']:
                            return 1  # El segundo instante es más antiguo.
                        elif instante1['minutos'] < instante2['minutos']:
                            return -1  # El primer instante es más antiguo.
                        else:
                            if instante1['segundos'] > instante2['segundos']:
                                return 1  # El segundo instante es más antiguo.
                            elif instante1['segundos'] < instante2['segundos']:
                                return -1  # El primer instante es más antiguo.
                            else:
                                return 0  # Los instantes son iguales

# Expresión regular para los diferentes formatos de fechas y horas
patrones_fechas = re.compile(
    r'(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2})|'  # Formato 1: YYYY-MM-DD HH:MM
    r'(?i)(January|February|March|April|May|June|July|August|September|October|November|December)\s+(0?[1-9]|[12][0-9]|3[01]),\s+(\d{1,4})\s+(1[0-2]|0?[1-9]):([0-5][0-9])\s+(AM|PM)|'  # Formato 2: Month DD, YYYY HH:MM AM/PM
    r'(\d{2}):(\d{2}):(\d{2}) (\d{2})/(\d{2})/(\d{4})'  # Formato 3: HH:MM:SS DD/MM/YYYY
)

# Función que convierte un patrón de fechas y horas en un diccionario de fechas y horas
def convertirFormatoFecha(instante):
    # Vemos si la cadena del instante coincide con alguno de los patrones según sus expresiones regulares
    formato = patrones_fechas.search(instante)

    # Inicializamos las variables de fechas y horas
    anyo = mes = dia = horas = minutos = segundos = None

    # Si la cadena del instante coincide con alguno de los patrones, entonces comprobamos su formato
    if formato:
        if formato.group(1) and formato.group(2) and formato.group(3) and formato.group(4) and formato.group(5):
            # Es el formato 1: YYYY-MM-DD HH:MM
            anyo = formato.group(1)
            mes = formato.group(2)
            dia = formato.group(3)
            horas = formato.group(4)
            minutos = formato.group(5)
            segundos = '00'
        elif formato.group(6) and formato.group(7) and formato.group(8) and formato.group(9) and formato.group(10) and formato.group(11):
            # Es el formato 2: Month DD, YYYY HH:MM AM/PM
            mes = meses[formato.group(6)]
            dia = formato.group(7)
            anyo = formato.group(8)
            horas = formato.group(9)
            minutos = formato.group(10)
            am_pm = formato.group(11)
            segundos = '00'
            # Lo convertimos a formato 24 horas
            if am_pm.lower() == 'pm' and horas != '12':
                horas = str(int(horas) + 12)
            elif am_pm.lower() == 'am' and horas == '12':
                horas = '00'
        elif formato.group(12) and formato.group(13) and formato.group(14) and formato.group(15) and formato.group(16) and formato.group(17):
            # Es el formato 3: HH:MM:SS DD/MM/YYYY
            horas = formato.group(12)
            minutos = formato.group(13)
            segundos = formato.group(14)
            dia = formato.group(15)
            mes = formato.group(16)
            anyo = formato.group(17)

    if anyo and mes and dia and horas and minutos and segundos is not None:
        instante_formateado = {
            'anyo': int(anyo),
            'mes': int(mes),
            'dia': int(dia),
            'horas': int(horas),
            'minutos': int(minutos),
            'segundos': int(segundos)
        }
        if esFechaCorrecta(instante_formateado) and esHoraCorrecta(instante_formateado):
            return instante_formateado
    return None

# Definimos qué tiene que hacer la opción stime: procesa un archivo y filtra las fechas dentro del rango especificado
def opcion_stime(desde, hasta, fichero):
    # Convertimos las fechas de los parámetros 'desde' y 'hasta' al diccionario de fechas y horas
    instante_desde = convertirFormatoFecha(desde)
    instante_hasta = convertirFormatoFecha(hasta)
    
    # Verificamos si las fechas dadas son correctas
    if instante_desde is None or instante_hasta is None:
        print("Error: Formato de fecha incorrecto en los parámetros 'desde' o 'hasta'.")
        return
    
    # Abrimos el archivo para lectura
    archivo = open(fichero, 'r')
    while True:
        # Leemos una línea del archivo
        linea = archivo.readline()
        if not linea:
            # Si se llega al final del archivo, salimos del bucle
            break
        else:
            # Dividimos la línea en partes usando ';' como separador
            partes = linea.split(';')
            # Obtenemos la cadena de la fecha
            fecha = partes[2].strip().strip('"')
            # Convertimos la cadena de fecha al diccionario de fechas y horas
            evento = convertirFormatoFecha(fecha)
            if evento is not None:
                # Verificamos si el evento está dentro del rango dado
                if (compararInstTemp(instante_desde, evento) <= 0) and (compararInstTemp(evento, instante_hasta) <= 0):
                    # Normalizamos el instante
                    resultado = normalizar.normalizarInstante(evento)
                    if resultado:
                        # Formateamos el evento en el formato YYYY-MM-DD HH:MM
                        evento_formateado = f"{evento['anyo']}-{evento['mes']:02d}-{evento['dia']:02d} {evento['horas']:02d}:{evento['minutos']:02d}"
                        # Imprimimos el evento formateado
                        print(evento_formateado)
    # Cerramos el archivo al terminar de leerlo
    archivo.close()