//
//  ContentView.swift
//  HumanoidRobot
//
//  Created by G axa on 8/15/25.
//

import SwiftUI
import SceneKit

struct ContentView: View {
    var body: some View {
        NavigationView {
            RobotSelectionView()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// 机器人选择主页
struct RobotSelectionView: View {
    var body: some View {
        ZStack {
            // 赛博朋克背景
            CyberpunkBackground()
            
            VStack(spacing: 30) {
                // 标题
                VStack(spacing: 10) {
                    Text("HUMANOID")
                        .font(.system(size: 48, weight: .black, design: .monospaced))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.mint, Color.cyan, Color.blue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    Text("ROBOT COLLECTION")
                        .font(.system(size: 18, weight: .medium, design: .monospaced))
                        .foregroundColor(.white.opacity(0.8))
                        .tracking(3)
                }
                .padding(.top, 50)
                
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
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: width, y: y))
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
    
    var body: some View {
        ZStack {
            // 背景
            CyberpunkBackground()
            
            VStack {
                // 顶部导航栏
                HStack {
                    // 返回按钮
                    NavigationLink("← Back", destination: RobotSelectionView())
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
