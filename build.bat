@echo off
REM *****************************************************************************
REM
REM Title:       build.bat
REM
REM Description: Build script for the IoHookInheritance project (Windows)
REM
REM *****************************************************************************

echo ==========================================
echo Building IoHookInheritance Example
echo ==========================================
echo.

REM Check if dbl is available
where dbl >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: dbl compiler not found in PATH
    echo Please ensure Synergy DBL is installed and in your PATH
    exit /b 1
)

echo Step 1: Compiling source files...
echo.

echo   Compiling BaseIOHook.dbl...
dbl -o BaseIOHook.dbo BaseIOHook.dbl
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to compile BaseIOHook.dbl
    exit /b 1
)

echo   Compiling LoggingIOHook.dbl...
dbl -o LoggingIOHook.dbo LoggingIOHook.dbl
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to compile LoggingIOHook.dbl
    exit /b 1
)

echo   Compiling ValidationIOHook.dbl...
dbl -o ValidationIOHook.dbo ValidationIOHook.dbl
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to compile ValidationIOHook.dbl
    exit /b 1
)

echo   Compiling StatisticsIOHook.dbl...
dbl -o StatisticsIOHook.dbo StatisticsIOHook.dbl
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to compile StatisticsIOHook.dbl
    exit /b 1
)

echo   Compiling CombinedIOHook.dbl...
dbl -o CombinedIOHook.dbo CombinedIOHook.dbl
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to compile CombinedIOHook.dbl
    exit /b 1
)

echo   Compiling MainProgram.dbl...
dbl -o MainProgram.dbo MainProgram.dbl
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to compile MainProgram.dbl
    exit /b 1
)

echo.
echo Step 2: Linking executable...
echo.

REM Check if dblink is available
where dblink >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    echo   Using dblink...
    dblink -o MainProgram.dbr MainProgram.dbo BaseIOHook.dbo LoggingIOHook.dbo ValidationIOHook.dbo StatisticsIOHook.dbo CombinedIOHook.dbo
    if %ERRORLEVEL% NEQ 0 (
        echo ERROR: Failed to link program
        exit /b 1
    )
) else (
    echo   dblink not found, using dbl with object files...
    dbl -o MainProgram.dbr MainProgram.dbo BaseIOHook.dbo LoggingIOHook.dbo ValidationIOHook.dbo StatisticsIOHook.dbo CombinedIOHook.dbo
    if %ERRORLEVEL% NEQ 0 (
        echo ERROR: Failed to create executable
        exit /b 1
    )
)

echo.
echo ==========================================
echo Build completed successfully!
echo ==========================================
echo.
echo Run the program with: dbr MainProgram.dbr
echo.
