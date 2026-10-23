#!/usr/bin/env bash
# theme-switcher.sh — v5.0 (Nix uyumlu, tam sürüm)
#
#   ./theme-switcher.sh --list
#   ./theme-switcher.sh --current
#   ./theme-switcher.sh --apply <tema>
#   ./theme-switcher.sh --apply <tema> --from <kaynak>
#   ./theme-switcher.sh --scan
#   ./theme-switcher.sh --preview <tema>
#   ./theme-switcher.sh --image <resim>
#   ./theme-switcher.sh --backup
#   ./theme-switcher.sh --restore

set -euo pipefail

NIXFILE="${NIXFILE:-./style.css}"
BACKUP_DIR="${BACKUP_DIR:-./.theme-backups}"
ROFI_COLOR_FILES="${ROFI_COLOR_FILES:-/home/mete/.config/rofi/powermenu/type-1/style-1.rasi.rasi /home/mete/.config/rofi/launchers/type-2/style-1.rasi /home/mete/.config/rofi/colors.rasi}"

declare -A THEMES

# ══════════════════════════════════════════════════════════════════════════
#  TEMA TANIMLARI
# ══════════════════════════════════════════════════════════════════════════
THEMES[_user_hybrid_blue]="68baf0 56a8e8 6898c8 aad8f8 5c7ea3 0a0f1a 141e30 152540 1e1e2e 1e2d1e 0f1f0f 2a3d2a 6ec648 7dd45a 7ab84e"

# ── Green Tones ──────────────────────────────────────────────────────────
THEMES[nature_green]="40a02b 2d8a1f 5fb233 a6d189 6a9f4b 0d1a0d 1a2d1a 1a3520 1e1e2e 1e2d1e 0f1f0f 2a3d2a 6ec648 7dd45a 7ab84e"
THEMES[emerald]="50c878 3da363 6fdb92 b8e8c8 5aaf6a 0a1a10 162b1c 1a3525 1c1c2e 1c2e22 0e1e14 284038 78d890 8ae8a0 82d898"
THEMES[forest]="2e7d32 1b5e20 43a047 81c784 4caf50 0b150b 192819 1d3520 1b1b2a 1b2a1d 0d1b0d 263626 66bb6a 7bcb7f 71c375"
THEMES[mint]="00bfa5 009688 26c6da a7ffeb 4db6ac 0a1614 182a26 1a3530 1c1c2c 1c2c28 0e1c18 283e38 4dd0c0 66e0d0 55d8c8"
THEMES[sage]="7c9a72 5f7d55 95b38a c8dcc2 6e8c64 0d1a0e 1a2d1c 1e3520 1e1e2c 1e2e20 101e10 2c3e2c 88aa80 98ba90 90b288"
THEMES[lime]="aeea00 9ccc00 c6ff00 e6ff99 8bc34a 0e1a05 1e2d10 223518 1e1e28 202e18 121e08 2e3e1e b0e840 c0f850 b8f048"
THEMES[jungle]="1a7a4a 0e5c34 28a060 7ddaaa 3a8a5a 080f0b 121e16 163020 181c22 182e20 0c1a10 223628 4ab870 5ed888 52c878"
THEMES[olive]="808000 6b6b00 9a9a10 c8c870 808040 101208 1c1e0a 222410 1e1e1a 222014 14140c 303218 a0a030 b0b040 a8a838"
THEMES[jade]="00a86b 007a50 00c880 80e8b8 30b87a 0a1610 182c20 1c3828 1a1c28 1c2e22 0e1c16 283c30 3acc90 52dca0 46d498"
THEMES[seafoam]="2eb872 1a9a58 44cc88 96e8c0 40a870 0c1810 1a2c1e 1e3826 1c1e2a 1e2e20 10180e 2c3c28 60cc90 78dca8 6cd49c"
THEMES[moss]="4a7c59 3a6048 5a9068 a8c8b0 608870 0d1610 1a2a1c 1e3422 1c1c28 1c2c1e 101a10 2c3828 68a078 80b090 78a888"
THEMES[chartreuse]="7fff00 6acc00 9fff30 d4ff98 88cc40 0e1a04 1c2e0a 20380e 1c2018 1e2e10 121e08 2c3818 a0ff50 b4ff68 aaff5a"

# ── Blue Tones ───────────────────────────────────────────────────────────
THEMES[ocean_blue]="4a9eff 2d7ad4 64b5f6 90caf9 5c8db8 0d1520 1a2540 1a2845 1c1c30 1c2540 0e1525 2a3550 5cb8ff 70c8ff 65c0ff"
THEMES[deep_blue]="1565c0 0d47a1 1976d2 90caf9 42a5f5 0a0f1e 141e35 182845 1a1a30 1a2538 0c1420 243048 2196f3 42a5f5 339af0"
THEMES[cyan]="00bcd4 0097a7 26c6da 80deea 4dd0e1 0a1618 142628 183035 1a1a2e 1a2830 0c181c 243438 40e0d0 55f0e0 48e8d8"
THEMES[sky]="56a8e8 3d8fd0 72c0f5 aad8f8 6898c8 0d1520 182838 1c3040 1c1c2e 1c2e3a 0e1820 283a48 68baf0 7ccaf8 72c2f5"
THEMES[arctic]="5bc8f5 3aaad4 78d8ff b4e8ff 6ab8d8 0a1820 182a38 1c3445 1c1e30 1c2e3c 0e1c26 283c4c 7ad8ff 96e4ff 88dcff"
THEMES[navy]="003087 001a5c 0044b0 a0b8e8 204880 080e1a 101828 142030 18182a 182030 0c1020 202840 3060c0 4878d8 3870cc"
THEMES[steel_blue]="4682b4 2c6090 5a9ed0 a0c8e8 5888b0 0c161e 18263a 1c3044 1c1e2c 1c2e3a 0e1820 283a4a 5a9cd0 72b0e4 68a8dc"
THEMES[cornflower]="6495ed 4070cc 7aabff c0d4ff 7890c8 0e1428 1c2440 20305c 1c1c30 1e2840 101828 2c3854 80b0ff 9ac4ff 8cb8ff"
THEMES[teal]="008080 006060 009a9a 70d0d0 308080 0a1414 182020 1c2c2c 1a1c28 1a2828 0e1818 283434 3aa8a8 50c0c0 48b8b8"
THEMES[cobalt]="0047ab 002a80 1060d0 90b8f0 2060a0 080e1c 101c30 14283c 181a28 182030 0c1220 202c40 2878e0 4090f0 3888e8"
THEMES[sapphire]="0f52ba 0a3a8a 1a68e0 90b8f8 2258a8 0a1020 141e38 183050 1a1a2c 1a2440 0c1428 242e50 2880f0 48a0ff 3898f8"
THEMES[powder_blue]="b0d8f0 88b8d8 c8e8ff e8f4ff 90c0e0 101c28 1e3040 223c50 1c1e2c 1e3040 121e28 2c4050 d0e8ff e4f4ff d8ecff"

# ── Purple/Pink Tones ────────────────────────────────────────────────────
THEMES[purple]="9c27b0 7b1fa2 ab47bc ce93d8 8e44ad 140a18 25142e 301a38 1e1c2e 221c2e 180e20 342440 b040c8 c050d8 b848d0"
THEMES[lavender]="b388ff 9575cd c9a0ff e1bee7 a382d4 120e1c 201830 281e3a 1c1c30 201c32 140e20 302440 c098ff d0a8ff c8a0ff"
THEMES[rose]="e91e63 c2185b f06292 f8bbd0 ec407a 1a0a10 2d141e 381a28 2a1a28 2e1c28 1c0e18 3e2430 f07090 f880a0 f47898"
THEMES[violet]="7c3aed 5b21b6 9f67ff d4b8ff 6d28d9 120a22 221440 2e1c50 1e1a30 221c38 160e28 30284a 9060ff a878ff 9c6eff"
THEMES[magenta]="e040fb b000d0 f060ff f0a8ff b830e0 180a1e 2c1038 381440 26182e 2a1c36 1c101e 3a2440 e858ff f870ff ee62ff"
THEMES[orchid]="da70d6 b050b0 e890e0 f4c8f0 c060b8 1a0e18 2c1e2c 382430 261e28 2a2028 1c1418 3a2c38 e888e0 f4a0ec e090e4"
THEMES[plum]="8e4585 6a2e64 a858a0 d4a8d0 7a3870 120c10 201820 2a2028 1e1820 221c22 160e14 30242e a060a0 b878b0 a870a8"
THEMES[fuchsia]="ff00ff cc00cc ff40ff ffa0ff dd30cc 1a001a 2e002e 420042 281428 2c1c2c 1c0c1c 3c2c3c ff40ff ff68ff ff50ff"
THEMES[mauve]="e0b0ff c090e8 f0c8ff f8e8ff c8a0e0 1a1422 2c2038 382840 261e2e 2a2230 1c1620 38303e e8c0ff f0d0ff eac8ff"
THEMES[lilac]="c8a2c8 a880a8 dbbcdb eddeed b890b8 18121a 2a1e2a 342430 221e28 26202c 1a1418 34283a d0aad0 e0c0e0 d8b2d8"
THEMES[wine]="722f37 5a2028 8a3c48 c890a0 6a3040 130a0c 22141a 2c1c24 201416 241820 160e12 2e2228 a04858 b86070 b05860"
THEMES[pink_neon]="ff69b4 e0408a ff90c8 ffcce8 e05898 1a0c14 2e1824 3c2030 281422 2c1c28 1c1018 3c2834 ff80c0 ff98d0 ff8cc8"

# ── Warm Tones ───────────────────────────────────────────────────────────
THEMES[royal_gold]="f5c211 e0a500 ffdd33 f9e2af a6894a 1a1510 2a2518 352e1a 26241c 28261e 1c1a10 3a3528 e0c840 ecd850 e5d048"
THEMES[sunset]="ff7043 e64a19 ff8a65 ffccbc bf5c3e 1a100a 2d1a12 381e18 2a1e1c 2e201c 1c140e 3e2a22 ff8860 ff9870 ff9068"
THEMES[amber]="ffb300 ff8f00 ffc107 ffe082 ffa000 1a1508 2d2510 352e14 26241a 28261c 1c1a0c 3a3520 ffc840 ffd850 ffd048"
THEMES[copper]="bf6830 a04e20 d47a40 e8b890 9a6840 1a1008 2d1c10 352218 261e1a 28201c 1c160e 3a2c22 c88050 d89060 d08858"
THEMES[crimson]="dc143c b8002a e8304a f0909a b82038 1a0808 2e1010 3c1818 28141a 2c1818 1c0c0e 3c2028 e83050 f84868 f04060"
THEMES[lava]="ff4500 cc2800 ff6020 ffa080 e05030 1a0800 2e1000 3c1800 281410 2c1810 1c0c08 3c2418 ff7040 ff8858 ff7e50"
THEMES[tangerine]="ff8c00 e06a00 ffaa30 ffd090 e07a30 1a1004 2e1e08 3a280e 281e0c 2c2010 1c1408 3c2e18 ffa040 ffb858 ffaa50"
THEMES[coral]="ff6b6b e84040 ff8888 ffcccc e05858 1a0c0c 2e1818 3c2020 281818 2c1a1a 1c0e0e 3c2828 ff8888 ffa0a0 ff9090"
THEMES[cherry]="de3163 b81048 f04878 f8a0b8 c82858 1a080e 2e1020 3c1830 28101c 2c1420 1c0c18 3c2030 f04870 f86090 f05080"
THEMES[sienna]="a0522d 7a3c1e b86030 e0aa80 906040 180e08 2c1c10 382416 26181a 2a1c1a 1a1008 38281e b07040 c08858 b87850"
THEMES[rust]="b7410e 8a2a00 d05820 e8a878 a05020 180c06 2c180a 382010 261610 2a1a10 1a0e08 362418 c06030 d07848 c87040"
THEMES[volcano]="ff3d00 cc1800 ff6030 ff9070 e04030 1a0600 2e1000 3c1800 28100c 2c1810 1a0a06 3c2018 ff6040 ff7858 ff6e50"
THEMES[peach]="ffbe76 f09040 ffd090 ffe8c0 e0a060 1a1208 2e2010 3a2c18 28201a 2c2218 1c160e 3c3020 ffcc90 ffdaaa ffd498"
THEMES[saffron]="f4c430 d4a000 ffdc50 fff0a0 d4a840 181404 2c2608 38320e 26241a 28260c 1c1c08 3a3818 f8d050 ffe068 ffda58"

# ── Neutral / Popular ────────────────────────────────────────────────────
THEMES[nord]="88c0d0 5e81ac 81a1c1 b4d0e0 6a8ea0 0d1118 1a2430 1e2c3a 1c1e28 1e2830 0e1620 283440 8abcc8 96ccd8 90c4d0"
THEMES[catppuccin_mocha]="89b4fa 7480c0 b4befe cba6f7 74c7ec 1e1e2e 181825 313244 1e1e2e 1e2838 11111b 45475a 94e2d5 a6e3a1 89dceb"
THEMES[dracula]="bd93f9 6272a4 ff79c6 f8f8f2 8be9fd 282a36 21222c 44475a 282a36 2a2d40 1a1c24 44475a 50fa7b ffb86c ff5555"
THEMES[gruvbox]="d79921 cc241d fb4934 fabd2f b8bb26 282828 1d2021 3c3836 282828 2a2e28 1c1c1c 504945 8ec07c 83a598 689d6a"
THEMES[tokyo_night]="7aa2f7 567ad4 bb9af7 c0caf5 73daca 1a1b26 16161e 292e42 1a1b26 1e2030 13131c 3b4261 7dcfff 9ece6a ff9e64"
THEMES[onedark]="61afef 528bff e06c75 98c379 c678dd 282c34 21252b 3e4451 282c34 2c313c 1c1f26 3e4451 56b6c2 e5c07b d19a66"
THEMES[solarized_dark]="268bd2 2aa198 859900 657b83 b58900 002b36 073642 0d3240 002b36 073642 001f26 0d3240 2aa198 859900 cb4b16"
THEMES[monokai]="f92672 66d9e8 a6e22e e6db74 fd971f 272822 1e1f1c 3e3d32 272822 2d2e27 1c1d19 3e3d32 ae81ff a6e22e 75715e"
THEMES[material]="82aaff 7986cb c3e88d ffcb6b f07178 1e2127 252a33 2d3548 1e2127 232933 171a21 313844 89ddff 80cbc4 c792ea"
THEMES[ayu_dark]="e6b450 ff8f40 f29668 d2a6ff 39bae6 0d1017 131721 1c2030 0d1017 131721 090e14 1e2840 95e6cb 7fd962 f07178"
THEMES[palenight]="82aaff c792ea c3e88d ffcb6b f07178 292d3e 1b1e2b 32374d 292d3e 2c3150 1f2233 3e4370 89ddff 80cbc4 ff5370"
THEMES[atom_one]="61afef 528bff e06c75 98c379 c678dd 1e2127 252931 3b414d 1e2127 252931 181b20 383f4d 56b6c2 e5c07b d19a66"
THEMES[horizon]="e95678 f09483 fab795 fac29a 29d397 1c1e26 16181f 2e303e 1c1e26 1e212e 141620 2e3040 6bdfe6 fab795 b877db"
THEMES[moonfly]="80a0ff 7070c8 74b2ff c4c8da 78c8b0 080818 101028 1a2038 080818 101030 040410 1a2248 3fc6c8 46c28e ff5189"
THEMES[nightfox]="71afe5 5189af 82c7dd a6dbff 738799 192330 212e3f 283a50 192330 1e2d3d 141c28 28394a 63cdcf c3e88d b3be62"
THEMES[kanagawa]="7e9cd8 938aa9 957fb8 dcd7ba 6a9589 1f1f28 16161d 2d4f67 1f1f28 223249 16161d 363646 6a9589 938aa9 c34043"

# ── Light Themes ─────────────────────────────────────────────────────────
THEMES[github_light]="0969da 0550ae 1a7f37 24292f 656d76 ffffff f6f8fa dde8f8 ffffff f0f0f8 f6f6f6 e8eaed 1b7c83 0a7bbb cf212e"
THEMES[solarized_light]="268bd2 2aa198 859900 657b83 b58900 fdf6e3 eee8d5 d4cbaf fdf6e3 e8e2cc f2eedc e0d8c0 2aa198 859900 cb4b16"
THEMES[catppuccin_latte]="1e66f5 7287fd 8839ef 4c4f69 209fb5 eff1f5 e6e9ef ccd0da eff1f5 e0e4ec dce0e8 bcc0cc 179299 40a02b d20f39"
THEMES[gruvbox_light]="d65d0e cc241d b57614 458588 427b58 fbf1c7 f2e5bc d5c4a1 fbf1c7 f4e8ca ebdbb2 c9b99a 427b58 8ec07c 689d6a"
THEMES[nord_light]="5e81ac 81a1c1 88c0d0 2e3440 4c566a eceff4 e5e9f0 d0d8e8 eceff4 e4e8f0 dce4f0 cdd4e0 88c0d0 8fbcbb a3be8c"

# ── Retro / Vintage ──────────────────────────────────────────────────────
THEMES[cyberpunk]="ff0090 00fff0 ff6600 ffe600 7000ff 0a0010 150020 200030 0f001e 180028 0a0018 28003c 00ffcc ff00cc cc00ff"
THEMES[vaporwave]="ff71ce 05ffa1 b967ff fffb96 01cdfe 120020 1e0036 2a0048 1a1030 201438 140028 2e1a40 05ffa1 b967ff ff71ce"
THEMES[synthwave]="e16cff 36f9f6 ff8b39 ffd319 ff1493 0d0221 1a0a3c 26124e 180232 1e0840 100020 2c1850 36f9f6 ff7ec7 fe3e84"
THEMES[outrun]="ff4af8 00e5ff ff6d00 ffef00 7b2fff 12001a 20003a 2c0050 1a0c2a 220e38 14001e 30104a 00e5ff e040fb ff4af8"
THEMES[c64]="7869c4 6a5acd 9488d4 c8c0e8 5040b0 3030a0 2020a0 3838c0 2828a8 3030b0 1c1c88 4040b8 4040c0 8090f0 7060d0"
THEMES[amber_crt]="ffb000 e09000 ffc840 ffe090 c88000 1a1000 2e2000 3c2e00 281e00 2c2200 1c1600 3a3000 ffcc40 ffd858 ffcc50"
THEMES[green_crt]="00ff41 00cc30 30ff70 a0ffc0 00aa28 001a08 003010 004018 001e10 002c18 001408 104028 00ee3a 30ff70 00cc30"
THEMES[phosphor]="ffdd00 ccaa00 ffee40 fff0a0 ddbb00 161200 282000 342e00 201e00 262400 181600 343200 ffe840 fff060 ffee50"

# ── Pastel ───────────────────────────────────────────────────────────────
THEMES[pastel_pink]="f4a7b9 e88fa0 f8c0cc fde8f0 e898b0 2a1820 3c2430 4a2e3c 2e1e28 342430 221420 40303e f0a0b8 fac0cc f8b0c4"
THEMES[pastel_blue]="a8c8f8 88b0e8 c0d8ff e4f0ff 90b8e0 181e2a 26303e 30404e 1e2430 243040 161c28 303c4c b4d0ff c8e0ff bcd8ff"
THEMES[pastel_green]="90d4a8 78c090 a8e0c0 d4f0e0 80c098 142018 203028 283c30 1c2822 20302a 141e1a 2c3e32 9adab0 b0e8c8 a4e0bc"
THEMES[pastel_purple]="c9b8e8 b4a0d8 dccef8 f0e8ff bc98d8 1e1828 30263e 3c3050 26203a 2c2840 1e1830 3c3050 d4c4f0 e4d4ff dcc8f4"
THEMES[pastel_yellow]="f8e890 f0d870 fff0a8 fffad8 e8d060 221e08 383012 443c18 2c2818 30300e 201e0a 3c3820 fff0a8 fffac8 fff8a0"
THEMES[bubblegum]="ff80ab ff4d94 ff99bb ffcce5 f43f7a 1e0c14 32182a 422038 2a1020 30162a 1e0c18 3e2238 ff90b8 ffa8cc ff9cc4"
THEMES[cotton_candy]="f9a8d4 f472b6 fbc7e2 fde8f2 e879a0 200c16 341624 3e2230 2a1622 30202a 1e1018 3e2834 ffb0d8 ffc8e4 ffbeda"

# ── Natural / Earth ──────────────────────────────────────────────────────
THEMES[earthy]="8b6914 6b4c0c a07820 d4b870 907040 1a1408 2c2410 382e18 26201a 2a2418 1c180c 3a3020 c09030 d0a848 c8a040"
THEMES[terracotta]="c1440e 9a3008 d86030 f0b090 b05530 1a0c08 2e1810 3c2018 281610 2c1a12 1c100a 3c2820 d07040 e08858 d87850"
THEMES[desert]="c2956c a07048 d4a880 eed8b8 b08058 1c1610 302a1a 3c3222 28221a 2c2820 1e1a10 3a3428 d4a880 e8c0a0 dcb890"
THEMES[sand]="e8c97a d4a840 f0d890 fcecc0 c8a040 1e1c10 32300e 403e18 2c2a1a 302e14 22200e 3e3c1c f0d890 fce8b0 f8e0a0"
THEMES[clay]="b04030 8a2a20 c85040 e8a898 a03828 1a0c0a 2e1814 3c2220 281412 2c1c18 1c1008 3c2c22 c06050 d07868 c87060"
THEMES[bamboo]="6aa64e 4e8a38 80bc64 c0e0a8 5a9840 101808 1c2c10 243818 1e2218 20280e 141a0c 2e3018 80b85e 98cc78 8cc070"
THEMES[mushroom]="9e8070 7c6050 b89080 dcc8b8 8c6e5c 1a1410 2c2218 382c22 241e1a 28201c 1c1610 363028 b09080 c4a898 b89888"
THEMES[stone]="7a7a8a 5a5a6a 909098 c8c8d0 6a6a78 141418 202028 2c2c38 1e1e26 222230 161620 303040 909098 a0a0b0 989898"

# ── Mono / Minimal ───────────────────────────────────────────────────────
THEMES[monochrome_dark]="c0c0c0 909090 e0e0e0 f0f0f0 808080 0c0c0c 1a1a1a 282828 161616 202020 101010 303030 d8d8d8 eeeeee e0e0e0"
THEMES[monochrome_light]="404040 606060 202020 181818 888888 f0f0f0 e0e0e0 c8c8c8 f0f0f0 e4e4e4 d8d8d8 b8b8b8 303030 181818 4a4a4a"
THEMES[charcoal]="78889a 5a6878 90a0b4 c0ccd8 687888 0e1218 182028 202c38 161e28 1c2430 101820 283040 8090a8 9aafc0 8898b0"
THEMES[graphite]="909090 686868 b0b0b0 d8d8d8 787878 101010 1c1c1c 282828 181818 222222 121212 303030 a0a0a0 c0c0c0 b0b0b0"
THEMES[ink]="304070 203060 405090 8898c0 304878 0c0c16 141428 1c1c38 141420 18182c 0e0e18 282840 4858a0 6070b8 5060a8"

# ── Special / Creative ───────────────────────────────────────────────────
THEMES[aurora]="98be65 51afef c678dd e06c75 ecbe7b 1b2229 282c34 3b4451 1b2229 222831 12181e 3b4251 4db5bd 98be65 ff6c6b"
THEMES[galactic]="a78bfa 60a5fa 34d399 fbbf24 f87171 0f0a1e 1a1030 221648 160c28 1e1038 0c0818 2c1e50 818cf8 a78bfa 34d399"
THEMES[arctic_fox]="81a1c1 88c0d0 5e81ac d8dee9 4c566a 2e3440 363d4a 414857 2e3440 38404e 252b38 4a525d 8fbcbb 88c0d0 81a1c1"
THEMES[deep_sea]="006994 00547a 0088c0 70c8e8 2878a0 040e18 081820 0c2230 081020 0a1a2c 040c18 102438 0090c8 30b8e8 0088c0"
THEMES[lush]="58d68d 27ae60 1e8449 abebc6 1abc9c 0b1e14 162c20 1c3828 161e24 1a2c20 0e1a14 24322c 45b39d 48c9b0 52be8f"
THEMES[fire_and_ice]="ff4500 0088ff ff6600 00aaff dd3300 0c0c18 180808 200e10 101010 14141c 0a0a12 20081a ff6030 0099ff ff5520"
THEMES[matrix]="00ff41 00cc30 20ff58 a0ffb0 00aa28 001a08 003010 004818 001e10 002c18 001408 104028 00ee3a 30ff70 00cc30"
THEMES[neon_city]="ff0080 00ffff ff8000 ffff00 8000ff 0a0014 14002a 1e0040 0e0020 180030 08001a 280040 00ffcc ff00aa ff4488"
THEMES[night_drive]="dcb441 59783c 42a3a1 e6dfcb 828d7a 0a0f0d 141b18 1c2621 121815 2a3324 070a09 223029 f5b041 76d7c4 ca6f1e"
THEMES[MIT]="a31d1d a31d1d e5e7eb f4f4f5 8b949e 0f0b0b 191414 261e1e 161010 2a1b1b 0a0707 331414 a31d1d e5e7eb f4f4f5"

# ── Slot isimleri & sabit renkler ────────────────────────────────────────
SLOT_NAMES=(PRIMARY SECONDARY BRIGHT SOFT MUTED BG_DARK BG_ALT BG_VISUAL BG_FZF BG_FZF_HL BG_PMENU BG_BRIGHT EXTRA1 EXTRA2 EXTRA3)
FIXED_COLORS="f38ba8 a6e3a1 cdd6f4 ffffff 000000 ff6b6b 6c7086 808080"

# ══════════════════════════════════════════════════════════════════════════
#  RENKLER (terminal çıktısı için)
# ══════════════════════════════════════════════════════════════════════════
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

# ══════════════════════════════════════════════════════════════════════════
#  YARDIMCI FONKSİYONLAR
# ══════════════════════════════════════════════════════════════════════════
hex_to_rgb() {
  local hex="${1#\#}"
  hex="${hex,,}"
  hex="${hex:0:6}"
  if [[ ! "$hex" =~ ^[0-9a-f]{6}$ ]]; then
    echo "0 0 0"
    return
  fi
  local r=$((16#${hex:0:2}))
  local g=$((16#${hex:2:2}))
  local b=$((16#${hex:4:2}))
  echo "$r $g $b"
}

compute_gradient_colors() {
  local bg_dark="$1"
  local rgb
  rgb=$(hex_to_rgb "$bg_dark")
  local r g b
  read -r r g b <<<"$rgb"

  local g1r=$((r * 77 / 100))
  local g1g=$((g * 77 / 100))
  local g1b=$((b * 77 / 100))
  ((g1r < 1 && r > 0)) && g1r=1
  ((g1g < 1 && g > 0)) && g1g=1
  ((g1b < 1 && b > 0)) && g1b=1

  local g2r=$((r * 154 / 100))
  local g2g=$((g * 154 / 100))
  local g2b=$((b * 154 / 100))
  ((g2r > 255)) && g2r=255
  ((g2g > 255)) && g2g=255
  ((g2b > 255)) && g2b=255

  echo "$g1r $g1g $g1b $g2r $g2g $g2b"
}

is_fixed_color() {
  local color="${1,,}"
  for fc in $FIXED_COLORS; do
    [[ "$color" == "${fc,,}" ]] && return 0
  done
  return 1
}

safe_grep_count() {
  local pattern="$1"
  local file="$2"
  [[ ! -f "$file" ]] && {
    echo 0
    return
  }
  local n
  n=$(grep -oPi "(?<![0-9a-f])${pattern}(?![0-9a-f])" "$file" 2>/dev/null | wc -l | tr -d ' ' || true)
  echo "${n:-0}"
}

print_color_block() {
  local hex="${1#\#}"
  hex="${hex,,}"
  if [[ ! "$hex" =~ ^[0-9a-f]{6} ]]; then
    printf "[?]"
    return
  fi
  hex="${hex:0:6}"
  local r=$((16#${hex:0:2}))
  local g=$((16#${hex:2:2}))
  local b=$((16#${hex:4:2}))
  printf "\033[48;2;%d;%d;%dm  \033[0m" "$r" "$g" "$b"
}

# ══════════════════════════════════════════════════════════════════════════
#  TEMA LİSTELEME
# ══════════════════════════════════════════════════════════════════════════
list_themes() {
  echo -e "\n${BOLD}╔══════════════════════════════════════════════════════════╗${NC}"
  echo -e "${BOLD}║          Kullanılabilir Temalar                          ║${NC}"
  echo -e "${BOLD}╚══════════════════════════════════════════════════════════╝${NC}"

  local -A categories
  categories[yesil]="nature_green emerald forest mint sage lime jungle olive jade seafoam moss chartreuse"
  categories[mavi]="ocean_blue deep_blue cyan sky arctic navy steel_blue cornflower teal cobalt sapphire powder_blue"
  categories[mor]="purple lavender rose violet magenta orchid plum fuchsia mauve lilac wine pink_neon"
  categories[sicak]="royal_gold sunset amber copper crimson lava tangerine coral cherry sienna rust volcano peach saffron"
  categories[notr]="nord catppuccin_mocha dracula gruvbox tokyo_night onedark solarized_dark monokai material ayu_dark palenight atom_one horizon moonfly nightfox kanagawa"
  categories[acik]="github_light solarized_light catppuccin_latte gruvbox_light nord_light"
  categories[retro]="cyberpunk vaporwave synthwave outrun c64 amber_crt green_crt phosphor"
  categories[pastel]="pastel_pink pastel_blue pastel_green pastel_purple pastel_yellow bubblegum cotton_candy"
  categories[dogal]="earthy terracotta desert sand clay bamboo mushroom stone"
  categories[mono]="monochrome_dark monochrome_light charcoal graphite ink"
  categories[ozel]="aurora galactic arctic_fox deep_sea lush fire_and_ice matrix neon_city night_drive MIT _user_hybrid_blue"

  local -A cat_labels
  cat_labels[yesil]="Yeşil Tonlar"
  cat_labels[mavi]="Mavi Tonlar"
  cat_labels[mor]="Mor/Pembe Tonlar"
  cat_labels[sicak]="Sıcak Tonlar"
  cat_labels[notr]="Nötr/Popüler"
  cat_labels[acik]="Açık Temalar"
  cat_labels[retro]="Retro/Vintage"
  cat_labels[pastel]="Pastel Temalar"
  cat_labels[dogal]="Doğal/Toprak"
  cat_labels[mono]="Minimal/Mono"
  cat_labels[ozel]="Özel/Yaratıcı"

  local cat_order=(yesil mavi mor sicak notr acik retro pastel dogal mono ozel)
  local -A listed

  for cat in "${cat_order[@]}"; do
    echo -e "\n${BOLD}${CYAN}  ── ${cat_labels[$cat]} ──${NC}"
    for theme in ${categories[$cat]}; do
      local colors="${THEMES[$theme]}"
      [[ -z "$colors" ]] && continue
      listed[$theme]=1
      local -a color_arr
      read -ra color_arr <<<"$colors"
      printf "    %-22s " "$theme"
      for c in "${color_arr[@]}"; do
        print_color_block "$c"
      done
      echo ""
    done
  done

  local untagged=()
  for theme in "${!THEMES[@]}"; do
    [[ -z "${listed[$theme]+x}" ]] && untagged+=("$theme")
  done
  if ((${#untagged[@]} > 0)); then
    echo -e "\n${BOLD}${CYAN}  ── Diğer ──${NC}"
    for theme in $(printf '%s\n' "${untagged[@]}" | sort); do
      local -a color_arr
      read -ra color_arr <<<"${THEMES[$theme]}"
      printf "    %-22s " "$theme"
      for c in "${color_arr[@]}"; do print_color_block "$c"; done
      echo ""
    done
  fi

  echo ""
  echo -e "${DIM}  Toplam: ${#THEMES[@]} tema${NC}"
  echo -e "${DIM}  Kullanım: $0 --apply <tema>${NC}"
  echo -e "${DIM}  Kaynak belirt: $0 --apply <hedef> --from <kaynak>${NC}\n"
}

# ══════════════════════════════════════════════════════════════════════════
#  TARAMA
# ══════════════════════════════════════════════════════════════════════════
scan_colors() {
  if [[ ! -f "$NIXFILE" ]]; then
    echo -e "${RED}  ✗ $NIXFILE yok${NC}"
    return 1
  fi

  echo -e "\n${BOLD}  home.nix renk taraması${NC}"
  echo -e "${DIM}  Dosya: $NIXFILE${NC}\n"
  echo -e "${BOLD}  Tüm #hex renkler (kullanım sayısına göre):${NC}"

  while IFS= read -r line; do
    local count color hex marker=""
    count=$(awk '{print $1}' <<<"$line")
    color=$(awk '{print $2}' <<<"$line")
    hex="${color#\#}"
    if is_fixed_color "$hex"; then
      marker="${DIM} [SABİT - değişmez]${NC}"
    fi
    printf "    %4d× " "$count"
    print_color_block "$hex"
    echo -e " ${color}${marker}"
  done < <(grep -oiP '#[0-9a-f]{6,8}' "$NIXFILE" | tr '[:upper:]' '[:lower:]' | sort | uniq -c | sort -rn)

  echo -e "\n${BOLD}  Tema eşleşmeleri:${NC}"
  local best_theme="" best_score=0
  for theme in "${!THEMES[@]}"; do
    local -a color_arr
    read -ra color_arr <<<"${THEMES[$theme]}"
    local score=0
    for c in "${color_arr[@]}"; do
      local cnt
      cnt=$(safe_grep_count "$c" "$NIXFILE")
      ((cnt > 0)) && score=$((score + cnt))
    done
    if ((score > best_score)); then
      best_score=$score
      best_theme=$theme
    fi
    ((score > 0)) && printf "    %-22s eşleşme: %d\n" "$theme" "$score"
  done

  if [[ -n "$best_theme" ]] && ((best_score > 0)); then
    echo -e "\n    ${GREEN}En yakın tema: ${BOLD}$best_theme${NC} ${GREEN}(skor: $best_score)${NC}"
  fi

  echo -e "\n${BOLD}  RGB/RGBA formatları:${NC}"
  grep -oP 'rgba?\([0-9, .]+\)' "$NIXFILE" 2>/dev/null | sort | uniq -c | sort -rn | while IFS= read -r line; do
    echo "    $line"
  done

  echo ""
}

# ══════════════════════════════════════════════════════════════════════════
#  MEVCUT TEMA TESPİT / GÖSTER
# ══════════════════════════════════════════════════════════════════════════
detect_current_theme() {
  [[ ! -f "$NIXFILE" ]] && {
    echo "unknown"
    return
  }

  local best_theme="" best_score=0
  for theme in "${!THEMES[@]}"; do
    local -a color_arr
    read -ra color_arr <<<"${THEMES[$theme]}"
    local score=0
    for i in "${!color_arr[@]}"; do
      local cnt
      cnt=$(safe_grep_count "${color_arr[$i]}" "$NIXFILE")
      ((cnt == 0)) && continue
      if ((i < 5)); then
        score=$((score + cnt * 3))
      elif ((i < 12)); then
        score=$((score + cnt * 2))
      else
        score=$((score + cnt))
      fi
    done
    if ((score > best_score)); then
      best_score=$score
      best_theme=$theme
    fi
  done

  if ((best_score >= 50)) && [[ -n "$best_theme" ]]; then
    echo "$best_theme"
  else
    echo "unknown"
  fi
}

show_current() {
  local current
  current=$(detect_current_theme)

  if [[ "$current" == "unknown" ]]; then
    echo -e "\n${YELLOW}  ⚠ Mevcut tema otomatik tespit edilemedi${NC}"
    echo -e "${DIM}  Detaylı tarama: $0 --scan${NC}"
    echo -e "${DIM}  Elle belirt:    $0 --apply <hedef> --from <kaynak>${NC}\n"
    return
  fi

  echo -e "\n${BOLD}  Mevcut tema: ${GREEN}$current${NC}\n"
  local -a color_arr
  read -ra color_arr <<<"${THEMES[$current]}"
  for i in "${!color_arr[@]}"; do
    local cnt
    cnt=$(safe_grep_count "${color_arr[$i]}" "$NIXFILE")
    printf "    %-14s " "${SLOT_NAMES[$i]}"
    print_color_block "${color_arr[$i]}"
    if ((cnt > 0)); then
      echo -e " #${color_arr[$i]} ${GREEN}(${cnt}×)${NC}"
    else
      echo -e " #${color_arr[$i]} ${RED}(bulunamadı!)${NC}"
    fi
  done
  echo ""
}

# ══════════════════════════════════════════════════════════════════════════
#  ÖNİZLEME
# ══════════════════════════════════════════════════════════════════════════
preview_theme() {
  local theme="$1"
  if [[ -z "${THEMES[$theme]+x}" ]]; then
    echo -e "${RED}  ✗ '$theme' teması bulunamadı${NC}"
    return 1
  fi

  local -a color_arr
  read -ra color_arr <<<"${THEMES[$theme]}"

  echo -e "\n${BOLD}  Tema önizleme: ${CYAN}$theme${NC}\n"
  for i in "${!color_arr[@]}"; do
    printf "    %-14s " "${SLOT_NAMES[$i]}"
    print_color_block "${color_arr[$i]}"
    echo " #${color_arr[$i]}"
  done

  local -a grad
  read -ra grad <<<"$(compute_gradient_colors "${color_arr[5]}")"
  echo ""
  echo -e "    ${DIM}Hyprlock gradient1: rgba(${grad[0]}, ${grad[1]}, ${grad[2]}, ...)${NC}"
  echo -e "    ${DIM}Hyprlock gradient2: rgba(${grad[3]}, ${grad[4]}, ${grad[5]}, ...)${NC}"
  echo ""
}

# ══════════════════════════════════════════════════════════════════════════
#  RESİMDEN TEMA
# ══════════════════════════════════════════════════════════════════════════
generate_theme_from_image() {
  local img_path="$1"

  if [[ ! -f "$img_path" ]]; then
    echo -e "${RED}  ✗ Dosya bulunamadı: $img_path${NC}"
    exit 1
  fi

  if ! command -v magick &>/dev/null && ! command -v convert &>/dev/null; then
    echo -e "${RED}  ✗ ImageMagick gerekli${NC}"
    echo -e "${DIM}  'imagemagick' paketini kurup tekrar dene.${NC}"
    exit 1
  fi

  echo -e "\n${BOLD}  Resimden renkler çıkarılıyor...${NC}"
  echo -e "${DIM}  Dosya: $img_path${NC}"

  local hex_colors=""
  if command -v magick &>/dev/null; then
    hex_colors=$(magick "$img_path" -resize 50x50 -colors 15 -unique-colors txt:- 2>/dev/null |
      grep -oE '#[0-9A-Fa-f]{6}' | tr '[:upper:]' '[:lower:]' | sed 's/#//' || true)
  else
    hex_colors=$(convert "$img_path" -resize 50x50 -colors 15 -unique-colors txt:- 2>/dev/null |
      grep -oE '#[0-9A-Fa-f]{6}' | tr '[:upper:]' '[:lower:]' | sed 's/#//' || true)
  fi

  local -a color_arr
  read -ra color_arr <<<"$hex_colors"
  local total=${#color_arr[@]}

  if ((total == 0)); then
    echo -e "${RED}  ✗ Renk çıkarılamadı${NC}"
    exit 1
  fi

  local -a final=()
  local i last=$((total - 1))
  for ((i = 0; i < 15; i++)); do
    if ((i < total)); then
      final+=("${color_arr[$i]}")
    else
      final+=("${color_arr[$last]}")
    fi
  done

  THEMES[custom_image]="${final[*]}"

  echo -e "\n${GREEN}  ✓ Renk paketi oluşturuldu!${NC}"
  preview_theme "custom_image"

  echo ""
  read -rp "  Bu temayı uygulamak istiyor musun? [e/h]: " user_confirm
  if [[ "${user_confirm,,}" == "e" ]]; then
    apply_theme "custom_image"
  else
    echo -e "\n${YELLOW}  ⚠ İptal edildi${NC}"
  fi
}

# ══════════════════════════════════════════════════════════════════════════
#  YEDEK / GERİ YÜKLEME
# ══════════════════════════════════════════════════════════════════════════
backup() {
  mkdir -p "$BACKUP_DIR"
  local timestamp
  timestamp=$(date +%Y%m%d_%H%M%S)
  local backup_file="${BACKUP_DIR}/home.nix.${timestamp}.bak"
  cp "$NIXFILE" "$backup_file"
  echo -e "${GREEN}  ✓ Yedek oluşturuldu: ${backup_file}${NC}"

  if [[ ! -f "${BACKUP_DIR}/home.nix.original" ]]; then
    cp "$NIXFILE" "${BACKUP_DIR}/home.nix.original"
    echo -e "${GREEN}  ✓ Orijinal: ${BACKUP_DIR}/home.nix.original${NC}"
  fi
}

restore() {
  if [[ -f "${BACKUP_DIR}/home.nix.original" ]]; then
    cp "${BACKUP_DIR}/home.nix.original" "$NIXFILE"
    echo -e "${GREEN}  ✓ Orijinal geri yüklendi${NC}"
  else
    local latest
    latest=$(ls -t "${BACKUP_DIR}"/home.nix.*.bak 2>/dev/null | head -1 || true)
    if [[ -n "$latest" ]]; then
      cp "$latest" "$NIXFILE"
      echo -e "${GREEN}  ✓ Son yedek geri yüklendi: ${latest}${NC}"
    else
      echo -e "${RED}  ✗ Yedek bulunamadı${NC}"
      return 1
    fi
  fi
}

# ══════════════════════════════════════════════════════════════════════════
#  ROFI
# ══════════════════════════════════════════════════════════════════════════
write_rofi_colors_file() {
  local rasi_file="$1"
  local -n _colors=$2

  local bg="${_colors[5]}"
  local bg_alt="${_colors[6]}"
  local fg="${_colors[3]}"
  local selected="${_colors[0]}"
  local active="${_colors[1]}"
  local urgent="${_colors[2]}"

  if [[ -f "$rasi_file" ]]; then
    cp "$rasi_file" "${rasi_file}.bak.$(date +%Y%m%d_%H%M%S)" 2>/dev/null || true
  fi

  mkdir -p "$(dirname "$rasi_file")"
  cat >"$rasi_file" <<EOF
/**
* Tema renkleri (theme-switcher tarafından otomatik üretildi)
*/
* {
    background:       #${bg}FF;
    background-alt:   #${bg_alt}FF;
    foreground:       #${fg}FF;
    selected:         #${selected}FF;
    active:           #${active}FF;
    urgent:           #${urgent}FF;
}
EOF
}

update_rofi_themes() {
  local target_theme="$1"
  local -a dst_arr
  read -ra dst_arr <<<"${THEMES[$target_theme]}"

  local updated=0 skipped=0
  echo -e "\n${BOLD}  Rofi temaları güncelleniyor:${NC}"

  for rasi in $ROFI_COLOR_FILES; do
    rasi="${rasi/#\~/$HOME}"
    if [[ -d "$(dirname "$rasi")" ]] || [[ -f "$rasi" ]]; then
      write_rofi_colors_file "$rasi" dst_arr
      echo -e "    ${GREEN}✓${NC} ${rasi}"
      updated=$((updated + 1))
    else
      echo -e "    ${DIM}○ atlandı (dizin yok): ${rasi}${NC}"
      skipped=$((skipped + 1))
    fi
  done

  if ((updated == 0)); then
    echo -e "    ${YELLOW}⚠ Hiç rofi dosyası güncellenmedi${NC}"
    echo -e "    ${DIM}ROFI_COLOR_FILES env ile yolları belirtebilirsin${NC}"
  else
    echo -e "    ${DIM}Toplam: ${updated} güncellendi, ${skipped} atlandı${NC}"
  fi
}

# ══════════════════════════════════════════════════════════════════════════
#  ANA FONKSİYON: Tema uygula
# ══════════════════════════════════════════════════════════════════════════
apply_theme() {
  local target_theme="$1"
  local force_from="${2:-}"

  if [[ -z "${THEMES[$target_theme]+x}" ]]; then
    echo -e "${RED}  ✗ '$target_theme' teması bulunamadı${NC}"
    echo -e "${DIM}  Temaları listele: $0 --list${NC}"
    return 1
  fi

  if [[ ! -f "$NIXFILE" ]]; then
    echo -e "${RED}  ✗ $NIXFILE yok${NC}"
    return 1
  fi

  local current_theme
  if [[ -n "$force_from" ]]; then
    if [[ -z "${THEMES[$force_from]+x}" ]]; then
      echo -e "${RED}  ✗ Kaynak '$force_from' bulunamadı${NC}"
      return 1
    fi
    current_theme="$force_from"
    echo -e "${CYAN}  ℹ Kaynak tema elle belirtildi: $current_theme${NC}"
  else
    current_theme=$(detect_current_theme)
    if [[ "$current_theme" == "unknown" ]]; then
      echo -e "${YELLOW}  ⚠ Mevcut tema otomatik tespit edilemedi!${NC}"
      echo ""
      echo -e "${BOLD}  Çözüm seçenekleri:${NC}"
      echo -e "    1) Kaynağı belirt:  ${CYAN}$0 --apply $target_theme --from <mevcut_tema>${NC}"
      echo -e "    2) Renkleri tara:   ${CYAN}$0 --scan${NC}"
      echo -e "    3) Orijinale dön:   ${CYAN}$0 --restore${NC}"
      echo ""
      echo -e "${DIM}  Not: home.nix farklı bir araç tarafından değiştirildiyse,"
      echo -e "  --restore ile orijinale dönüp sonra temayı uygulayabilirsin.${NC}"
      return 1
    fi
  fi

  if [[ "$current_theme" == "$target_theme" ]]; then
    echo -e "${YELLOW}  ⚠ '$target_theme' zaten aktif${NC}"
    return 0
  fi

  echo -e "\n${BOLD}  Tema değişimi: ${CYAN}$current_theme${NC} → ${GREEN}$target_theme${NC}\n"

  backup

  local -a src_arr dst_arr
  read -ra src_arr <<<"${THEMES[$current_theme]}"
  read -ra dst_arr <<<"${THEMES[$target_theme]}"

  if ((${#src_arr[@]} != 15)) || ((${#dst_arr[@]} != 15)); then
    echo -e "${RED}  ✗ Renk sayısı hatalı (kaynak: ${#src_arr[@]}, hedef: ${#dst_arr[@]}; 15 olmalı)${NC}"
    return 1
  fi

  # ── PASS 1: kaynak renkler → placeholder ─────────────────────────────
  local sed_pass1=""
  local src_found=0
  local i s ph r g b n

  for i in "${!src_arr[@]}"; do
    s="${src_arr[$i]}"
    s="${s,,}"

    if is_fixed_color "$s"; then
      echo -e "    ${DIM}[sabit] #$s korunuyor${NC}"
      continue
    fi

    n=$(safe_grep_count "$s" "$NIXFILE")
    ((n == 0)) && continue

    src_found=$((src_found + n))
    ph="__TS_${i}__"

    sed_pass1+="s/#${s}\([0-9a-f]\{2\}\)\b/#${ph}\1/gI;"
    sed_pass1+="s/#${s}\b/#${ph}/gI;"
    sed_pass1+="s/rgba(${s}\([0-9a-f]\{2\}\))/rgba(${ph}\1)/gI;"
    sed_pass1+="s/rgba(${s}\b/rgba(${ph}/gI;"

    read -r r g b <<<"$(hex_to_rgb "$s")"
    sed_pass1+="s/rgb([[:space:]]*${r}[[:space:]]*,[[:space:]]*${g}[[:space:]]*,[[:space:]]*${b}[[:space:]]*)/rgb(__RGB_${i}_R__, __RGB_${i}_G__, __RGB_${i}_B__)/g;"
    sed_pass1+="s/rgba([[:space:]]*${r}[[:space:]]*,[[:space:]]*${g}[[:space:]]*,[[:space:]]*${b}[[:space:]]*,[[:space:]]*\([0-9.]*\)[[:space:]]*)/rgba(__RGB_${i}_R__, __RGB_${i}_G__, __RGB_${i}_B__, \1)/g;"
  done

  if ((src_found == 0)); then
    echo -e "\n${RED}  ✗ Kaynak renkler dosyada bulunamadı!${NC}"
    echo -e "${DIM}  Doğru kaynak temayı bul: $0 --scan${NC}\n"
    return 1
  fi
  echo -e "${DIM}  Toplam kaynak eşleşme: $src_found${NC}"

  local -a sg dg
  read -ra sg <<<"$(compute_gradient_colors "${src_arr[5]}")"
  read -ra dg <<<"$(compute_gradient_colors "${dst_arr[5]}")"

  sed_pass1+="s/rgba([[:space:]]*${sg[0]}[[:space:]]*,[[:space:]]*${sg[1]}[[:space:]]*,[[:space:]]*${sg[2]}[[:space:]]*,[[:space:]]*\([0-9.]*\)[[:space:]]*)/rgba(__G1R__, __G1G__, __G1B__, \1)/g;"
  sed_pass1+="s/rgba([[:space:]]*${sg[3]}[[:space:]]*,[[:space:]]*${sg[4]}[[:space:]]*,[[:space:]]*${sg[5]}[[:space:]]*,[[:space:]]*\([0-9.]*\)[[:space:]]*)/rgba(__G2R__, __G2G__, __G2B__, \1)/g;"

  if [[ "$current_theme" == "_user_hybrid_blue" ]]; then
    sed_pass1+="s/rgba([[:space:]]*10[[:space:]]*,[[:space:]]*20[[:space:]]*,[[:space:]]*10[[:space:]]*,[[:space:]]*\([0-9.]*\)[[:space:]]*)/rgba(__G1R__, __G1G__, __G1B__, \1)/g;"
    sed_pass1+="s/rgba([[:space:]]*20[[:space:]]*,[[:space:]]*40[[:space:]]*,[[:space:]]*20[[:space:]]*,[[:space:]]*\([0-9.]*\)[[:space:]]*)/rgba(__G2R__, __G2G__, __G2B__, \1)/g;"
  fi

  echo -e "${DIM}  Pass 1 uygulanıyor...${NC}"
  sed -i "$sed_pass1" "$NIXFILE"

  # ── PASS 2: placeholder → hedef renkler ──────────────────────────────
  local sed_pass2=""
  local d
  for i in "${!dst_arr[@]}"; do
    d="${dst_arr[$i]}"
    d="${d,,}"
    ph="__TS_${i}__"

    sed_pass2+="s/#${ph}/#${d}/g;"
    sed_pass2+="s/rgba(${ph}/rgba(${d}/g;"

    read -r r g b <<<"$(hex_to_rgb "$d")"
    sed_pass2+="s/__RGB_${i}_R__/${r}/g;"
    sed_pass2+="s/__RGB_${i}_G__/${g}/g;"
    sed_pass2+="s/__RGB_${i}_B__/${b}/g;"
  done

  sed_pass2+="s/__G1R__/${dg[0]}/g;s/__G1G__/${dg[1]}/g;s/__G1B__/${dg[2]}/g;"
  sed_pass2+="s/__G2R__/${dg[3]}/g;s/__G2G__/${dg[4]}/g;s/__G2B__/${dg[5]}/g;"

  echo -e "${DIM}  Pass 2 uygulanıyor...${NC}"
  sed -i "$sed_pass2" "$NIXFILE"

  # ── Doğrulama ────────────────────────────────────────────────────────
  echo -e "\n${BOLD}  Doğrulama:${NC}"

  local total_new=0
  for i in "${!dst_arr[@]}"; do
    n=$(safe_grep_count "${dst_arr[$i]}" "$NIXFILE")
    total_new=$((total_new + n))
    if ((n > 0)); then
      printf "    %-14s #%-8s → ${GREEN}%3d×${NC}\n" "${SLOT_NAMES[$i]}" "${dst_arr[$i]}" "$n"
    fi
  done

  local remaining_old=0
  local skip
  for i in "${!src_arr[@]}"; do
    s="${src_arr[$i]}"
    s="${s,,}"
    is_fixed_color "$s" && continue

    skip=0
    for d in "${dst_arr[@]}"; do
      if [[ "$s" == "${d,,}" ]]; then
        skip=1
        break
      fi
    done
    ((skip == 1)) && continue

    n=$(safe_grep_count "$s" "$NIXFILE")
    remaining_old=$((remaining_old + n))
    if ((n > 0)); then
      echo -e "    ${RED}⚠ Kalan eski renk: #$s → $n×${NC}"
    fi
  done

  local remaining_ph
  remaining_ph=$(grep -oE "__TS_[0-9]+__|__RGB_[0-9]+_[RGB]__|__G[12][RGB]__" "$NIXFILE" 2>/dev/null | wc -l | tr -d ' ' || echo 0)
  if ((remaining_ph > 0)); then
    echo -e "    ${RED}⚠ Kalan placeholder: $remaining_ph${NC}"
  fi

  echo ""
  echo -e "    ${BOLD}Toplam yeni kullanım: ${GREEN}$total_new${NC}"
  echo -e "    ${BOLD}Kalan eski renk: ${remaining_old}${NC}"
  echo -e "    ${BOLD}Kalan placeholder: ${remaining_ph}${NC}"

  update_rofi_themes "$target_theme"

  if ((remaining_old == 0 && remaining_ph == 0)); then
    echo -e "\n  ${GREEN}${BOLD}✓ Tema başarıyla uygulandı: ${target_theme}${NC}\n"
  else
    echo -e "\n  ${YELLOW}⚠ Tema uygulandı ama bazı değerler kaldı${NC}"
    echo -e "${DIM}  Kalanları gör: $0 --scan${NC}\n"
  fi
}

# ══════════════════════════════════════════════════════════════════════════
#  USAGE / MAIN
# ══════════════════════════════════════════════════════════════════════════
usage() {
  echo -e "\n${BOLD}  NixOS Home-Manager Theme Switcher v5.0${NC}"
  echo -e "${DIM}  Kullanım:${NC}"
  echo -e "    $0 --list                          Tema listesi"
  echo -e "    $0 --current                       Mevcut temayı göster"
  echo -e "    $0 --apply <tema>                  Tema uygula (otomatik tespit)"
  echo -e "    $0 --apply <tema> --from <kaynak>  Kaynağı elle belirterek uygula"
  echo -e "    $0 --scan                          home.nix renklerini tara"
  echo -e "    $0 --preview <tema>                Tema önizleme"
  echo -e "    $0 --image <resim_dosyası>         Resimden tema çıkar ve uygula"
  echo -e "    $0 --backup                        Yedek oluştur"
  echo -e "    $0 --restore                       Yedeği geri yükle"
  echo ""
}

main() {
  if (($# == 0)); then
    usage
    list_themes
    exit 0
  fi

  local action=""
  local theme_name=""
  local from_theme=""

  while (($# > 0)); do
    case "$1" in
    --list | -l)
      list_themes
      exit 0
      ;;
    --current | -c)
      show_current
      exit 0
      ;;
    --scan | -s)
      scan_colors
      exit 0
      ;;
    --image | -i)
      shift
      if (($# == 0)); then
        echo -e "${RED}  ✗ Resim dosyası belirtilmedi${NC}"
        exit 1
      fi
      generate_theme_from_image "$1"
      exit 0
      ;;
    --apply | -a)
      action="apply"
      shift
      if (($# == 0)); then
        echo -e "${RED}  ✗ Tema adı belirtilmedi${NC}"
        exit 1
      fi
      theme_name="$1"
      shift
      ;;
    --from | -f)
      shift
      if (($# == 0)); then
        echo -e "${RED}  ✗ Kaynak tema adı belirtilmedi${NC}"
        exit 1
      fi
      from_theme="$1"
      shift
      ;;
    --preview | -p)
      shift
      if (($# == 0)); then
        echo -e "${RED}  ✗ Tema adı belirtilmedi${NC}"
        exit 1
      fi
      preview_theme "$1"
      exit 0
      ;;
    --backup | -b)
      backup
      exit 0
      ;;
    --restore | -r)
      restore
      exit 0
      ;;
    --help | -h)
      usage
      exit 0
      ;;
    *)
      echo -e "${RED}  ✗ Bilinmeyen parametre: $1${NC}"
      usage
      exit 1
      ;;
    esac
  done

  if [[ "$action" == "apply" ]] && [[ -n "$theme_name" ]]; then
    apply_theme "$theme_name" "$from_theme"
  fi
}

main "$@"
