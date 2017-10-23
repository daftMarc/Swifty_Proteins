//
//  ProteinTableViewCell.swift
//  SwiftyProteins
//
//  Created by Marc FAMILARI on 23/10/2017.
//  Copyright © 2017 Marc FAMILARI. All rights reserved.
//

import UIKit

class ProteinTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var cellLabel: UILabel!
    
    var colors: (UIColor, UIColor)?
    var proteinName: String? {
        didSet {
            self.updateUI()
        }
    }
    
    
    func updateUI() {
        self.cellLabel.text = ""
        
        if let name = self.proteinName {
            self.cellLabel.text = name
        }
        if let color = self.colors {
            self.backgroundColor = color.0
            self.cellLabel.textColor = color.1
        }
    }
    
}
