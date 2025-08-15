#!/bin/bash

# 👀 文件监控和自动更新脚本

echo "👀 开始监控文件变化..."
echo "按 Ctrl+C 停止监控"

# 监控文件变化并自动更新
while true; do
    # 检查是否有未提交的更改
    if ! git diff-index --quiet HEAD --; then
        echo ""
        echo "📝 检测到文件变化，正在自动更新..."
        
        # 运行自动更新脚本
        ./auto_update.sh
        
        echo "⏳ 继续监控中..."
    fi
    
    # 等待5秒后再次检查
    sleep 5
done
