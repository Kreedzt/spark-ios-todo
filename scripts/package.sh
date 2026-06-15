#!/usr/bin/env bash
#
# 项目打包脚本
# 将项目源码打包为 zip，排除构建产物、版本控制及用户专属文件。
# 用法:
#   ./scripts/package.sh            # 输出到 dist/
#   ./scripts/package.sh <输出目录>  # 输出到指定目录
#
set -euo pipefail

# 仓库根目录（脚本位于 scripts/ 下）
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

PROJECT_NAME="spark-ios-todo"
OUT_DIR="${1:-$ROOT/dist}"
STAMP="$(date +%Y%m%d_%H%M%S)"
ZIP_PATH="$OUT_DIR/${PROJECT_NAME}_${STAMP}.zip"

mkdir -p "$OUT_DIR"

# 需要排除的归档成员模式（与 .gitignore 保持一致）
EXCLUDES=(
  '.git/*'
  '*/.git/*'
  '.claude/*'
  'dist/*'
  'build/*'
  '*/build/*'
  'DerivedData/*'
  '*/DerivedData/*'
  '.swiftpm/*'
  '*/.swiftpm/*'
  '.build/*'
  '*/.build/*'
  '*xcuserdata*'
  '*.xcuserstate'
  '*.DS_Store'
)

ARGS=()
for e in "${EXCLUDES[@]}"; do
  ARGS+=('-x' "$e")
done

echo "📦 正在打包 $PROJECT_NAME ..."
zip -r -q "$ZIP_PATH" . "${ARGS[@]}"

SIZE="$(du -h "$ZIP_PATH" | cut -f1)"
COUNT="$(unzip -l "$ZIP_PATH" | tail -1 | awk '{print $2}')"
echo "✅ 打包完成: $ZIP_PATH"
echo "   体积: $SIZE   文件数: $COUNT"
