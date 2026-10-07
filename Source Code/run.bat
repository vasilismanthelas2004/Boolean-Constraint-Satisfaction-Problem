@echo off
setlocal

:: ==========================================
:: ΡΥΘΜΙΣΕΙΣ
:: ==========================================
set C_FILE=bcsp_generate.c
set EXE_FILE=bcsp_generate.exe
set N_VAL=20
set K_VAL=4

:: Λίστα με τις τιμές του M
set M_VALUES=40 80 100 120 160 180 200 220 240 280

echo [CHECK 1] Psaxno ton GCC...
where gcc >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] O GCC den vrethike!
    echo Prepei na egkatastiseis ton MinGW.
    pause
    exit /b
)
echo [OK] GCC vrethike.

echo [CHECK 2] Psaxno to arxeio C...
if not exist %C_FILE% (
    echo [ERROR] To arxeio %C_FILE% den vrethike!
    pause
    exit /b
)
echo [OK] Arxeio C vrethike.

:: Αρχική ρύθμιση N και K (Μία φορά)
echo [INIT] Rythmisi N=%N_VAL% kai K=%K_VAL%...
powershell -Command "(Get-Content '%C_FILE%') -replace '#define N .*', '#define N %N_VAL%' | Set-Content '%C_FILE%'"
powershell -Command "(Get-Content '%C_FILE%') -replace '#define K .*', '#define K %K_VAL%' | Set-Content '%C_FILE%'"

:: Εδώ ξεκινάει το loop, αλλά καλεί συνάρτηση για ασφάλεια
echo.
echo Ksekiname ti dimiourgia...

for %%m in (%M_VALUES%) do call :PROCESS_M %%m

echo.
echo ==========================================
echo OLA TELEIOSAN EPITIXOS!
echo ==========================================
pause
exit /b

:: ==========================================
:: Η ΣΥΝΑΡΤΗΣΗ ΠΟΥ KANEI TH DOULEIA
:: ==========================================
:PROCESS_M
set CURR_M=%1
echo.
echo -----------------------------------
echo Epeksergasia gia M = %CURR_M%
echo -----------------------------------

:: 1. Αλλαγή του M στον κώδικα
powershell -Command "(Get-Content '%C_FILE%') -replace '#define M .*', '#define M %CURR_M%' | Set-Content '%C_FILE%'"

:: 2. Compile
gcc %C_FILE% -o %EXE_FILE%
if %errorlevel% neq 0 (
    echo [ERROR] To Compile apetuxe gia M=%CURR_M%!
    goto :EOF
)

:: 3. Εκτέλεση
:: Τρέχει: bcsp_generate.exe problem_mXX 1 10
%EXE_FILE% problem_m%CURR_M% 1 10

echo -> Dimiourgithikan ta arxeia gia M=%CURR_M%
goto :EOF