<p align="center">
  <a href="https://himitsushell.com/" target="blank"><img src="https://avatars.githubusercontent.com/u/264618628?s=200&v=4" width="120" alt="HimitsuShell Logo" /></a>
</p>
<p align="center">
  <img src="https://img.shields.io/badge/Docker-Ready-2496ED?logo=docker&logoColor=white" alt="Docker Ready" />
  <a href="https://github.com/HimitsuShell/Himitsu/releases">
    <img src="https://img.shields.io/github/v/release/HimitsuShell/Himitsu?color=2da44e" alt="Latest Release" />
  </a>
</p>

## HimitsuShell
<img src="assets/features_obfuscation.png" width="300" style="margin: auto">

[HimitsuShell](https://himitsushell.com) converts shell scripts into obfuscated binaries using an embedded shell interpreter, advanced obfuscation, and anti-debugging techniques. An alternative to shc.

## Usage
```shell
# 1. Download the Docker Image from GitHub Releases
https://github.com/HimitsuShell/Himitsu/releases

# 2. Load the Docker Image
docker load -i himitsu_core_v1.2.0.tar.gz

# 3. Start the Container
docker run --name himitsu_core -d -it himitsu_core:v1.2.0

# 4. Upload Your Shell Script (The filename must be "launcher.sh")
docker cp launcher.sh himitsu_core:/var/work/

# 5. Build the Protected Binary (10–20 seconds)
docker exec himitsu_core /var/work/compile.sh

# 6. Download the Generated Binary
docker cp himitsu_core:/var/work/safeLauncher .
```

### Obfuscation Options
```shell
# Obfuscation Options
- bcf         # Bogus Control Flow (Warning: Significantly increases build time and binary size.)
-   bcf_prob  # Probability (1–100, default: 70)
-   bcf_loop  # Number of Iterations (default: 2)
- sub         # Instruction Substitution (add/and/sub/or/xor)
-   sub_loop  # Number of Iterations (default: 1)
- sobf        # String Encryption
- split       # Basic Block Splitting
-   split_num # Number of Splits (default: 3)
- ibr         # Indirect Branches
- icall       # Indirect Calls
- igv         # Indirect Global Variable

# Enabled by Default (Docker Image)
sobf, icall, ibr, igv, sub

# Customize the Obfuscation Options
Modify /var/work/compile.sh inside the 'himitsu_core' container.
```

### System Requirements
- **CPU:** AMD x86_64, 2.5 GHz or higher (6 cores / 12 threads recommended)
- **Memory:** 16 GB RAM
- **Storage:** 10 GB available SSD/NVMe space

### Supported Platforms
- **Linux x86_64 (static musl)**
- Linux ARM64 (Coming Soon)
- Linux ARMv7 (Planned)
- Linux RISC-V 64 (Planned)

## Features
#### OS-Level Logging & Hooking Protection
Embeds its own shell interpreter, eliminating reliance on the system shell and reducing exposure to OS-level logging and hooking. (e.g., auditd).
#### String & Constant Encryption
All strings and constants in the binary are encrypted, making static analysis more difficult (e.g., IDA, Ghidra).
#### Debugger Detection
Continuously detects debuggers during execution, making dynamic analysis more difficult (e.g., gdb, ptrace, strace).
#### Advanced Obfuscation Techniques
Features instruction substitution, indirect calls, indirect branches, basic block splitting, and bogus control flow.
#### License Verification (Planned)
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
We welcome questions, feedback, bug reports, feature requests, and discussions about HimitsuShell. Feel free to start a discussion and share your thoughts.

## Contact
For inquiries, please contact:

hjyun@mushsw.com

## License
The Community Edition is free for individual use.

**Organizations require a Commercial License. (https://himitsushell.com)**