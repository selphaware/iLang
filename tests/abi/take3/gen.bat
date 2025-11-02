@echo off
echo Generating following ABI:
type coderequests.ai
echo Generating ABI...
python ..\..\..\gen\genwrap.py --prompt-file coderequests.ai
echo ABI generation complete.
