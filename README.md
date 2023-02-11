<h4 align="right"><strong>中文</strong> | <a href="https://github.com/Ligure-Studio/MacOSHelperShell/blob/main/README_EN.md">English</a></h4>
<p align="center">
    <img src="./assets/logo.jpg" width=280/>
</p>
<h1 align="center">MacOSHelperShell</h1>
<div align="center">   
  <img src="https://img.shields.io/github/stars/Ligure-Studio/MacOSHelperShell?label=Stars" alt="GitHub Stars"/>
  <img src="https://img.shields.io/github/forks/Ligure-Studio/MacOSHelperShell?label=Forks" alt="GitHub Forks"/> 
  <a href="https://github.com/Ligure-Studio/MacOSHelperShell/releases" target="_blank">
    <img src="https://img.shields.io/github/v/release/Ligure-Studio/MacOSHelperShell?display_name=tag" alt="GitHub Release"/></a>
</div>




一款简单易用的macOS帮助脚本，可以便捷的实现一些功能。

该脚本由[明燊](https://github.com/FANChenjia)、[小叶](https://github.com/yeenjie123456)、[Jerry](https://github.com/Jerry-XU1010)共同开发和维护，非常好用，具体怎么好用你用了就知道了。

---

## 功能

| 序号 | 功能                                                         | 备注 |
| ---- | ------------------------------------------------------------ | ---- |
| 1    | 开启"全部来源"                                               |      |
| 2    | 移除隔离属性(解决"已损坏问题")                               |      |
| 3    | 将Dock重置为默认                                             |      |
| 4    | 开启/关闭通过刷指纹验证sudo                                  |      |
| 5    | 清除缩略图缓存(适用于缩略图被抢)                             |      |
| 6    | 安装Xcode CLT(因国内网络问题,可能等待时间较长或安装失败)     |      |
| 7    | 安装Homebrew(耗时可能有点长,请耐心等待,已经装过就不用装了)   |      |
| 8    | 查看硬盘读写数据(需安装支持软件)                             |      |
| 9    | 查询SIP开关状态                                              |      |
| 10   | 文件校验                                                     |      |
| 11   | 修复Sideloadly!的Local Anisette在macOS 13.1以上无法使用的问题 |      |
|      | 请期待更多新功能……                                           |      |



## 使用方法
# 推荐使用Beta版，体验新功能！Stable版一般适用于无法经常联网更新的用户。

### 1、终端快速使用（需联网）

直接复制粘贴以下命令到终端，然后回车：


```shell
curl -L https://raw.githubusercontent.com/Ligure-Studio/MacOSHelperShell/main/OSHelper_Stable.sh -O && sh OSHelper_Stable.sh
```

如果你是中国大陆用户，遇到网络问题难以使用上述命令，请使用下面的命令：

```shell
curl -L https://ghproxy.com/https://raw.githubusercontent.com/Ligure-Studio/MacOSHelperShell/main/OSHelper_Stable.sh -O && sh OSHelper_Stable.sh
```

beta版：


```shell
curl -L https://raw.githubusercontent.com/Ligure-Studio/MacOSHelperShell/main/OSHelper_Beta.sh -O && sh OSHelper_Beta.sh
```

beta版（国内）：


```shell
curl -L https://ghproxy.com/https://raw.githubusercontent.com/Ligure-Studio/MacOSHelperShell/main/OSHelper_Beta.sh -O && sh OSHelper_Beta.sh
```

>🚀优点：无需手动下载文件，每次使用都保证是最新版。

### 2、下载sh文件使用

[右键另存为](https://raw.githubusercontent.com/Ligure-Studio/MacOSHelperShell/main/OSHelper_Stable.sh)

[右键另存为（国内）](https://ghproxy.com/https://raw.githubusercontent.com/Ligure-Studio/MacOSHelperShell/main/OSHelper_Stable.sh)

[右键另存为（beta）](https://raw.githubusercontent.com/Ligure-Studio/MacOSHelperShell/main/OSHelper_Beta.sh)

[右键另存为（beta国内）](https://raw.githubusercontent.com/Ligure-Studio/MacOSHelperShell/main/OSHelper_Beta.sh)

使用方法：

```shell
sh /PATH（你的实际文件路径）/OSHelper.sh
```

也可以直接先在终端输入sh，然后打个空格，然后把你下载的文件拖进终端窗口。

>🚀优点：离线使用，版本手动更新。

### 3、下载release中的dmg使用 **（暂未更新，先别用）**

[点我进入release](https://github.com/Ligure-Studio/MacOSHelperShell/releases)

>🚀优点：使用方便。

待完善……
