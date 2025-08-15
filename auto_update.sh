#!/bin/bash

# 🤖 智能自动更新脚本

echo "🔍 检查文件变化..."

# 检查是否有未提交的更改
if git diff-index --quiet HEAD --; then
    echo "✅ 没有新的更改需要提交"
else
    echo "📝 发现文件变化，正在自动提交..."
    
    # 添加所有更改
    git add .
    
    # 生成提交信息
    COMMIT_MSG="🤖 自动更新 - $(date '+%Y-%m-%d %H:%M:%S')"
    
    # 提交更改
    git commit -m "$COMMIT_MSG"
    
    echo "✅ 自动提交完成: $COMMIT_MSG"
    echo "🚀 正在推送到GitHub..."
    
    # 推送到GitHub
    git push origin main
    
    if [ $? -eq 0 ]; then
        echo "🎉 自动更新成功！"
        echo "🌐 查看更新: https://github.com/alexa-gui/HumanoidRobot"
    else
        echo "❌ 推送失败，请检查网络连接"
    fi
fi
