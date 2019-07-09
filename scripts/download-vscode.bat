@echo off
set destination="%~dp0.\vscode.exe"
if exist %destination% exit
:DOWNLOAD
if /i "%PROCESSOR_IDENTIFIER:~0,3%"=="x86" (
    echo 开始下载32位系统安装程序，请耐心等待。。。
    @ping 127.0.0.1 -n 2 >nul
    bitsadmin.exe /transfer "vscode"  /download /priority foreground https://vscode.cdn.azure.cn/stable/5f24c93878bd4bc645a4a17c620e2487b11005f9/VSCodeSetup-ia32-1.29.0.exe  %destination%
) else (
    echo 开始下载64位系统安装程序，请耐心等待。。。
    @ping 127.0.0.1 -n 2 >nul
    bitsadmin.exe /transfer "vscode" /download /priority foreground https://vscode.cdn.azure.cn/stable/5f24c93878bd4bc645a4a17c620e2487b11005f9/VSCodeSetup-x64-1.29.0.exe  %destination%
)
exit