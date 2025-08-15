#!/bin/bash

# 🚀 自动推送到GitHub脚本

echo "🤖 准备推送3D机器人应用到GitHub..."

# 检查Git状态
echo "📋 检查Git状态..."
git status

# 添加所有文件
echo "📁 添加所有文件..."
git add .

# 提交更改
echo "💾 提交更改..."
git commit -m "🤖 3D机器人应用更新 - $(date '+%Y-%m-%d %H:%M:%S')"

# 推送到GitHub
echo "🚀 推送到GitHub..."
git push -u origin main

if [ $? -eq 0 ]; then
    echo "✅ 推送成功！"
    echo ""
    echo "🌐 你的项目现在可以在以下地址查看："
    echo "   https://github.com/alexa-gui/HumanoidRobot-3D-App"
    echo ""
    echo "📋 下一步："
    echo "1. 访问GitHub仓库查看项目"
    echo "2. 设置GitHub Pages（可选）"
    echo "3. 配置GitHub Actions自动构建"
    echo "4. 邀请协作者（可选）"
else
    echo "❌ 推送失败！"
    echo ""
    echo "🔧 请确保："
    echo "1. 已在GitHub创建仓库：HumanoidRobot-3D-App"
    echo "2. 远程仓库地址正确"
    echo "3. 有推送权限"
    echo ""
    echo "📖 查看创建仓库说明："
    echo "   open create_repo_instructions.md"
fi
