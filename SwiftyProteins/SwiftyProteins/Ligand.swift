//
//  Ligand.swift
//  SwiftyProteins
//
//  Created by Marc FAMILARI on 10/25/17.
//  Copyright © 2017 Marc FAMILARI. All rights reserved.
//

import Foundation

struct Ligand {
    var atoms: [Atom]?
    var description: Description?
}

struct Description: CustomStringConvertible {
    
    var id: String?
    var formula: String?
    var weight: String?
    var name: String?
    var type: String?
    var smiles: String?
    var identifiers: String?
    var InChI: String?
    var InChIKey: String?
    
    var description: String {
        return "id = \(String(describing: id))\nformula = \(String(describing: formula))\nweight = \(String(describing: weight))\nname = \(String(describing: name))\ntype = \(String(describing: type))\nsmiles = \(String(describing: smiles))\nidentifiers = \(String(describing: identifiers))\nInChI = \(String(describing: InChI))\nInChIKey = \(String(describing: InChIKey))"
    }
    
}


struct Atom {
    var name: String?
    var number: Int?
    var coord: Coordinates?
}

struct Coordinates {
    var x: Double?
    var y: Double?
    var z: Double?
}
