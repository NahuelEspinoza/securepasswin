# SecurePassWin

SecurePassWin es un gestor de contraseñas local para Windows escrito en Batch Script que ofrece una forma segura y confiable de almacenar y gestionar contraseñas. El programa utiliza encriptación AES-256-GCM junto con una capa adicional de encriptación para proteger las contraseñas almacenadas.

## Características

- Almacenamiento seguro de contraseñas en un directorio local.
- Encriptación fuerte utilizando AES-256-GCM y una capa adicional de encriptación.
- Generación de contraseñas seguras automáticamente.
- Menú intuitivo para agregar y mostrar contraseñas.
- Verificación de integridad para asegurar que los archivos de contraseñas no hayan sido modificados.
- Gestión segura de claves utilizando OpenSSL.
- Registro de eventos para fines de auditoría.

## Requisitos

- Windows (probado en Windows 10)
- OpenSSL instalado y configurado en el sistema.

## Instalación

1. Clona o descarga el repositorio SecurePassWin.
2. Asegúrate de tener OpenSSL instalado y configurado correctamente en tu sistema.
3. Ejecuta el archivo `SecurePassWin.bat` para iniciar el programa.

## Uso

- Al iniciar el programa, se te pedirá que ingreses la contraseña maestra para desbloquear el gestor de contraseñas.
- Una vez desbloqueado, puedes seleccionar las opciones del menú para agregar contraseñas o mostrar contraseñas existentes.
- Las contraseñas se encriptarán y almacenarán de forma segura en el directorio especificado.
- Las contraseñas generadas automáticamente se guardarán en un archivo de texto temporal y se eliminarán después de su uso.

## Contribución

Las contribuciones son bienvenidas. Si tienes alguna idea de mejora, corrección de errores o nueva característica, por favor, siéntete libre de realizar un pull request o abrir un issue en este repositorio.

## Autor

SecurePassWin ha sido desarrollado por [NahuelEspinoza] y está disponible como software de código abierto bajo la licencia [MIT].
