# 在Debian上搭建Termux包的编译环境

#### 根据 [Termux 官方包编译环境搭建脚本](https://github.com/termux/termux-packages/tree/master/scripts) 改造而来，已在Debian 9 测试通过。
#### 仅仅是将 setup-ubuntu.sh setup-android-sdk.sh properties.sh 脚本融合为一个脚本。

#### 通过在用户根目录（$HOME）执行 ./setup-termux-build.sh 来自动搭建Termux包编译环境。

#### 在 packages 目录里有一些兼容Termux的可编译包。

# 错误：

1. `mv: cannot move '/home/xxx/.termux-build/_cache/18-aarch64-21-v4-tmp' to '/home/xxx/.termux-build/_cache/18-aarch64-21-v4': Permission denied`
2. 手动执行 `mv /home/xxx/.termux-build/_cache/18-aarch64-21-v4-tmp /home/xxx/.termux-build/_cache/18-aarch64-21-v4` 即可

#### 更新于2019.02.06
