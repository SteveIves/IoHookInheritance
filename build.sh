#!/bin/bash
##*****************************************************************************
##
## Title:       build.sh
##
## Description: Build script for the IoHookInheritance project
##
##*****************************************************************************

echo "=========================================="
echo "Building IoHookInheritance Example"
echo "=========================================="
echo ""

# Check if dbl is available
if ! command -v dbl &> /dev/null
then
    echo "ERROR: dbl compiler not found in PATH"
    echo "Please ensure Synergy DBL is installed and in your PATH"
    exit 1
fi

echo "Step 1: Compiling source files..."
echo ""

# Compile each source file
echo "  Compiling BaseIOHook.dbl..."
dbl -o BaseIOHook.dbo BaseIOHook.dbl
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to compile BaseIOHook.dbl"
    exit 1
fi

echo "  Compiling LoggingIOHook.dbl..."
dbl -o LoggingIOHook.dbo LoggingIOHook.dbl
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to compile LoggingIOHook.dbl"
    exit 1
fi

echo "  Compiling ValidationIOHook.dbl..."
dbl -o ValidationIOHook.dbo ValidationIOHook.dbl
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to compile ValidationIOHook.dbl"
    exit 1
fi

echo "  Compiling StatisticsIOHook.dbl..."
dbl -o StatisticsIOHook.dbo StatisticsIOHook.dbl
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to compile StatisticsIOHook.dbl"
    exit 1
fi

echo "  Compiling CombinedIOHook.dbl..."
dbl -o CombinedIOHook.dbo CombinedIOHook.dbl
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to compile CombinedIOHook.dbl"
    exit 1
fi

echo "  Compiling MainProgram.dbl..."
dbl -o MainProgram.dbo MainProgram.dbl
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to compile MainProgram.dbl"
    exit 1
fi

echo ""
echo "Step 2: Linking executable..."
echo ""

# Check if dblink is available
if command -v dblink &> /dev/null
then
    echo "  Using dblink..."
    dblink -o MainProgram.dbr MainProgram.dbo BaseIOHook.dbo LoggingIOHook.dbo ValidationIOHook.dbo StatisticsIOHook.dbo CombinedIOHook.dbo
    if [ $? -ne 0 ]; then
        echo "ERROR: Failed to link program"
        exit 1
    fi
else
    echo "  dblink not found, using dbl with object files..."
    dbl -o MainProgram.dbr MainProgram.dbo BaseIOHook.dbo LoggingIOHook.dbo ValidationIOHook.dbo StatisticsIOHook.dbo CombinedIOHook.dbo
    if [ $? -ne 0 ]; then
        echo "ERROR: Failed to create executable"
        exit 1
    fi
fi

echo ""
echo "=========================================="
echo "Build completed successfully!"
echo "=========================================="
echo ""
echo "Run the program with: dbr MainProgram.dbr"
echo ""
