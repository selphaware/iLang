@echo off
echo Generating following ABI:
type coderequests.ai
echo Generating ABI... (please wait)
python ..\..\..\gen\genwrap.py --prompt-file coderequests.ai
echo ABI generation complete.
