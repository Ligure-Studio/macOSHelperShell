echo '欢迎使用MacOS Helper Shell'
echo '由明燊开发,在github开源,禁止付费站点转载'
echo -e "\033[31m Beta 0.0.01 \033[0m"
echo '请选择功能:'
echo '[1].开启"全部来源"'
echo '[2].移除隔离属性(解决"已损坏问题")'
echo '[3].将Dock重置为默认'
echo '[4].清楚缩略图缓存(适用于缩略图被抢)'
echo '[5].安装Homebrew'
echo '[6].查看硬盘容量(需安装支持软件)'
echo '[n].退出'
read inputNumber
if [ "$inputNumber" == '1' ]
then
    sudo spctl --master-disable
    exit 0
elif [ "$inputNumber" == '2' ]
then
    echo '请输入软件路径(可将软件拖进终端)'
    read appPath
    sudo xattr -r -d com.apple.quarantine $appPath
    exit 0
elif [ "$inputNumber" == '3' ]
then
    echo '你真的确认要操作吗?'
    echo '操作后Dock将重置为出厂设置且无法恢复'
    echo '输入y以执行'
    read yOrNot
    if [ '$yOrNot' == 'y' ]; then
        defaults delete com.apple.dock; killall Dock
    fi
    sleep 5
    exit 0
elif [ "$inputNumber" == '4' ]
then
    sudo find /private/var/folders/ \( -name com.apple.dock.iconcache -or -name com.apple.iconservices \) -exec rm -rfv {} \;
    sudo rm -rf /Library/Caches/com.apple.iconservices.store;
    killall Dock
    killall Finder
    sleep 5
    exit 0
elif [ "$inputNumber" == '5' ]
then
    echo '默认已进行换源'
     HOMEBREW_CORE_GIT_REMOTE=https://mirrors.ustc.edu.cn/homebrew-core.git
    /bin/bash -c "$(curl -fsSL https://cdn.jsdelivr.net/gh/ineo6/homebrew-install/install.sh)"
        sleep 5
    exit 0
elif [ "$inputNumber" == '6' ]
then
    echo '请确认已安装homebrew(若未安装重新打开输入5即可)'
    brew install smartmontools
    smartctl -a disk0
fi
echo '开源地址:https://github.com/FANChenjia/MacOSHelperShell'
echo -e "\033[34m 欢迎反馈问题或建议到 mingshen.work@ligure.eu.org,我会持续跟进 \033[0m"
sleep 5
exit 0
