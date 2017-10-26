//
//  SceneKitViewController.swift
//  SwiftyProteins
//
//  Created by Martin SIREAU on 10/26/17.
//  Copyright © 2017 Marc FAMILARI. All rights reserved.
//

import UIKit
import SceneKit

class SceneKitViewController: UIViewController {

    var ligandView: SCNView!
    var ligandScene: SCNScene!
    var cameraNode: SCNNode!
    var myLigand: Ligand!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        initScene()
        initCamera()
        for atom in myLigand.atoms {
            let coor = SCNVector3(x: Float(atom.coord.x!), y: Float(atom.coord.y!), z: Float(atom.coord.z!))
            createTarget(coor: coor, color: self.whichColor(name: atom.name!))
        }
//        createTarget(x: 1, y: 1, z: 5)
    }
    
    func initView() {
        ligandView = self.view as! SCNView
        ligandView.allowsCameraControl = true
        ligandView.autoenablesDefaultLighting = true
    }
    
    func initScene() {
        ligandScene = SCNScene()
        ligandView.scene = ligandScene
        
        ligandView.isPlaying = true
    }
    
    func initCamera() {
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        
        cameraNode.position = SCNVector3(x: 0, y:5, z:50)
        ligandScene.rootNode.addChildNode(cameraNode)
    }
    
    func createTarget(coor: SCNVector3, color: UIColor) {
        let geometry:SCNGeometry = SCNSphere(radius: 0.2)
        
        geometry.materials.first?.diffuse.contents = color
        
        let geometryNode = SCNNode(geometry: geometry)
        
        geometryNode.position = coor
        
        ligandScene.rootNode.addChildNode(geometryNode)
    }
    
    func whichColor(name: String) -> UIColor{
        switch name {
        case "C":
            return .lightGray
        case "O":
            return .red
        case "F":
            return .green
        case "N":
            return .blue
        case "H":
            return .white
        default:
            return .black
        }
    }
}
