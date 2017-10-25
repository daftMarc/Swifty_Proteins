//
//  GetMoleculeInformations.swift
//  SwiftyProteins
//
//  Created by Marc FAMILARI on 10/24/17.
//  Copyright © 2017 Marc FAMILARI. All rights reserved.
//

import Foundation
import Alamofire
import SWXMLHash

class GetMoleculeInformations {
    
    var delegate: ProteinsTableViewController!
    
    init(_ delegate: ProteinsTableViewController,_ ligand: String) {
        self.delegate = delegate
        
        self.getLigandInfo(ligand)
    }
    
    
    func getLigandInfo(_ ligand: String) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        guard let firstChar = ligand.characters.first?.description else {
            DispatchQueue.main.async { self.delegate.displayAlert(ligand) }
            return
        }
        
        let ligand = "\(firstChar)/\(ligand)/\(ligand).xml"
        
        Alamofire.request(Constants.api + ligand).response { response in
            guard let data = response.data else {
                DispatchQueue.main.async { self.delegate.displayAlert(ligand) }
                return
            }
            
            let xml = SWXMLHash.parse(data)
            
            if let formula = xml["PDBx:datablock"]["PDBx:chem_compCategory"]["PDBx:chem_comp"]["PDBx:formula"].element?.text {
                print("FORMULA = \(formula)")
            }
            
            if let weight = xml["PDBx:datablock"]["PDBx:chem_compCategory"]["PDBx:chem_comp"]["PDBx:formula_weight"].element?.text {
                print("WEIGHT = \(weight)")
            }
            
            if let name = xml["PDBx:datablock"]["PDBx:chem_compCategory"]["PDBx:chem_comp"]["PDBx:name"].element?.text {
                print("NAME = \(name)")
            }
            
            if let type = xml["PDBx:datablock"]["PDBx:chem_compCategory"]["PDBx:chem_comp"]["PDBx:pdbx_type"].element?.text {
                print("TYPE = \(type)")
            }
            
            do {
                if let smiles = try xml["PDBx:datablock"]["PDBx:pdbx_chem_comp_descriptorCategory"]["PDBx:pdbx_chem_comp_descriptor"].withAttribute("type", "SMILES")["PDBx:descriptor"].element?.text {
                    print("SMILES = \(smiles)")
                }
            } catch {
                print("Can't get SMILES")
            }
            
            do {
                if let identifiers = try xml["PDBx:datablock"]["PDBx:pdbx_chem_comp_identifierCategory"]["PDBx:pdbx_chem_comp_identifier"].withAttribute("type", "SYSTEMATIC NAME")["PDBx:identifier"].element?.text {
                    print("identifiers = \(identifiers)")
                }
            } catch {
                print("Can't get identifiers")
            }
            
            do {
                if let inChI = try xml["PDBx:datablock"]["PDBx:pdbx_chem_comp_descriptorCategory"]["PDBx:pdbx_chem_comp_descriptor"].withAttribute("type", "InChI")["PDBx:descriptor"].element?.text {
                    print("inChI = \(inChI)")
                }
            } catch {
                print("Can't get InChI")
            }
            
            do {
                if let inChIKey = try xml["PDBx:datablock"]["PDBx:pdbx_chem_comp_descriptorCategory"]["PDBx:pdbx_chem_comp_descriptor"].withAttribute("type", "InChIKey")["PDBx:descriptor"].element?.text {
                    print("inChIKey = \(inChIKey)")
                }
            } catch {
                print("Can't get InChIKey")
            }
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
}
