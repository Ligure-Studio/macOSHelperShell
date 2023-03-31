#!/bin/bash
echo '====欢迎使用macOS Helper Shell===='
echo '😁由Ligure Studio团队维护,基于 MIT LICENSE 开源。'
echo '👍开源地址:https://github.com/Ligure-Studio/macOSHelperShell'
echo '❗️为保证功能顺利运行,请在出现Password提示时输入您电脑的开机密码(密码不会在界面上显示)'
echo  "\033[31m 0.1.1-beta4(classified-unstable) \033[0m"
echo '------------------------------'
sleep 1

# ===安装Homebrew函数===

function installBrew {
    echo '❓首先我们要检测你是否安装Xcode CLT.'
    if xcode-select -p &> /dev/null; then
        echo "✅你已经安装了Xcode CLT.接下来我们将为您安装Homebrew.😁"
        export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
        export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
        export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
        echo '👍默认已进行换源'
        git clone --depth=1 https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/install.git brew-install
        /bin/bash brew-install/install.sh
        rm -rf brew-install
        export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
        brew update
        export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
        for tap in core cask{,-fonts,-drivers,-versions} command-not-found; do
        brew tap --custom-remote --force-auto-update "homebrew/${tap}" "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-${tap}.git"
        done
        brew update
        test -r ~/.bash_profile && echo 'export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"' >> ~/.bash_profile  # bash
        test -r ~/.bash_profile && echo 'export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"' >> ~/.bash_profile
        test -r ~/.profile && echo 'export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"' >> ~/.profile
        test -r ~/.profile && echo 'export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"' >> ~/.profile

        test -r ~/.zprofile && echo 'export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"' >> ~/.zprofile  # zsh
        test -r ~/.zprofile && echo 'export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"' >> ~/.zprofile
    else
        echo "❌您没有安装Xcode CLT,是否安装Xcode CLT?(y/n)"
        read yOrNot
        if [ $yOrNot == "y" ] || [ $yOrNot == "Y" ]; then
            echo '⏩开始安装Xcode CLT'
            xcode-select --install
           echo '👌🏻理论上来讲你应该已经安装成功了,或者你已经安装过了(报error: command line tools are already installed错误).'
           echo '🤔如果报其他错(error),那多半是网络问题,请访问 https://developer.apple.com/download/all/ 登录您的Apple ID,然后手动下载.😁'
           echo '😀请再次尝试安装Homebrew.'
        else
           echo '❎将不会安装Xcode CLT和Homebrew'
        fi
    fi
}

#===安装Homebrew函数结束===

#===系统功能函数===

function OSFunction {
    echo '[1].开启"全部来源"'
    echo '[2].关闭"全部来源"'
    echo '[3].清除软件隔离属性(解决"已损坏"问题)'
    echo '[4].开启/关闭通过刷指纹验证sudo'
    echo '[5].将Dock栏恢复出厂设置'
    echo '[6].刷新缩略图(适用于缩略图被抢)'
    echo '[7].下载macOS'
    echo '[8].制作macOS可引导安装盘（没写完）'
    echo '[n].退出'
    read OSInputNumber #OS部分输入参数
    if [ "$OSInputNumber" == '1' ]
    then
        sudo spctl --master-disable
        echo '✅已完成'
    elif [ "$OSInputNumber" == '2' ]
    then
       sudo spctl --master-enable
        echo '✅已完成'
    elif [ "$OSInputNumber" == '3' ]
    then
        echo '😀请输入软件路径(可将软件拖进终端)👉'
        read appPath
        sudo xattr -r -d com.apple.quarantine $appPath
        echo '✅已完成'
    elif [ "$OSInputNumber" == '4' ]
    then
        echo '😀正在检测是否已经开启本功能……'
        status=$(sudo cat /etc/pam.d/sudo)
        if [[ $status == *"pam_tid.so"* ]]; then
            echo "🤔似乎已开启该功能, 是否需要关闭?(y/n)"
            read yOrNot
            if [ $yOrNot == "y" ] || [ $yOrNot == "Y" ]; then
                sed -i '' "/pam_tid.so/d" /etc/pam.d/sudo
                echo '✅已关闭'
            else
                echo '❎将不会关闭'
            fi
        else
            echo "👌没有开启该功能, 正在开启……"
            sudo sed '1i auth       sufficient     pam_tid.so' /etc/pam.d/sudo
            echo "✅已打开"
        fi
    elif [ "$OSInputNumber" == '5' ]
    then
        echo '⚠️ 你真的确认要操作吗?'
        echo '⚠️ 操作后Dock将重置为出厂设置且无法恢复!'
        echo '🤔是否仍然执行?(y/n)'
        read yOrNot
        if [ $yOrNot == "y" ] || [ $yOrNot == "Y" ]; then
            defaults delete com.apple.dock; killall Dock
            echo '✅已完成'
        else
            echo '❎将不会重置Dock'
        fi
    elif [ "$OSInputNumber" == '6' ]
    then
        sudo find /private/var/folders/ \( -name com.apple.dock.iconcache -or -name com.apple.iconservices \) -exec rm -rfv {} \;
        sudo rm -rf /Library/Caches/com.apple.iconservices.store;
        killall Dock
        killall Finder
        echo '✅已完成'
    elif [ "$OSInputNumber" == '7' ]
    then
        echo '选择系统版本后将会打开App Store，您可自行点击“获取”进行下载。'
        echo '请选择你要下载的版本（过于老旧的版本此处不提供）：'
        sleep 1
        echo '[1].Ventura 13'
        echo '[2].Monterey 12'
        echo '[3].Big Sur 11'
        echo '[4].Catalina 10.15'
        echo '[5].Mojave 10.14'
        echo '[6].High Sierra 10.13'
        echo '[n].退出'
        read OSVerNumber
        if [ "$OSVerNumber" == '1' ];then
            open 'macappstores://apps.apple.com/app/macos-ventura/id1638787999'
            OSFunction
        elif [ "$OSVerNumber" == '2' ];then
            open 'macappstores://apps.apple.com/app/macos-monterey/id1576738294'
            OSFunction
        elif [ "$OSVerNumber" == '3' ];then
            open 'macappstores://apps.apple.com/app/macos-big-sur/id1526878132'
            OSFunction
        elif [ "$OSVerNumber" == '4' ];then
            open 'macappstores://apps.apple.com/app/macos-catalina/id1466841314'
            OSFunction
        elif [ "$OSVerNumber" == '5' ];then
            open 'macappstores://apps.apple.com/app/macos-mojave/id1398502828'
            OSFunction
        elif [ "$OSVerNumber" == '6' ];then
            open 'macappstores://apps.apple.com/app/macos-high-sierra/id1246284741'
            OSFunction
        elif [ "$OSVerNumber" == 'n' ];then
            OSFunction
        else
            echo '❌输入错误!'
        fi
    elif [ "$OSInputNumber" == '8' ];then
        echo '⚠️ 使用此功能需要先下载相应版本的macOS，如果您没下载，请重进脚本，使用“一般系统功能”→“[7].下载macOS”功能进行下载。'
        echo '⚠️ 您需要准备一个至少14GB的U盘，且一旦开始制作，您U盘里的所有数据就会全部清空，请慎重决定！'
        echo '没搞完，睡觉了😴'
    elif [ "$OSInputNumber" == 'n' ]
    then
        main
    else
        echo '❌输入错误!'
    fi
}

#===系统功能函数结束===


#===常用开发库安装函数===

function devTools {
    echo '[1].安装Xcode CLT(因国内网络问题,可能等待时间较长或安装失败)'
    echo '[2].安装Homebrew(耗时可能有点长,请耐心等待,已经装过就不用装了)'
    echo '[n].退出'
    read DevInputNumber #Dev部分输入参数
    if [ "$DevInputNumber" == '1' ]
    then
        xcode-select --install
        echo '👌🏻理论上来讲你应该已经安装成功了,或者你已经安装过了(报error: command line tools are already installed错误).'
        echo '🤔如果报其他错(error),那多半是网络问题,请访问 https://developer.apple.com/download/all/ 登录您的Apple ID,然后手动下载.😁'
    elif [ "$DevInputNumber" == '2' ]
    then
        if which brew >/dev/null; then
            echo '✅你已经安装过了,无需重复安装!'
        else
            installBrew
        fi
    elif [ "$DevInputNumber" == 'n' ]
    then
        main
    else
        echo '❌输入错误!'
    fi
}

#===常用开发库安装函数结束===


#===高级系统功能函数===

function hyperOSFunction {
    echo '[1].查看硬盘读写数据(需安装支持软件)'
    echo '[2].查询SIP开关状态'
    echo '[n].退出'
    read hyperInputNumber #Hyper部分输入参数
    if [ "$hyperInputNumber" == '1' ]
    then
        if which smartctl >/dev/null; then
            echo "✅你已安装smartmontools,下面为你查询硬盘数据。😁"
            smartctl -a disk0
        else
            echo "❌看起来你没有安装smartmontools。为了更好地实现相关功能,我们首先需要安装smartmontools。在安装smartmontools之前,我们需要确认您已经安装了Homebrew。接下来我们会自动检测。"
            if which brew >/dev/null; then
                echo "✅您安装了Homebrew。我们将会通过brew安装smartmontools。😁"
                echo "👍smartmotools是macOS上的一个小工具,可以用来查询硬盘数据,不会弄坏您的电脑。你是否要安装smartmontools?(y/n)"
                read answer
                if [ $answer == "y" ] || [ $answer == "Y" ]; then
                    brew install smartmontools
                    echo "✅看起来您应该成功安装了smartmontools.🎉下面为你查询硬盘数据.😁"
                    smartctl -a disk0
                else
                    echo "❎您没有输入y,我们将不会为您安装smartmontools,您的电脑没有遭到修改,感谢您的使用.😁"
                fi
            else
                echo '❌您没有安装brew,是否安装Homebrew?(y/n)'
                read yOrNot
                if [ $yOrNot == "y" ] || [ $yOrNot == "Y" ]; then
                    installBrew
                else
                    echo "❎将不会安装Homebrew和smartmontools"
                fi
            fi
        fi
     elif [ "$hyperInputNumber" == '2' ]
     then
        status=$(csrutil status)
        if [[ $status == *"enabled"* ]]; then
            echo "✅您已打开SIP!"
        else
            echo "❌您已关闭SIP!"
        fi
    elif [ "$hyperInputNumber" == 'n' ]
    then
        main
    else
        echo '❌输入错误!'
    fi
}

function verifyTools {
    echo '[1].md5校验'
    echo '[2].sha256校验'
    echo '[3].sha512校验'
    echo '[4].sha1校验'
    echo '[5].crc32校验(需安装支持软件)'
    echo '[6].比对实用工具(区分大小写)'
    echo '[7].比对实用工具(不区分大小写)'
    echo '[n].退出'
    read verifyInputNumber #Verify部分输入参数
    if [ "$verifyInputNumber" == '1' ]
    then
        echo '请将要校验的文件拖到终端窗口'
        read md5Path
        md5 $md5Path
        echo '✅校验完成!'
    elif [ "$verifyInputNumber" == '2' ]
    then
        echo '请将要校验的文件拖到终端窗口'
        read sha256Path
        shasum -a 256 $sha256Path
        echo '✅检验完成!'
    elif [ "$verifyInputNumber" == '3' ]
    then
        echo '请将要校验的文件拖到终端窗口'
        read sha512Path
        shasum -a 512 $sha512Path
        echo '✅检验完成!'
    elif [ "$verifyInputNumber" == '4' ]
    then
        echo '请将要校验的文件拖到终端窗口'
        read sha1Path
        shasum -a 1 $sha1Path
        echo '✅检验完成!'
    elif [ "$verifyInputNumber" == '5' ]
    then
        if which cksfv >/dev/null; then
            echo "✅你已安装cksfv,下面请拖入要校验的文件到终端窗口.😁"
            read crc32Path
            cksfv $crc32Path
            echo '✅校验完成'
        else
            echo "❌看起来你没有安装cksfv。为了更好地实现相关功能,我们首先需要安装cksfv.在安装cksfv之前,我们需要确认您已经安装了Homebrew."
            if which brew >/dev/null; then
                echo "✅您安装了Homebrew.我们将会通过brew安装cksfv.😁"
                echo "👍cksfv是macOS上的一个小工具,可以用来校验crc32,不会弄坏您的电脑。你是否要安装cksfv?(y/n)"
                read answer
                if [ $answer == "y" ] || [ $answer == "Y" ]; then
                    brew install cksfv
                    echo "✅看起来您应该成功安装了cksfv🎉.下面请拖入要校验的文件到终端窗口.😁"
                    read crc32Path1
                    cksfv $crc32Path1
                else
                    echo "❎您没有输入y,我们将不会为您安装cksfv,您的电脑没有遭到修改,感谢您的使用.😁"
                fi
            else
                echo '❌您没有安装brew,是否安装Homebrew?(y/n)'
                read yOrNot
                if [ $yOrNot == "y" ] || [ $yOrNot == "Y" ]; then
                    installBrew
                else
                    echo "❎将不会安装Homebrew和cksfv"
                fi
            fi
        fi
    elif [ "$verifyInputNumber" == '6' ]
    then
        echo '请输入第一个值'
        read key111
        echo '请输入第二个值'
        read key222
        if [ $key111 == $key222 ]; then
            echo '✅比对通过,两者一致!'
        else
            echo '❌比对不通过,两者不一致!'
        fi
    elif [ "$verifyInputNumber" == '7' ]
    then
        echo '请输入第一个值'
        read key111
        echo '请输入第二个值'
        read key222
        key111=`echo $key111 | tr '[:upper:]' '[:lower:]'`
        key222=`echo $key222 | tr '[:upper:]' '[:lower:]'`
        if [ $key111 == $key222 ]; then
            echo '✅比对通过,两者一致!'
        else
            echo '❌比对不通过,两者不一致!'
        fi
    elif [ "$verifyInputNumber" == 'n' ]
    then
        main
    else
        echo '❌输入错误!'
    fi
}


#===高级系统功能函数结束===


#===软件修复专区函数===

function fixTools {
    echo '[1].修复Sideloadly!的Local Anisette在macOS 13.1以上无法使用的问题'
    echo '[2].软件签名,修复破解软件无法使用的问题'
    echo '[n].退出'
    read fixInputNumber #fix部分输入参数
    if [ "$fixInputNumber" == '1' ]
    then
        if xcode-select -p &> /dev/null; then
            echo "✅你已经安装了Xcode CLT.接下来我们将为您修复.😁"
            for loop in 13.1 13.2 13.3 13.4 13.5 13.6 13.7 13.8 13.9
            do
            Arraykey="Supported${loop}PluginCompatibilityUUIDs"
            echo $Arraykey
            sudo /usr/libexec/PlistBuddy -c "Add :$Arraykey array" /Library/Mail/Bundles/SideloadlyPlugin.mailbundle/Contents/Info.plist
            sudo /usr/libexec/PlistBuddy -c "Add :$Arraykey: string 25288CEF-7D9B-49A8-BE6B-E41DA6277CF3" /Library/Mail/Bundles/SideloadlyPlugin.mailbundle/Contents/Info.plist
            sudo /usr/libexec/PlistBuddy -c "Add :$Arraykey: string 6FF8B077-81FA-45A4-BD57-17CDE79F13A5" /Library/Mail/Bundles/SideloadlyPlugin.mailbundle/Contents/Info.plist
            sudo /usr/libexec/PlistBuddy -c "Add :$Arraykey: string A4B49485-0377-4FAB-8D8E-E3B8018CFC21" /Library/Mail/Bundles/SideloadlyPlugin.mailbundle/Contents/Info.plist
            sudo /usr/libexec/PlistBuddy -c "Add :$Arraykey: string 890E3F5B-9490-4828-8F3F-B6561E513FCC" /Library/Mail/Bundles/SideloadlyPlugin.mailbundle/Contents/Info.plist
            done
            sudo codesign -f -s - /Library/Mail/Bundles/SideloadlyPlugin.mailbundle
        else
            echo "❌您没有安装Xcode CLT,是否安装Xcode CLT?(y/n)"
            read yOrNot
            if [ $yOrNot == "y" ] || [ $yOrNot == "Y" ]; then
                echo '⏩开始安装Xcode CLT'
                xcode-select --install
                echo '👌🏻理论上来讲你应该已经安装成功了,或者你已经安装过了(报error: command line tools are already installed错误).'
                echo '🤔如果报其他错(error),那多半是网络问题,请访问 https://developer.apple.com/download/all/ 登录您的Apple ID,然后手动下载.😁'
                echo '😀请再次尝试修复.'
            else
                echo '❎将不会安装Xcode CLT和修复'
            fi
        fi
    elif [ "$fixInputNumber" == '2' ]
    then
        if xcode-select -p &> /dev/null; then
            echo "✅你已经安装了Xcode CLT.接下来我们将为您修复.😁"
            echo "请将你的app拖进来"
            read appPathInput 
            sudo codesign -f -s - "${appPathInput}" && \
            echo "✅你已成功软件签名.😁"
        else
            echo "❌您没有安装Xcode CLT,是否安装Xcode CLT?(y/n)"
            read yOrNot
            if [ $yOrNot == "y" ] || [ $yOrNot == "Y" ]; then
                echo '⏩开始安装Xcode CLT'
                xcode-select --install
                echo '👌🏻理论上来讲你应该已经安装成功了,或者你已经安装过了(报error: command line tools are already installed错误).'
                echo '🤔如果报其他错(error),那多半是网络问题,请访问 https://developer.apple.com/download/all/ 登录您的Apple ID,然后手动下载.😁'
                echo '😀请再次尝试修复.'
            else
                echo '❎将不会安装Xcode CLT和修复'
            fi
        fi
    elif [ "$fixInputNumber" == 'n' ]
    then
        main
    else
        echo '❌输入错误!'
    fi
}

#===软件修复专区函数结束===


#===主函数===

function main {
    echo '请选择功能:'
    echo '[1].一般系统功能'
    echo '[2].开发库一键安装'
    echo '[3].进阶系统功能'
    echo '[4].校验专区'
    echo '[5].软件修复专区'
    echo '[n].退出'
    read MainInputNumber
    if [ "$MainInputNumber" == '1' ]
    then
    OSFunction
    elif [ "$MainInputNumber" == '2' ]
    then
    devTools
    elif [ "$MainInputNumber" == '3' ]
    then
    hyperOSFunction
    elif [ "$MainInputNumber" == '4' ]
    then
    verifyTools
    elif [ "$MainInputNumber" == '5' ]
    then
    fixTools
    elif [ "$MainInputNumber" == 'n' ]
    then
        echo '👍开源地址:https://github.com/Ligure-Studio/MacOSHelperShell'
        echo "\033[34m欢迎反馈问题或建议到 service@ligure.cn ,我们会持续跟进 \033[0m"
        sleep 1
        exit 0
    else
        echo '❌输入错误!'
    fi
    main
}

#===主函数===



#===执行主函数===

main

#===执行主函数===
