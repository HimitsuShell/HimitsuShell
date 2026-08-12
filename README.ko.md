<p align="center">
  <a href="https://himitsushell.com/" target="blank"><img src="https://avatars.githubusercontent.com/u/264618628?s=200&v=4" width="100" alt="HimitsuShell Logo" /></a>
</p>
<p align="center">
  <a href="https://github.com/HimitsuShell/Himitsu/releases"><img src="https://img.shields.io/github/v/release/HimitsuShell/Himitsu?color=2da44e" alt="Latest Release" /></a>
  <a href="https://github.com/HimitsuShell/Himitsu/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-PolyForm%20NC-blue" alt="PolyForm Noncommercial 1.0.0 License" /></a>
  <a href="https://github.com/HimitsuShell/Himitsu/releases"><img src="https://img.shields.io/github/downloads/HimitsuShell/Himitsu/total.svg" alt="GitHub Total Downloads" /></a>
</p>

**README:** [English](README.md) | [中文](README.zh-CN.md) | [日本語](README.ja.md) | [한국어](README.ko.md)

# HimitsuShell
커널을 감시해도 볼 수 없는 쉘 스크립트.

쉘 스크립트를 내장 인터프리터, LLVM 기반 난독화, 디버깅 방지 기능을 갖춘 단일 정적 바이너리로 변환합니다 (shc 대안).

<img src="assets/features_obfuscation.png" width="200"><br>
<sub><b>Block Flow Graph (Ghidra)</b></sub>

## 사용법
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

#### 난독화 옵션 (LLVM 기반)
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

#### 시스템 요구사항
- **CPU:** x86_64 (Intel/AMD), 2.5 GHz 이상 *(6코어 / 12스레드 권장)*
- **메모리:** 16 GB RAM
- **저장공간:** 10 GB 여유 공간 (SSD/NVMe)

#### 지원 플랫폼
- **Linux x86_64 (static musl)**
- Linux ARM64 (곧 지원 예정)
- Linux ARMv7 (예정)
- Linux RISC-V 64 (예정)

## 기능
- **OS 수준의 로깅 및 후킹 방어**  
  시스템 쉘(예: `/bin/sh`) 대신 자체 내장 쉘 인터프리터를 사용하여 쉘 스크립트를 실행합니다. 쉘 스크립트는 OS 수준의 로깅 및 후킹(예: `auditd`, `bpftrace`)을 통해서도 노출되지 않습니다.

- **문자열 및 상수 암호화**  
  바이너리 내부의 모든 문자열과 상수가 암호화되어 정적 분석이 더욱 어려워집니다 (예: `IDA`, `Ghidra`).

- **디버거 감지**  
  실행 중에 지속적으로 디버거를 감지하여 동적 분석을 더욱 어렵게 만듭니다 (예: `gdb`, `ptrace`, `strace`).

- **고급 난독화 기법**  
  명령어 치환, 간접 호출, 간접 분기, 기본 블록 분할, 가짜 제어 흐름 기법이 포함되어 있습니다.

- **라이선스 검증 (예정)**  
  유효한 라이선스 키를 가진 사용자만 쉘 스크립트 실행이 가능하도록 제한합니다.

## 연구 및 보안 분석
#### shc, ssc 등은 왜 사용하면 안 되나요?
자동화된 디컴파일 도구가 존재합니다:
- UnSHc: https://github.com/yanncam/UnSHc
- unshell: https://github.com/Rem01Gaming/unshell

#### shc와 비교
| | HimitsuShell | shc |
|-|-|-|
| OS 수준의 로깅 및 후킹 방어 | ✓ | |
| 동적 라이브러리 후킹 방어 | ✓ | |
| 문자열 및 상수 암호화 | ✓ | |
| 디버거 감지 | ✓ | ✓ |
| 고급 난독화 기법 | ✓ | |

#### 문서
- [쉘 스크립트 보호 도구 비교: shc vs HimitsuShell (바이너리화, 암호화, 난독화)](https://himitsushell.github.io/ko/shc-vs-himitsushell/)
- [쉘 스크립트 보안: shc의 구조적 한계와 취약점 (암호화, 컴파일러, 난독화)](https://himitsushell.github.io/ko/shc-security-analysis/)
- [리눅스 쉘 스크립트 보안: ssc의 구조적 한계와 취약점 (소스코드 보호, 난독화, 역공학)](https://himitsushell.github.io/ko/ssc-security-analysis/)
- [도커 이미지·컨테이너 소스코드 보호 방법 (Python, C/C++, 쉘 스크립트, LLVM 난독화, DRM)](https://himitsushell.github.io/ko/how-to-protect-docker/)

## FAQ
- **어떤 리눅스 쉘을 지원하나요?**  
  POSIX/LSB 규격을 준수하는 쉘(예: `/bin/sh`)을 지원합니다.

- **Bash, Zsh 스크립트가 작동하나요?**  
  작동하지만 오류가 발생할 수 있습니다. 사용 전 테스트해 보시는 것을 권장합니다.

- **어떤 쉘 명령어를 지원하나요?**  
  아래 나열된 명령어는 바이너리에 내장되었습니다. 다른 명령어도 작동하지만, 시스템 쉘에 의존하므로 후킹이나 로깅에 노출될 수 있습니다.

  <sup>basename bash blkdiscard blkid blockdev bunzip2 bzcat cal cat chattr chgrp chmod chown chroot chrt chvt cksum clear cmp comm count cp cpio crc32 cut date dd deallocvt devmem df dirname dmesg dnsdomainname dos2unix du echo egrep eject env expand factor fallocate false fgrep file find flock fmt fold free freeramdisk fsfreeze fstype fsync ftpget ftpput getconf getopt gpiodetect gpiofind gpioget gpioinfo gpioset grep groups gunzip halt hd head help hexedit host hostname httpd hwclock i2cdetect i2cdump i2cget i2cset i2ctransfer iconv id ifconfig inotifyd insmod install ionice iorenice iotop kill killall killall5 link linux32 ln logger login logname losetup ls lsattr lsmod lspci lsusb makedevs mcookie md5sum memeater microcom mix mkdir mkfifo mknod mkpasswd mkswap mktemp modinfo mount mountpoint mv nbd-client nbd-server nc netcat netstat nice nl nohup nologin nproc nsenter od oneit openvt partprobe paste patch pgrep pidof ping ping6 pivot_root pkill pmap poweroff printenv printf prlimit ps pwd pwdx pwgen readahead readelf readlink realpath reboot renice reset rev rfkill rm rmdir rmmod rtcwake sed seq setfattr setsid sh sha1sum sha224sum sha256sum sha384sum sha3sum sha512sum shred shuf sleep sntp sort split stat strings su swapoff swapon switch_root sync sysctl tac tail tar taskset tee test time timeout top touch true truncate ts tsort tty tunctl uclampset ulimit umount uname unicode uniq unix2dos unlink unshare uptime usleep uudecode uuencode uuidgen vconfig vmstat w watch watchdog wc wget which who whoami xargs xxd yes zcat</sup>

- **난독화 엔진만 따로 사용할 수 있나요?**  
  가능합니다. [HimitsuObfuscator](https://github.com/HimitsuShell/HimitsuObfuscator)

## 토론
질문, 버그 신고, 기능 요청, 의견 교환 등을 환영합니다.  
이곳으로 문의해 주셔도 됩니다. hjyun@mushsw.com.

## License
See [README.md](README.md#license) and [LICENSE](LICENSE) for details.
