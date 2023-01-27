echo '====欢迎使用MacOS Helper Shell===='
echo '😁由明燊、小叶、Jerry共同开发和维护,在github开源,禁止马克喵和其他付费站点转载!'
echo '👍开源地址:https://github.com/FANChenjia/MacOSHelperShell'
echo '🤔如果遇到“Password”提示,请放心输入你电脑开机密码.脚本已经开源,不会上传数据.'
echo  "\033[31m 0.0.3-beta \033[0m"
echo '------------------------------'
sleep 1
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
           echo '😀请再次输入6尝试安装Homebrew.'
        else
           echo '❎将不会安装Xcode CLT和Homebrew'
        fi
    fi
}
function main {
    echo '请选择功能:'
    echo '[1].开启"全部来源"'
    echo '[2].移除隔离属性(解决"已损坏问题")'
    echo '[3].将Dock重置为默认'
    echo '[4].清除缩略图缓存(适用于缩略图被抢)'
    echo '[5].安装Xcode CLT(因国内网络问题,可能等待时间较长或安装失败)'
    echo '[6].安装Homebrew(耗时可能有点长,请耐心等待,已经装过就不用装了)'
    echo '[7].查看硬盘读写数据(需安装支持软件)'
    echo '[8].查询SIP开关状态'
    echo '[n].退出'
    read inputNumber
    if [ "$inputNumber" == '1' ]
    then
        sudo spctl --master-disable
        echo '✅已完成'
    elif [ "$inputNumber" == '2' ]
    then
        echo '😀请输入软件路径(可将软件拖进终端)👉'
        read appPath
        sudo xattr -r -d com.apple.quarantine $appPath
        echo '✅已完成'
    elif [ "$inputNumber" == '3' ]
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
    elif [ "$inputNumber" == '4' ]
    then
        sudo find /private/var/folders/ \( -name com.apple.dock.iconcache -or -name com.apple.iconservices \) -exec rm -rfv {} \;
        sudo rm -rf /Library/Caches/com.apple.iconservices.store;
        killall Dock
        killall Finder
        echo '✅已完成'
    elif [ "$inputNumber" == '5' ]
    then
        xcode-select --install
        echo '👌🏻理论上来讲你应该已经安装成功了,或者你已经安装过了(报error: command line tools are already installed错误).'
        echo '🤔如果报其他错(error),那多半是网络问题,请访问 https://developer.apple.com/download/all/ 登录您的Apple ID,然后手动下载.😁'
    elif [ "$inputNumber" == '6' ]
    then
        if which brew >/dev/null; then
            echo '✅你已经安装过了,无需重复安装!'
        else
            installBrew
        fi
    elif [ "$inputNumber" == '7' ]
    then
        if which smartctl >/dev/null; then
            echo "✅你已安装smartmontools,下面为你查询硬盘数据。😁"
            smartctl -a disk0
        else
            echo "❌看起来你没有安装smartmontools。为了更好地实现相关功能,我们首先需要安装smartmontools。在安装smartmontools之前,我们需要确认您已经安装了Homebrew。接下来我们会自动检测。"
            if which brew >/dev/null; then
                echo "✅您安装了Homebrew。我们将会通过brew安装smartmontools。😁"
                echo "👍smartmotools是MacOS上的一个小工具,可以用来查询硬盘数据,不会弄坏您的电脑。你是否要安装smartmontools?(y/n)"
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
     elif [ "$inputNumber" == '8' ]
     then
         status=$(csrutil status)
         if [[ $status == *"enabled"* ]]; then
             echo "✅您已打开SIP!"
         else
             echo "❌您已关闭SIP!"
         fi
    elif [ "$inputNumber" == 'n' ]
    then
        echo '👍开源地址:https://github.com/FANChenjia/MacOSHelperShell'
        echo "\033[34m欢迎反馈问题或建议到 mingshen.work@ligure.eu.org,我会持续跟进 \033[0m"
        sleep 1
        exit 0
    fi
    main
}
main

