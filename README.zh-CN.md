<p align="center">
  <a href="https://himitsushell.com/" target="blank"><img src="https://avatars.githubusercontent.com/u/264618628?s=200&v=4" width="100" alt="HimitsuShell Logo" /></a>
</p>
<p align="center">
  <a href="https://github.com/HimitsuShell/Himitsu/releases"><img src="https://img.shields.io/github/v/release/HimitsuShell/Himitsu?color=2da44e" alt="Latest Release" /></a>
  <a href="https://github.com/HimitsuShell/Himitsu/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-PolyForm%20NC-blue" alt="PolyForm Noncommercial 1.0.0 License" /></a>
  <a href="https://github.com/HimitsuShell/Himitsu/releases"><img src="https://img.shields.io/github/downloads/HimitsuShell/Himitsu/total.svg" alt="GitHub Total Downloads" /></a>
</p>

> 翻译版本，错误请提 Issue。

**README:** [English](README.md) | [中文](README.zh-CN.md) | [日本語](README.ja.md)

# HimitsuShell
即使在内核级追踪下也无法被察觉的 Shell 脚本。

将 shell 脚本转换为包含内置解释器、基于 LLVM 的混淆及反调试保护的单一静态二进制文件（shc 的替代方案）。

<img src="assets/features_obfuscation.png" width="200"><br>
<sub><b>基本块流程图（Ghidra）</b></sub>

## 使用方法
```shell
# 1. download and load docker image
curl -LO https://github.com/HimitsuShell/Himitsu/releases/download/v1.2.0/himitsu_core_v1.2.0.tar.gz
docker load -i himitsu_core_v1.2.0.tar.gz

# 2. start container
docker run --name himitsu_core -d -it himitsu_core:v1.2.0

# 3. upload your shell script (must be named launcher.sh)
docker cp launcher.sh himitsu_core:/var/work/

# 4. build and download binary (10–20 seconds)
docker exec himitsu_core /var/work/compile.sh
docker cp himitsu_core:/var/work/safeLauncher .
```

#### 混淆选项（基于 LLVM）
```shell
# obfuscation options
- bcf         # bogus control flow (warning: significantly increases build time and binary size.)
  - bcf_prob  # probability (1–100, default: 70)
  - bcf_loop  # number of iterations (default: 2)
- sub         # instruction substitution (add/and/sub/or/xor)
  - sub_loop  # number of iterations (default: 1)
- sobf        # string encryption
- split       # basic block splitting
  - split_num # number of splits (default: 3)
- ibr         # indirect branches
- icall       # indirect calls
- igv         # indirect global variable

# default options
sobf, icall, ibr, igv, sub

# how to customize
modify /var/work/compile.sh inside the `himitsu_core` container.
```

#### 系统要求
- **CPU：** x86_64（Intel/AMD），2.5 GHz 或更高 *(推荐 6 核心 / 12 线程)*
- **内存：** 16 GB RAM
- **存储：** 10 GB 可用空间（SSD/NVMe）

#### 支持的平台
- **Linux x86_64（静态 musl）**
- Linux ARM64（即将支持）
- Linux ARMv7（计划中）
- Linux RISC-V 64（计划中）

## 功能
- **操作系统级日志与 Hook 防护**  
  使用自带的内置 shell 解释器执行 shell 脚本，而非依赖系统 shell（例如 `/bin/bash`）。因此即使是操作系统级的日志记录与 hook 工具（`auditd`、`bpftrace`）也无法捕获脚本内容。

- **字符串与常量加密**  
  二进制文件中的所有字符串和常量均经过加密，从而增加静态分析的难度（例如 `IDA`、`Ghidra`）。

- **调试器检测**  
  在运行过程中持续检测调试器，从而增加动态分析的难度（例如 `gdb`、`ptrace`、`strace`）。

- **高级混淆技术**  
  包含指令替换、间接调用、间接跳转、基本块拆分以及虚假控制流等技术。

- **许可证验证（计划中）**  
  限制仅拥有有效许可证密钥的用户才能执行 shell 脚本。

## 研究与安全分析
#### 为什么不用 shc、ssc 等工具？
已知的自动反编译工具：
- UnSHc: https://github.com/yanncam/UnSHc
- unshell: https://github.com/Rem01Gaming/unshell

#### 与 shc 的对比
| | HimitsuShell | shc |
|-|-|-|
| 操作系统级日志与 Hook 防护 | ✓ | |
| 动态库 Hook 防护 | ✓ | |
| 字符串与常量加密 | ✓ | |
| 调试器检测 | ✓ | ✓ |
| 高级混淆技术 | ✓ | |

#### 相关文章
- [Shell 脚本保护工具对比：shc 与 HimitsuShell（二进制化、加密、混淆）](https://himitsushell.github.io/zh/shc-vs-himitsushell/)
- [Shell 脚本安全：shc 的结构性局限与漏洞（加密、编译器、混淆）](https://himitsushell.github.io/zh/shc-security-analysis/)
- [Linux Shell 脚本安全：ssc 的结构性局限与漏洞（源代码保护、混淆、逆向工程）](https://himitsushell.github.io/zh/ssc-security-analysis/)
- [Docker 镜像与容器源代码保护方法（Python、C/C++、Shell 脚本、LLVM 混淆、DRM）](https://himitsushell.github.io/zh/how-to-protect-docker/)

## 常见问题
- **支持哪些 Linux shell？**  
  支持符合 POSIX/LSB 标准的 shell（例如 /bin/sh）。

- **Bash 或 Zsh 脚本可以使用吗？**  
  可以使用，但可能会出现错误，建议在正式使用前先进行测试。

- **支持哪些 shell 命令？**  
  以下列出的命令已内置于二进制文件中。其他命令同样可以使用，但会依赖系统 shell，因此可能会被 hook 或日志记录捕获。

  <sup>basename bash blkdiscard blkid blockdev bunzip2 bzcat cal cat chattr chgrp chmod chown chroot chrt chvt cksum clear cmp comm count cp cpio crc32 cut date dd deallocvt devmem df dirname dmesg dnsdomainname dos2unix du echo egrep eject env expand factor fallocate false fgrep file find flock fmt fold free freeramdisk fsfreeze fstype fsync ftpget ftpput getconf getopt gpiodetect gpiofind gpioget gpioinfo gpioset grep groups gunzip halt hd head help hexedit host hostname httpd hwclock i2cdetect i2cdump i2cget i2cset i2ctransfer iconv id ifconfig inotifyd insmod install ionice iorenice iotop kill killall killall5 link linux32 ln logger login logname losetup ls lsattr lsmod lspci lsusb makedevs mcookie md5sum memeater microcom mix mkdir mkfifo mknod mkpasswd mkswap mktemp modinfo mount mountpoint mv nbd-client nbd-server nc netcat netstat nice nl nohup nologin nproc nsenter od oneit openvt partprobe paste patch pgrep pidof ping ping6 pivot_root pkill pmap poweroff printenv printf prlimit ps pwd pwdx pwgen readahead readelf readlink realpath reboot renice reset rev rfkill rm rmdir rmmod rtcwake sed seq setfattr setsid sh sha1sum sha224sum sha256sum sha384sum sha3sum sha512sum shred shuf sleep sntp sort split stat strings su swapoff swapon switch_root sync sysctl tac tail tar taskset tee test time timeout top touch true truncate ts tsort tty tunctl uclampset ulimit umount uname unicode uniq unix2dos unlink unshare uptime usleep uudecode uuencode uuidgen vconfig vmstat w watch watchdog wc wget which who whoami xargs xxd yes zcat</sup>

- **可以只使用混淆引擎吗？**  
  可以，请参见 [HimitsuObfuscator](https://github.com/HimitsuShell/HimitsuObfuscator)

## 讨论
欢迎提出问题、报告 bug、提交功能请求以及进行任何形式的讨论。  
您也可以通过 hjyun@mushsw.com 与我们联系。

## License
See [README.md](README.md#license) and [LICENSE](LICENSE) for details.