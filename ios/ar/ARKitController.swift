import UIKit
import ARKit

class ARKitController: UIViewController {
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var spawnLabel: UILabel!
    @IBOutlet weak var widthLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var depthLabel: UILabel!

    private let configuration = ARWorldTrackingConfiguration()
    private var node: SCNNode!
    private var lastRotation: Float = 0
    private var initialCenter = CGPoint()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addTapGesture()
        self.addPinchGesture()
        self.addRotationGesture()
        self.addPanGesture()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.sceneView.session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.sceneView.session.pause()
    }

    func addBox(x: Float, y: Float, z: Float) {
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.init(red: 134 / 255.0, green: 69 / 255.0, blue: 234 / 255.0, alpha: 0.8)
        material.locksAmbientWithDiffuse = true
        box.materials = [material]

        self.node = SCNNode()
        self.node.geometry = box
        self.node.position = SCNVector3(x, y, z)

        sceneView.scene.rootNode.addChildNode(self.node)
    }

    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        self.sceneView.addGestureRecognizer(tapGesture)
    }

    @objc func didTap(_ gesture: UIPanGestureRecognizer) {
        let tapLocation = gesture.location(in: self.sceneView)
        let results = self.sceneView.hitTest(tapLocation, types: .featurePoint)

        guard let result = results.first else {
            return
        }

        let translation = result.worldTransform.translation

        guard let node = self.node else {
            spawnLabel.isHidden = true

            addBox(x: translation.x, y: translation.y, z: translation.z)
            updateDimensionLabels()
            return
        }

        node.position = SCNVector3Make(translation.x, translation.y, translation.z)
        self.sceneView.scene.rootNode.addChildNode(self.node)
    }

    private func addPinchGesture() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(_:)))
        self.sceneView.addGestureRecognizer(pinchGesture)
    }

    @objc func didPinch(_ gesture: UIPinchGestureRecognizer) {
        let originalScale = node.scale

        switch gesture.state {
        case .began:
            gesture.scale = CGFloat(originalScale.x)
        case .changed:
            var newScale: SCNVector3
            if gesture.scale < 0.5 {
                newScale = SCNVector3(x: 0.5, y: 0.5, z: 0.5)
            } else if gesture.scale > 3 {
                newScale = SCNVector3(3, 3, 3)
            } else {
                newScale = SCNVector3(gesture.scale, gesture.scale, gesture.scale)
            }

            node.scale = newScale
            updateDimensionLabels()
        default:
            break
        }
    }

    private func addRotationGesture() {
        let panGesture = UIRotationGestureRecognizer(target: self, action: #selector(didRotate(_:)))
        self.sceneView.addGestureRecognizer(panGesture)
    }

    @objc func didRotate(_ gesture: UIRotationGestureRecognizer) {
        switch gesture.state {
        case .changed:
            self.node.eulerAngles.y = self.lastRotation - Float(gesture.rotation)
        case .ended:
            self.lastRotation -= Float(gesture.rotation)
        default:
            break
        }
    }

    private func addPanGesture() {
        let pinchGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        self.sceneView.addGestureRecognizer(pinchGesture)
    }

    @objc func didPan(_ gesture: UIPanGestureRecognizer) {
        let tapLocation = gesture.location(in: self.sceneView)
        let results = self.sceneView.hitTest(tapLocation, types: .featurePoint)


        guard let result = results.first else {
            return
        }

        let translation = result.worldTransform.translation
        guard let node = self.node else { return }

        node.position = SCNVector3Make(translation.x, translation.y, translation.z)
        self.sceneView.scene.rootNode.addChildNode(self.node)
    }

    private func updateDimensionLabels() -> Void {
        widthLabel.text = getDimensionText("Width", node.width, node.scale.x)
        heightLabel.text = getDimensionText("Height", node.height, node.scale.y)
        depthLabel.text = getDimensionText("Depth", node.depth, node.scale.z)
    }

    private func getDimensionText(_ text: String, _ size: CGFloat, _ scale: Float) -> String {
        return "\(text): \((Float(size) * scale).rounded(toPlaces: 2))m";
    }
}

extension Float {
    func rounded(toPlaces places:Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}

extension float4x4 {
    var translation: SIMD3<Float> {
        let translation = self.columns.3
        return SIMD3(translation.x, translation.y, translation.z)
    }
}

extension SCNNode {
    var height: CGFloat { CGFloat(self.boundingBox.max.y - self.boundingBox.min.y) }
    var width: CGFloat { CGFloat(self.boundingBox.max.x - self.boundingBox.min.x) }
    var depth: CGFloat { CGFloat(self.boundingBox.max.z - self.boundingBox.min.z) }
}
