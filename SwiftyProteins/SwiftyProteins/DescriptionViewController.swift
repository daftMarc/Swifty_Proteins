//
//  DescriptionViewController.swift
//  SwiftyProteins
//
//  Created by Marc FAMILARI on 10/26/17.
//  Copyright © 2017 Marc FAMILARI. All rights reserved.
//

import UIKit

class DescriptionViewController: UIViewController {
    
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var identifiersLabel: UILabel!
    @IBOutlet weak var formulaLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var smilesLabel: UILabel!
    @IBOutlet weak var inChIKeyLabel: UILabel!
    @IBOutlet weak var inChILabel: UILabel!
    
    var ligandDescription: Description!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let id = ligandDescription.id { self.idLabel.text = id }
        if let name = ligandDescription.name { self.nameLabel.text = name }
        if let identifiers = ligandDescription.identifiers { self.identifiersLabel.text = identifiers }
        if let formula = ligandDescription.formula { self.formulaLabel.text = formula }
        if let type = ligandDescription.type { self.typeLabel.text = type }
        if let smiles = ligandDescription.smiles { self.smilesLabel.text = smiles }
        if let inChI = ligandDescription.InChI { self.inChILabel.text = inChI }
        if let inChIKey = ligandDescription.InChIKey { self.inChIKeyLabel.text = inChIKey }
        if let weight = ligandDescription.weight { self.weightLabel.text = weight }
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.dismissView))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeDown)
    }
    
    
    func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }

}
