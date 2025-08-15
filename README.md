# 🤖 HumanoidRobot 3D应用

一个现代化的iOS应用，展示各种人形机器人模型的3D交互体验。

![3D机器人应用](https://img.shields.io/badge/iOS-16.4+-blue.svg)
![SwiftUI](https://img.shields.io/badge/SwiftUI-4.0+-orange.svg)
![SceneKit](https://img.shields.io/badge/SceneKit-3D-orange.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## ✨ 功能特性

- 🎯 **多种机器人模型**: Tesla Optimus、Figure AI、Unitree G1、智元灵犀
- 🎮 **3D交互**: 手势控制旋转、缩放、点击查看详情
- 🔍 **部位详情**: 点击机器人部位查看硬件和软件规格
- 🎨 **现代化UI**: Glassy和Cyber风格设计
- 📱 **响应式设计**: 支持iPhone和iPad
- 🔧 **外部模型导入**: 支持.dae、.scn、.obj格式
- 🌟 **自定义图标**: 现代化机器人应用图标

## 🚀 快速开始

### 系统要求
- iOS 16.4+
- Xcode 14.0+
- macOS 12.0+

### 安装步骤
1. 克隆仓库
```bash
git clone https://github.com/alexa-gui/HumanoidRobot-3D-App.git
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

## 🎮 使用说明

### 主界面
- 选择不同的机器人模型
- 点击机器人卡片进入3D视图

### 3D交互
- **旋转**: 拖拽屏幕旋转机器人
- **缩放**: 双指缩放调整大小
- **点击部位**: 点击机器人部位查看详情

### 详情页面
- 查看硬件规格
- 查看软件配置
- 了解技术参数

## 🔧 自定义3D模型

详细指南请查看 [3D_MODEL_IMPORT_GUIDE.md](3D_MODEL_IMPORT_GUIDE.md)

### 支持的格式
- `.dae` (Collada) - 推荐格式
- `.scn` (SceneKit) - 最佳性能
- `.obj` - 基础几何体
- `.usdz` - AR支持

## 🎨 设计特色

### 视觉风格
- **Glassy效果**: 半透明玻璃质感
- **Cyber风格**: 科技感配色和动画
- **Morandi色系**: 柔和优雅的配色方案

### 交互设计
- 流畅的3D动画
- 直观的手势控制
- 响应式布局

## 📱 截图展示

### 主界面
- 机器人选择卡片
- 现代化导航设计

### 3D视图
- 真实3D渲染
- 交互式控制

### 详情页面
- 详细规格信息
- 优雅的布局设计

## 🔄 版本控制

### 当前版本
- 完整3D机器人展示功能
- 外部模型导入支持
- 现代化UI设计

### 计划功能
- [ ] AR增强现实支持
- [ ] 更多机器人模型
- [ ] 动画效果增强
- [ ] 云端模型同步

## 🤝 贡献

欢迎提交Issue和Pull Request！

### 贡献指南
1. Fork项目
2. 创建功能分支
3. 提交更改
4. 推送到分支
5. 创建Pull Request

## 📄 许可证

MIT License - 详见 [LICENSE](LICENSE) 文件

## 📞 联系方式

- **GitHub**: [@alexa-gui](https://github.com/alexa-gui)
- **项目地址**: https://github.com/alexa-gui/HumanoidRobot-3D-App
- **问题反馈**: [Issues](https://github.com/alexa-gui/HumanoidRobot-3D-App/issues)

## 🙏 致谢

感谢所有为这个项目做出贡献的开发者和设计师！

---

⭐ 如果这个项目对你有帮助，请给它一个星标！
