import regex as re

# Lista con las letras para los DNIs
letras = ["T", "R", "W", "A", "G", "M", "Y", "F", "P", "D", "X", "B", "N", "J", "Z", "S", "Q", "V", "H", "L", "C", "K", "E"]

# Función que calcula la letra correcta del DNI a partir del número
def letraDNI(num_dni):
    if num_dni[0] not in ["X", "Y", "Z"] and len(num_dni) == 8:
        resto = int(num_dni) % 23
        return letras[resto]
    elif num_dni[0] in ["X", "Y", "Z"] and len(num_dni) == 8:
        if num_dni[0] == "X":
            num_dni = "0" + num_dni[1:]
        elif num_dni[0] == "Y":
            num_dni = "1" + num_dni[1:]
        elif num_dni[0] == "Z":
            num_dni = "2" + num_dni[1:]
        else:
            return "El número de DNI introducido es incorrecto."
        resto = int(num_dni) % 23
        return letras[resto]
    else:
        return "El número de DNI introducido es incorrecto."

# Función que comprueba si un DNI es correcto
def comprobarDNI(dni):
    # Extraemos los primeros 8 caracteres (números) del DNI
    num_dni = dni[0:8]
    # Calcula la letra correcta para el número de DNI
    letra_correcta = letraDNI(num_dni)
    # Formamos el DNI completo con su letra correcta
    dni_correcto = num_dni + letra_correcta

    # Compara el DNI dado con el DNI correcto
    if dni == dni_correcto:
        return True
    else:
        return False

# Expresión regular para validar el formato del NIF
patron_nif = re.compile(r'(\d{8}[A-Z])|([X-Z])(\d{7}[A-Z])')

# Definimos qué tiene que hacer la opción snif: procesa un archivo y filtra los DNIs que coinciden con el DNI dado
def opcion_snif(NIF, fichero):
    encontrado = False
    # Abrimos el archivo en modo lectura
    archivo = open(fichero, 'r')
    while True:
        # Leemos una línea del archivo
        linea = archivo.readline()
        if not linea:
            # Si se llega al final del archivo, salimos del bucle
            break
        else:
            # Buscamos un DNI en la línea utilizando la expresión regular
            nif = patron_nif.search(linea)
            # Si se encuentra un DNI, es válido y coincide con el DNI dado:
            if nif and comprobarDNI(nif.group()) and nif.group() == NIF:
                # Imprimimos el DNI encontrado
                print(nif.group())
                encontrado = True
    if not encontrado:
        print("No se ha encontrado un NIF igual que el introducido")
    # Cerramos el archivo al terminar
    archivo.close()

