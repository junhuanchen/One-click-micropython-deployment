@echo off
echo 正在检查 python pip ，请稍候...
for /f "delims=" %%t in ('pip -V') do set str=%%t
echo %str% | find /c /i "site-packages\pip" >nul && set pip_installed=1 || set pip_installed=0
if %pip_installed% equ 1 (
	echo 存在 pip 开始更换pip源为国内源
	@md %userprofile%\pip
	@copy %~dp0.\pip.ini %userprofile%\pip
	echo 开始更新pip版本
	python -m pip install --upgrade pip --user
	python -m pip install -r %~dp0.\requirements.txt --user
	pip install mpfshell-lite
)
