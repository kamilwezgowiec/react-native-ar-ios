//
//  ViewController.swift
//  Hello World
//
//  Created by Kamil Wezgowiec on 28/09/2021.
//

import UIKit
import SceneKit
import ARKit

class ARKitController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
//        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
//
//        // Set the scene to the view
//        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Detect horizontal planes in the scene
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}


////
////  ViewController.swift
////  clearabee
////
////  Created by Kamil Wezgowiec on 06/10/2021.
////
//
//import UIKit
//import ARKit
//
//class ARKitController: UIViewController {
//    //MARK: - IBOutlets
//    @IBOutlet weak var sceneView: ARSCNView!
//
//    //MARK: - Variables
//    private let configuration = ARWorldTrackingConfiguration()
//    private var node: SCNNode!
//    private var lastRotation: Float = 0
//    private var initialCenter = CGPoint()
//
//    //MARK: - Life cycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        print("changed view :)")
//        // Show statistics such as fps and timing information
//        // self.sceneView.showsStatistics = true
//        // self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
//        self.addTapGesture()
//        self.addPinchGesture()
//        self.addRotationGesture()
//        self.addPanGesture()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.sceneView.session.run(configuration)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.sceneView.session.pause()
//    }
//
//    //MARK: - Methods
//
//    func addBox(x: Float, y: Float, z: Float) {
//        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
//        let material = SCNMaterial()
//        material.diffuse.contents = UIColor.init(red: 134 / 255.0, green: 69 / 255.0, blue: 234 / 255.0, alpha: 0.8)
//        material.locksAmbientWithDiffuse = true
//        box.materials = [material]
//
//        self.node = SCNNode()
//        self.node.geometry = box
//        self.node.position = SCNVector3(x, y, z)
//        //Positive x is to the right. Negative x is to the left. Positive y is up. Negative y is down. Positive z is backward. Negative z is forward.
//        //A node represents the position and the coordinates of an object in a 3D space. By itself, the node has no visible content.
//
//        sceneView.scene.rootNode.addChildNode(self.node)
//    }
//
//    private func addTapGesture() {
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
//        self.sceneView.addGestureRecognizer(tapGesture)
//    }
//
//    @objc func didTap(_ gesture: UIPanGestureRecognizer) {
//        let tapLocation = gesture.location(in: self.sceneView)
//        let results = self.sceneView.hitTest(tapLocation, types: .featurePoint)
//
//        guard let result = results.first else {
//            return
//        }
//
//        let translation = result.worldTransform.translation
//
//        guard let node = self.node else {
//            self.addBox(x: translation.x, y: translation.y, z: translation.z)
//            return
//        }
//        node.position = SCNVector3Make(translation.x, translation.y, translation.z)
//        self.sceneView.scene.rootNode.addChildNode(self.node)
//    }
//
//    private func addPinchGesture() {
//        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(_:)))
//        self.sceneView.addGestureRecognizer(pinchGesture)
//    }
//
//    @objc func didPinch(_ gesture: UIPinchGestureRecognizer) {
//        let originalScale = node.scale
//
//        switch gesture.state {
//        case .began:
//            gesture.scale = CGFloat(originalScale.x)
//        case .changed:
//            var newScale: SCNVector3
//            if gesture.scale < 0.5 {
//                newScale = SCNVector3(x: 0.5, y: 0.5, z: 0.5)
//            } else if gesture.scale > 3 {
//                newScale = SCNVector3(3, 3, 3)
//            } else {
//                newScale = SCNVector3(gesture.scale, gesture.scale, gesture.scale)
//            }
//            node.scale = newScale
//        default:
//            break
//        }
//    }
//
//    private func addRotationGesture() {
//        let panGesture = UIRotationGestureRecognizer(target: self, action: #selector(didRotate(_:)))
//        self.sceneView.addGestureRecognizer(panGesture)
//    }
//
//    @objc func didRotate(_ gesture: UIRotationGestureRecognizer) {
//        switch gesture.state {
//        case .changed:
//            // change node y angel
//            self.node.eulerAngles.y = self.lastRotation + Float(gesture.rotation)
//        case .ended:
//            // save last rotation
//            self.lastRotation += Float(gesture.rotation)
//        default:
//            break
//        }
//    }
//
//    private func addPanGesture() {
//        let pinchGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
//        self.sceneView.addGestureRecognizer(pinchGesture)
//    }
//
//    @objc func didPan(_ gesture: UIPanGestureRecognizer) {
//        let tapLocation = gesture.location(in: self.sceneView)
//        let results = self.sceneView.hitTest(tapLocation, types: .featurePoint)
//
//
//        guard let result = results.first else {
//            return
//        }
//
//        let translation = result.worldTransform.translation
//        guard let node = self.node else {
//            self.addBox(x: translation.x, y: translation.y, z: translation.z)
//            return
//        }
//
//        node.position = SCNVector3Make(translation.x, translation.y, translation.z)
//        self.sceneView.scene.rootNode.addChildNode(self.node)
//    }
//}
//
//extension float4x4 {
//    var translation: SIMD3<Float> {
//        let translation = self.columns.3
//        return SIMD3(translation.x, translation.y, translation.z)
//    }
//}
