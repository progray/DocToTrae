@echo off
REM Auto Ignore Tests for DocTo
REM This script tests the auto-ignore functionality for TOC, password-protected, and timeout scenarios

setlocal enabledelayedexpansion

REM Set paths
set DOCTO_EXE=..\src\docto.exe
set INPUT_DIR=InputFiles
set OUTPUT_DIR=Output
set IGNORE_FILE=..\src\docto.ignore.txt

REM Clean up previous test results
if exist "%OUTPUT_DIR%" rmdir /s /q "%OUTPUT_DIR%"
mkdir "%OUTPUT_DIR%"
if exist "%IGNORE_FILE%" del "%IGNORE_FILE%"

REM Test 1: Skip documents with TOC
echo Test 1: Skipping documents with TOC...
"%DOCTO_EXE%" --word --inputfile "%INPUT_DIR%\Pie3.doc" --outputfile "%OUTPUT_DIR%\Pie3.txt" --outputextension .txt --skip-on-toc true
if !errorlevel! equ 0 (
    echo ERROR: Test 1 failed - Document with TOC was not skipped
) else (
    echo SUCCESS: Test 1 passed - Document with TOC was skipped
)

REM Test 2: Skip password-protected documents
echo.
echo Test 2: Skipping password-protected documents...
"%DOCTO_EXE%" --word --inputfile "%INPUT_DIR%\pwd.docx" --outputfile "%OUTPUT_DIR%\pwd.txt" --outputextension .txt
if !errorlevel! equ 0 (
    echo ERROR: Test 2 failed - Password-protected document was not skipped
) else (
    echo SUCCESS: Test 2 passed - Password-protected document was skipped
)

REM Test 3: Timeout handling
echo.
echo Test 3: Testing conversion timeout...
"%DOCTO_EXE%" --word --inputfile "%INPUT_DIR%\PigeonPie.doc" --outputfile "%OUTPUT_DIR%\PigeonPie.txt" --outputextension .txt --conv-timeout 1
if !errorlevel! equ 0 (
    echo ERROR: Test 3 failed - Conversion did not timeout
) else (
    echo SUCCESS: Test 3 passed - Conversion timed out as expected
)

REM Test 4: Verify ignore file
echo.
echo Test 4: Verifying ignore file contents...
if exist "%IGNORE_FILE%" (
    echo SUCCESS: Test 4 passed - Ignore file was created
    echo Ignore file contents:
    type "%IGNORE_FILE%"
) else (
    echo ERROR: Test 4 failed - Ignore file was not created
)

REM Clean up
if exist "%OUTPUT_DIR%" rmdir /s /q "%OUTPUT_DIR%"
if exist "%IGNORE_FILE%" del "%IGNORE_FILE%"

echo.
echo All tests completed!
pause