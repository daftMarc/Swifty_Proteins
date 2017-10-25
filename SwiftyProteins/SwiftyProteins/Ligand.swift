//
//  Ligand.swift
//  SwiftyProteins
//
//  Created by Marc FAMILARI on 10/25/17.
//  Copyright © 2017 Marc FAMILARI. All rights reserved.
//

import Foundation

struct Ligand {
    var atoms =  [Atom]()
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


struct Atom: CustomStringConvertible {
    
    var name: String?
    var number: Int?
    var conect = [Int]()
    var coord = Coordinates()
    
    var description: String {
        return "\nname = \(String(describing: name))\nnumber = \(String(describing: number))\ncoor = \(String(describing: coord))\nconect = \(String(describing: conect))"
    }
}

struct Coordinates: CustomStringConvertible {
    
    var x: Double?
    var y: Double?
    var z: Double?
    
    var description: String {
        return "\nx = \(String(describing: x))\ny = \(String(describing: y))\nz = \(String(describing: z))"
    }
}
