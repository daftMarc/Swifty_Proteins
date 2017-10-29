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
    
    
    @IBAction func presentDescriptionAction(_ sender: UIButton) {
        let destinationVC = storyboard?.instantiateViewController(withIdentifier: "Description View Controller") as! DescriptionViewController
        
        destinationVC.ligandDescription = self.myLigand.description
        
        self.present(destinationVC, animated: true, completion: nil)
    }
    
    @IBAction func shareAction(_ sender: UIBarButtonItem) {
        let screenShot = self.ligandView.snapshot()
        
        let vc = UIActivityViewController(activityItems: ["Here is my AWESOME ligand !", screenShot], applicationActivities: nil)
        present(vc, animated: true)
    }
    
    @IBAction func rotateLigand(_ sender: UIButton) {
        if self.rotation { self.ligandScene.rootNode.runAction(SCNAction.rotateBy(x: 0, y: 500, z: 0, duration: 600), forKey: Constants.rotate) }
        else { self.ligandScene.rootNode.removeAction(forKey: Constants.rotate) }
        
        self.rotation = !self.rotation
    }

    @IBAction func removeBallsAction(_ sender: UIButton) {
        if !self.displayBalls {
            self.ligandScene.rootNode.enumerateChildNodes { (node, stop) -> Void in
                if let color = node.geometry?.materials.first?.diffuse.contents as? UIColor {
                    if color != UIColor.lightGray { node.removeFromParentNode() }
                }
            }
        } else { self.drawAtoms(sticks: false) }
        
        self.rotation = true
        self.ligandScene.rootNode.removeAction(forKey: Constants.rotate)
        self.displayBalls = !self.displayBalls
    }
    
    @IBAction func removeSticksAction(_ sender: UIButton) {
        self.hydrogenIsOff = !self.hydrogenIsOff
        if self.hydrogenIsOff {
            self.ligandScene.rootNode.enumerateChildNodes { (node, stop) -> Void in
             node.removeFromParentNode()
            }
        }
        self.drawAtoms()
    }
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var ligandView: SCNView!
    @IBOutlet weak var elementName: UILabel!
    let ligandScene = SCNScene()
    let cameraNode = SCNNode()
    var myLigand: Ligand!
    var rotation = true
    var displayBalls = false
    var displaySticks = false
    var hydrogenIsOff = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.myLigand.description?.id
        
        self.cameraNode.camera = SCNCamera()
        self.ligandScene.rootNode.addChildNode(self.cameraNode)
        
        // place the camera
        let firstAtom = self.myLigand.atoms[0]
        if firstAtom.coord.x! > Float(10) {
            self.cameraNode.position = SCNVector3(x: firstAtom.coord.x!, y: firstAtom.coord.y!, z: firstAtom.coord.y! + 30)
        } else {
            self.cameraNode.position = SCNVector3(x: 0, y: 0, z: 50)
        }
        
        // set the scene to the view
        self.ligandView.scene = self.ligandScene
        
        // allow the user to manipulate the camera
        ligandView.allowsCameraControl = true
        
        // set default light
        self.ligandView.autoenablesDefaultLighting = true
        
        self.drawAtoms()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: ligandView)
        let hitList = ligandView.hitTest(location, options: nil)
        
        if let hitObj = hitList.first {
            let node = hitObj.node
            if let atomName = node.name{
                self.elementName.text = "Element = \(atomName)"
            }
        }
    }
    
    func drawAtoms(balls: Bool = true, sticks: Bool = true) {
        for atom in myLigand.atoms {
            let coor = SCNVector3(x: atom.coord.x!, y: atom.coord.y!, z: atom.coord.z!)
            
            if balls { createTarget(atomName: atom.name!, coor: coor, color: Constants.CPKColors[atom.name!] ?? Constants.defaultColor) }
            if sticks { createLink(atom: atom, number: atom.number!, connect: atom.conect) }
        }
    }
    
    func createTarget(atomName: String, coor: SCNVector3, color: UIColor) {
        let geometry:SCNGeometry = SCNSphere(radius: 0.2)

        geometry.materials.first?.diffuse.contents = color
        
        let geometryNode = SCNNode(geometry: geometry)
        
        geometryNode.position = coor
        geometryNode.name = atomName
        
        if self.hydrogenIsOff, atomName == "H" { return }
        
        ligandScene.rootNode.addChildNode(geometryNode)
    }
    
    func createLink(atom: Atom, number: Int, connect: [Int]){
        print("number = \(number)\nconnect = \(connect)")
        let atom1 = getAtomWith(number: number)
        let vec1 = SCNVector3(x: (atom1?.coord.x)!, y: (atom1?.coord.y)!, z: (atom1?.coord.z)!)
        
        if self.hydrogenIsOff, atom.name == "H" { return }
        
        for connection in connect{
            let line = SCNNode()
            let atom2 = getAtomWith(number: connection)
            let vec2 = SCNVector3(x: (atom2?.coord.x)!, y: (atom2?.coord.y)!, z: (atom2?.coord.z)!)
        
            if self.hydrogenIsOff, atom2!.name == "H" { continue }
            print(ligandScene.rootNode.childNodes.count)
            ligandScene.rootNode.addChildNode(line.buildLineInTwoPointsWithRotation(from: vec1, to: vec2, radius: 0.1, color: .lightGray))
            print(ligandScene.rootNode.childNodes.count)

        }
    }
    
    func getAtomWith(number: Int) -> Atom? {
        for atom in myLigand.atoms{
            if atom.number == number {
                return atom
            }
        }
        return nil
    }

}

extension SCNNode {
    
    func normalizeVector(_ iv: SCNVector3) -> SCNVector3 {
        let length = sqrt(iv.x * iv.x + iv.y * iv.y + iv.z * iv.z)
        if length == 0 {
            return SCNVector3(0.0, 0.0, 0.0)
        }
        
        return SCNVector3( iv.x / length, iv.y / length, iv.z / length)
        
    }
    
    func buildLineInTwoPointsWithRotation(from startPoint: SCNVector3,
                                          to endPoint: SCNVector3,
                                          radius: CGFloat,
                                          color: UIColor) -> SCNNode {
        let w = SCNVector3(x: endPoint.x-startPoint.x,
                           y: endPoint.y-startPoint.y,
                           z: endPoint.z-startPoint.z)
        let l = CGFloat(sqrt(w.x * w.x + w.y * w.y + w.z * w.z))
        
        if l == 0.0 {
            // two points together.
            let sphere = SCNSphere(radius: radius)
            sphere.firstMaterial?.diffuse.contents = color
            self.geometry = sphere
            self.position = startPoint
            return self
            
        }
        
        let cyl = SCNCylinder(radius: radius, height: l)
        cyl.firstMaterial?.diffuse.contents = color
        
        self.geometry = cyl
        
        //original vector of cylinder above 0,0,0
        let ov = SCNVector3(0, l/2.0,0)
        //target vector, in new coordination
        let nv = SCNVector3((endPoint.x - startPoint.x)/2.0, (endPoint.y - startPoint.y)/2.0,
                            (endPoint.z-startPoint.z)/2.0)
        
        // axis between two vector
        let av = SCNVector3( (ov.x + nv.x)/2.0, (ov.y+nv.y)/2.0, (ov.z+nv.z)/2.0)
        
        //normalized axis vector
        let av_normalized = normalizeVector(av)
        let q0 = Float(0.0) //cos(angel/2), angle is always 180 or M_PI
        let q1 = Float(av_normalized.x) // x' * sin(angle/2)
        let q2 = Float(av_normalized.y) // y' * sin(angle/2)
        let q3 = Float(av_normalized.z) // z' * sin(angle/2)
        
        let r_m11 = q0 * q0 + q1 * q1 - q2 * q2 - q3 * q3
        let r_m12 = 2 * q1 * q2 + 2 * q0 * q3
        let r_m13 = 2 * q1 * q3 - 2 * q0 * q2
        let r_m21 = 2 * q1 * q2 - 2 * q0 * q3
        let r_m22 = q0 * q0 - q1 * q1 + q2 * q2 - q3 * q3
        let r_m23 = 2 * q2 * q3 + 2 * q0 * q1
        let r_m31 = 2 * q1 * q3 + 2 * q0 * q2
        let r_m32 = 2 * q2 * q3 - 2 * q0 * q1
        let r_m33 = q0 * q0 - q1 * q1 - q2 * q2 + q3 * q3
        
        self.transform.m11 = r_m11
        self.transform.m12 = r_m12
        self.transform.m13 = r_m13
        self.transform.m14 = 0.0
        
        self.transform.m21 = r_m21
        self.transform.m22 = r_m22
        self.transform.m23 = r_m23
        self.transform.m24 = 0.0
        
        self.transform.m31 = r_m31
        self.transform.m32 = r_m32
        self.transform.m33 = r_m33
        self.transform.m34 = 0.0
        
        self.transform.m41 = (startPoint.x + endPoint.x) / 2.0
        self.transform.m42 = (startPoint.y + endPoint.y) / 2.0
        self.transform.m43 = (startPoint.z + endPoint.z) / 2.0
        self.transform.m44 = 1.0
        return self
    }
}
