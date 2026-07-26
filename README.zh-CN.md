<p align="center">
  <a href="https://himitsushell.com/" target="blank"><img src="https://avatars.githubusercontent.com/u/264618628?s=200&v=4" width="100" alt="HimitsuShell Logo" /></a>
</p>
<p align="center">
  <a href="https://github.com/HimitsuShell/Himitsu/releases">
    <img src="https://img.shields.io/github/v/release/HimitsuShell/Himitsu?color=2da44e" alt="Latest Release" />
  </a>
  <a href="https://github.com/HimitsuShell/Himitsu/blob/main/LICENSE">
    <img src="https://img.shields.io/badge/license-PolyForm%20NC-blue" alt="PolyForm Noncommercial 1.0.0 License" />
  </a>
  <a href="https://github.com/HimitsuShell/Himitsu/releases">
    <img src="https://img.shields.io/github/downloads/HimitsuShell/Himitsu/total.svg" alt="GitHub Total Downloads" />
  </a>
</p>

> 本 README 由 AI 翻译，可能存在错误或不准确之处。如发现问题，欢迎提交 Issue 或 Pull Request 进行修正。

**README:** [English](README.md) | [中文](README.zh-CN.md) | [日本語](README.ja.md)

## HimitsuShell
通过内置的 shell 解释器、高级混淆技术以及反调试机制，将 shell 脚本转换为经过混淆处理的二进制文件。（可作为 shc 的替代方案）

<img src="assets/features_obfuscation.png" width="220"><br>
<sub><b>Block Flow Graph（Ghidra）</b></sub>

## 使用方法
```shell
# 1. Download Docker image
curl -LO https://github.com/HimitsuShell/Himitsu/releases/download/v1.2.0/himitsu_core_v1.2.0.tar.gz

# 2. Load Docker image
docker load -i himitsu_core_v1.2.0.tar.gz

# 3. Start container
docker run --name himitsu_core -d -it himitsu_core:v1.2.0

# 4. Upload your shell script (must be named launcher.sh)
docker cp launcher.sh himitsu_core:/var/work/

# 5. Build binary (10–20 seconds)
docker exec himitsu_core /var/work/compile.sh

# 6. Download generated binary
docker cp himitsu_core:/var/work/safeLauncher .
```

### 混淆选项
```shell
# Obfuscation Options
- bcf         # Bogus Control Flow (Warning: Significantly increases build time and binary size.)
  - bcf_prob  # Probability (1–100, default: 70)
  - bcf_loop  # Number of Iterations (default: 2)
- sub         # Instruction Substitution (add/and/sub/or/xor)
  - sub_loop  # Number of Iterations (default: 1)
- sobf        # String Encryption
- split       # Basic Block Splitting
  - split_num # Number of Splits (default: 3)
- ibr         # Indirect Branches
- icall       # Indirect Calls
- igv         # Indirect Global Variable

# Enabled by Default
sobf, icall, ibr, igv, sub

# How to Customize
Modify /var/work/compile.sh inside the `himitsu_core` container.
```

### 系统要求
- **CPU:** x86_64 (Intel/AMD)，2.5 GHz 以上 *（推荐 6 核 12 线程）*
- **内存:** 16 GB RAM
- **存储空间:** 10 GB 可用空间 (SSD/NVMe)

### 支持平台
- **Linux x86_64（静态 musl）**
- Linux ARM64（即将推出）
- Linux ARMv7（计划中）
- Linux RISC-V 64（计划中）

## 功能特性
- **系统层日志与 Hook 防护**  
内置独立的 shell 解释器，摆脱对系统 shell 的依赖，从而降低被系统层日志记录和 Hook 检测的风险（例如 `auditd`、`bpftrace`）。

- **字符串与常量加密**  
二进制文件中的所有字符串和常量均经过加密处理，增加静态分析的难度（例如 `IDA`、`Ghidra`）。

- **调试器检测**  
运行时持续检测调试器，提高动态分析的难度（例如 `gdb`、`ptrace`、`strace`）。

- **高级混淆技术**  
支持指令替换、间接调用、间接跳转、基本块拆分以及虚假控制流（Bogus Control Flow）等技术。

- **许可证验证（计划中）**  
限制 shell 脚本仅能由持有有效许可证密钥的用户执行。

## 研究与安全分析
#### 相关文章
- [Shell 脚本转二进制工具对比：shc vs. HimitsuShell](https://medium.com/@y37653/shell-script-to-binary-tools-shc-vs-himitsushell-31baed264c6f)
- [shc 安全分析：Shell 脚本编译工具的结构性缺陷](https://medium.com/@y37653/how-to-hack-shc-shell-script-protection-tool-bd958126ea66)
- [ssc 安全分析：Shell 脚本编译工具的结构性缺陷](https://medium.com/@y37653/how-to-hack-ssc-shell-script-protection-tool-90a34b13c802)

#### 与 shc 的对比
| | HimitsuShell | shc |
|-|-|-|
| 系统层日志与 Hook 防护 | ✓ | |
| 动态库 Hook 防护 | ✓ | |
| 字符串与常量加密 | ✓ | |
| 调试器检测 | ✓ | ✓ |
| 高级混淆技术 | ✓ | |

## 讨论
欢迎提出问题、反馈 Bug、提交功能请求以及进行相关讨论。

也可以通过邮箱联系我们: hjyun@mushsw.com。

## 许可证
HimitsuShell 采用双重许可模式，其中社区版（Community Edition）供非商业用途免费使用：[Polyform Noncommercial 1.0.0](https://polyformproject.org/licenses/noncommercial/1.0.0)。

依据该许可证，HimitsuShell 可免费用于个人/非商业用途，但如需用于商业用途，则必须使用商业版（Commercial Edition）。

商业版可通过 [himitsushell.com](https://himitsushell.com) 购买。有关许可证的更多详情，请参阅我们的[服务条款](https://himitsushell.com/pdf/terms_of_service.pdf)。