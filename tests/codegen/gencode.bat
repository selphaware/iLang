@echo off
echo iLang, Selphaware (C) 2025
echo.
echo Press any key to read the AI Request in request.ai
pause > nul
type request.ai
echo ------------------------------------------------------------------------------------------------------------
echo.
date /t
time /t
echo *** READY ***
echo --- iLang, Selphaware ---
echo GENERATE [ %1 ]: press any key to proceed building code and app, or press ctrl-c to exit.
echo Press [ENTER to Proceed] [CTRL-C to Exit]
pause > nul
echo Generating code (please wait)...

rem executing gen
chcp 65001
set PYTHONUTF8=1
set PYTHONIOENCODING=utf-8
type request.ai | python -X utf8 ..\..\gen\codegen.py -p - -o %1.c
rem done.

echo Generation complete. Selphaware (C) 2025.
