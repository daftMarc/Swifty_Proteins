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
        self.balls = !self.balls
        
        if !self.balls {
            self.changeModelButton.isUserInteractionEnabled = false
            self.changeModelButton.alpha = 0.5
        } else {
            self.changeModelButton.isUserInteractionEnabled = true
            self.changeModelButton.alpha = 1
        }
        
        if !self.balls {
            self.ligandScene.rootNode.enumerateChildNodes { (node, stop) -> Void in
                if let color = node.geometry?.materials.first?.diffuse.contents as? UIColor {
                    if color != UIColor.lightGray { node.removeFromParentNode() }
                }
            }
        } else { self.drawAtoms() }
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
    
    @IBAction func changeModelAction(_ sender: UIButton) {
        self.spheresModel = !self.spheresModel
        
        self.removeAllChilds()
        self.drawAtoms()
    }
    
    @IBOutlet weak var changeModelButton: UIButton!
    @IBOutlet weak var ballsButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var ligandView: SCNView!
    @IBOutlet weak var elementName: UILabel!
    let ligandScene = SCNScene()
    let cameraNode = SCNNode()
    var myLigand: Ligand!
    var rotation = true
    var balls = true
    var spheresModel = false {
        didSet {
            if self.spheresModel {
                self.ballsButton.isUserInteractionEnabled = false
                self.ballsButton.alpha = 0.5
            }
            else {
                self.ballsButton.isUserInteractionEnabled = true
                self.ballsButton.alpha = 1
            }
        }
    }
    var hydrogenIsOff = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.myLigand.description?.id
        
        self.elementName.layer.masksToBounds = true
        self.elementName.layer.cornerRadius = 5
        
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
                self.elementName.text = " Element = \(atomName) "
            }
        }
    }
    
    func drawAtoms() {
        for atom in myLigand.atoms {
            let coor = SCNVector3(x: atom.coord.x!, y: atom.coord.y!, z: atom.coord.z!)
            
            if self.balls { createTarget(atomName: atom.name!, coor: coor, color: Constants.CPKColors[atom.name!] ?? Constants.defaultColor) }
            createLink(atom: atom, number: atom.number!, connect: atom.conect)
        }
    }
    
    func createTarget(atomName: String, coor: SCNVector3, color: UIColor) {
        let geometry:SCNGeometry = SCNSphere(radius: self.spheresModel ? 0.9 : 0.2)

        geometry.materials.first?.diffuse.contents = color
        
        let geometryNode = SCNNode(geometry: geometry)
        
        geometryNode.position = coor
        geometryNode.name = atomName
        
        if self.hydrogenIsOff, atomName == "H" { return }
        
        ligandScene.rootNode.addChildNode(geometryNode)
    }
    
    func createLink(atom: Atom, number: Int, connect: [Int]){
        let atom1 = getAtomWith(number: number)
        let vec1 = SCNVector3(x: (atom1?.coord.x)!, y: (atom1?.coord.y)!, z: (atom1?.coord.z)!)
        
        if self.hydrogenIsOff, atom.name == "H" { return }
        
        for connection in connect{
            let atom2 = getAtomWith(number: connection)
            let vec2 = SCNVector3(x: (atom2?.coord.x)!, y: (atom2?.coord.y)!, z: (atom2?.coord.z)!)
        
            if self.hydrogenIsOff, atom2!.name == "H" { continue }

            let test = CylinderLine(parent: ligandScene.rootNode, v1: vec1, v2: vec2, radius: self.spheresModel ? 0.9 : 0.1, color: UIColor.lightGray)
            ligandScene.rootNode.addChildNode(test)
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

    func removeAllChilds() {
        self.ligandScene.rootNode.enumerateChildNodes { (node, stop) -> Void in
            node.removeFromParentNode()
        }
    }
    
}

class   CylinderLine: SCNNode
{
    init( parent: SCNNode,//Needed to add destination point of your line
        v1: SCNVector3,//source
        v2: SCNVector3,//destination
        radius: CGFloat,//somes option for the cylinder
        color: UIColor )// color of your node object
    {
        super.init()
        
        //Calcul the height of our line
        let  height = v1.distance(receiver: v2)
        
        //set position to v1 coordonate
        position = v1
        
        //Create the second node to draw direction vector
        let nodeV2 = SCNNode()
        
        //define his position
        nodeV2.position = v2
        //add it to parent
        parent.addChildNode(nodeV2)
        
        //Align Z axis
        let zAlign = SCNNode()
        zAlign.eulerAngles.x = Float(Double.pi / 2)
        
        //create our cylinder
        let cyl = SCNCylinder(radius: radius, height: CGFloat(height))
        cyl.firstMaterial?.diffuse.contents = color
        
        //Create node with cylinder
        let nodeCyl = SCNNode(geometry: cyl )
        nodeCyl.position.y = -height/2
        zAlign.addChildNode(nodeCyl)
        
        //Add it to child
        addChildNode(zAlign)
        
        //set contrainte direction to our vector
        constraints = [SCNLookAtConstraint(target: nodeV2)]
    }
    
    override init() {
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

private extension SCNVector3{
    func distance(receiver:SCNVector3) -> Float{
        let xd = receiver.x - self.x
        let yd = receiver.y - self.y
        let zd = receiver.z - self.z
        let distance = Float(sqrt(xd * xd + yd * yd + zd * zd))
        
        if (distance < 0){
            return (distance * -1)
        } else {
            return (distance)
        }
    }
}
