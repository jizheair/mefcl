@ECHO OFF

REM Set Path for lib64
call %~dp0\..\lib64\setpath.bat

SET PATH=%~dp0;%PATH%

CD /d %~dp0
wx86cl64.exe