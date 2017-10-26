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

struct Description {
    
    var id: String?
    var formula: String?
    var weight: String?
    var name: String?
    var type: String?
    var smiles: String?
    var identifiers: String?
    var InChI: String?
    var InChIKey: String?
    
}


struct Atom {
    
    var name: String?
    var number: Int?
    var conect = [Int]()
    var coord = Coordinates()
    
}

struct Coordinates {
    
    var x: Float?
    var y: Float?
    var z: Float?
    
}
