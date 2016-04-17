# AzurePowerShell
Scripts de ejemplo usados en el programa de formación de Microsoft Azure

## Crear una máquina virtual desde PowerShell
### Pasos a alto nivel
1. Añadir la suscripción a la sesión de PowerShell
2. Crear los recursos necesarios en orden de dependencia
3. Crear la cuenta de almacenamiento
4. Opcional: Asocia un nombre de dominio público
5. Opcional: Crear un conjunto de disponibilidad
6. Opcional: Crear las reglas NAT asociadas a la tarjetas de red virtual
7. Ejecutar el conjunto de comando para crear la máquina virtual
8. Visualizar en cada uno de los pasos los resultados que se están generando en el portal de Azure.

### Referencias y enlaces de interes
[https://azure.microsoft.com/es-es/documentation/articles/virtual-machines-windows-create-powershell/]

##Crear un almacenamiento de Azure con PowerShell ARM
1. Añadir la suscripción a la sesión de PowerShell
2. Crear la cuenta de almacenamiento
3. Asignar la cuenta de almacenamiento al contexto actual
4. Crear el contenedor tipo bloque asociado a la cuenta de almacenamiento asignada en el contexto actual
4. Subir un documento de ejemplo al nuevo almacenamiento creado
5. Visualizar desde el portal en un explorador web
6. Descargar el documento previamente subido a una carpeta
7. Visualizar el contenido de la carpeta

## Crear una red virtual a partir de una plantilla ARM y PowerShell
1. Descargar la planti


