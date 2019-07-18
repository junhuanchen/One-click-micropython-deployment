@echo off
%1 %2 
ver|find "5.">nul&&goto :st 
mshta vbscript:createobject("shell.application").shellexecute("%~s0","goto :st","","runas",1)(window.close)&goto :eof 
:st 
copy "%~0" "%windir%\system32\" 
:: %1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
CLS
echo ***************************************************************************
echo **                           Python һ����װ�ű�                         **
echo **                                                                       **
echo **                         �簲װ���ɹ������ٴ�ִ��                      **
echo **                                                                       **
echo **                     ���������Python�����߰�װpythonʹ��              **
echo ***************************************************************************
@ping 127.0.0.1 -n 2 >nul
set setup_flag=0

echo ���ڼ��python�����Ժ�...
for /f "delims=" %%t in ('python -V') do set str=%%t
echo %str% | find /c /i "python 3." >nul && set py_installed=1 || set py_installed=0
if %py_installed% equ 1 (
	echo python3�Ѱ�װ����ʼ����pip
	call %~dp0.\scripts\pip-upgrade.bat
	goto SETUP_VSCODE
)

echo ��ʼ���أ����Ժ󡣡���
start  /wait %~dp0.\scripts\download.bat  -s
echo �������

:SETUP
echo ��ʼ�Զ���װ�������ĵȺ�����رձ����ڣ�������
start /wait %~dp0.\scripts\PythonInstaller.exe /quiet  InstallAllUsers=1 PrependPath=1
set setup_flag=1

:SEARCH
set "FileName=python3.dll"
echo ���ڼ���Ƿ��Ѱ�װpython�����Ժ�...
for %%a in (C D E F) do (
    if exist %%a:\nul (
        pushd %%a:\
		echo ���� %%a ��
        for /r %%b in ("*%FileName%") do (
            if /i "%%~nxb" equ "%FileName%" (
				echo �ҵ���װĿ¼%%~pdb
                set python_path=%%~pdb
				cd %%~pdb
				call %~dp0.\scripts\pip-upgrade.bat
				goto SETUP_VSCODE
            )
        )
		popd
    )
)


:SETUP_VSCODE
echo ��ʼ����Ƿ�װvscode
for /f "delims=" %%t in ('code -v') do set str2=%%t
echo %str2% | findstr /r "[1-9]." >nul && set code_installed=1 || set code_installed=0
if %code_installed% equ 1 ( goto SETUP_EXTENSION )

@rd /S /Q %userprofile%\AppData\Roaming\Code
@rd /S /Q %userprofile%\.vscode
start /wait %~dp0.\scripts\download-vscode.bat -s
echo ���ڰ�װvscode�������ĵȺ�
call %~dp0.\scripts\vscode.exe  /VERYSILENT /NORESTARTAPPLICATIONS


:SETUP_EXTENSION
for %%a in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist %%a:\nul (
        pushd %%a:\
        echo ���� %%a ��
        for /r %%b in ("*Code.exe") do (
            if "%%~nxb" equ "Code.exe" (
				echo VSCode�Ѱ�װ
				set vscode_exe=%%b
				call %~dp0.\scripts\link.bat
				set vscode_path=%%~pdb.\bin\code
				echo ��ʼ��װvscode���
				start /wait %~dp0.\scripts\install-vscode-extension.bat -s
				echo vscode�����װ���
				goto END
            )
        )
        popd
    )
)

:END
echo ��װ���
rem start https://prod.pandateacher.com/python-manuscript/user-install-manual/windows.html
