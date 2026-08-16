@echo off
set GVIM="D:\Program Files\Vim\vim91\gvim.exe"
set FILE="D:\Program Files\Vim\vimfiles\todo\work-todo.txt"

%GVIM% --servername GVIM --remote-tab-silent %FILE%
if errorlevel 1 (
    start "" %GVIM% --servername GVIM %FILE%
)
