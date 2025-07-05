import regex as re

# Función que verifica si las coordenadas son correctas
def sonCoordenadasCorrectas(coordenadas):
    return -90 <= coordenadas['latitud'] <= 90 and -180 <= coordenadas['longitud'] <= 180

# Función que convierte un valor a formato GPS
def convertir_a_gps(valor, tipo):
    grados = int(valor)
    minutos = int((valor - grados) * 60)
    segundos = (valor - grados - minutos / 60) * 3600
    orientacion = 'N' if tipo == 'latitud' and grados >= 0 else 'S' if tipo == 'latitud' else 'E' if grados >= 0 else 'W'
    grados = abs(grados)
    return f"{grados:03d}{minutos:02d}{segundos:07.4f}{orientacion}"

# Expresión regular combinada para los diferentes formatos de coordenadas
patron_coordenadas = re.compile(
    r'([+-]?\d{1,2}(?:\.\d+)?)\s*,\s*([+-]?\d{1,2}(?:\.\d+)?)\s*|'  # Formato decimal
    r'(\d{1,2}(chr(176))\d{1,2}‘\d{1,2}(?:\.\d{1,4})?"\s*[NS])\s*,\s*(\d{1,2}°\d{1,2}‘\d{1,2}(?:\.\d{1,4})?"\s*[EW])|'  # Formato sexagesimal
    r'(\d{3}\d{2}\d{2}\.\d{4}[NS])\s*,\s*(\d{3}\d{2}\d{2}\.\d{4}[EW])'  # Formato GPS
)

# Función que convierte coordenadas sexagesimales a decimales
def convertirSexagesimalADecimal(coordenada):
    partes = re.split('[°‘"]', coordenada)
    grados = float(partes[0])
    minutos = float(partes[1])
    segundos = float(partes[2])
    orientacion = partes[3].strip()

    decimal = grados + minutos / 60 + segundos / 3600
    if orientacion in ['S', 'W']:
        decimal = -decimal
    return decimal

# Función que convierte coordenadas GPS a decimales
def convertirGPSADecimal(coordenada):
    orientacion = coordenada[-1]
    valor = float(coordenada[:-1])
    grados = int(valor // 10000)
    minutos = int((valor % 10000) // 100)
    segundos = valor % 100
    decimal = grados + minutos / 60 + segundos / 3600
    if orientacion in ['S', 'W']:
        decimal = -decimal
    return decimal

# Función que convierte una cadena de coordenadas a un diccionario de coordenadas
def convertirFormatoCoordenadas(coordenadas):
    # Vemos si la cadena de coordenadas coincide con alguno de los patrones según sus expresiones regulares
    formato = patron_coordenadas.search(coordenadas)

    # Inicializamos las variables de latitud y longitud
    latitud = longitud = None

    # Si la cadena de las coordenadas coincide con algunos de los patrones, entonces comprobar su formato
    if formato:
        if formato.group(1) and formato.group(2):
            # Es el formato decimal
            latitud = float(formato.group(1))
            longitud = float(formato.group(2))
        elif formato.group(3) and formato.group(4):
            # Es el formato sexagesimal
            latitud = convertirSexagesimalADecimal(formato.group(3))
            longitud = convertirSexagesimalADecimal(formato.group(4))
        elif formato.group(5) and formato.group(6):
            # Es el formato GPS
            latitud = convertirGPSADecimal(formato.group(5))
            longitud = convertirGPSADecimal(formato.group(6))

    if latitud is not None and longitud is not None:
        coordenadas_formateadas = {'latitud': latitud, 'longitud': longitud}
        if sonCoordenadasCorrectas(coordenadas_formateadas):
            return coordenadas_formateadas
    return None