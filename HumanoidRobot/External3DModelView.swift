import SwiftUI
import SceneKit

struct External3DModelView: UIViewRepresentable {
    let modelFileName: String
    let modelFileType: ModelFileType
    
    enum ModelFileType {
        case dae
        case scn
        case obj
        case usdz
    }
    
    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        sceneView.scene = loadExternalModel()
        sceneView.backgroundColor = UIColor.clear
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.cameraControlConfiguration.allowsTranslation = true
        sceneView.cameraControlConfiguration.autoSwitchToFreeCamera = true
        
        return sceneView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        uiView.scene = loadExternalModel()
    }
    
    private func loadExternalModel() -> SCNScene {
        let scene = SCNScene()
        
        // 设置相机
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(0, 0, 5)
        cameraNode.camera?.fieldOfView = 60
        scene.rootNode.addChildNode(cameraNode)
        
        // 设置灯光
        let ambientLight = SCNNode()
        ambientLight.light = SCNLight()
        ambientLight.light?.type = .ambient
        ambientLight.light?.intensity = 300
        scene.rootNode.addChildNode(ambientLight)
        
        let mainLight = SCNNode()
        mainLight.light = SCNLight()
        mainLight.light?.type = .omni
        mainLight.light?.intensity = 800
        mainLight.position = SCNVector3(5, 5, 5)
        scene.rootNode.addChildNode(mainLight)
        
        // 尝试加载外部模型
        if let modelNode = loadModelFromFile() {
            scene.rootNode.addChildNode(modelNode)
        } else {
            // 如果加载失败，显示一个占位符
            let placeholderGeometry = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0.1)
            let placeholderMaterial = SCNMaterial()
            placeholderMaterial.diffuse.contents = UIColor.red
            placeholderGeometry.materials = [placeholderMaterial]
            
            let placeholderNode = SCNNode(geometry: placeholderGeometry)
            scene.rootNode.addChildNode(placeholderNode)
        }
        
        return scene
    }
    
    private func loadModelFromFile() -> SCNNode? {
        guard let modelURL = getModelURL() else {
            print("❌ 无法找到模型文件: \(modelFileName)")
            return nil
        }
        
        do {
            switch modelFileType {
            case .dae, .scn:
                let scene = try SCNScene(url: modelURL, options: nil)
                return scene.rootNode
                
            case .obj:
                // 对于.obj文件，需要特殊处理
                let scene = try SCNScene(url: modelURL, options: [
                    SCNSceneSource.LoadingOption.checkConsistency: true
                ])
                return scene.rootNode
                
            case .usdz:
                // USDZ文件需要使用RealityKit，这里只是示例
                print("⚠️ USDZ文件需要使用RealityKit框架")
                return nil
            }
        } catch {
            print("❌ 加载模型文件失败: \(error)")
            return nil
        }
    }
    
    private func getModelURL() -> URL? {
        // 首先尝试从Bundle中加载
        if let bundleURL = Bundle.main.url(forResource: modelFileName, withExtension: getFileExtension()) {
            return bundleURL
        }
        
        // 如果Bundle中没有，尝试从Documents目录加载
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return documentsPath?.appendingPathComponent("\(modelFileName).\(getFileExtension())")
    }
    
    private func getFileExtension() -> String {
        switch modelFileType {
        case .dae: return "dae"
        case .scn: return "scn"
        case .obj: return "obj"
        case .usdz: return "usdz"
        }
    }
}

// 使用示例
struct External3DModelExampleView: View {
    var body: some View {
        VStack {
            Text("外部3D模型示例")
                .font(.title)
                .padding()
            
            External3DModelView(
                modelFileName: "robot_model",
                modelFileType: .dae
            )
            .frame(height: 400)
            
            Text("要使用外部3D模型，请将.dae、.scn或.obj文件添加到项目中")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding()
        }
    }
}

// 高级3D模型加载器
class Advanced3DModelLoader {
    static func loadModelWithAnimation(modelName: String) -> SCNNode? {
        guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "dae") else {
            return nil
        }
        
        do {
            let scene = try SCNScene(url: modelURL, options: [
                SCNSceneSource.LoadingOption.checkConsistency: true,
                SCNSceneSource.LoadingOption.createNormalsIfAbsent: true
            ])
            
            let rootNode = scene.rootNode
            
            // 应用材质优化
            applyMaterialOptimizations(to: rootNode)
            
            // 设置动画
            setupAnimations(for: rootNode)
            
            return rootNode
        } catch {
            print("加载模型失败: \(error)")
            return nil
        }
    }
    
    private static func applyMaterialOptimizations(to node: SCNNode) {
        // 遍历所有子节点并优化材质
        for childNode in node.childNodes {
            if let geometry = childNode.geometry {
                for material in geometry.materials {
                    // 启用PBR渲染
                    material.lightingModel = .physicallyBased
                    
                    // 设置默认金属度
                    if material.metalness.contents == nil {
                        material.metalness.contents = 0.0
                    }
                    
                    // 设置默认粗糙度
                    if material.roughness.contents == nil {
                        material.roughness.contents = 0.5
                    }
                }
            }
            
            // 递归处理子节点
            applyMaterialOptimizations(to: childNode)
        }
    }
    
    private static func setupAnimations(for node: SCNNode) {
        // 获取所有动画
        let animations = node.animationKeys
        
        for animationKey in animations {
            if let animation = node.animation(forKey: animationKey) {
                // 设置动画循环
                animation.repeatCount = .infinity
                
                // 播放动画
                node.addAnimation(animation, forKey: animationKey)
            }
        }
        
        // 递归处理子节点
        for childNode in node.childNodes {
            setupAnimations(for: childNode)
        }
    }
}

// RealityKit集成示例（需要导入RealityKit）
/*
import RealityKit

struct RealityKitModelView: UIViewRepresentable {
    let modelName: String
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        // 加载USDZ模型
        if let modelEntity = try? ModelEntity.loadModel(named: modelName) {
            let anchor = AnchorEntity()
            anchor.addChild(modelEntity)
            arView.scene.addAnchor(anchor)
        }
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        // 更新视图
    }
}
*/
