@echo off
%1 %2 
ver|find "5.">nul&&goto :st 
mshta vbscript:createobject("shell.application").shellexecute("%~s0","goto :st","","runas",1)(window.close)&goto :eof 
:st 
copy "%~0" "%windir%\system32\" 
:: %1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
CLS
echo ***************************************************************************
echo                           Python 一键安装脚本                        
echo                         如安装不成功，请再次执行                      
echo                       本程序仅供 Python 爱好者使用           
echo ***************************************************************************
@ping 127.0.0.1 -n 2 >nul
set setup_flag=0

echo 正在检查python，请稍候...
for /f "delims=" %%t in ('python -V') do set str=%%t
echo %str% | find /c /i "python 3." >nul && set py_installed=1 || set py_installed=0
if %py_installed% equ 1 (
	echo python3已安装，开始更新pip
	call %~dp0.\scripts\pip-upgrade.bat
	goto SETUP_VSCODE
)

:SEARCH
set "FileName=python3.dll"
echo 正在检查是否已安装python，请稍候...
for %%a in (C D E F) do (
    if exist %%a:\nul (
        pushd %%a:\
		echo 搜索 %%a 盘
        for /r %%b in ("*%FileName%") do (
            if /i "%%~nxb" equ "%FileName%" (
				echo 找到安装目录%%~pdb
                set python_path=%%~pdb
				cd %%~pdb
				call %~dp0.\scripts\pip-upgrade.bat
				goto SET_PATH
            )
        )
		popd
    )
)

echo 开始下载，请稍后。。。
start  /wait %~dp0.\scripts\download.bat  -s
echo 下载完成

:SETUP
echo 开始自动安装，请耐心等候，切勿关闭本窗口！！！！
start /wait %~dp0.\scripts\PythonInstaller.exe /quiet  InstallAllUsers=1 PrependPath=1
set setup_flag=1
goto SEARCH

:SET_PATH
if %setup_flag% equ 1 ( goto SETUP_VSCODE)
set path_=%path%
echo 设置python环境变量
echo %path% | find /c /i "%python_path%" >nul && set re=1 || set re=0
set flag=0
if %re% equ 0 (
    set path_=%python_path%;%path_%
	set flag=1
)
echo %path% | find /c /i "%python_path%Scripts" >nul && set re=1 || set re=0
if %re% equ 0 (
    set path_=%python_path%Scripts;%path_%
	set flag=1
)
if %flag% equ 1 (
	setx path "%path_%" /m
	echo 环境变量注入成功
)

:SETUP_VSCODE
echo 开始检测是否安装vscode
for /f "delims=" %%t in ('code -v') do set str2=%%t
echo %str2% | findstr /r "[0-9]." >nul && set code_installed=1 || set code_installed=0
if %code_installed% equ 1 ( goto SETUP_EXTENSION )
@rd /S /Q %userprofile%\AppData\Roaming\Code
@rd /S /Q %userprofile%\.vscode
start /wait %~dp0.\scripts\download-vscode.bat -s
echo 正在安装vscode，请耐心等候
call %~dp0.\scripts\vscode.exe  /VERYSILENT /NORESTARTAPPLICATIONS

:SETUP_EXTENSION
for %%a in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist %%a:\nul (
        pushd %%a:\
        echo 搜索 %%a 盘
        for /r %%b in ("*Code.exe") do (
            if "%%~nxb" equ "Code.exe" (
				echo VSCode已安装
				set vscode_exe=%%b
				call %~dp0.\scripts\link.bat
				set vscode_path=%%~pdb.\bin\code
				echo 开始安装vscode插件
				start /wait %~dp0.\scripts\install-vscode-extension.bat -s
				echo vscode插件安装完成	
				goto end
            )
        )
        popd
    )
)

:end
echo 安装完成！！
rem start https://prod.pandateacher.com/python-manuscript/user-install-manual/windows.html
