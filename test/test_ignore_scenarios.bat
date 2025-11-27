@echo off
REM Test script for verifying ignore scenarios (TOC, password, timeout)

echo Testing DocTo ignore scenarios...
echo.

REM Test 1: Skip on TOC
echo Test 1: Skip on TOC
docto -WD -f "InputFiles\PigeonPie.doc" -O "Output\PigeonPie.pdf" -T wdFormatPDF --skip-on-toc true
echo.

REM Test 2: Password protected document
echo Test 2: Password protected document
docto -WD -f "InputFiles\pwd.docx" -O "Output\pwd.pdf" -T wdFormatPDF
echo.

REM Test 3: Conversion timeout
echo Test 3: Conversion timeout
docto -WD -f "InputFiles\Mayonnaise.doc" -O "Output\Mayonnaise.pdf" -T wdFormatPDF --conv-timeout 1
echo.

echo Test completed. Check Output directory and docto.ignore.txt for results.
