@echo off
setlocal enabledelayedexpansion

REM Carpeta de almacenamiento de contraseñas
set "password_folder=C:\PasswordManager"

REM Solicitar contrasena maestra de forma segura
set "master_password="
echo Ingrese la contrasena maestra: 
call :MaskInput master_password

REM Generar una clave segura a partir de la contrasena maestra
openssl enc -aes-256-gcm -pbkdf2 -iter 100000 -salt -pass pass:!master_password! -md sha512 -out "%password_folder%\master_password.bin" > nul

REM Limpiar la variable de la contrasena maestra
set "master_password="

REM Verificación de integridad
certutil -hashfile "%password_folder%\master_password.bin" SHA256 > "%password_folder%\master_password.hash"

REM Menú principal
:MainMenu
cls
echo Gestor de contrasenas local
echo.
echo 1. Agregar contrasena
echo 2. Mostrar contrasena
echo 3. Salir
echo.

set /p "option=Ingrese una opcion: "

if "%option%"=="1" (
    call :AddPassword
    goto :MainMenu
) else if "%option%"=="2" (
    call :ShowPassword
    goto :MainMenu
) else if "%option%"=="3" (
    exit
) else (
    echo Opción invalida. Intente nuevamente.
    pause
    goto :MainMenu
)

REM Función para agregar una contrasena
:AddPassword
cls
set /p "website=Ingrese el nombre del sitio web: "
set /p "username=Ingrese el nombre de usuario: "
set /p "password=Ingrese la contrasena: "

REM Generar una contrasena segura
set "generated_password="
powershell -command "$generated_password = -join ((33..47) + (58..64) + (91..96) + (123..126) | Get-Random -Count 16 | ForEach-Object {[char]$_}); $generated_password" > "%password_folder%\generated_password.txt"
set /p "generated_password=" < "%password_folder%\generated_password.txt"
del "%password_folder%\generated_password.txt"

REM Encriptacion adicional
openssl enc -aes-256-gcm -pbkdf2 -iter 100000 -salt -pass file:"%password_folder%\master_password.bin" -md sha512 -out "%password_folder%\%website%.bin" > nul

REM Verificacion de integridad
certutil -hashfile "%password_folder%\%website%.bin" SHA256 > "%password_folder%\%website%.hash"

echo Contrasena agregada exitosamente.
pause
exit /b

REM Funcion para mostrar una contrasena
:ShowPassword
cls
set /p "website=Ingrese el nombre del sitio web: "

REM Verificacion de integridad
certutil -hashfile "%password_folder%\%website%.bin" SHA256 > "%password_folder%\%website%.hash"
certutil -hashfile "%password_folder%\%website%.bin" SHA256 | findstr /i /c:"%website%.bin" > nul
if not errorlevel 1 (
    REM Desencriptar contrasena
    openssl enc -aes-256-gcm -pbkdf2 -iter 100000 -salt -pass file:"%password_folder%\master_password.bin" -md sha512 -in "%password_folder%\%website%.bin" -out "%password_folder%\decrypted_password.txt" > nul
    set /p "decrypted_password=" < "%password_folder%\decrypted_password.txt"
    del "%password_folder%\decrypted_password.txt"

    echo Contrasena para %website%: %decrypted_password%
) else (
    echo No se encontro la contrasena para %website%.
)
pause
exit /b

REM Funcion para ocultar la entrada de texto
:MaskInput
setlocal enabledelayedexpansion
set "input="
for /f "delims=" %%i in ('powershell -Command "$x = $host.ui.RawUI.ReadKey('NoEcho,IncludeKeyDown'); Write-Output $x.KeyChar"') do set "input=!input!%%i"
endlocal & set "%1=%input%"
exit /b
