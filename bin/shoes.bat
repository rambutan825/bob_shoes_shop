@echo off

REM Note that this is NOT the actual bin/shoes.bat that gets installed with
REM the gem! ext\install\shoes.bat is copied over to bin for gems, but
REM this is the right thing to use from bin on a source checkout.

set "SHOES_PICKER_BIN_DIR=%~dp0"

set bin_dir=bin
ext\install\shoes.bat %*
