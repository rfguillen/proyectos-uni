import regex as re
import csv

# Expresión regular para los números de télefono de distintos países
patron_num_telefono = re.compile(r'^(\d\s?){9}|(?:\+(\d{1,3})\s?)?(\d\s?){9,13}')

# Definimos qué tiene que hacer la opción sphone: procesa un archivo y filtra los números de teléfono que coinciden con el dado
def opcion_sphone(telefono, fichero):
    encontrado = False
    # Abrimos el fichero
    archivo = open(fichero, 'r')
    while True:
        # Leemos una línea del archivo
        linea = archivo.readline()
        if not linea:
            # Si se llega al final del archivo, salir del bucle
            break
        else:
            # Buscamos un número de teléfono en la línea utilizando la expresión regular
            num_telefono = patron_num_telefono.search(linea)
            # Si se encuentra un número de teléfono y coincide con el número dado entonces:
            if num_telefono and num_telefono.group() == telefono:
                # Imprimimos el número
                print(num_telefono.group())
                encontrado = True
    if not encontrado:
        print("No se ha encontrado un número de teléfono igual que el introducido")
    # Cerramos el archivo
    archivo.close()