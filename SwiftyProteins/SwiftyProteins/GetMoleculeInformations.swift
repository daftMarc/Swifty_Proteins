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
    
    
    init(_ ligand: String) {
        self.getLigandInfo(ligand)
    }
    
    
    func getLigandInfo(_ ligand: String) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let parameters: Parameters = ["chemicalID": ligand
        ]
        
        let describe = "describeHet"
        
        Alamofire.request(Constants.api + describe, parameters: parameters).response { response in
            if let data = response.data {
                let xml = SWXMLHash.parse(data)
                print("XML = \(xml)")
                print("SMILES = \(xml["describeHet"]["ligandInfo"]["ligand"]["smiles"].element?.text)")
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    
}
