//
//  GetLigandData.swift
//  SwiftyProteins
//
//  Created by Marc FAMILARI on 10/25/17.
//  Copyright © 2017 Marc FAMILARI. All rights reserved.
//

import Foundation
import Alamofire
import SWXMLHash

class GetLigandData {
    
    
    var delegate: LigandTableViewController!
    
    
    init(_ delegate: LigandTableViewController,_ ligand: String) {
        self.delegate = delegate
        
        self.getLigandInfo(ligand)
    }
    
    
    func getLigandInfo(_ ligand: String) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        guard let firstChar = ligand.characters.first?.description else {
            DispatchQueue.main.async { self.delegate.displayAlert(ligand) }
            return
        }
        
        let ligandURL = "\(firstChar)/\(ligand)/\(ligand).xml"
        
        Alamofire.request(Constants.api + ligandURL).response { response in
            guard let data = response.data, let code = response.response?.statusCode, code == 200 else {
                DispatchQueue.main.async { self.delegate.displayAlert(ligand) }
                return
            }
            
            self.parseXML(data, ligand, firstChar)
        }
    }
    
    func parseXML(_ data: Data, _ ligand: String, _ firstChar: String) {
        let xml = SWXMLHash.parse(data)
        var description = Description()
        
        description.id = ligand
        
        if let formula = xml["PDBx:datablock"]["PDBx:chem_compCategory"]["PDBx:chem_comp"]["PDBx:formula"].element?.text { description.formula = formula }
        if let weight = xml["PDBx:datablock"]["PDBx:chem_compCategory"]["PDBx:chem_comp"]["PDBx:formula_weight"].element?.text { description.weight = weight }
        if let name = xml["PDBx:datablock"]["PDBx:chem_compCategory"]["PDBx:chem_comp"]["PDBx:name"].element?.text { description.name = name }
        if let type = xml["PDBx:datablock"]["PDBx:chem_compCategory"]["PDBx:chem_comp"]["PDBx:pdbx_type"].element?.text {description.type = type}
        
        do {
            if let smiles = try xml["PDBx:datablock"]["PDBx:pdbx_chem_comp_descriptorCategory"]["PDBx:pdbx_chem_comp_descriptor"].withAttribute("type", "SMILES")["PDBx:descriptor"].element?.text { description.smiles = smiles }
        } catch { print("Can't get SMILES") }
        
        do {
            if let identifiers = try xml["PDBx:datablock"]["PDBx:pdbx_chem_comp_identifierCategory"]["PDBx:pdbx_chem_comp_identifier"].withAttribute("type", "SYSTEMATIC NAME")["PDBx:identifier"].element?.text { description.identifiers = identifiers }
        } catch { print("Can't get identifiers") }
        
        do {
            if let inChI = try xml["PDBx:datablock"]["PDBx:pdbx_chem_comp_descriptorCategory"]["PDBx:pdbx_chem_comp_descriptor"].withAttribute("type", "InChI")["PDBx:descriptor"].element?.text { description.InChI = inChI }
        } catch { print("Can't get InChI") }
        
        do {
            if let inChIKey = try xml["PDBx:datablock"]["PDBx:pdbx_chem_comp_descriptorCategory"]["PDBx:pdbx_chem_comp_descriptor"].withAttribute("type", "InChIKey")["PDBx:descriptor"].element?.text { description.InChIKey = inChIKey }
        } catch { print("Can't get InChIKey") }
        
        self.getLigandPDB(ligand, firstChar, description)
    }
    
    
    func getLigandPDB(_ ligand: String, _ firstChar: String, _ description: Description) {
        let ligandURL = "\(firstChar)/\(ligand)/\(ligand)_ideal.pdb"
        
        Alamofire.request(Constants.api + ligandURL).responseString { response in
            guard let data = response.data, let PDB = String(data: data, encoding: .utf8), let code = response.response?.statusCode, code == 200 else {
                DispatchQueue.main.async { self.delegate.displayAlert(ligand) }
                return
            }
            
            self.parsePDB(PDB, description)
        }
    }
    
    func parsePDB(_ PDB: String, _ description: Description) {
        var ligand = Ligand()
        ligand.description = description
        
        var content = PDB.components(separatedBy: "\n")
        var filteredContent = [[String]]()
        
        for (i, element) in content.enumerated() {
            content[i] = element.condenseWhitespace()
            filteredContent.append(content[i].components(separatedBy: " "))
        }
        
        
        var atoms = [[String]]()
        var conects = [[String]]()
        
        for element in filteredContent {
            if element[0] == "ATOM" {
                atoms.append(element)
            } else if element[0] == "CONECT" {
                conects.append(element)
            }
        }
        
        ligand.atoms = self.getAtomsArray(atoms)
        self.fillAtomsConects(ligand, conects)
    }
    
    func getAtomsArray(_ atomsData: [[String]]) -> [Atom] {
        var atoms = [Atom]()
        var atom: Atom
        var coordinates: Coordinates
        
        for elements in atomsData {
            atom = Atom()
            coordinates = Coordinates()
            
            for (i, element) in elements.enumerated() {
                if i == 1 {
                    if let number = Int(element) { atom.number = number }
                } else if i == 6 {
                    if let x = Double(element) { coordinates.x = x }
                } else if i == 7 {
                    if let y = Double(element) { coordinates.y = y }
                } else if i == 8 {
                    if let z = Double(element) {
                        coordinates.z = z
                        atom.coord = coordinates
                    }
                } else if i == 11 { atom.name = element }
            }
            
            atoms.append(atom)
        }
        return atoms
    }
    
    func fillAtomsConects(_ ligand: Ligand, _ conects: [[String]]) {
//        print("CONECTS = \(conects)")
        var identifier: Int?
        var atom: Atom?
        
        for conect in conects {
            identifier = 0
            for (i, element) in conect.enumerated() {
                if i == 1 {
                    if let index = Int(element) {
                        identifier = index
                        if let spec = ligand.atoms?[index - 1] {
                            atom = spec
                        }
                    }
                } else if i > 1 {
                    if identifier != nil, atom != nil {
                        
                    }
                }
            }
        }
        
        
//        print("LIGAND = \(ligand)")
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
