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
        
        let ligandURL = "\(firstChar)/\(ligand)/\(ligand)_ideal.pdb"
        self.getLigandPDB(ligand, firstChar, description, ligandURL)
    }
    
    
    func getLigandPDB(_ ligand: String, _ firstChar: String, _ description: Description, _ ligandURL: String) {
        
        Alamofire.request(Constants.api + ligandURL).responseString { response in
            guard let data = response.data, let PDB = String(data: data, encoding: .utf8), let code = response.response?.statusCode, code == 200 else {
                DispatchQueue.main.async { self.delegate.displayAlert(ligand) }
                return
            }
            
            if data.isEmpty {
                self.getLigandPDB(ligand, firstChar, description, "\(firstChar)/\(ligand)/\(ligand)_model.pdb")
                return
            }
            
            self.parsePDB(PDB, description)
        }
    }
    
    func parsePDB(_ PDB: String, _ description: Description) {
        let formattedContent = self.getFormattedPDB(PDB)
        
        var ligand = Ligand()
        ligand.description = description
        
        for (i, element) in formattedContent.enumerated() {
            if element[0] == "ATOM" {
                ligand.atoms.append(Atom())
                
                guard ligand.atoms.indices.contains(i), let number = Int(element[1]), let x = Float(element[6]), let y = Float(element[7]), let z = Float(element[8]), element.indices.contains(11) else {
                    DispatchQueue.main.async { self.delegate.displayAlert(ligand.description?.id ?? "this protein") }
                    return
                }
                
                ligand.atoms[i].number = number
                ligand.atoms[i].coord.x = x
                ligand.atoms[i].coord.y = y
                ligand.atoms[i].coord.z = z
                ligand.atoms[i].name = element[11]
                
            } else if element[0] == "CONECT" {
                for (j, conect) in element.enumerated() {
                    if j > 1, let con = Int(conect), let index = Int(element[1]) {
                        
                        guard ligand.atoms.indices.contains(index - 1) else {
                            DispatchQueue.main.async { self.delegate.displayAlert(ligand.description?.id ?? "this protein") }
                            return
                        }
                        
                        ligand.atoms[index - 1].conect.append(con)
                    }
                }
            }
        }
        
        DispatchQueue.main.async { self.delegate.prepareForSceneKit(ligand: ligand) }
    }
    
    func getFormattedPDB(_ PDB: String) -> [[String]] {
        var content = PDB.components(separatedBy: "\n")
        var formattedContent = [[String]]()
        
        for (i, element) in content.enumerated() {
            content[i] = element.condenseWhitespace()
            formattedContent.append(content[i].components(separatedBy: " "))
        }
        
        return formattedContent
    }
    
}
