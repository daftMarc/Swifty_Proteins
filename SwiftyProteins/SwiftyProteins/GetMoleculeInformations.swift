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
        
        let parameters: Parameters = ["chemicalID": ligand
        ]
        
        let describe = "describeHet"
        
        Alamofire.request(Constants.api + describe, parameters: parameters).response { response in
            guard let data = response.data else {
                DispatchQueue.main.async { self.delegate.displayAlert(ligand) }
                return
            }
            
            let xml = SWXMLHash.parse(data)
            guard let smiles = xml["describeHet"]["ligandInfo"]["ligand"]["smiles"].element?.text else {
                DispatchQueue.main.async { self.delegate.displayAlert(ligand) }
                return
            }
            print("SMILES = \(smiles)")
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
}
