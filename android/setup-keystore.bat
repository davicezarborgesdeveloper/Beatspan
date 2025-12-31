@echo off
REM Script para configurar o keystore de release do Beatspan
REM Execute este script uma vez para gerar o keystore de producao

echo.
echo ========================================
echo  Beatspan - Setup de Release Keystore
echo ========================================
echo.

REM Verifica se o keystore ja existe
if exist "beatspan-release.keystore" (
    echo [AVISO] O keystore 'beatspan-release.keystore' ja existe!
    echo.
    set /p OVERWRITE="Deseja sobrescrever? Isso invalidara builds anteriores! (s/N): "
    if /i not "%OVERWRITE%"=="s" (
        echo.
        echo Operacao cancelada.
        pause
        exit /b 1
    )
    echo.
    echo Removendo keystore anterior...
    del beatspan-release.keystore
)

echo.
echo Este script vai criar um keystore para assinar builds de release.
echo Voce precisara fornecer as seguintes informacoes:
echo.
echo 1. Senha do keystore (minimo 6 caracteres)
echo 2. Senha da key (minimo 6 caracteres)
echo 3. Nome completo
echo 4. Nome da organizacao
echo 5. Cidade
echo 6. Estado
echo 7. Codigo do pais (BR)
echo.
pause

echo.
echo Gerando keystore...
echo.
echo IMPORTANTE: Anote as senhas em um local SEGURO!
echo Voce precisara delas para futuros builds.
echo.

REM Gera o keystore
keytool -genkey -v -keystore beatspan-release.keystore -alias beatspan -keyalg RSA -keysize 2048 -validity 10000

if errorlevel 1 (
    echo.
    echo [ERRO] Falha ao gerar o keystore!
    echo Certifique-se de que o Java JDK esta instalado e no PATH.
    pause
    exit /b 1
)

echo.
echo ========================================
echo  Keystore criado com sucesso!
echo ========================================
echo.
echo Arquivo: android\beatspan-release.keystore
echo.
echo PROXIMOS PASSOS:
echo.
echo 1. Crie o arquivo 'key.properties' com base no 'key.properties.example'
echo 2. Preencha as senhas que voce acabou de criar
echo 3. NUNCA commite o arquivo 'key.properties' ou 'beatspan-release.keystore'
echo 4. Guarde as senhas em um gerenciador de senhas seguro
echo.
echo IMPORTANTE: Se voce perder este keystore ou as senhas,
echo NAO SERA POSSIVEL atualizar o app na Play Store!
echo.
echo Faca backup do keystore em um local seguro!
echo.
pause
