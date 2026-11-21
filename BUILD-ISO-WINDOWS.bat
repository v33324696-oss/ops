@echo off
setlocal EnableExtensions
title NOVA GAMER OS - Build ISO
echo ==========================================
echo        NOVA GAMER OS - INTEL EDITION
echo ==========================================
echo.
where wsl.exe >nul 2>nul
if errorlevel 1 (
  echo ERRO: WSL nao foi encontrado.
  echo Abra PowerShell como Administrador e execute:
  echo   wsl --install -d Debian
  echo Reinicie se solicitado, abra Debian uma vez e conclua a configuracao.
  pause
  exit /b 1
)
wsl.exe -l -q | findstr /i /x "Debian" >nul
if errorlevel 1 (
  echo ERRO: Debian no WSL nao esta instalado.
  echo Execute no PowerShell como Administrador:
  echo   wsl --install -d Debian
  echo Depois abra Debian pelo menu Iniciar, configure o usuario e rode este BAT.
  pause
  exit /b 1
)
set "WINPATH=%~dp0"
for %%I in ("%WINPATH%.") do set "WINPATH=%%~fI"
set "LINUXPATH="
for /f "usebackq delims=" %%P in (`wsl.exe wslpath -a "%WINPATH%"`) do set "LINUXPATH=%%P"
if not defined LINUXPATH (
  echo ERRO: nao foi possivel localizar a pasta no WSL.
  pause
  exit /b 1
)
echo Instalando ferramentas de compilacao e construindo a ISO.
echo Sudo pode solicitar a senha do usuario Debian.
echo E necessario internet e espaco livre em disco.
echo.
wsl.exe -d Debian -- bash -lc "sudo apt-get update && sudo apt-get install -y live-build debootstrap xorriso squashfs-tools && cd '%LINUXPATH%' && sudo ./scripts/build-iso.sh"
if errorlevel 1 (
  echo.
  echo A compilacao falhou. Confira a mensagem acima, internet e espaco livre.
  pause
  exit /b 1
)
echo.
echo ISO pronta em:
echo %WINPATH%build\NOVA-GAMER-OS-amd64.iso
pause
endlocal
