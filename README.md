<p align="center">
  <a href="https://himitsushell.com/" target="blank"><img src="https://avatars.githubusercontent.com/u/264618628?s=200&v=4" width="100" alt="HimitsuShell Logo" /></a>
</p>
<p align="center">
  <a href="https://github.com/HimitsuShell/Himitsu/releases"><img src="https://img.shields.io/github/v/release/HimitsuShell/Himitsu?color=2da44e" alt="Latest Release" /></a>
  <a href="https://github.com/HimitsuShell/Himitsu/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-PolyForm%20NC-blue" alt="PolyForm Noncommercial 1.0.0 License" /></a>
  <a href="https://github.com/HimitsuShell/Himitsu/releases"><img src="https://img.shields.io/github/downloads/HimitsuShell/Himitsu/total.svg" alt="GitHub Total Downloads" /></a>
</p>

**README:** [English](README.md) | [中文](README.zh-CN.md) | [日本語](README.ja.md)

# HimitsuShell
Shell scripts invisible even to kernel tracing.
  
Converts shell scripts into single static binaries with an embedded interpreter, llvm-based obfuscation, and anti-debug protections (shc alternative).

<img src="assets/features_obfuscation.png" width="200"><br>
<sub><b>Block Flow Graph (Ghidra)</b></sub>

## Usage
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

#### Obfuscation Options (LLVM-based)
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

#### System Requirements
- **CPU:** x86_64 (Intel/AMD), 2.5 GHz or higher *(6 cores / 12 threads recommended)*
- **Memory:** 16 GB RAM
- **Storage:** 10 GB available space (SSD/NVMe)

#### Supported Platforms
- **Linux x86_64 (static musl)**
- Linux ARM64 (Coming Soon)
- Linux ARMv7 (Planned)
- Linux RISC-V 64 (Planned)

## Features
- **OS-Level Logging & Hooking Protection**  
  Executes shell scripts using its own embedded shell interpreter instead of the system shell (e.g., `/bin/bash`). Shell scripts are not exposed even by OS-level logging and hooking (`auditd`, `bpftrace`).

- **String & Constant Encryption**  
  All strings and constants in the binary are encrypted, making static analysis more difficult (e.g., `IDA`, `Ghidra`).

- **Debugger Detection**  
  Continuously detects debuggers during execution, making dynamic analysis more difficult (e.g., `gdb`, `ptrace`, `strace`).

- **Advanced Obfuscation Techniques**  
  Features instruction substitution, indirect calls, indirect branches, basic block splitting, and bogus control flow.

- **License Verification (Planned)**  
  Restricts shell script execution to users with a valid license key.

## Research & Security Analysis
#### Why not shc, ssc, etc.?
Known auto decompilation tools:
- UnSHc: https://github.com/yanncam/UnSHc
- unshell: https://github.com/Rem01Gaming/unshell

#### Compared to shc
| | HimitsuShell | shc |
|-|-|-|
| OS-Level Logging & Hooking Protection | ✓ | |
| Dynamic Library Hooking Protection | ✓ | |
| String & Constant Encryption | ✓ | |
| Debugger Detection | ✓ | ✓ |
| Advanced Obfuscation Techniques | ✓ | |

#### Articles
- [Comparing Shell Script Protection Tools: shc vs HimitsuShell (Binary Compilation, Encryption, and Obfuscation)](https://himitsushell.github.io/en/shc-vs-himitsushell/)
- [Shell Script Security: Structural Limitations and Vulnerabilities of shc (Encryption, Compiler, Obfuscation)](https://himitsushell.github.io/en/shc-security-analysis/)
- [Linux Shell Script Security: Structural Limitations and Vulnerabilities in ssc (Source Code Protection, Obfuscation, Reverse Engineering)](https://himitsushell.github.io/en/ssc-security-analysis/)
- [How to Protect Source Code in Docker Images and Containers (Python, C/C++, Shell Scripts, LLVM Obfuscation, DRM)](https://himitsushell.github.io/en/how-to-protect-docker/)

## FAQ
- **Which Linux shells are supported?**  
  Supports POSIX/LSB-compliant shells (e.g., /bin/sh).

- **Do Bash or Zsh scripts work?**  
  They work, but errors can occur. We recommend testing before use.

- **Which shell commands are supported?**  
  The commands listed below are built into the binary. Other commands also work, but they rely on the system shell and may be exposed to hooking or logging.

  <sup>basename bash blkdiscard blkid blockdev bunzip2 bzcat cal cat chattr chgrp chmod chown chroot chrt chvt cksum clear cmp comm count cp cpio crc32 cut date dd deallocvt devmem df dirname dmesg dnsdomainname dos2unix du echo egrep eject env expand factor fallocate false fgrep file find flock fmt fold free freeramdisk fsfreeze fstype fsync ftpget ftpput getconf getopt gpiodetect gpiofind gpioget gpioinfo gpioset grep groups gunzip halt hd head help hexedit host hostname httpd hwclock i2cdetect i2cdump i2cget i2cset i2ctransfer iconv id ifconfig inotifyd insmod install ionice iorenice iotop kill killall killall5 link linux32 ln logger login logname losetup ls lsattr lsmod lspci lsusb makedevs mcookie md5sum memeater microcom mix mkdir mkfifo mknod mkpasswd mkswap mktemp modinfo mount mountpoint mv nbd-client nbd-server nc netcat netstat nice nl nohup nologin nproc nsenter od oneit openvt partprobe paste patch pgrep pidof ping ping6 pivot_root pkill pmap poweroff printenv printf prlimit ps pwd pwdx pwgen readahead readelf readlink realpath reboot renice reset rev rfkill rm rmdir rmmod rtcwake sed seq setfattr setsid sh sha1sum sha224sum sha256sum sha384sum sha3sum sha512sum shred shuf sleep sntp sort split stat strings su swapoff swapon switch_root sync sysctl tac tail tar taskset tee test time timeout top touch true truncate ts tsort tty tunctl uclampset ulimit umount uname unicode uniq unix2dos unlink unshare uptime usleep uudecode uuencode uuidgen vconfig vmstat w watch watchdog wc wget which who whoami xargs xxd yes zcat</sup>

- **Can I use only the obfuscation engine?**  
  Yes. See [HimitsuObfuscator](https://github.com/HimitsuShell/HimitsuObfuscator)

## Discussions
Questions, bug reports, feature requests, and general discussions are welcome.  
You can also contact us at hjyun@mushsw.com.

## License
HimitsuShell has a dual license model with a Community Edition for noncommercial use:  [Polyform Noncommercial 1.0.0](https://polyformproject.org/licenses/noncommercial/1.0.0).

With this license HimitsuShell is free to use for personal/noncommercial use, but will require a Commercial Edition to be used in a commercial business.

Commercial Edition can be purchased at [himitsushell.com](https://himitsushell.com). For more details on our licensing, see our [Terms of Service](https://himitsushell.com/pdf/terms_of_service.pdf).
