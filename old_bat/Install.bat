@ECHO OFF
CLS
REM ===== Global =====
SET INSTALLDIR=%USERPROFILE%\TESToCoding
SET VSCHOME=\VSC
SET MINGWHOME=\MinGWx86_64-8.1.0
SET PYTHONHOME=\Python3
SET TEMP_PATH=

REM ========== Annatation ==========
@ECHO --------------------------------------------------------------------------------------
@ECHO            *Visual Studio Code portable* installanion 
@ECHO            *MinGW* and *C/C++ extension for VSC* portable installation
@ECHO            *Python3* and *Python extension for VSC* portable installation
@ECHO -------------------------------------------------------------------------------------- 
@ECHO  Portable installation enables all data created and maintained by VS Code to live 
@ECHO  near itself, so it can be moved around across environments, for example,
@ECHO  on a USB drive.
@ECHO  Move your portable installaton on another drive using your root installation directory 
@ECHO  %INSTALLDIR:~2%  (for instance current default location) 
@ECHO  or change in %VSCHOME%\bin\code.cmd PATH variable according to new location
@ECHO -------------------------------------------------------------------------------------- 
@ECHO   This will install:
@ECHO   - VSC Win x86 64 bit v 1.64.2 - source: https://code.visualstudio.com/download#
@ECHO     Visual Studio Code site: https://code.visualstudio.com/
@ECHO   - MinGW_GCC x86 64 bit v 8.1.0 - sourse: https://sourceforge.net/projects/mingw-w64/
@ECHO     files/Toolchains%20targetting%20Win64/Personal%20Builds/mingw-builds/8.1.0/
@ECHO     threads-win32/seh/x86_64-8.1.0-release-win32-seh-rt_v6-rev0.7z/download
@ECHO     (MinGW site: http://mingw-w64.org/doku.php)
@ECHO   - Python 3.10.1 - source: https://www.python.org/ftp/python/3.10.1/python-3.10.1-embed-amd64.zip
@ECHO     For additional information about using Python on Windows, see Using Python on Windows at 
@ECHO     Python.org https://docs.python.org/3.9/using/windows.html
@ECHO   - Python3 Windows help file - source: https://www.python.org/ftp/python/3.10.1/python3101.chm
@ECHO
@ECHO --------------------------------------------------------------------------------------

REM ========== Choice section ==========
choice  /C acfqd /n /t 20 /d q /m "Choose install option: "a" - for Auto, "c" - for Custom, "f" - for Full, "d" - for .Net 4.5.2 only ; "q" - for Quit"

IF "%ERRORLEVEL%" == "1" (
    call :Autoinstall
    GOTO ENDLABEL
) 

IF "%ERRORLEVEL%" == "2" (
    call :Custominstall
    GOTO ENDLABEL
) 

IF "%ERRORLEVEL%" == "3" (
    call :Fullinstall
    GOTO ENDLABEL
)

IF "%ERRORLEVEL%" == "4" (
    ECHO As you wish Sten... quitting
    GOTO ENDLABEL
)

IF "%ERRORLEVEL%" == "5" (
    call :Framework_dotNet_install
    GOTO ENDLABEL
)

REM ========== Installation variant section ==========

:Autoinstall
ECHO.
ECHO Auto install ...
call :Path_set
call :VSC_install
call :Framework_dotNet_check
REM installing some common extansions for VSC
call :MaterialIcon_extansion

REM del next
REM md %INSTALLDIR%%VSCHOME%\bin
REM ECHO test > %INSTALLDIR%%VSCHOME%\bin\code.cmd

call :MINGW_install
call :C_extansion
call :Python_install
call :Py_extansion
call :Set_variables
call :Uninstall_bat
EXIT /B 0

:Custominstall
ECHO Custom install ...
@ECHO Not ready
EXIT /B 0

:Fullinstall
ECHO Full install ...
@ECHO Not ready
EXIT /B 0


REM ========== Functions section ==========

:Path_set
REM ==== Setting "PATH" search invironemnt variable
CLS 
@ECHO --------------------------------------------------------------------------------------
@ECHO  Visual Studio Code installation directory: %INSTALLDIR%%VSCHOME%
@ECHO --------------------------------------------------------------------------------------
SET NAME=
SET /P NAME= " Change installation path %INSTALLDIR% for %VSCHOME% or press [Enter] to continue: "
IF /I "%NAME%"=="" GOTO :QUITFUNC ELSE 
SET INSTALLDIR=%NAME%
GOTO Path_set
:QUITFUNC
EXIT /B 0

:VSC_install
REM ==== Installing VSC
ECHO.
ECHO VSC installing....
md %INSTALLDIR%%VSCHOME%\data\user-data
md %INSTALLDIR%%VSCHOME%\data\extensions
md %INSTALLDIR%%VSCHOME%\data\tmp
7z\7za.exe x "Visual Studio Code"\* -o%INSTALLDIR%%VSCHOME%
EXIT /B 0

:Framework_dotNet_check
REM ==== Checking installed version of dotNET Framework
@ECHO.
@ECHO --------------------------------------------------------------------------------------
@ECHO DotNET Framework 4.5.2 or higher is required for VSC. Make sure you have 
@ECHO right DotNET version installed. Cheking your DotNET Framework versoin:
@ECHO.
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\full" /v version
@ECHO If incorrect, you can install it later
PAUSE
EXIT /B 0

:Framework_dotNet_install
REM ==== Installing dotNET Framework 4.5.2
@ECHO.
@ECHO Installation skipted (commented) in install.bat file
REM @ECHO .Net installing....
REM "dotNet 4.5.2"\NDP452-KB2901907-x86-x64-AllOS-ENU.exe
EXIT /B 0

:MaterialIcon_extansion
@ECHO.
@ECHO --------------------------------------------------------------------------------------
ECHO Installing Material Icon Theme for VSC...
@ECHO --------------------------------------------------------------------------------------
CALL %INSTALLDIR%%VSCHOME%\bin\code --install-extension pkief.material-icon-theme
EXIT /B 0



REM ==== MinGW installation function
:MINGW_install
ECHO.
@ECHO --------------------------------------------------------------------------------------
@ECHO  Installing MinGW to directory: %INSTALLDIR%%MINGWHOME%
@ECHO --------------------------------------------------------------------------------------
md %INSTALLDIR%%MINGWHOME%
ECHO MinGW installing....
7z\7za.exe x MinGW_GCC\* -o%INSTALLDIR%%MINGWHOME%
EXIT /B 0
REM **** End of MinGW installation function

REM ==== C/C++ extension installation function
:C_extansion
@ECHO.
@ECHO --------------------------------------------------------------------------------------
ECHO Installing C/C++ ms-vscode.cpptools extension for VSC...
@ECHO --------------------------------------------------------------------------------------
CALL %INSTALLDIR%%VSCHOME%\bin\code --install-extension ms-vscode.cpptools
EXIT /B 0
REM **** End of C/C++ extension installation function

REM ==== Python3 installation function
:Python_install
ECHO.
@ECHO --------------------------------------------------------------------------------------
@ECHO  Installing Python3 to directory: %INSTALLDIR%%PYTHONHOME%
@ECHO --------------------------------------------------------------------------------------
@ECHO Python3 installing...
7z\7za.exe x Python3\* -o%INSTALLDIR%%PYTHONHOME%
@ECHO.
@ECHO Installing documentstion to %INSTALLDIR%%PYTHONHOME%\docs
md %INSTALLDIR%%PYTHONHOME%\docs
copy Python3\python3101.chm %INSTALLDIR%%PYTHONHOME%\docs
copy Python3\pythonworldru.pdf %INSTALLDIR%%PYTHONHOME%\docs
EXIT /B 0
REM **** End of Python3 installation function

:Py_extansion
REM ==== Installing Python extension
@ECHO.
@ECHO --------------------------------------------------------------------------------------
ECHO Installing Python3 ms-python.python extension for VSC...
@ECHO --------------------------------------------------------------------------------------
CALL %INSTALLDIR%%VSCHOME%\bin\code --install-extension ms-python.python
EXIT /B 0

:Set_variables
REM ==== Setting PATH variable temporary in *code.cmd*
ECHO.
@ECHO --------------------------------------------------------------------------------------
@ECHO Setting temporary PATH variable while executing *code.cmd* form %INSTALLDIR%%VSCHOME%\bin
@ECHO --------------------------------------------------------------------------------------
IF EXIST %INSTALLDIR%%VSCHOME%\bin\code.cmd COPY %INSTALLDIR%%VSCHOME%\bin\code.cmd %INSTALLDIR%%VSCHOME%\bin\code.old_cmd
@ECHO @ECHO OFF > %INSTALLDIR%%VSCHOME%\bin\code.cmd

REM %INSTALLDIR:~2% - INSTALLDIR variable string without 2 first letters, i.e. without drive letters (C: - for instance)
REM It gives us opportunity to set correct drive letter in PATH varisble, even if we will use installation on USB-drive with assighned random drive letter 

SET WRITE_PATH=%%~d0%INSTALLDIR:~2%%MINGWHOME%\mingw64\bin;%%~d0%INSTALLDIR:~2%%VSCHOME%\bin;%%~d0%INSTALLDIR:~2%%PYTHONHOME%
REM WRITE_PATH uses extra "%" for correct wrighting PATH to *code.cmd* - %~d0% but not its value (c: - for instance)
REM %~d0 shows current drive letter where <code.cmd> is evoked

@ECHO SET PATH=%WRITE_PATH%;%PATH% >> %INSTALLDIR%%VSCHOME%\bin\code.cmd
@ECHO @ECHO PATH = %%PATH%% >> %INSTALLDIR%%VSCHOME%\bin\code.cmd
TYPE %INSTALLDIR%%VSCHOME%\bin\code.old_cmd >> %INSTALLDIR%%VSCHOME%\bin\code.cmd

@ECHO --------------------------------------------------------------------------------------
@ECHO  Cheking toolchain availability through the 'PATH' variable:
@ECHO --------------------------------------------------------------------------------------
@ECHO OFF
SET TEMP_PATH=%INSTALLDIR%%MINGWHOME%\mingw64\bin;%INSTALLDIR%VSCHOME\bin;%INSTALLDIR%%PYTHONHOME%
REM TEMP_PATH - our correct search path to installed tools. It takes in account only the instaled tolls (MinGW or MinGW + Python ets.)
SET PATH=%TEMP_PATH%;%PATH%
@ECHO PATH = %PATH%
@ECHO --------------------------------------------------------------------------------------
@ECHO gcc test
gcc --version
@ECHO g++ test
g++ --version
@ECHO gdb test
gdb --version
@ECHO.
python --version
EXIT /B 0

:Uninstall_bat
REM ==== Making Uninstall.bat file
@ECHO.
@ECHO Generating Uninstall.bat...
@ECHO @ECHO OFF > %INSTALLDIR%\Uninstall.bat
@ECHO SET VSCHOME=%VSCHOME%>> %INSTALLDIR%\Uninstall.bat
@ECHO SET MINGWHOME=%MINGWHOME%>> %INSTALLDIR%\Uninstall.bat
@ECHO SET PYTHONHOME=%PYTHONHOME%>> %INSTALLDIR%\Uninstall.bat
@ECHO SET INSTALLDIR=%INSTALLDIR%>> %INSTALLDIR%\Uninstall.bat
TYPE Uninstall._bat>> %INSTALLDIR%\Uninstall.bat
@ECHO **************************************************************************************
@ECHO *             *Visual Studio Code*  and *MinGW* installation complete!               *
@ECHO **************************************************************************************
EXIT /B 0

REM ========== End of functions section ==========
REM ==== EOF
:ENDLABEL
PAUSE

REM Useful add-ons for VSC

REM Debug Visualizer - UId:hediet.debug-visualize
REM Material Icon Theme - иконки UId:pkief.material-icon-theme
REM http://code.visualstudio.com
REM http://vscode.dev
REM http://vscodium.com
REM http://open-vsx.org
REM http://emmet.io
REM http://github.com/tonsky/FiraCode
REM Community Material Theme
REM Bracket-Pair-Colorizer & Bracket-Pair-Colorizer-2
REM Better Comments
REM Indent-rainbow
REM Path Intellisense
REM Live Server
REM Prettier
REM PHP Intelephense
REM GitLens — Git supercharged
REM ESLint
REM Quokka.js
REM Code Runner
REM Duckly: Pair Programming with any IDE
REM pair-programming-timer ???
