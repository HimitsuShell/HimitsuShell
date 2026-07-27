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

**README:** [English](README.md) | [中文](README.zh-CN.md) | [日本語](README.ja.md)

# HimitsuShell
Converts shell scripts into obfuscated binaries using an embedded shell interpreter, advanced obfuscation, and anti-debugging techniques. (alternative to shc)

<img src="assets/features_obfuscation.png" width="220"><br>
<sub><b>Block Flow Graph (Ghidra)</b></sub>

## Usage
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

### Obfuscation Options
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

### System Requirements
- **CPU:** x86_64 (Intel/AMD), 2.5 GHz or higher *(6 cores / 12 threads recommended)*
- **Memory:** 16 GB RAM
- **Storage:** 10 GB available space (SSD/NVMe)

### Supported Platforms
- **Linux x86_64 (static musl)**
- Linux ARM64 (Coming Soon)
- Linux ARMv7 (Planned)
- Linux RISC-V 64 (Planned)

## Features
- **OS-Level Logging & Hooking Protection**  
  Embeds its own shell interpreter, eliminating reliance on the system shell and reducing exposure to OS-level logging and hooking. (e.g., `auditd`, `bpftrace`).

- **String & Constant Encryption**  
All strings and constants in the binary are encrypted, making static analysis more difficult (e.g., `IDA`, `Ghidra`).

- **Debugger Detection**  
Continuously detects debuggers during execution, making dynamic analysis more difficult (e.g., `gdb`, `ptrace`, `strace`).

- **Advanced Obfuscation Techniques**  
Features instruction substitution, indirect calls, indirect branches, basic block splitting, and bogus control flow.

- **License Verification (Planned)**  
Restricts shell script execution to users with a valid license key.

## Research & Security Analysis
#### Articles
- [Shell Script-to-Binary Tools: shc vs. HimitsuShell](https://medium.com/@y37653/shell-script-to-binary-tools-shc-vs-himitsushell-31baed264c6f)
- [shc Security Analysis: Structural Limitations of a Shell Script Compiler](https://medium.com/@y37653/how-to-hack-shc-shell-script-protection-tool-bd958126ea66)
- [ssc Security Analysis: Structural Limitations of a Shell Script Compiler](https://medium.com/@y37653/how-to-hack-ssc-shell-script-protection-tool-90a34b13c802)

#### Compared to shc
| | HimitsuShell | shc |
|-|-|-|
| OS-Level Logging & Hooking Protection | ✓ | |
| Dynamic Library Hooking Protection | ✓ | |
| String & Constant Encryption | ✓ | |
| Debugger Detection | ✓ | ✓ |
| Advanced Obfuscation Techniques | ✓ | |

## Discussions
Questions, bug reports, feature requests, and general discussions are welcome.

You can also contact us at hjyun@mushsw.com.

## License
HimitsuShell has a dual license model with a Community Edition for noncommercial use:  [Polyform Noncommercial 1.0.0](https://polyformproject.org/licenses/noncommercial/1.0.0).

With this license HimitsuShell is free to use for personal/noncommercial use, but will require a Commercial Edition to be used in a commercial business.

Commercial Edition can be purchased at [himitsushell.com](https://himitsushell.com). For more details on our licensing, see our [Terms of Service](https://himitsushell.com/pdf/terms_of_service.pdf).
