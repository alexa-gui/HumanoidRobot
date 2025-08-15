#!/bin/bash

# 🤖 3D机器人应用 GitHub 仓库设置脚本

echo "🚀 开始设置GitHub仓库..."

# 检查是否安装了gh CLI
if ! command -v gh &> /dev/null; then
    echo "❌ 未找到GitHub CLI (gh)。请先安装："
    echo "   brew install gh"
    echo "   然后运行: gh auth login"
    exit 1
fi

# 检查GitHub认证状态
if ! gh auth status &> /dev/null; then
    echo "❌ 请先登录GitHub："
    echo "   gh auth login"
    exit 1
fi

# 创建GitHub仓库
echo "📦 创建GitHub仓库..."
REPO_NAME="HumanoidRobot-3D-App"
REPO_DESCRIPTION="🤖 3D人形机器人展示应用 - 支持多种机器人模型、3D交互和外部模型导入"

gh repo create "$REPO_NAME" \
    --description "$REPO_DESCRIPTION" \
    --public \
    --source=. \
    --remote=origin \
    --push

if [ $? -eq 0 ]; then
    echo "✅ GitHub仓库创建成功！"
    echo "🌐 仓库地址: https://github.com/$(gh api user --jq .login)/$REPO_NAME"
else
    echo "❌ 仓库创建失败，尝试手动设置..."
    echo "请访问 https://github.com/new 手动创建仓库"
    echo "然后运行以下命令："
    echo "git remote add origin https://github.com/YOUR_USERNAME/$REPO_NAME.git"
    echo "git push -u origin main"
fi

# 设置自动更新脚本
echo "🔄 设置自动更新脚本..."
cat > auto_update.sh << 'EOF'
#!/bin/bash

# 自动更新脚本
echo "🔄 开始自动更新..."

# 检查是否有更改
if [[ -n $(git status --porcelain) ]]; then
    echo "📝 发现更改，准备提交..."
    
    # 添加所有更改
    git add .
    
    # 提交更改
    git commit -m "🤖 自动更新 - $(date '+%Y-%m-%d %H:%M:%S')"
    
    # 推送到远程仓库
    git push origin main
    
    echo "✅ 自动更新完成！"
else
    echo "📭 没有发现更改"
fi
EOF

chmod +x auto_update.sh

# 创建GitHub Actions工作流
echo "⚙️ 设置GitHub Actions..."
mkdir -p .github/workflows

cat > .github/workflows/auto-update.yml << 'EOF'
name: Auto Update

on:
  push:
    branches: [ main ]
  schedule:
    # 每天凌晨2点检查更新
    - cron: '0 2 * * *'

jobs:
  update:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Xcode
      uses: maxim-lobanov/setup-xcode@v1
      with:
        xcode-version: '14.3.1'
    
    - name: Build project
      run: |
        xcodebuild -project HumanoidRobot.xcodeproj -scheme HumanoidRobot -destination 'platform=iOS Simulator,name=iPhone 14' build
    
    - name: Commit and push if changes
      run: |
        git config --local user.email "action@github.com"
        git config --local user.name "GitHub Action"
        git add .
        git diff --quiet && git diff --staged --quiet || (git commit -m "🤖 自动构建更新 - $(date '+%Y-%m-%d %H:%M:%S')" && git push)
EOF

# 创建README文件
echo "📖 创建README文件..."
cat > README.md << 'EOF'
# 🤖 HumanoidRobot 3D应用

一个现代化的iOS应用，展示各种人形机器人模型的3D交互体验。

## ✨ 功能特性

- 🎯 **多种机器人模型**: Tesla Optimus、Figure AI、Unitree G1、智元灵犀
- 🎮 **3D交互**: 手势控制旋转、缩放、点击查看详情
- 🔍 **部位详情**: 点击机器人部位查看硬件和软件规格
- 🎨 **现代化UI**: Glassy和Cyber风格设计
- 📱 **响应式设计**: 支持iPhone和iPad
- 🔧 **外部模型导入**: 支持.dae、.scn、.obj格式

## 🚀 快速开始

### 系统要求
- iOS 16.4+
- Xcode 14.0+
- macOS 12.0+

### 安装步骤
1. 克隆仓库
```bash
git clone https://github.com/YOUR_USERNAME/HumanoidRobot-3D-App.git
cd HumanoidRobot-3D-App
```

2. 打开项目
```bash
open HumanoidRobot.xcodeproj
```

3. 选择目标设备并运行

## 🎨 技术栈

- **SwiftUI**: 现代化UI框架
- **SceneKit**: 3D图形渲染
- **UIKit**: 手势识别和交互
- **Core Animation**: 流畅动画效果

## 📁 项目结构

```
HumanoidRobot/
├── ContentView.swift          # 主界面和3D视图
├── External3DModelView.swift  # 外部模型导入
├── Assets.xcassets/          # 图标和资源
└── 3DModels/                 # 3D模型文件
```

## 🔧 自定义3D模型

详细指南请查看 [3D_MODEL_IMPORT_GUIDE.md](3D_MODEL_IMPORT_GUIDE.md)

## 🤝 贡献

欢迎提交Issue和Pull Request！

## 📄 许可证

MIT License

## 📞 联系方式

如有问题，请提交Issue或联系开发者。
EOF

# 提交新文件
git add .
git commit -m "📚 添加项目文档和自动化配置"

# 推送到远程仓库
git push origin main

echo "🎉 设置完成！"
echo ""
echo "📋 下一步："
echo "1. 访问你的GitHub仓库"
echo "2. 检查GitHub Actions是否正常运行"
echo "3. 根据需要修改自动更新配置"
echo ""
echo "🔄 手动运行自动更新："
echo "   ./auto_update.sh"
echo ""
echo "📖 查看项目文档："
echo "   open README.md"
echo "   open 3D_MODEL_IMPORT_GUIDE.md"
