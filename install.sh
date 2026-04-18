#!/usr/bin/env bash
# PM-Playbooks-Skills 一键安装脚本
# 用法：
#   curl -fsSL https://raw.githubusercontent.com/CyrusYoungzzz/PM-Playbooks-Skills/main/install.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/CyrusYoungzzz/PM-Playbooks-Skills/main/install.sh | bash -s -- --project
#
# 默认安装到 ~/.claude/（全局可用）。加 --project 安装到当前目录的 .claude/。
#
# 安装内容：
#   ~/.claude/skills/pm-playbooks/        ← Skill（SKILL.md + references/）
#   ~/.claude/commands/*.md               ← 7 个 slash commands

set -euo pipefail

REPO="https://github.com/CyrusYoungzzz/PM-Playbooks-Skills.git"
SCOPE="user"

for arg in "$@"; do
  case "$arg" in
    --project|-p) SCOPE="project" ;;
    --user|-u)    SCOPE="user" ;;
    -h|--help)
      sed -n '2,8p' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
  esac
done

if [ "$SCOPE" = "project" ]; then
  TARGET="$(pwd)/.claude"
  echo "📦 安装到当前项目：$TARGET"
else
  TARGET="$HOME/.claude"
  echo "📦 安装到用户全局：$TARGET"
fi

if ! command -v git >/dev/null 2>&1; then
  echo "❌ 需要 git，请先安装 git" >&2
  exit 1
fi

TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

echo "⬇️  拉取仓库..."
git clone --depth 1 --quiet "$REPO" "$TMPDIR/repo"

SKILL_DIR="$TARGET/skills/pm-playbooks"
mkdir -p "$TARGET/commands" "$SKILL_DIR"

echo "🎯 安装 Skill（SKILL.md + references）..."
cp "$TMPDIR/repo/SKILL.md" "$SKILL_DIR/SKILL.md"
cp -R "$TMPDIR/repo/references" "$SKILL_DIR/"

echo "📝 安装 slash commands..."
cp -R "$TMPDIR/repo/.claude/commands/." "$TARGET/commands/"

cat <<EOF

✅ 安装完成

两种使用方式：

1) 显式触发（slash command，推荐）——在 Claude Code 里输入 /：
   /真伪需求分析   /爆品立项     /超预期设计   /预期诊断
   /品类立项       /产品老化     /回声效应

2) 自动触发（Skill）——描述 PM 问题时 Claude 会自动加载 pm-playbooks skill

文件位置：
   Skill:     $SKILL_DIR/
   命令：     $TARGET/commands/

试一下：
   /真伪需求分析 我想给陪聊 App 加一个一键定时祝福功能

卸载：
   rm -rf $SKILL_DIR
   rm -f  $TARGET/commands/{真伪需求分析,爆品立项,超预期设计,预期诊断,品类立项,产品老化,回声效应}.md

EOF
