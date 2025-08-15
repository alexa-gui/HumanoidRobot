//
//  ContentView.swift
//  HumanoidRobot
//
//  Created by G axa on 8/15/25.
//

import SwiftUI
import SceneKit

struct ContentView: View {
    @State private var selectedTab = 1 // 默认选中Home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Tab 1: Robot Models - 各家公司机器人模型
            RobotSelectionView()
                .tabItem {
                    Image(systemName: "cube.box")
                    Text("Models")
                }
                .tag(0)
            
            // Tab 2: Home - 模块化组装 (中间)
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(1)
            
            // Tab 3: Knowledge - 硬核科技知识
            KnowledgeView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Knowledge")
                }
                .tag(2)
        }
        .accentColor(.cyan)
        .preferredColorScheme(.dark)
    }
}

// MARK: - Home Tab - 模块化组装
struct HomeView: View {
    @State private var showingAssemblyView = false
    @State private var showingRobotDetail = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // 赛博朋克背景
                CyberpunkBackground()
                
                VStack(spacing: 25) {
                    // 蓝色大标题
                    VStack(spacing: 8) {
                        Text("WELCOME")
                            .font(.system(size: 38, weight: .black, design: .monospaced))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.mint, Color.cyan, Color.blue],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        
                        Text("MODULAR ASSEMBLY")
                            .font(.system(size: 16, weight: .medium, design: .monospaced))
                            .foregroundColor(.white.opacity(0.8))
                            .tracking(3)
                    }
                    .padding(.top, 120)
                    .offset(y: 0)
                    
                    // 模块化机器人3D模型
                    VStack(spacing: 10) {
                        // 3D机器人视图
                        ModularRobot3DView()
                            .frame(height: 400)
                            .onTapGesture {
                                showingRobotDetail = true
                            }
                        
                        Text("Tap to explore")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .padding(.horizontal, 20)
                    
                    // 组装按钮
                    Button(action: {
                        showingAssemblyView = true
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "gearshape.2.fill")
                                .font(.system(size: 20))
                            Text("ASSEMBLE ROBOT")
                                .font(.system(size: 16, weight: .semibold, design: .monospaced))
                                .tracking(1)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.cyan, Color.blue],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                    }
                    
                    // 底部间距，确保不与Tab重叠
                    Spacer()
                        .frame(height: 100)
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingRobotDetail) {
                ModularRobotDetailView()
            }
            .sheet(isPresented: $showingAssemblyView) {
                RobotAssemblyView()
            }
        }
    }
}

// 统计卡片
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.cyan)
            
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(width: 80, height: 80)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.cyan.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

// 模块化机器人3D视图
struct ModularRobot3DView: UIViewRepresentable {
    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        sceneView.scene = createModularRobotScene()
        sceneView.backgroundColor = UIColor.clear
        sceneView.allowsCameraControl = true
        sceneView.cameraControlConfiguration.allowsTranslation = true
        sceneView.cameraControlConfiguration.autoSwitchToFreeCamera = true
        
        return sceneView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {}
    
    private func createModularRobotScene() -> SCNScene {
        let scene = SCNScene()
        
        // 创建模块化机器人
        let robotNode = createModularRobot()
        scene.rootNode.addChildNode(robotNode)
        
        // 设置相机
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(0, 2, 5)
        scene.rootNode.addChildNode(cameraNode)
        
        // 设置灯光
        let ambientLight = SCNNode()
        ambientLight.light = SCNLight()
        ambientLight.light?.type = .ambient
        ambientLight.light?.intensity = 100
        scene.rootNode.addChildNode(ambientLight)
        
        let directionalLight = SCNNode()
        directionalLight.light = SCNLight()
        directionalLight.light?.type = .directional
        directionalLight.light?.intensity = 800
        directionalLight.position = SCNVector3(5, 5, 5)
        scene.rootNode.addChildNode(directionalLight)
        
        return scene
    }
    
    private func createModularRobot() -> SCNNode {
        let robotNode = SCNNode()
        
        // 头部模块
        let headNode = createModularHead()
        headNode.position = SCNVector3(0, 1.8, 0)
        robotNode.addChildNode(headNode)
        
        // 躯干模块
        let torsoNode = createModularTorso()
        torsoNode.position = SCNVector3(0, 1.2, 0)
        robotNode.addChildNode(torsoNode)
        
        // 手臂模块
        let leftArmNode = createModularArm(isLeft: true)
        leftArmNode.position = SCNVector3(-0.8, 1.2, 0)
        robotNode.addChildNode(leftArmNode)
        
        let rightArmNode = createModularArm(isLeft: false)
        rightArmNode.position = SCNVector3(0.8, 1.2, 0)
        robotNode.addChildNode(rightArmNode)
        
        // 腿部模块
        let leftLegNode = createModularLeg(isLeft: true)
        leftLegNode.position = SCNVector3(-0.3, 0.3, 0)
        robotNode.addChildNode(leftLegNode)
        
        let rightLegNode = createModularLeg(isLeft: false)
        rightLegNode.position = SCNVector3(0.3, 0.3, 0)
        robotNode.addChildNode(rightLegNode)
        
        return robotNode
    }
    
    private func createModularHead() -> SCNNode {
        let headNode = SCNNode()
        
        // 头部主体 - 科幻六边形设计
        let headGeometry = SCNBox(width: 0.35, height: 0.45, length: 0.35, chamferRadius: 0.08)
        let headMaterial = SCNMaterial()
        headMaterial.diffuse.contents = UIColor(red: 0.1, green: 0.1, blue: 0.2, alpha: 1.0)
        headMaterial.metalness.contents = 0.9
        headMaterial.roughness.contents = 0.1
        headMaterial.reflective.contents = UIColor.white
        headGeometry.materials = [headMaterial]
        
        let headBodyNode = SCNNode(geometry: headGeometry)
        headNode.addChildNode(headBodyNode)
        
        // 科幻眼睛 - 全息投影效果
        let eyeGeometry = SCNCylinder(radius: 0.06, height: 0.02)
        let eyeMaterial = SCNMaterial()
        eyeMaterial.diffuse.contents = UIColor.cyan
        eyeMaterial.emission.contents = UIColor.cyan
        eyeMaterial.transparency = 0.8
        eyeGeometry.materials = [eyeMaterial]
        
        let leftEye = SCNNode(geometry: eyeGeometry)
        leftEye.position = SCNVector3(-0.12, 0.05, 0.18)
        leftEye.eulerAngles = SCNVector3(Float.pi/2, 0, 0)
        headNode.addChildNode(leftEye)
        
        let rightEye = SCNNode(geometry: eyeGeometry)
        rightEye.position = SCNVector3(0.12, 0.05, 0.18)
        rightEye.eulerAngles = SCNVector3(Float.pi/2, 0, 0)
        headNode.addChildNode(rightEye)
        
        // 中央传感器
        let sensorGeometry = SCNCylinder(radius: 0.03, height: 0.01)
        let sensorMaterial = SCNMaterial()
        sensorMaterial.diffuse.contents = UIColor.purple
        sensorMaterial.emission.contents = UIColor.purple
        sensorMaterial.transparency = 0.9
        sensorGeometry.materials = [sensorMaterial]
        
        let sensor = SCNNode(geometry: sensorGeometry)
        sensor.position = SCNVector3(0, 0.15, 0.18)
        sensor.eulerAngles = SCNVector3(Float.pi/2, 0, 0)
        headNode.addChildNode(sensor)
        
        // 头部装饰线条
        let lineGeometry = SCNBox(width: 0.3, height: 0.02, length: 0.01, chamferRadius: 0.005)
        let lineMaterial = SCNMaterial()
        lineMaterial.diffuse.contents = UIColor.cyan
        lineMaterial.emission.contents = UIColor.cyan
        lineGeometry.materials = [lineMaterial]
        
        let topLine = SCNNode(geometry: lineGeometry)
        topLine.position = SCNVector3(0, 0.22, 0.15)
        headNode.addChildNode(topLine)
        
        let bottomLine = SCNNode(geometry: lineGeometry)
        bottomLine.position = SCNVector3(0, -0.18, 0.15)
        headNode.addChildNode(bottomLine)
        
        return headNode
    }
    
    private func createModularTorso() -> SCNNode {
        let torsoNode = SCNNode()
        
        // 躯干主体 - 科幻装甲设计
        let torsoGeometry = SCNBox(width: 0.55, height: 0.85, length: 0.25, chamferRadius: 0.1)
        let torsoMaterial = SCNMaterial()
        torsoMaterial.diffuse.contents = UIColor(red: 0.15, green: 0.15, blue: 0.25, alpha: 1.0)
        torsoMaterial.metalness.contents = 0.95
        torsoMaterial.roughness.contents = 0.05
        torsoMaterial.reflective.contents = UIColor.white
        torsoGeometry.materials = [torsoMaterial]
        
        let torsoBodyNode = SCNNode(geometry: torsoGeometry)
        torsoNode.addChildNode(torsoBodyNode)
        
        // 中央能量核心
        let coreGeometry = SCNCylinder(radius: 0.08, height: 0.15)
        let coreMaterial = SCNMaterial()
        coreMaterial.diffuse.contents = UIColor.cyan
        coreMaterial.emission.contents = UIColor.cyan
        coreMaterial.transparency = 0.7
        coreGeometry.materials = [coreMaterial]
        
        let core = SCNNode(geometry: coreGeometry)
        core.position = SCNVector3(0, 0.1, 0.13)
        core.eulerAngles = SCNVector3(Float.pi/2, 0, 0)
        torsoNode.addChildNode(core)
        
        // 能量核心光环
        let ringGeometry = SCNTorus(ringRadius: 0.12, pipeRadius: 0.01)
        let ringMaterial = SCNMaterial()
        ringMaterial.diffuse.contents = UIColor.cyan
        ringMaterial.emission.contents = UIColor.cyan
        ringGeometry.materials = [ringMaterial]
        
        let ring = SCNNode(geometry: ringGeometry)
        ring.position = SCNVector3(0, 0.1, 0.13)
        ring.eulerAngles = SCNVector3(Float.pi/2, 0, 0)
        torsoNode.addChildNode(ring)
        
        // 装甲板
        let armorGeometry = SCNBox(width: 0.45, height: 0.2, length: 0.02, chamferRadius: 0.01)
        let armorMaterial = SCNMaterial()
        armorMaterial.diffuse.contents = UIColor(red: 0.2, green: 0.2, blue: 0.3, alpha: 1.0)
        armorMaterial.metalness.contents = 0.9
        armorGeometry.materials = [armorMaterial]
        
        let topArmor = SCNNode(geometry: armorGeometry)
        topArmor.position = SCNVector3(0, 0.3, 0.13)
        torsoNode.addChildNode(topArmor)
        
        let bottomArmor = SCNNode(geometry: armorGeometry)
        bottomArmor.position = SCNVector3(0, -0.2, 0.13)
        torsoNode.addChildNode(bottomArmor)
        
        // 装饰线条
        let lineGeometry = SCNBox(width: 0.5, height: 0.02, length: 0.01, chamferRadius: 0.005)
        let lineMaterial = SCNMaterial()
        lineMaterial.diffuse.contents = UIColor.cyan
        lineMaterial.emission.contents = UIColor.cyan
        lineGeometry.materials = [lineMaterial]
        
        let topLine = SCNNode(geometry: lineGeometry)
        topLine.position = SCNVector3(0, 0.4, 0.12)
        torsoNode.addChildNode(topLine)
        
        let bottomLine = SCNNode(geometry: lineGeometry)
        bottomLine.position = SCNVector3(0, -0.4, 0.12)
        torsoNode.addChildNode(bottomLine)
        
        return torsoNode
    }
    
    private func createModularArm(isLeft: Bool) -> SCNNode {
        let armNode = SCNNode()
        
        // 上臂 - 科幻装甲设计
        let upperArmGeometry = SCNCapsule(capRadius: 0.09, height: 0.42)
        let armMaterial = SCNMaterial()
        armMaterial.diffuse.contents = UIColor(red: 0.2, green: 0.2, blue: 0.3, alpha: 1.0)
        armMaterial.metalness.contents = 0.9
        armMaterial.roughness.contents = 0.1
        upperArmGeometry.materials = [armMaterial]
        
        let upperArmNode = SCNNode(geometry: upperArmGeometry)
        upperArmNode.eulerAngles = SCNVector3(0, 0, isLeft ? Float.pi/4 : -Float.pi/4)
        armNode.addChildNode(upperArmNode)
        
        // 上臂装甲板
        let upperArmorGeometry = SCNBox(width: 0.15, height: 0.35, length: 0.02, chamferRadius: 0.01)
        let armorMaterial = SCNMaterial()
        armorMaterial.diffuse.contents = UIColor(red: 0.25, green: 0.25, blue: 0.35, alpha: 1.0)
        armorMaterial.metalness.contents = 0.95
        upperArmorGeometry.materials = [armorMaterial]
        
        let upperArmor = SCNNode(geometry: upperArmorGeometry)
        upperArmor.position = SCNVector3(isLeft ? -0.05 : 0.05, -0.02, 0.1)
        upperArmor.eulerAngles = SCNVector3(0, 0, isLeft ? Float.pi/4 : -Float.pi/4)
        armNode.addChildNode(upperArmor)
        
        // 前臂
        let forearmGeometry = SCNCapsule(capRadius: 0.07, height: 0.32)
        forearmGeometry.materials = [armMaterial]
        
        let forearmNode = SCNNode(geometry: forearmGeometry)
        forearmNode.position = SCNVector3(isLeft ? -0.22 : 0.22, -0.18, 0)
        forearmNode.eulerAngles = SCNVector3(0, 0, isLeft ? Float.pi/6 : -Float.pi/6)
        armNode.addChildNode(forearmNode)
        
        // 前臂装甲板
        let forearmArmorGeometry = SCNBox(width: 0.12, height: 0.25, length: 0.02, chamferRadius: 0.01)
        forearmArmorGeometry.materials = [armorMaterial]
        
        let forearmArmor = SCNNode(geometry: forearmArmorGeometry)
        forearmArmor.position = SCNVector3(isLeft ? -0.33 : 0.33, -0.25, 0.08)
        forearmArmor.eulerAngles = SCNVector3(0, 0, isLeft ? Float.pi/6 : -Float.pi/6)
        armNode.addChildNode(forearmArmor)
        
        // 科幻手部
        let handGeometry = SCNBox(width: 0.14, height: 0.1, length: 0.18, chamferRadius: 0.03)
        let handMaterial = SCNMaterial()
        handMaterial.diffuse.contents = UIColor(red: 0.15, green: 0.15, blue: 0.25, alpha: 1.0)
        handMaterial.metalness.contents = 0.95
        handMaterial.roughness.contents = 0.05
        handGeometry.materials = [handMaterial]
        
        let handNode = SCNNode(geometry: handGeometry)
        handNode.position = SCNVector3(isLeft ? -0.38 : 0.38, -0.32, 0)
        armNode.addChildNode(handNode)
        
        // 手部能量核心
        let handCoreGeometry = SCNCylinder(radius: 0.02, height: 0.05)
        let handCoreMaterial = SCNMaterial()
        handCoreMaterial.diffuse.contents = UIColor.cyan
        handCoreMaterial.emission.contents = UIColor.cyan
        handCoreGeometry.materials = [handCoreMaterial]
        
        let handCore = SCNNode(geometry: handCoreGeometry)
        handCore.position = SCNVector3(isLeft ? -0.38 : 0.38, -0.32, 0.09)
        handCore.eulerAngles = SCNVector3(Float.pi/2, 0, 0)
        armNode.addChildNode(handCore)
        
        // 关节装饰
        let jointGeometry = SCNTorus(ringRadius: 0.1, pipeRadius: 0.01)
        let jointMaterial = SCNMaterial()
        jointMaterial.diffuse.contents = UIColor.cyan
        jointMaterial.emission.contents = UIColor.cyan
        jointGeometry.materials = [jointMaterial]
        
        let shoulderJoint = SCNNode(geometry: jointGeometry)
        shoulderJoint.position = SCNVector3(isLeft ? -0.05 : 0.05, 0.1, 0)
        shoulderJoint.eulerAngles = SCNVector3(Float.pi/2, 0, 0)
        armNode.addChildNode(shoulderJoint)
        
        let elbowJoint = SCNNode(geometry: jointGeometry)
        elbowJoint.position = SCNVector3(isLeft ? -0.22 : 0.22, -0.18, 0)
        elbowJoint.eulerAngles = SCNVector3(Float.pi/2, 0, 0)
        armNode.addChildNode(elbowJoint)
        
        return armNode
    }
    
    private func createModularLeg(isLeft: Bool) -> SCNNode {
        let legNode = SCNNode()
        
        // 大腿 - 科幻装甲设计
        let thighGeometry = SCNCapsule(capRadius: 0.11, height: 0.52)
        let legMaterial = SCNMaterial()
        legMaterial.diffuse.contents = UIColor(red: 0.2, green: 0.2, blue: 0.3, alpha: 1.0)
        legMaterial.metalness.contents = 0.9
        legMaterial.roughness.contents = 0.1
        thighGeometry.materials = [legMaterial]
        
        let thighNode = SCNNode(geometry: thighGeometry)
        legNode.addChildNode(thighNode)
        
        // 大腿装甲板
        let thighArmorGeometry = SCNBox(width: 0.18, height: 0.4, length: 0.02, chamferRadius: 0.01)
        let armorMaterial = SCNMaterial()
        armorMaterial.diffuse.contents = UIColor(red: 0.25, green: 0.25, blue: 0.35, alpha: 1.0)
        armorMaterial.metalness.contents = 0.95
        thighArmorGeometry.materials = [armorMaterial]
        
        let thighArmor = SCNNode(geometry: thighArmorGeometry)
        thighArmor.position = SCNVector3(0, 0.02, 0.11)
        legNode.addChildNode(thighArmor)
        
        // 小腿
        let calfGeometry = SCNCapsule(capRadius: 0.09, height: 0.42)
        calfGeometry.materials = [legMaterial]
        
        let calfNode = SCNNode(geometry: calfGeometry)
        calfNode.position = SCNVector3(0, -0.47, 0)
        legNode.addChildNode(calfNode)
        
        // 小腿装甲板
        let calfArmorGeometry = SCNBox(width: 0.15, height: 0.3, length: 0.02, chamferRadius: 0.01)
        calfArmorGeometry.materials = [armorMaterial]
        
        let calfArmor = SCNNode(geometry: calfArmorGeometry)
        calfArmor.position = SCNVector3(0, -0.47, 0.09)
        legNode.addChildNode(calfArmor)
        
        // 科幻脚部
        let footGeometry = SCNBox(width: 0.18, height: 0.1, length: 0.28, chamferRadius: 0.03)
        let footMaterial = SCNMaterial()
        footMaterial.diffuse.contents = UIColor(red: 0.15, green: 0.15, blue: 0.25, alpha: 1.0)
        footMaterial.metalness.contents = 0.95
        footMaterial.roughness.contents = 0.05
        footGeometry.materials = [footMaterial]
        
        let footNode = SCNNode(geometry: footGeometry)
        footNode.position = SCNVector3(0, -0.68, 0.06)
        legNode.addChildNode(footNode)
        
        // 脚部推进器
        let thrusterGeometry = SCNCylinder(radius: 0.03, height: 0.02)
        let thrusterMaterial = SCNMaterial()
        thrusterMaterial.diffuse.contents = UIColor.orange
        thrusterMaterial.emission.contents = UIColor.orange
        thrusterGeometry.materials = [thrusterMaterial]
        
        let leftThruster = SCNNode(geometry: thrusterGeometry)
        leftThruster.position = SCNVector3(-0.06, -0.68, 0.15)
        leftThruster.eulerAngles = SCNVector3(Float.pi/2, 0, 0)
        legNode.addChildNode(leftThruster)
        
        let rightThruster = SCNNode(geometry: thrusterGeometry)
        rightThruster.position = SCNVector3(0.06, -0.68, 0.15)
        rightThruster.eulerAngles = SCNVector3(Float.pi/2, 0, 0)
        legNode.addChildNode(rightThruster)
        
        // 关节装饰
        let jointGeometry = SCNTorus(ringRadius: 0.12, pipeRadius: 0.01)
        let jointMaterial = SCNMaterial()
        jointMaterial.diffuse.contents = UIColor.cyan
        jointMaterial.emission.contents = UIColor.cyan
        jointGeometry.materials = [jointMaterial]
        
        let hipJoint = SCNNode(geometry: jointGeometry)
        hipJoint.position = SCNVector3(0, 0.25, 0)
        hipJoint.eulerAngles = SCNVector3(Float.pi/2, 0, 0)
        legNode.addChildNode(hipJoint)
        
        let kneeJoint = SCNNode(geometry: jointGeometry)
        kneeJoint.position = SCNVector3(0, -0.25, 0)
        kneeJoint.eulerAngles = SCNVector3(Float.pi/2, 0, 0)
        legNode.addChildNode(kneeJoint)
        
        return legNode
    }
}

// 模块化机器人详情页
struct ModularRobotDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                CyberpunkBackground()
                
                ScrollView {
                    VStack(spacing: 30) {
                        // 3D模型
                        ModularRobot3DView()
                            .frame(height: 300)
                        
                        // 模块信息
                        VStack(spacing: 20) {
                            Text("MODULAR COMPONENTS")
                                .font(.system(size: 20, weight: .bold, design: .monospaced))
                                .foregroundColor(.white)
                                .tracking(2)
                            
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                                SpecCard(title: "Head", value: "AI Core", icon: "brain.head.profile")
                                SpecCard(title: "Torso", value: "Power Unit", icon: "bolt")
                                SpecCard(title: "Arms", value: "Servo Motors", icon: "gearshape")
                                SpecCard(title: "Legs", value: "Actuators", icon: "figure.walk")
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // 组装状态
                        VStack(spacing: 15) {
                            Text("ASSEMBLY STATUS")
                                .font(.system(size: 20, weight: .bold, design: .monospaced))
                                .foregroundColor(.white)
                                .tracking(2)
                            
                            VStack(spacing: 10) {
                                AssemblyStatusRow(component: "Head Module", status: "Installed", color: .green)
                                AssemblyStatusRow(component: "Torso Module", status: "Installed", color: .green)
                                AssemblyStatusRow(component: "Arm Modules", status: "Installed", color: .green)
                                AssemblyStatusRow(component: "Leg Modules", status: "Installed", color: .green)
                                AssemblyStatusRow(component: "AI Processor", status: "Ready", color: .blue)
                                AssemblyStatusRow(component: "Power System", status: "Ready", color: .blue)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.vertical, 20)
                }
            }
            .navigationTitle("Modular Robot")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

// 组装状态行
struct AssemblyStatusRow: View {
    let component: String
    let status: String
    let color: Color
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(component)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(status)
                    .font(.system(size: 12))
                    .foregroundColor(color)
            }
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 16))
                .foregroundColor(color)
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.05))
        )
    }
}

// 机器人组装界面
struct RobotAssemblyView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedCategory = 0
    @State private var selectedComponent = 0
    
    let categories = ["Head", "Torso", "Arms", "Legs", "Sensors", "Power"]
    
    var body: some View {
        NavigationView {
            ZStack {
                CyberpunkBackground()
                
                VStack(spacing: 0) {
                    // 3D预览区域
        VStack {
                        Text("ASSEMBLY PREVIEW")
                            .font(.system(size: 18, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                            .tracking(2)
                            .padding(.top, 20)
                        
                        ModularRobot3DView()
                            .frame(height: 300)
                            .padding(.horizontal, 20)
                    }
                    
                    // 组装控制区域
                    VStack(spacing: 20) {
                        // 分类选择器
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(0..<categories.count, id: \.self) { index in
                                    Button(action: {
                                        selectedCategory = index
                                        selectedComponent = 0
                                    }) {
                                        Text(categories[index])
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(selectedCategory == index ? .white : .white.opacity(0.6))
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 10)
                                            .background(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .fill(selectedCategory == index ? 
                                                          LinearGradient(colors: [Color.cyan, Color.blue], startPoint: .leading, endPoint: .trailing) :
                                                          LinearGradient(colors: [Color.white.opacity(0.1), Color.white.opacity(0.1)], startPoint: .leading, endPoint: .trailing))
                                            )
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .stroke(selectedCategory == index ? Color.cyan.opacity(0.5) : Color.clear, lineWidth: 1)
                                            )
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        // 组件列表
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                                ForEach(getComponents(for: selectedCategory), id: \.self) { component in
                                    ComponentCard(component: component)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        .frame(maxHeight: 300)
                    }
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Robot Assembly")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
    
    private func getComponents(for category: Int) -> [String] {
        switch category {
        case 0: // Head
            return ["AI Core v1.0", "Vision System", "Audio Processor", "Neural Network", "Memory Module", "Communication Hub"]
        case 1: // Torso
            return ["Power Unit", "Main Controller", "Battery Pack", "Cooling System", "Data Bus", "Backup Power"]
        case 2: // Arms
            return ["Servo Motors", "Force Sensors", "Gripper System", "Joint Controllers", "Flexible Cables", "Armor Plating"]
        case 3: // Legs
            return ["Linear Actuators", "Balance Sensors", "Foot Pads", "Knee Joints", "Shock Absorbers", "Mobility System"]
        case 4: // Sensors
            return ["LIDAR Scanner", "Depth Camera", "IMU Sensor", "Touch Sensors", "Temperature Sensor", "Pressure Sensors"]
        case 5: // Power
            return ["Lithium Battery", "Solar Panel", "Wireless Charging", "Power Management", "Energy Monitor", "Backup Generator"]
        default:
            return []
        }
    }
}

// 组件卡片
struct ComponentCard: View {
    let component: String
    
    var body: some View {
        VStack(spacing: 12) {
            // 组件图标
            Image(systemName: getComponentIcon())
                .font(.system(size: 30))
                .foregroundColor(.cyan)
                .frame(width: 60, height: 60)
                .background(
                    Circle()
                        .fill(Color.cyan.opacity(0.2))
                )
            
            // 组件名称
            Text(component)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            // 安装按钮
            Button(action: {
                // 安装组件的逻辑
            }) {
                Text("INSTALL")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.green)
                    )
            }
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 10)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.cyan.opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    private func getComponentIcon() -> String {
        if component.contains("AI") || component.contains("Neural") {
            return "brain.head.profile"
        } else if component.contains("Vision") || component.contains("Camera") {
            return "eye"
        } else if component.contains("Power") || component.contains("Battery") {
            return "bolt"
        } else if component.contains("Motor") || component.contains("Actuator") {
            return "gearshape"
        } else if component.contains("Sensor") {
            return "sensor.tag.radiowaves"
        } else if component.contains("Memory") || component.contains("Data") {
            return "memorychip"
        } else {
            return "cube"
        }
    }
}

// 规格卡片
struct SpecCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.cyan)
            
            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
            
            Text(title)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(height: 80)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.cyan.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

// 功能行
struct CapabilityRow: View {
    let title: String
    let description: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12))
                .foregroundColor(.cyan)
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.05))
        )
    }
}

// MARK: - Knowledge Tab - 硬核科技知识
struct KnowledgeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                CyberpunkBackground()
                
                VStack(spacing: 25) {
                    // 标题
                    VStack(spacing: 10) {
                        Text("KNOWLEDGE")
                            .font(.system(size: 38, weight: .black, design: .monospaced))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.mint, Color.cyan, Color.blue],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        
                        Text("EMBODIED AI GUIDE")
                            .font(.system(size: 16, weight: .medium, design: .monospaced))
                            .foregroundColor(.white.opacity(0.8))
                            .tracking(2)
                    }
                    .padding(.top, 120)
                    .offset(y: 0)
                    
                    // 知识分类
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible())], spacing: 15) {
                            KnowledgeCategoryCard(
                                title: "Hardware Systems",
                                subtitle: "机械结构、传感器、执行器",
                                icon: "gearshape.2.fill",
                                color: .blue
                            )
                            
                            KnowledgeCategoryCard(
                                title: "Software & AI",
                                subtitle: "算法、机器学习、控制系统",
                                icon: "brain.head.profile",
                                color: .purple
                            )
                            
                            KnowledgeCategoryCard(
                                title: "Control & Planning",
                                subtitle: "运动控制、路径规划、任务执行",
                                icon: "target",
                                color: .green
                            )
                            
                            KnowledgeCategoryCard(
                                title: "Perception & Sensing",
                                subtitle: "视觉、触觉、多模态感知",
                                icon: "eye.fill",
                                color: .orange
                            )
                            
                            KnowledgeCategoryCard(
                                title: "Learning & Adaptation",
                                subtitle: "强化学习、模仿学习、迁移学习",
                                icon: "graduationcap.fill",
                                color: .pink
                            )
                            
                            KnowledgeCategoryCard(
                                title: "Datasets & Benchmarks",
                                subtitle: "训练数据、评估标准、基准测试",
                                icon: "externaldrive.fill",
                                color: .cyan
                            )
                            
                            KnowledgeCategoryCard(
                                title: "Research Papers",
                                subtitle: "最新论文、技术趋势、前沿研究",
                                icon: "doc.text.fill",
                                color: .red
                            )
                            
                            KnowledgeCategoryCard(
                                title: "Development Tools",
                                subtitle: "仿真环境、开发框架、调试工具",
                                icon: "hammer.fill",
                                color: .yellow
                            )
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 30)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// 知识分类卡片
struct KnowledgeCategoryCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        NavigationLink(destination: KnowledgeDetailView(category: title)) {
            HStack(spacing: 15) {
                // 图标
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
                    .frame(width: 50, height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(color.opacity(0.2))
                    )
                
                // 内容
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.7))
                        .lineLimit(2)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(color.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// 知识详情页
struct KnowledgeDetailView: View {
    let category: String
    
    var body: some View {
        ZStack {
            CyberpunkBackground()
            
            ScrollView {
                VStack(spacing: 25) {
                    // 标题
                    Text(category.uppercased())
                        .font(.system(size: 28, weight: .black, design: .monospaced))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.mint, Color.cyan, Color.blue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .padding(.top, 20)
                    
                    // 根据分类显示不同内容
                    switch category {
                    case "Hardware Systems":
                        HardwareSystemsContent()
                    case "Software & AI":
                        SoftwareAIContent()
                    case "Control & Planning":
                        ControlPlanningContent()
                    case "Perception & Sensing":
                        PerceptionSensingContent()
                    case "Learning & Adaptation":
                        LearningAdaptationContent()
                    case "Datasets & Benchmarks":
                        DatasetsBenchmarksContent()
                    case "Research Papers":
                        ResearchPapersContent()
                    case "Development Tools":
                        DevelopmentToolsContent()
                    default:
                        Text("Content coming soon...")
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .navigationTitle(category)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 知识内容组件
struct HardwareSystemsContent: View {
    var body: some View {
        VStack(spacing: 20) {
            KnowledgeSection(
                title: "机械结构",
                items: [
                    "关节设计 - 高精度伺服电机",
                    "连杆系统 - 轻量化碳纤维材料",
                    "平衡机构 - 动态重心调节",
                    "末端执行器 - 多功能手部设计"
                ]
            )
            
            KnowledgeSection(
                title: "传感器系统",
                items: [
                    "IMU - 惯性测量单元",
                    "力传感器 - 触觉反馈",
                    "视觉传感器 - 深度相机",
                    "编码器 - 位置反馈"
                ]
            )
            
            KnowledgeSection(
                title: "执行器技术",
                items: [
                    "伺服电机 - 高扭矩密度",
                    "液压系统 - 大功率输出",
                    "气动系统 - 轻量化设计",
                    "直线执行器 - 精确控制"
                ]
            )
        }
    }
}

struct SoftwareAIContent: View {
    var body: some View {
        VStack(spacing: 20) {
            KnowledgeSection(
                title: "人工智能算法",
                items: [
                    "深度学习 - 神经网络架构",
                    "强化学习 - 策略优化",
                    "计算机视觉 - 目标识别",
                    "自然语言处理 - 人机交互"
                ]
            )
            
            KnowledgeSection(
                title: "控制系统",
                items: [
                    "PID控制 - 基础控制算法",
                    "模型预测控制 - 高级控制",
                    "自适应控制 - 环境适应",
                    "鲁棒控制 - 抗干扰能力"
                ]
            )
            
            KnowledgeSection(
                title: "软件架构",
                items: [
                    "ROS - 机器人操作系统",
                    "实时系统 - 低延迟响应",
                    "分布式计算 - 多核并行",
                    "云端集成 - 远程控制"
                ]
            )
        }
    }
}

struct ControlPlanningContent: View {
    var body: some View {
        VStack(spacing: 20) {
            KnowledgeSection(
                title: "运动控制",
                items: [
                    "轨迹规划 - 平滑运动",
                    "逆运动学 - 位置控制",
                    "动力学建模 - 力控制",
                    "协调控制 - 多关节同步"
                ]
            )
            
            KnowledgeSection(
                title: "路径规划",
                items: [
                    "A*算法 - 最优路径",
                    "RRT算法 - 随机采样",
                    "PRM算法 - 概率路线图",
                    "动态规划 - 实时调整"
                ]
            )
            
            KnowledgeSection(
                title: "任务执行",
                items: [
                    "任务分解 - 层次化执行",
                    "状态机 - 行为控制",
                    "错误恢复 - 异常处理",
                    "多任务调度 - 并行执行"
                ]
            )
        }
    }
}

struct PerceptionSensingContent: View {
    var body: some View {
        VStack(spacing: 20) {
            KnowledgeSection(
                title: "视觉感知",
                items: [
                    "目标检测 - YOLO/SSD算法",
                    "语义分割 - 像素级识别",
                    "深度估计 - 3D重建",
                    "姿态估计 - 6DOF定位"
                ]
            )
            
            KnowledgeSection(
                title: "触觉感知",
                items: [
                    "力反馈 - 接触力测量",
                    "纹理识别 - 表面特征",
                    "形状感知 - 物体几何",
                    "温度感知 - 热传导"
                ]
            )
            
            KnowledgeSection(
                title: "多模态融合",
                items: [
                    "传感器融合 - 卡尔曼滤波",
                    "跨模态学习 - 信息互补",
                    "注意力机制 - 重点关注",
                    "时序建模 - 动态感知"
                ]
            )
        }
    }
}

struct LearningAdaptationContent: View {
    var body: some View {
        VStack(spacing: 20) {
            KnowledgeSection(
                title: "强化学习",
                items: [
                    "Q-Learning - 价值函数",
                    "Policy Gradient - 策略优化",
                    "Actor-Critic - 混合方法",
                    "Multi-Agent - 协作学习"
                ]
            )
            
            KnowledgeSection(
                title: "模仿学习",
                items: [
                    "行为克隆 - 直接模仿",
                    "逆强化学习 - 奖励推断",
                    "生成对抗模仿 - GAN方法",
                    "多模态模仿 - 跨域学习"
                ]
            )
            
            KnowledgeSection(
                title: "迁移学习",
                items: [
                    "域适应 - 环境迁移",
                    "技能迁移 - 任务迁移",
                    "元学习 - 快速适应",
                    "持续学习 - 增量更新"
                ]
            )
        }
    }
}

struct DatasetsBenchmarksContent: View {
    var body: some View {
        VStack(spacing: 20) {
            KnowledgeSection(
                title: "训练数据集",
                items: [
                    "RoboMIND - 10.7万条轨迹",
                    "AgiBot World - 100万条数据",
                    "DROID - 7.6万条示范",
                    "BridgeData V2 - 6万条轨迹"
                ]
            )
            
            KnowledgeSection(
                title: "评估基准",
                items: [
                    "成功率 - 任务完成率",
                    "效率指标 - 时间成本",
                    "鲁棒性 - 环境适应",
                    "泛化能力 - 跨域测试"
                ]
            )
            
            KnowledgeSection(
                title: "竞赛平台",
                items: [
                    "RoboCup - 机器人足球",
                    "DARPA Challenge - 救援任务",
                    "Amazon Picking - 拣选挑战",
                    "RLBench - 基准测试"
                ]
            )
        }
    }
}

struct ResearchPapersContent: View {
    var body: some View {
        VStack(spacing: 20) {
            KnowledgeSection(
                title: "最新论文",
                items: [
                    "ICRA 2025 - 机器人自动化",
                    "CoRL 2024 - 强化学习",
                    "NeurIPS 2024 - 深度学习",
                    "Science Robotics - 前沿技术"
                ]
            )
            
            KnowledgeSection(
                title: "技术趋势",
                items: [
                    "大语言模型 - 机器人控制",
                    "多模态学习 - 跨域理解",
                    "自监督学习 - 无标注数据",
                    "神经符号 - 可解释AI"
                ]
            )
            
            KnowledgeSection(
                title: "前沿研究",
                items: [
                    "具身智能 - 物理交互",
                    "社会机器人 - 人机协作",
                    "软体机器人 - 柔性设计",
                    "群体机器人 - 分布式控制"
                ]
            )
        }
    }
}

struct DevelopmentToolsContent: View {
    var body: some View {
        VStack(spacing: 20) {
            KnowledgeSection(
                title: "仿真环境",
                items: [
                    "MuJoCo - 物理仿真",
                    "Gazebo - ROS集成",
                    "PyBullet - 开源仿真",
                    "Isaac Sim - NVIDIA平台"
                ]
            )
            
            KnowledgeSection(
                title: "开发框架",
                items: [
                    "ROS/ROS2 - 机器人中间件",
                    "MoveIt - 运动规划",
                    "OpenAI Gym - 强化学习",
                    "Stable Baselines - RL算法"
                ]
            )
            
            KnowledgeSection(
                title: "调试工具",
                items: [
                    "RViz - 3D可视化",
                    "rqt - 图形化工具",
                    "PlotJuggler - 数据可视化",
                    "GDB - 程序调试"
                ]
            )
        }
    }
}

// 知识章节组件
struct KnowledgeSection: View {
    let title: String
    let items: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .font(.system(size: 18, weight: .bold, design: .monospaced))
                .foregroundColor(.cyan)
                .tracking(1)
            
            VStack(spacing: 8) {
                ForEach(items, id: \.self) { item in
                    HStack {
                        Image(systemName: "circle.fill")
                            .font(.system(size: 6))
                            .foregroundColor(.cyan)
                        
                        Text(item)
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white.opacity(0.05))
                    )
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.cyan.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

// 机器人选择主页 (Robots Tab)
struct RobotSelectionView: View {
    var body: some View {
        NavigationView {
            ZStack {
                // 赛博朋克背景
                CyberpunkBackground()
                
                VStack(spacing: 25) {
                    // 标题
                    VStack(spacing: 10) {
                        Text("ROBOT")
                            .font(.system(size: 38, weight: .black, design: .monospaced))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.mint, Color.cyan, Color.blue],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        
                        Text("COLLECTION")
                            .font(.system(size: 16, weight: .medium, design: .monospaced))
                            .foregroundColor(.white.opacity(0.8))
                            .tracking(3)
                    }
                    .padding(.top, 120)
                    .offset(y: 0)
                    
                    Spacer()
                    
                    // 机器人选择网格
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 20) {
                        ForEach(RobotType.allCases, id: \.self) { robot in
                            NavigationLink(destination: RobotDetailView(robot: robot)) {
                                RobotCard(robot: robot)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    Spacer()
                    
                    Text("SELECT YOUR ROBOT")
                        .font(.system(size: 14, weight: .medium, design: .monospaced))
                        .foregroundColor(.white.opacity(0.6))
                        .tracking(2)
                        .padding(.bottom, 30)
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// 赛博朋克背景
struct CyberpunkBackground: View {
    @State private var animationPhase: CGFloat = 0
    
    var body: some View {
        ZStack {
            // 基础渐变
            LinearGradient(
                colors: [
                    Color(red: 0.1, green: 0.05, blue: 0.2),
                    Color(red: 0.05, green: 0.1, blue: 0.15),
                    Color(red: 0.15, green: 0.05, blue: 0.1)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // 动态网格
            GeometryReader { geometry in
                Path { path in
                    let width = geometry.size.width
                    let height = geometry.size.height
                    let gridSize: CGFloat = 40
                    
                    for x in stride(from: 0, through: width, by: gridSize) {
                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x, y: height))
                    }
                    
                    for y in stride(from: 0, through: height, by: gridSize) {
                        path.move(to: CGPoint(x: 0, y: y + 60))
                        path.addLine(to: CGPoint(x: width, y: y + 60))
                    }
                }
                .stroke(Color.mint.opacity(0.1), lineWidth: 0.5)
            }
            
            // 浮动粒子
            ForEach(0..<20, id: \.self) { index in
                Circle()
                    .fill(Color.cyan.opacity(0.3))
                    .frame(width: 4, height: 4)
                    .offset(
                        x: CGFloat.random(in: -200...200),
                        y: CGFloat.random(in: -400...400)
                    )
                    .animation(
                        Animation.easeInOut(duration: Double.random(in: 3...6))
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.2),
                        value: animationPhase
                    )
            }
        }
        .onAppear {
            animationPhase = 1
        }
    }
}

// 机器人类型枚举
enum RobotType: String, CaseIterable {
    case teslaOptimus = "Tesla Optimus"
    case figureAI = "Figure AI"
    case yushuG1 = "宇树 G1"
    case zhiyuanLingxi = "智元灵犀"
    
    var description: String {
        switch self {
        case .teslaOptimus:
            return "特斯拉人形机器人"
        case .figureAI:
            return "Figure AI 智能机器人"
        case .yushuG1:
            return "宇树科技 G1 机器人"
        case .zhiyuanLingxi:
            return "智元机器人 灵犀"
        }
    }
    
    var colorScheme: (primary: Color, secondary: Color, accent: Color) {
        switch self {
        case .teslaOptimus:
            return (Color.mint, Color.cyan, Color.blue)
        case .figureAI:
            return (Color.pink, Color.purple, Color.indigo)
        case .yushuG1:
            return (Color.orange, Color.yellow, Color.red)
        case .zhiyuanLingxi:
            return (Color.green, Color.teal, Color.mint)
        }
    }
    
    var icon: String {
        switch self {
        case .teslaOptimus:
            return "bolt.fill"
        case .figureAI:
            return "brain.head.profile"
        case .yushuG1:
            return "leaf.fill"
        case .zhiyuanLingxi:
            return "sparkles"
        }
    }
}

// 机器人卡片
struct RobotCard: View {
    let robot: RobotType
    
    var body: some View {
        VStack(spacing: 20) {
            // 图标
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                robot.colorScheme.primary.opacity(0.3),
                                robot.colorScheme.secondary.opacity(0.2)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [robot.colorScheme.primary, robot.colorScheme.secondary],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    )
                
                Image(systemName: robot.icon)
                    .font(.system(size: 32, weight: .medium))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [robot.colorScheme.primary, robot.colorScheme.secondary],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            // 文字信息
            VStack(spacing: 8) {
                Text(robot.rawValue)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text(robot.description)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
        }
        .frame(height: 180)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.15),
                            Color.white.opacity(0.08),
                            Color.white.opacity(0.03)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    robot.colorScheme.primary.opacity(0.4),
                                    robot.colorScheme.secondary.opacity(0.4),
                                    robot.colorScheme.accent.opacity(0.3)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                )
        )
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.05),
                            Color.clear
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        )
    }
}

// 机器人详情页
struct RobotDetailView: View {
    let robot: RobotType
    @State private var selectedPart: RobotPart?
    @State private var showingDetail = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            // 背景
            CyberpunkBackground()
            
            VStack {
                // 顶部导航栏
                HStack {
                    // 返回按钮
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .medium))
                            Text("Back")
                                .font(.system(size: 16, weight: .medium))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white.opacity(0.2))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                )
                        )
                    }
                    
                    Spacer()
                    
                    Text(robot.rawValue)
                        .font(.system(size: 24, weight: .bold, design: .monospaced))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [robot.colorScheme.primary, robot.colorScheme.secondary],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    Spacer()
                    
                    // 分享按钮
                    Button(action: {
                        // 分享功能
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white.opacity(0.2))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                    )
                            )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                Spacer()
                
                // 3D机器人模型
                Robot3DView(
                    robot: robot,
                    selectedPart: $selectedPart,
                    showingDetail: $showingDetail
                )
                .frame(height: 500)
                
                Spacer()
                
                // 底部提示
                VStack(spacing: 10) {
                    Text("👆 TAP TO EXPLORE")
                        .font(.system(size: 14, weight: .medium, design: .monospaced))
                        .foregroundColor(.white.opacity(0.8))
                        .tracking(2)
                    
                    Text("🤏 DRAG TO ROTATE")
                        .font(.system(size: 12, weight: .medium, design: .monospaced))
                        .foregroundColor(.white.opacity(0.6))
                        .tracking(1)
                }
                .padding(.bottom, 30)
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingDetail) {
            if let part = selectedPart {
                RobotPartDetailView(robot: robot, part: part)
            }
        }
        .onChange(of: showingDetail) { newValue in
            print("🔄 showingDetail changed to: \(newValue)")
            if !newValue {
                selectedPart = nil
                print("🔄 Reset selectedPart to nil")
            }
        }
        .onChange(of: selectedPart) { newValue in
            print("🔄 selectedPart changed to: \(newValue?.rawValue ?? "nil")")
        }
    }
}

// 机器人部位枚举
enum RobotPart: String, CaseIterable {
    case head = "头部"
    case torso = "躯干"
    case leftArm = "左臂"
    case rightArm = "右臂"
    case leftLeg = "左腿"
    case rightLeg = "右腿"
    
    var description: String {
        switch self {
        case .head:
            return "智能感知系统"
        case .torso:
            return "核心处理单元"
        case .leftArm, .rightArm:
            return "精密机械臂"
        case .leftLeg, .rightLeg:
            return "动力驱动系统"
        }
    }
}

// 3D机器人视图
struct Robot3DView: UIViewRepresentable {
    let robot: RobotType
    @Binding var selectedPart: RobotPart?
    @Binding var showingDetail: Bool
    
    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        sceneView.scene = createDetailedRobotScene()
        sceneView.backgroundColor = UIColor.clear
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.cameraControlConfiguration.allowsTranslation = true
        sceneView.cameraControlConfiguration.autoSwitchToFreeCamera = true
        
        // 添加手势识别器
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
        
        return sceneView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        // 更新场景
        uiView.scene = createDetailedRobotScene()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    private func createDetailedRobotScene() -> SCNScene {
        let scene = SCNScene()
        
        // 设置相机
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(0, 0, 8)
        cameraNode.camera?.fieldOfView = 60
        cameraNode.camera?.zFar = 100
        scene.rootNode.addChildNode(cameraNode)
        
        // 设置环境光
        let ambientLight = SCNNode()
        ambientLight.light = SCNLight()
        ambientLight.light?.type = .ambient
        ambientLight.light?.intensity = 300
        ambientLight.light?.color = UIColor.white
        scene.rootNode.addChildNode(ambientLight)
        
        // 设置主光源
        let mainLight = SCNNode()
        mainLight.light = SCNLight()
        mainLight.light?.type = .omni
        mainLight.light?.intensity = 800
        mainLight.light?.color = UIColor.white
        mainLight.position = SCNVector3(5, 5, 5)
        scene.rootNode.addChildNode(mainLight)
        
        // 创建机器人
        let robotNode = createDetailedRobot()
        scene.rootNode.addChildNode(robotNode)
        
        return scene
    }
    
    private func createDetailedRobot() -> SCNNode {
        let robotNode = SCNNode()
        let colors = robot.colorScheme
        
        // 创建头部
        let headNode = createDetailedHead(colors: colors)
        headNode.position = SCNVector3(0, 2.5, 0)
        robotNode.addChildNode(headNode)
        
        // 创建躯干
        let torsoNode = createDetailedTorso(colors: colors)
        torsoNode.position = SCNVector3(0, 1.2, 0)
        robotNode.addChildNode(torsoNode)
        
        // 创建左臂
        let leftArmNode = createDetailedArm(colors: colors, isLeft: true)
        leftArmNode.position = SCNVector3(-1.8, 1.5, 0)
        robotNode.addChildNode(leftArmNode)
        
        // 创建右臂
        let rightArmNode = createDetailedArm(colors: colors, isLeft: false)
        rightArmNode.position = SCNVector3(1.8, 1.5, 0)
        robotNode.addChildNode(rightArmNode)
        
        // 创建左腿
        let leftLegNode = createDetailedLeg(colors: colors, isLeft: true)
        leftLegNode.position = SCNVector3(-0.6, -0.8, 0)
        robotNode.addChildNode(leftLegNode)
        
        // 创建右腿
        let rightLegNode = createDetailedLeg(colors: colors, isLeft: false)
        rightLegNode.position = SCNVector3(0.6, -0.8, 0)
        robotNode.addChildNode(rightLegNode)
        
        return robotNode
    }
    
    private func createDetailedHead(colors: (primary: Color, secondary: Color, accent: Color)) -> SCNNode {
        let headNode = SCNNode()
        
        // 主头部 - 使用胶囊体
        let headGeometry = SCNCapsule(capRadius: 0.4, height: 0.8)
        let headMaterial = SCNMaterial()
        headMaterial.diffuse.contents = UIColor(colors.primary).withAlphaComponent(0.8)
        headMaterial.metalness.contents = 0.9
        headMaterial.roughness.contents = 0.1
        headMaterial.transparency = 0.2
        headMaterial.lightingModel = .physicallyBased
        headMaterial.reflective.contents = UIColor.white
        headMaterial.reflective.intensity = 0.5
        headGeometry.materials = [headMaterial]
        
        let headBodyNode = SCNNode(geometry: headGeometry)
        headBodyNode.name = RobotPart.head.rawValue
        headNode.addChildNode(headBodyNode)
        
        // 眼睛
        let leftEyeGeometry = SCNSphere(radius: 0.08)
        let eyeMaterial = SCNMaterial()
        eyeMaterial.diffuse.contents = UIColor.cyan
        eyeMaterial.emission.contents = UIColor.cyan
        eyeMaterial.emission.intensity = 0.3
        leftEyeGeometry.materials = [eyeMaterial]
        
        let leftEyeNode = SCNNode(geometry: leftEyeGeometry)
        leftEyeNode.position = SCNVector3(-0.15, 0.1, 0.35)
        headNode.addChildNode(leftEyeNode)
        
        let rightEyeNode = SCNNode(geometry: leftEyeGeometry)
        rightEyeNode.position = SCNVector3(0.15, 0.1, 0.35)
        headNode.addChildNode(rightEyeNode)
        
        // 天线
        let antennaGeometry = SCNCylinder(radius: 0.02, height: 0.3)
        let antennaMaterial = SCNMaterial()
        antennaMaterial.diffuse.contents = UIColor(colors.accent)
        antennaMaterial.metalness.contents = 0.8
        antennaGeometry.materials = [antennaMaterial]
        
        let leftAntennaNode = SCNNode(geometry: antennaGeometry)
        leftAntennaNode.position = SCNVector3(-0.2, 0.6, 0)
        leftAntennaNode.eulerAngles = SCNVector3(0.2, 0, 0)
        headNode.addChildNode(leftAntennaNode)
        
        let rightAntennaNode = SCNNode(geometry: antennaGeometry)
        rightAntennaNode.position = SCNVector3(0.2, 0.6, 0)
        rightAntennaNode.eulerAngles = SCNVector3(-0.2, 0, 0)
        headNode.addChildNode(rightAntennaNode)
        
        // 天线顶部发光点
        let antennaLightGeometry = SCNSphere(radius: 0.03)
        let antennaLightMaterial = SCNMaterial()
        antennaLightMaterial.diffuse.contents = UIColor.blue
        antennaLightMaterial.emission.contents = UIColor.blue
        antennaLightMaterial.emission.intensity = 0.5
        antennaLightGeometry.materials = [antennaLightMaterial]
        
        let leftAntennaLightNode = SCNNode(geometry: antennaLightGeometry)
        leftAntennaLightNode.position = SCNVector3(-0.2, 0.75, 0.05)
        headNode.addChildNode(leftAntennaLightNode)
        
        let rightAntennaLightNode = SCNNode(geometry: antennaLightGeometry)
        rightAntennaLightNode.position = SCNVector3(0.2, 0.75, -0.05)
        headNode.addChildNode(rightAntennaLightNode)
        
        return headNode
    }
    
    private func createDetailedTorso(colors: (primary: Color, secondary: Color, accent: Color)) -> SCNNode {
        let torsoNode = SCNNode()
        
        // 主躯干
        let torsoGeometry = SCNBox(width: 1.2, height: 1.6, length: 0.6, chamferRadius: 0.1)
        let torsoMaterial = SCNMaterial()
        torsoMaterial.diffuse.contents = UIColor(colors.secondary).withAlphaComponent(0.8)
        torsoMaterial.metalness.contents = 0.8
        torsoMaterial.roughness.contents = 0.15
        torsoMaterial.transparency = 0.2
        torsoMaterial.lightingModel = .physicallyBased
        torsoMaterial.reflective.contents = UIColor.white
        torsoMaterial.reflective.intensity = 0.4
        torsoGeometry.materials = [torsoMaterial]
        
        let torsoBodyNode = SCNNode(geometry: torsoGeometry)
        torsoBodyNode.name = RobotPart.torso.rawValue
        torsoNode.addChildNode(torsoBodyNode)
        
        // 胸部面板
        let chestPanelGeometry = SCNBox(width: 0.8, height: 0.4, length: 0.05, chamferRadius: 0.02)
        let chestPanelMaterial = SCNMaterial()
        chestPanelMaterial.diffuse.contents = UIColor(colors.accent)
        chestPanelMaterial.metalness.contents = 0.9
        chestPanelMaterial.roughness.contents = 0.1
        chestPanelGeometry.materials = [chestPanelMaterial]
        
        let chestPanelNode = SCNNode(geometry: chestPanelGeometry)
        chestPanelNode.position = SCNVector3(0, 0.2, 0.325)
        torsoNode.addChildNode(chestPanelNode)
        
        // 电路线条
        for i in 0..<3 {
            let circuitGeometry = SCNBox(width: 0.6, height: 0.02, length: 0.01, chamferRadius: 0.005)
            let circuitMaterial = SCNMaterial()
            circuitMaterial.diffuse.contents = UIColor.cyan
            circuitMaterial.emission.contents = UIColor.cyan
            circuitMaterial.emission.intensity = 0.2
            circuitGeometry.materials = [circuitMaterial]
            
            let circuitNode = SCNNode(geometry: circuitGeometry)
            circuitNode.position = SCNVector3(0, 0.1 - Double(i) * 0.15, 0.35)
            torsoNode.addChildNode(circuitNode)
        }
        
        // 肩部连接器
        let shoulderGeometry = SCNCylinder(radius: 0.15, height: 0.3)
        let shoulderMaterial = SCNMaterial()
        shoulderMaterial.diffuse.contents = UIColor(colors.primary)
        shoulderMaterial.metalness.contents = 0.7
        shoulderGeometry.materials = [shoulderMaterial]
        
        let leftShoulderNode = SCNNode(geometry: shoulderGeometry)
        leftShoulderNode.position = SCNVector3(-0.75, 0.4, 0)
        leftShoulderNode.eulerAngles = SCNVector3(0, 0, Float.pi/2)
        torsoNode.addChildNode(leftShoulderNode)
        
        let rightShoulderNode = SCNNode(geometry: shoulderGeometry)
        rightShoulderNode.position = SCNVector3(0.75, 0.4, 0)
        rightShoulderNode.eulerAngles = SCNVector3(0, 0, Float.pi/2)
        torsoNode.addChildNode(rightShoulderNode)
        
        return torsoNode
    }
    
    private func createDetailedArm(colors: (primary: Color, secondary: Color, accent: Color), isLeft: Bool) -> SCNNode {
        let armNode = SCNNode()
        
        // 上臂
        let upperArmGeometry = SCNCapsule(capRadius: 0.12, height: 0.8)
        let upperArmMaterial = SCNMaterial()
        upperArmMaterial.diffuse.contents = UIColor(colors.accent).withAlphaComponent(0.75)
        upperArmMaterial.metalness.contents = 0.7
        upperArmMaterial.roughness.contents = 0.2
        upperArmMaterial.transparency = 0.25
        upperArmMaterial.lightingModel = .physicallyBased
        upperArmMaterial.reflective.contents = UIColor.white
        upperArmMaterial.reflective.intensity = 0.3
        upperArmGeometry.materials = [upperArmMaterial]
        
        let upperArmNode = SCNNode(geometry: upperArmGeometry)
        upperArmNode.position = SCNVector3(0, 0.3, 0)
        upperArmNode.name = isLeft ? RobotPart.leftArm.rawValue : RobotPart.rightArm.rawValue
        armNode.addChildNode(upperArmNode)
        
        // 肘关节
        let elbowGeometry = SCNCylinder(radius: 0.15, height: 0.2)
        let elbowMaterial = SCNMaterial()
        elbowMaterial.diffuse.contents = UIColor(colors.primary)
        elbowMaterial.metalness.contents = 0.8
        elbowGeometry.materials = [elbowMaterial]
        
        let elbowNode = SCNNode(geometry: elbowGeometry)
        elbowNode.position = SCNVector3(0, -0.1, 0)
        elbowNode.eulerAngles = SCNVector3(0, 0, Float.pi/2)
        armNode.addChildNode(elbowNode)
        
        // 前臂
        let forearmGeometry = SCNCapsule(capRadius: 0.1, height: 0.7)
        let forearmMaterial = SCNMaterial()
        forearmMaterial.diffuse.contents = UIColor(colors.secondary)
        forearmMaterial.metalness.contents = 0.6
        forearmGeometry.materials = [forearmMaterial]
        
        let forearmNode = SCNNode(geometry: forearmGeometry)
        forearmNode.position = SCNVector3(0, -0.5, 0)
        armNode.addChildNode(forearmNode)
        
        // 手部
        let handGeometry = SCNBox(width: 0.2, height: 0.3, length: 0.15, chamferRadius: 0.05)
        let handMaterial = SCNMaterial()
        handMaterial.diffuse.contents = UIColor(colors.primary)
        handMaterial.metalness.contents = 0.7
        handGeometry.materials = [handMaterial]
        
        let handNode = SCNNode(geometry: handGeometry)
        handNode.position = SCNVector3(0, -0.85, 0)
        armNode.addChildNode(handNode)
        
        // 手指
        for i in 0..<3 {
            let fingerGeometry = SCNCapsule(capRadius: 0.02, height: 0.15)
            let fingerMaterial = SCNMaterial()
            fingerMaterial.diffuse.contents = UIColor(colors.accent)
            fingerGeometry.materials = [fingerMaterial]
            
            let fingerNode = SCNNode(geometry: fingerGeometry)
            fingerNode.position = SCNVector3(Float(i - 1) * 0.06, -1.0, 0)
            armNode.addChildNode(fingerNode)
        }
        
        return armNode
    }
    
    private func createDetailedLeg(colors: (primary: Color, secondary: Color, accent: Color), isLeft: Bool) -> SCNNode {
        let legNode = SCNNode()
        
        // 大腿
        let thighGeometry = SCNCapsule(capRadius: 0.15, height: 0.9)
        let thighMaterial = SCNMaterial()
        thighMaterial.diffuse.contents = UIColor(colors.primary)
        thighMaterial.metalness.contents = 0.7
        thighGeometry.materials = [thighMaterial]
        
        let thighNode = SCNNode(geometry: thighGeometry)
        thighNode.position = SCNVector3(0, 0.35, 0)
        thighNode.name = isLeft ? RobotPart.leftLeg.rawValue : RobotPart.rightLeg.rawValue
        legNode.addChildNode(thighNode)
        
        // 膝盖关节
        let kneeGeometry = SCNCylinder(radius: 0.18, height: 0.25)
        let kneeMaterial = SCNMaterial()
        kneeMaterial.diffuse.contents = UIColor(colors.accent)
        kneeMaterial.metalness.contents = 0.8
        kneeGeometry.materials = [kneeMaterial]
        
        let kneeNode = SCNNode(geometry: kneeGeometry)
        kneeNode.position = SCNVector3(0, -0.1, 0)
        kneeNode.eulerAngles = SCNVector3(0, 0, Float.pi/2)
        legNode.addChildNode(kneeNode)
        
        // 小腿
        let calfGeometry = SCNCapsule(capRadius: 0.12, height: 0.8)
        let calfMaterial = SCNMaterial()
        calfMaterial.diffuse.contents = UIColor(colors.secondary)
        calfMaterial.metalness.contents = 0.6
        calfGeometry.materials = [calfMaterial]
        
        let calfNode = SCNNode(geometry: calfGeometry)
        calfNode.position = SCNVector3(0, -0.55, 0)
        legNode.addChildNode(calfNode)
        
        // 脚部
        let footGeometry = SCNBox(width: 0.25, height: 0.1, length: 0.4, chamferRadius: 0.05)
        let footMaterial = SCNMaterial()
        footMaterial.diffuse.contents = UIColor(colors.primary)
        footMaterial.metalness.contents = 0.7
        footGeometry.materials = [footMaterial]
        
        let footNode = SCNNode(geometry: footGeometry)
        footNode.position = SCNVector3(0, -0.95, 0.1)
        legNode.addChildNode(footNode)
        
        // 脚底防滑纹
        for i in 0..<3 {
            let treadGeometry = SCNBox(width: 0.2, height: 0.02, length: 0.05, chamferRadius: 0.01)
            let treadMaterial = SCNMaterial()
            treadMaterial.diffuse.contents = UIColor(colors.accent)
            treadGeometry.materials = [treadMaterial]
            
            let treadNode = SCNNode(geometry: treadGeometry)
            treadNode.position = SCNVector3(0, -1.0, 0.1 + Float(i - 1) * 0.1)
            legNode.addChildNode(treadNode)
        }
        
        return legNode
    }
    
    class Coordinator: NSObject {
        let parent: Robot3DView
        
        init(_ parent: Robot3DView) {
            self.parent = parent
        }
        
        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            let sceneView = gesture.view as! SCNView
            let location = gesture.location(in: sceneView)
            let hitResults = sceneView.hitTest(location, options: [:])
            
            if let hitResult = hitResults.first {
                let node = hitResult.node
                
                if let partName = node.name, let part = RobotPart.allCases.first(where: { $0.rawValue == partName }) {
                    parent.selectedPart = part
                    parent.showingDetail = true
                    
                    // 添加点击动画效果
                    let scaleAction = SCNAction.scale(to: 1.2, duration: 0.1)
                    let scaleBackAction = SCNAction.scale(to: 1.0, duration: 0.1)
                    let sequence = SCNAction.sequence([scaleAction, scaleBackAction])
                    node.runAction(sequence)
                }
            }
        }
    }
}

// 机器人部位详情页
struct RobotPartDetailView: View {
    let robot: RobotType
    let part: RobotPart
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            // 背景
            LinearGradient(
                colors: [
                    Color(red: 0.1, green: 0.05, blue: 0.2),
                    Color(red: 0.05, green: 0.1, blue: 0.15)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
        VStack {
                // 顶部导航栏
                HStack {
                    Spacer()
                    
                    Text(part.rawValue)
                        .font(.system(size: 28, weight: .bold, design: .monospaced))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [robot.colorScheme.primary, robot.colorScheme.secondary],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    Spacer()
                    
                    Button("关闭") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.25),
                                        Color.white.opacity(0.15)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(
                                        LinearGradient(
                                            colors: [
                                                Color.white.opacity(0.4),
                                                Color.white.opacity(0.2)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1.5
                                    )
                            )
                    )
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 25) {
                        // 描述信息
                        VStack(alignment: .leading, spacing: 10) {
                            Text(part.description)
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.horizontal, 20)
                        
                        // 硬件规格
                        DetailSection(
                            title: "硬件规格",
                            icon: "cpu",
                            color: robot.colorScheme.primary,
                            items: getHardwareSpecs()
                        )
                        
                        // 软件功能
                        DetailSection(
                            title: "软件功能",
                            icon: "gear",
                            color: robot.colorScheme.secondary,
                            items: getSoftwareFeatures()
                        )
                        
                        // 技术参数
                        DetailSection(
                            title: "技术参数",
                            icon: "chart.bar",
                            color: robot.colorScheme.accent,
                            items: getTechnicalParams()
                        )
                    }
                    .padding(.vertical, 20)
                }
            }
        }
    }
    
    private func getHardwareSpecs() -> [String] {
        switch (robot, part) {
        case (.teslaOptimus, .head):
            return ["• 8K 立体视觉传感器", "• 激光雷达阵列", "• 深度感知摄像头", "• 语音识别模块", "• 面部表情识别"]
        case (.teslaOptimus, .torso):
            return ["• Tesla FSD 芯片", "• 神经网络处理器", "• 高容量电池组", "• 冷却系统", "• 无线通信模块"]
        case (.teslaOptimus, .leftArm), (.teslaOptimus, .rightArm):
            return ["• 7自由度机械臂", "• 精密力传感器", "• 触觉反馈系统", "• 高速伺服电机", "• 防碰撞传感器"]
        case (.teslaOptimus, .leftLeg), (.teslaOptimus, .rightLeg):
            return ["• 液压驱动系统", "• 平衡控制算法", "• 压力传感器", "• 关节限位器", "• 减震装置"]
            
        case (.figureAI, .head):
            return ["• 4K 高清摄像头", "• 红外传感器", "• 麦克风阵列", "• 扬声器系统", "• 表情显示屏"]
        case (.figureAI, .torso):
            return ["• Figure AI 大脑", "• 深度学习引擎", "• 行为规划算法", "• 学习适应系统", "• 人机交互AI"]
        case (.figureAI, .leftArm), (.figureAI, .rightArm):
            return ["• 6自由度机械臂", "• 精密力传感器", "• 触觉反馈系统", "• 高速伺服电机", "• 防碰撞传感器"]
        case (.figureAI, .leftLeg), (.figureAI, .rightLeg):
            return ["• 电动驱动系统", "• 平衡控制算法", "• 压力传感器", "• 关节限位器", "• 减震装置"]
            
        case (.yushuG1, .head):
            return ["• 双目视觉系统", "• 超声波传感器", "• 语音交互模块", "• LED状态指示", "• 触摸传感器"]
        case (.yushuG1, .torso):
            return ["• 宇树智能核心", "• 环境感知算法", "• 运动控制系统", "• 语音处理引擎", "• 情感计算模块"]
        case (.yushuG1, .leftArm), (.yushuG1, .rightArm):
            return ["• 5自由度机械臂", "• 精密力传感器", "• 触觉反馈系统", "• 高速伺服电机", "• 防碰撞传感器"]
        case (.yushuG1, .leftLeg), (.yushuG1, .rightLeg):
            return ["• 电动驱动系统", "• 平衡控制算法", "• 压力传感器", "• 关节限位器", "• 减震装置"]
            
        case (.zhiyuanLingxi, .head):
            return ["• 全景摄像头", "• 激光测距仪", "• 语音合成器", "• 情感识别模块", "• 环境感知器"]
        case (.zhiyuanLingxi, .torso):
            return ["• 灵犀AI处理器", "• 多模态融合", "• 智能决策系统", "• 知识图谱引擎", "• 自主学习算法"]
        case (.zhiyuanLingxi, .leftArm), (.zhiyuanLingxi, .rightArm):
            return ["• 6自由度机械臂", "• 精密力传感器", "• 触觉反馈系统", "• 高速伺服电机", "• 防碰撞传感器"]
        case (.zhiyuanLingxi, .leftLeg), (.zhiyuanLingxi, .rightLeg):
            return ["• 电动驱动系统", "• 平衡控制算法", "• 压力传感器", "• 关节限位器", "• 减震装置"]
        }
    }
    
    private func getSoftwareFeatures() -> [String] {
        switch (robot, part) {
        case (.teslaOptimus, .head):
            return ["• 计算机视觉算法", "• 自然语言处理", "• 情感识别AI", "• 环境感知系统", "• 实时图像处理"]
        case (.teslaOptimus, .torso):
            return ["• 中央控制系统", "• 任务调度算法", "• 能源管理系统", "• 安全监控系统", "• 学习算法框架"]
        case (.teslaOptimus, .leftArm), (.teslaOptimus, .rightArm):
            return ["• 运动规划算法", "• 力控制算法", "• 抓取策略优化", "• 碰撞检测系统", "• 精确轨迹控制"]
        case (.teslaOptimus, .leftLeg), (.teslaOptimus, .rightLeg):
            return ["• 步态规划算法", "• 平衡控制算法", "• 地形适应系统", "• 运动稳定性控制", "• 能耗优化算法"]
            
        case (.figureAI, .head):
            return ["• 计算机视觉算法", "• 自然语言处理", "• 情感识别AI", "• 环境感知系统", "• 实时图像处理"]
        case (.figureAI, .torso):
            return ["• 中央控制系统", "• 任务调度算法", "• 能源管理系统", "• 安全监控系统", "• 学习算法框架"]
        case (.figureAI, .leftArm), (.figureAI, .rightArm):
            return ["• 运动规划算法", "• 力控制算法", "• 抓取策略优化", "• 碰撞检测系统", "• 精确轨迹控制"]
        case (.figureAI, .leftLeg), (.figureAI, .rightLeg):
            return ["• 步态规划算法", "• 平衡控制算法", "• 地形适应系统", "• 运动稳定性控制", "• 能耗优化算法"]
            
        case (.yushuG1, .head):
            return ["• 计算机视觉算法", "• 自然语言处理", "• 情感识别AI", "• 环境感知系统", "• 实时图像处理"]
        case (.yushuG1, .torso):
            return ["• 中央控制系统", "• 任务调度算法", "• 能源管理系统", "• 安全监控系统", "• 学习算法框架"]
        case (.yushuG1, .leftArm), (.yushuG1, .rightArm):
            return ["• 运动规划算法", "• 力控制算法", "• 抓取策略优化", "• 碰撞检测系统", "• 精确轨迹控制"]
        case (.yushuG1, .leftLeg), (.yushuG1, .rightLeg):
            return ["• 步态规划算法", "• 平衡控制算法", "• 地形适应系统", "• 运动稳定性控制", "• 能耗优化算法"]
            
        case (.zhiyuanLingxi, .head):
            return ["• 计算机视觉算法", "• 自然语言处理", "• 情感识别AI", "• 环境感知系统", "• 实时图像处理"]
        case (.zhiyuanLingxi, .torso):
            return ["• 中央控制系统", "• 任务调度算法", "• 能源管理系统", "• 安全监控系统", "• 学习算法框架"]
        case (.zhiyuanLingxi, .leftArm), (.zhiyuanLingxi, .rightArm):
            return ["• 运动规划算法", "• 力控制算法", "• 抓取策略优化", "• 碰撞检测系统", "• 精确轨迹控制"]
        case (.zhiyuanLingxi, .leftLeg), (.zhiyuanLingxi, .rightLeg):
            return ["• 步态规划算法", "• 平衡控制算法", "• 地形适应系统", "• 运动稳定性控制", "• 能耗优化算法"]
        }
    }
    
    private func getTechnicalParams() -> [String] {
        switch (robot, part) {
        case (.teslaOptimus, _):
            return ["• 响应时间: < 5ms", "• 精度: ±0.05mm", "• 工作温度: -40°C ~ 80°C", "• 防护等级: IP68", "• 使用寿命: > 100,000小时"]
        case (.figureAI, _):
            return ["• 响应时间: < 8ms", "• 精度: ±0.1mm", "• 工作温度: -20°C ~ 60°C", "• 防护等级: IP67", "• 使用寿命: > 80,000小时"]
        case (.yushuG1, _):
            return ["• 响应时间: < 10ms", "• 精度: ±0.15mm", "• 工作温度: -10°C ~ 50°C", "• 防护等级: IP66", "• 使用寿命: > 60,000小时"]
        case (.zhiyuanLingxi, _):
            return ["• 响应时间: < 12ms", "• 精度: ±0.2mm", "• 工作温度: -15°C ~ 55°C", "• 防护等级: IP65", "• 使用寿命: > 70,000小时"]
        }
    }
}

// 详情页组件
struct DetailSection: View {
    let title: String
    let icon: String
    let color: Color
    let items: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.title2)
                Text(title)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(items, id: \.self) { item in
                    Text(item)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.12),
                            Color.white.opacity(0.06),
                            Color.white.opacity(0.03)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    color.opacity(0.3),
                                    color.opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
        .padding(.horizontal, 20)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
