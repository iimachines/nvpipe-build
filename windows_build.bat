@echo off

set CURDIR=%~DP0
set OUTDIR=%CURDIR%out
set SRCDIR=%CURDIR%NvPipe

cd /d "%CURDIR%"

if exist "%OUTDIR%"  (rd /s /q "%OUTDIR%")

mkdir "%OUTDIR%"

echo This script assumes the NvPipe source code is cloned in %SRCDIR%

echo ----------------------------------------------------------------
echo Generating project...

cmake -G "Visual Studio 15 2017 Win64" ^
    -B"%OUTDIR%" ^
    -H"%SRCDIR%" ^
    -DCMAKE_CONFIGURATION_TYPES="Debug;Release" ^
    -DNVPIPE_WITH_ENCODER=1 ^
    -DNVPIPE_WITH_DECODER=1 ^
    -DNVPIPE_WITH_OPENGL=1 ^
    -DNVPIPE_WITH_D3D11=1 ^
    -DNVPIPE_BUILD_EXAMPLES=0 ^
    -DNVPIPE_STATIC_LIB=1 ^
    -DNVPIPE_MSVC_STATIC_CRT=1 ^
    -DNVPIPE_MSVC_NO_ITERATOR_DEBUGGING=1 ^
    -DCMAKE_INSTALL_PREFIX="%OUTDIR%"

if errorlevel 1 goto error

echo ----------------------------------------------------------------
echo Building debug...

msbuild /p:configuration="Debug" /p:platform="x64" "%OUTDIR%\NvPipe.vcxproj"
if errorlevel 1 goto error

echo ----------------------------------------------------------------
echo Installing debug...

msbuild /p:configuration="Debug" /p:platform="x64" "%OUTDIR%\INSTALL.vcxproj"
if errorlevel 1 goto error

xcopy /i /y "%OUTDIR%\include\*.h" "%CURDIR%\include\"
if errorlevel 1 goto error

xcopy /i /y "%OUTDIR%\lib\*.lib" "%CURDIR%\lib\windows_debug_x64\"
if errorlevel 1 goto error

echo ----------------------------------------------------------------
echo Building release...

msbuild /p:configuration="Release" /p:platform="x64" "%OUTDIR%\NvPipe.vcxproj"
if errorlevel 1 goto error

echo ----------------------------------------------------------------
echo Installing release...

msbuild /p:configuration="Release" /p:platform="x64" "%OUTDIR%\INSTALL.vcxproj"
if errorlevel 1 goto error

xcopy /i /y "%OUTDIR%\lib\*.lib" "%CURDIR%\lib\windows_release_x64\"
if errorlevel 1 goto error

goto done

:done
color 2F
echo ************************** SUCCES :) ***************************
goto :exit

:error
color 4E
echo ************************** FAILURE :( **************************
goto :exit

:exit
cd /d "%CURDIR%"
pause
color

