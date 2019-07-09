@echo off
set destination="%~dp0.\PythonInstaller.exe"
if exist %destination% exit
:DOWNLOAD
if /i "%PROCESSOR_IDENTIFIER:~0,3%"=="X86" (
    echo 开始下载32位系统安装程序，请耐心等待。。。
    @ping 127.0.0.1 -n 2 >nul
    bitsadmin.exe /transfer "python3"  /download /priority foreground http://acdnbase.pandateacher.com/software/python-3.7.1.exe  %destination%
) else (
    echo 开始下载64位系统安装程序，请耐心等待。。。
    @ping 127.0.0.1 -n 2 >nul
    bitsadmin.exe /transfer "python3" /download /priority foreground http://acdnbase.pandateacher.com/software/python-3.7.1-amd64.exe  %destination%
)
exit