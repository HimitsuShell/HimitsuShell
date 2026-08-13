<p align="center">
  <a href="https://himitsushell.com/" target="blank"><img src="https://avatars.githubusercontent.com/u/264618628?s=200&v=4" width="100" alt="HimitsuShell Logo" /></a>
</p>
<p align="center">
  <a href="https://github.com/HimitsuShell/Himitsu/releases"><img src="https://img.shields.io/github/v/release/HimitsuShell/Himitsu?color=2da44e" alt="Latest Release" /></a>
  <a href="https://github.com/HimitsuShell/Himitsu/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-PolyForm%20NC-blue" alt="PolyForm Noncommercial 1.0.0 License" /></a>
  <a href="https://github.com/HimitsuShell/Himitsu/releases"><img src="https://img.shields.io/github/downloads/HimitsuShell/Himitsu/total.svg" alt="GitHub Total Downloads" /></a>
</p>

> 翻訳版です。問題があればIssueでお知らせください。

**README:** [English](README.md) | [中文](README.zh-CN.md) | [日本語](README.ja.md) | [한국어](README.ko.md)

# HimitsuShell
カーネルトレースからも見えないシェルスクリプト。

シェルスクリプトを、組み込みインタプリタ・LLVMベースの難読化・アンチデバッグ保護を備えた単一の静的バイナリに変換します（shcの代替）。

<img src="assets/features_obfuscation.png" width="200"><br>
<sub><b>ブロックフローグラフ（Ghidra）</b></sub>

## 使い方
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

#### 難読化オプション（LLVMベース）
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

#### システム要件
- **CPU:** x86_64（Intel/AMD）、2.5GHz以上 *(6コア/12スレッド推奨)*
- **メモリ:** 16GB RAM
- **ストレージ:** 10GBの空き容量（SSD/NVMe）

#### 対応プラットフォーム
- **Linux x86_64（static musl）**
- Linux ARM64（近日対応予定）
- Linux ARMv7（対応予定）
- Linux RISC-V 64（対応予定）

## 特徴
- **OSレベルのロギング・フッキング対策**  
  システムシェル（例：`/bin/bash`）の代わりに、独自の組み込みシェルインタプリタを使用してシェルスクリプトを実行します。OSレベルのロギングやフッキング（`auditd`、`bpftrace`）でもシェルスクリプトの中身は露出しません。

- **文字列・定数の暗号化**  
  バイナリ内のすべての文字列と定数が暗号化され、静的解析（`IDA`、`Ghidra`など）がより困難になります。

- **デバッガ検知**  
  実行中に継続的にデバッガを検知し、動的解析（`gdb`、`ptrace`、`strace`など）をより困難にします。

- **高度な難読化技術**  
  命令置換、間接呼び出し、間接分岐、基本ブロック分割、ボーガスコントロールフローなどの機能を備えています。

- **ライセンス認証（予定）**  
  有効なライセンスキーを持つユーザーのみにシェルスクリプトの実行を制限します。

## 研究・セキュリティ分析
#### なぜshcやsscではないのか？
既知の自動デコンパイルツール：
- UnSHc: https://github.com/yanncam/UnSHc
- unshell: https://github.com/Rem01Gaming/unshell

#### shcとの比較
| | HimitsuShell | shc |
|-|-|-|
| OSレベルのロギング・フッキング対策 | ✓ | |
| 動的ライブラリフッキング対策 | ✓ | |
| 文字列・定数の暗号化 | ✓ | |
| デバッガ検知 | ✓ | ✓ |
| 高度な難読化技術 | ✓ | |

#### 記事
- [シェルスクリプト保護ツール比較:shc vs HimitsuShell(バイナリ化、暗号化、難読化)](https://himitsushell.github.io/ja/shc-vs-himitsushell/)
- [シェルスクリプトのセキュリティ: shcの構造的限界と脆弱性(暗号化、コンパイラ、難読化)](https://himitsushell.github.io/ja/shc-security-analysis/)
- [Linuxシェルスクリプトのセキュリティ: sscの構造的限界と脆弱性(ソースコード保護、難読化、リバースエンジニアリング)](https://himitsushell.github.io/ja/ssc-security-analysis/)
- [Docker イメージ・コンテナのソースコード保護方法(Python、C/C++、シェルスクリプト、LLVM難読化、DRM)](https://himitsushell.github.io/ja/how-to-protect-docker/)

## よくある質問
- **どのLinuxシェルに対応していますか？**  
  POSIX/LSB準拠のシェル（例：/bin/sh）に対応しています。

- **BashやZshのスクリプトは動作しますか？**  
  動作はしますが、エラーが発生することがあります。使用前にテストすることをおすすめします。

- **どのシェルコマンドに対応していますか？**  
  以下に記載されたコマンドはバイナリに組み込まれています。それ以外のコマンドも動作はしますが、システムシェルに依存するため、フッキングやロギングにさらされる可能性があります。

  <sup>basename bash blkdiscard blkid blockdev bunzip2 bzcat cal cat chattr chgrp chmod chown chroot chrt chvt cksum clear cmp comm count cp cpio crc32 cut date dd deallocvt devmem df dirname dmesg dnsdomainname dos2unix du echo egrep eject env expand factor fallocate false fgrep file find flock fmt fold free freeramdisk fsfreeze fstype fsync ftpget ftpput getconf getopt gpiodetect gpiofind gpioget gpioinfo gpioset grep groups gunzip halt hd head help hexedit host hostname httpd hwclock i2cdetect i2cdump i2cget i2cset i2ctransfer iconv id ifconfig inotifyd insmod install ionice iorenice iotop kill killall killall5 link linux32 ln logger login logname losetup ls lsattr lsmod lspci lsusb makedevs mcookie md5sum memeater microcom mix mkdir mkfifo mknod mkpasswd mkswap mktemp modinfo mount mountpoint mv nbd-client nbd-server nc netcat netstat nice nl nohup nologin nproc nsenter od oneit openvt partprobe paste patch pgrep pidof ping ping6 pivot_root pkill pmap poweroff printenv printf prlimit ps pwd pwdx pwgen readahead readelf readlink realpath reboot renice reset rev rfkill rm rmdir rmmod rtcwake sed seq setfattr setsid sh sha1sum sha224sum sha256sum sha384sum sha3sum sha512sum shred shuf sleep sntp sort split stat strings su swapoff swapon switch_root sync sysctl tac tail tar taskset tee test time timeout top touch true truncate ts tsort tty tunctl uclampset ulimit umount uname unicode uniq unix2dos unlink unshare uptime usleep uudecode uuencode uuidgen vconfig vmstat w watch watchdog wc wget which who whoami xargs xxd yes zcat</sup>

- **難読化エンジンだけを使うことはできますか？**  
  はい。[HimitsuObfuscator](https://github.com/HimitsuShell/HimitsuObfuscator)をご覧ください。

## ディスカッション
質問、バグ報告、機能リクエスト、その他一般的な議論を歓迎します。  
hjyun@mushsw.com までご連絡いただくことも可能です。

## License
See [README.md](README.md#license) and [LICENSE](LICENSE) for details.
