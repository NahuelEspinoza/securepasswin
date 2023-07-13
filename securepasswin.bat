@echo off
setlocal enabledelayedexpansion

REM Carpeta de almacenamiento de contraseñas
set "password_folder=C:\PasswordManager"

REM Solicitar contraseña maestra de forma segura
set "master_password="
echo Ingrese la contraseña maestra: 
call :MaskInput master_password

REM Generar una clave segura a partir de la contraseña maestra
openssl enc -aes-256-gcm -pbkdf2 -iter 100000 -salt -pass pass:!master_password! -md sha512 -out "%password_folder%\master_password.bin" > nul

REM Limpiar la variable de la contraseña maestra
set "master_password="

REM Verificación de integridad
certutil -hashfile "%password_folder%\master_password.bin" SHA256 > "%password_folder%\master_password.hash"

REM Menú principal
:MainMenu
cls
echo Gestor de contraseñas local
echo.
echo 1. Agregar contraseña
echo 2. Mostrar contraseña
echo 3. Salir
echo.

set /p "option=Ingrese una opción: "

if "%option%"=="1" (
    call :AddPassword
    goto :MainMenu
) else if "%option%"=="2" (
    call :ShowPassword
    goto :MainMenu
) else if "%option%"=="3" (
    exit
) else (
    echo Opción inválida. Intente nuevamente.
    pause
    goto :MainMenu
)

REM Función para agregar una contraseña
:AddPassword
cls
set /p "website=Ingrese el nombre del sitio web: "
set /p "username=Ingrese el nombre de usuario: "
set /p "password=Ingrese la contraseña: "

REM Generar una contraseña segura
set "generated_password="
powershell -command "$generated_password = -join ((33..47) + (58..64) + (91..96) + (123..126) | Get-Random -Count 16 | ForEach-Object {[char]$_}); $generated_password" > "%password_folder%\generated_password.txt"
set /p "generated_password=" < "%password_folder%\generated_password.txt"
del "%password_folder%\generated_password.txt"

REM Encriptación adicional
openssl enc -aes-256-gcm -pbkdf2 -iter 100000 -salt -pass file:"%password_folder%\master_password.bin" -md sha512 -out "%password_folder%\%website%.bin" > nul

REM Verificación de integridad
certutil -hashfile "%password_folder%\%website%.bin" SHA256 > "%password_folder%\%website%.hash"

echo Contraseña agregada exitosamente.
pause
exit /b

REM Función para mostrar una contraseña
:ShowPassword
cls
set /p "website=Ingrese el nombre del sitio web: "

REM Verificación de integridad
certutil -hashfile "%password_folder%\%website%.bin" SHA256 > "%password_folder%\%website%.hash"
certutil -hashfile "%password_folder%\%website%.bin" SHA256 | findstr /i /c:"%website%.bin" > nul
if not errorlevel 1 (
    REM Desencriptar contraseña
    openssl enc -aes-256-gcm -pbkdf2 -iter 100000 -salt -pass file:"%password_folder%\master_password.bin" -md sha512 -in "%password_folder%\%website%.bin" -out "%password_folder%\decrypted_password.txt" > nul
    set /p "decrypted_password=" < "%password_folder%\decrypted_password.txt"
    del "%password_folder%\decrypted_password.txt"

    echo Contraseña para %website%: %decrypted_password%
) else (
    echo No se encontró la contraseña para %website%.
)
pause
exit /b

REM Función para ocultar la entrada de texto
:MaskInput
setlocal enabledelayedexpansion
set "input="
for /f "delims=" %%i in ('powershell -Command "$x = $host.ui.RawUI.ReadKey('NoEcho,IncludeKeyDown'); Write-Output $x.KeyChar"') do set "input=!input!%%i"
endlocal & set "%1=%input%"
exit /b
