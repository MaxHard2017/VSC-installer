@echo off
setlocal enableextensions
set TERM=
set HOME=%cd%
start cygwin64\bin\mintty.exe --configdir=./cygwin64 /bin/bash -l "/g/max/DevInstall/install.sh"