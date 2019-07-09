@echo off
for %%a in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist %%a:\nul (
        pushd %%a:\
        echo 搜索 %%a 盘
        for /r %%b in ("*Code.exe") do (
            if "%%~nxb" equ "Code.exe" (
				start  /d "%%~pdb" Code.exe  %~dp0..\lessons
				echo 开始添加右键菜单
				rem 增加右键打开文件
				set openfilemsg="使用VSCode编辑(&Q)"
				set opendirmsg="使用VSCode打开文件夹(&Q)"
				set vsdir=%%b
				REG ADD HKCR\Directory\shell\VSCode         /F /t REG_EXPAND_SZ /ve      /d "使用VSCode打开文件夹(&Q)"
				REG ADD HKCR\Directory\shell\VSCode         /F /t REG_EXPAND_SZ /v Icon  /d "%%b"
				REG ADD HKCR\Directory\shell\VSCode\command /F /t REG_EXPAND_SZ /ve      /d "\"%%b\" \"%%V\""

				REG ADD HKCR\Directory\Background\shell\VSCode         /F /t REG_EXPAND_SZ /ve      /d "使用VSCode打开文件夹(&Q)"
				REG ADD HKCR\Directory\Background\shell\VSCode         /F /t REG_EXPAND_SZ /v Icon  /d "%%b"
				REG ADD HKCR\Directory\Background\shell\VSCode\command /F /t REG_EXPAND_SZ /ve      /d "\"%%b\" \"%%V\""

				REG ADD HKCR\*\shell\VSCode         /F /t REG_EXPAND_SZ /ve     /d "使用VSCode编辑(&Q)"
				REG ADD HKCR\*\shell\VSCode         /F /t REG_EXPAND_SZ /v Icon /d "%%b"
				REG ADD HKCR\*\shell\VSCode\command /F /t REG_EXPAND_SZ /ve     /d "\"%%b\" \"%%1\""
				echo 开始安装vscode插件，请勿关闭本窗口
				rem %%~pdb\bin\code --install-extension  %~dp0.\python.vsix --force
				%%~pdb\bin\code --install-extension ms-python.python
				%%~pdb\bin\code --install-extension  ms-ceintl.vscode-language-pack-zh-hans --force
				%%~pdb\bin\code --install-extension junhuanchen.mpfshell
				echo VSCode插件安装完成
				@taskkill /f /im Code.exe
				exit
            )
        )
        popd
    )
)
echo 未安装vscode
pause
