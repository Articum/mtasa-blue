@echo off

rem Install data files
utils\premake5 install_data

if %0 == "%~0" pause
