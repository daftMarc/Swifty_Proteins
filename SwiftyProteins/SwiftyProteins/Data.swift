//
//  Data.swift
//  SwiftyProteins
//
//  Created by Marc FAMILARI on 10/23/17.
//  Copyright © 2017 Marc FAMILARI. All rights reserved.
//

import Foundation

struct Data {
    static var proteins: [String]!
}

struct Molecule {
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
