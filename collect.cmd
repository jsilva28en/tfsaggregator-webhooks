@SETLOCAL
@REM make sure git is available (no needed for Appveyor)
@set PATH=C:\Program Files (x86)\Git\bin;%PATH%
@set BASEDIR=%~dp0
@set CONFIG=%1
@mkdir %BASEDIR%_collect\%CONFIG%
@pushd %BASEDIR%_collect\%CONFIG%
@mkdir bin
@echo .Server. > %BASEDIR%bin-exclude.txt
@echo .lastcodeanalysissucceeded >> %BASEDIR%bin-exclude.txt
@echo .xml >> %BASEDIR%bin-exclude.txt
@echo .vshost >> %BASEDIR%bin-exclude.txt
@REM 1. binaries
xcopy %BASEDIR%Aggregator.ConsoleApp\bin\%CONFIG%\*.* bin /S /Y /R /EXCLUDE:%BASEDIR%bin-exclude.txt
xcopy %BASEDIR%Aggregator.ServerPlugin\bin\%CONFIG%\*.* bin /S /Y /R /EXCLUDE:%BASEDIR%bin-exclude.txt
@REM 2. wiki
@if exist %TEMP%\dummy-git rmdir /S/Q %TEMP%\dummy-git
git clone --depth=1 --single-branch --separate-git-dir=%TEMP%\dummy-git https://github.com/tfsaggregator/tfsaggregator.wiki.git docs
@REM TODO: edit links in MD files (add MD and remove absolute URL https://github.com/tfsaggregator/tfsaggregator/wiki/)
@del /F /Q docs\.git
@REM 3. samples
@mkdir samples
xcopy %BASEDIR%samples\*.policies samples /S /Y /R
xcopy %BASEDIR%UnitTests.Core\*.policies samples /S /Y /R
xcopy %BASEDIR%ManualTests\*.policies samples /S /Y /R
@REM 4. installer
xcopy %BASEDIR%*.ps1 /Y /R
@REM 5. miscellanea
xcopy %BASEDIR%LICENSE* /Y /R
xcopy %BASEDIR%readme* /Y /R
@REM cleanup
@del /Q %BASEDIR%bin-exclude.txt
@popd
@ENDLOCAL