#!/usr/bin/env bash
# PM-Playbooks-Skills 一键安装脚本
# 用法：
#   curl -fsSL https://raw.githubusercontent.com/CyrusYoungzzz/PM-Playbooks-Skills/main/install.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/CyrusYoungzzz/PM-Playbooks-Skills/main/install.sh | bash -s -- --project
#
# 默认安装到 ~/.claude/（全局可用）。加 --project 安装到当前目录的 .claude/。

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

mkdir -p "$TARGET/commands"

echo "📝 拷贝 slash commands..."
cp -R "$TMPDIR/repo/.claude/commands/." "$TARGET/commands/"

echo "📚 拷贝 references..."
cp -R "$TMPDIR/repo/references" "$TARGET/"

cat <<EOF

✅ 安装完成

已安装命令（在 Claude Code 里输入 / 即可看到）：
   /真伪需求分析   /爆品立项     /超预期设计   /预期诊断
   /品类立项       /产品老化     /回声效应

文件位置：
   命令：     $TARGET/commands/
   方法论：   $TARGET/references/

试一下：
   /真伪需求分析 我想给陪聊 App 加一个一键定时祝福功能

卸载：
   rm -rf $TARGET/commands/{真伪需求分析,爆品立项,超预期设计,预期诊断,品类立项,产品老化,回声效应}.md
   rm -rf $TARGET/references

EOF
