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

> このREADMEはAIによって翻訳されているため、誤りが含まれている可能性があります。修正すべき点があれば、IssueまたはPull Requestをお送りください。

**README:** [English](README.md) | [中文](README.zh-CN.md) | [日本語](README.ja.md)

## HimitsuShell
組み込みシェルインタプリタ、高度な難読化、アンチデバッギング技術を用いて、シェルスクリプトを難読化されたバイナリへと変換します。(shcの代替)

<img src="assets/features_obfuscation.png" width="220"><br>
<sub><b>ブロックフローグラフ (Ghidra)</b></sub>

## 使い方
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

### 難読化オプション
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

### システム要件
- **CPU:** x86_64 (Intel/AMD)、2.5 GHz以上 *(6コア/12スレッド推奨)*
- **メモリ:** 16 GB RAM
- **ストレージ:** 10 GBの空き容量 (SSD/NVMe)

### 対応プラットフォーム
- **Linux x86_64 (static musl)**
- Linux ARM64 (近日対応予定)
- Linux ARMv7 (予定)
- Linux RISC-V 64 (予定)

## 特徴
- **OSレベルのロギング・フッキング防止**
  独自のシェルインタプリタを組み込んでいるため、システムシェルへの依存がなく、OSレベルのロギングやフッキング(例:`auditd`、`bpftrace`)にさらされるリスクを軽減します。

- **文字列・定数の暗号化**
  バイナリ内のすべての文字列および定数を暗号化し、静的解析(例:`IDA`、`Ghidra`)をより困難にします。

- **デバッガ検出**
  実行中に常にデバッガを検出し、動的解析(例:`gdb`、`ptrace`、`strace`)をより困難にします。

- **高度な難読化技術**
  命令置換、間接呼び出し、間接分岐、基本ブロック分割、疑似制御フローなどの機能を備えています。

- **ライセンス認証(予定)**
  有効なライセンスキーを持つユーザーのみにシェルスクリプトの実行を制限します。

## 研究・セキュリティ分析
#### 記事
- [Shell Script-to-Binary Tools: shc vs. HimitsuShell](https://medium.com/@y37653/shell-script-to-binary-tools-shc-vs-himitsushell-31baed264c6f)
- [shc Security Analysis: Structural Limitations of a Shell Script Compiler](https://medium.com/@y37653/how-to-hack-shc-shell-script-protection-tool-bd958126ea66)
- [ssc Security Analysis: Structural Limitations of a Shell Script Compiler](https://medium.com/@y37653/how-to-hack-ssc-shell-script-protection-tool-90a34b13c802)

#### shcとの比較
| | HimitsuShell | shc |
|-|-|-|
| OSレベルのロギング・フッキング防止 | ✓ | |
| 動的ライブラリフッキング防止 | ✓ | |
| 文字列・定数の暗号化 | ✓ | |
| デバッガ検出 | ✓ | ✓ |
| 高度な難読化技術 | ✓ | |

## ディスカッション
質問、バグ報告、機能リクエスト、その他一般的な議論を歓迎します。

また、hjyun@mushsw.com までご連絡いただくことも可能です。

## ライセンス
HimitsuShellは、非商用利用向けのコミュニティエディションを含むデュアルライセンスモデルを採用しています: [Polyform Noncommercial 1.0.0](https://polyformproject.org/licenses/noncommercial/1.0.0)。

このライセンスの下では、HimitsuShellは個人利用・非商用利用であれば無料で使用できますが、商用ビジネスにおいて利用する場合は商用版(Commercial Edition)が必要になります。

商用版(Commercial Edition)は [himitsushell.com](https://himitsushell.com) にてご購入いただけます。ライセンスの詳細については、[利用規約](https://himitsushell.com/pdf/terms_of_service.pdf)をご覧ください。