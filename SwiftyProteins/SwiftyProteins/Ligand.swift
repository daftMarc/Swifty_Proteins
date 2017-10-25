//
//  Ligand.swift
//  SwiftyProteins
//
//  Created by Marc FAMILARI on 10/25/17.
//  Copyright © 2017 Marc FAMILARI. All rights reserved.
//

import Foundation

struct Ligand {
    static var atoms: [Atom]?
}

struct Atom {
    static var name: String?
    static var description: String?
    static var number: Int?
    static var ligand: String?
    static var coord: Coordinates?
    
    struct Coordinates {
        static var x: Double?
        static var y: Double?
        static var z: Double?
    }
}
