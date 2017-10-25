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
            
            self.parseXML(data, ligand)
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    
    func parseXML(_ data: Data, _ ligand: String) {
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
        
        print(description)
    }
    
}
