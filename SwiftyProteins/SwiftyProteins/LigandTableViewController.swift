//
//  LigandTableViewController.swift
//  SwiftyProteins
//
//  Created by Marc FAMILARI on 10/23/17.
//  Copyright © 2017 Marc FAMILARI. All rights reserved.
//

import UIKit

class LigandTableViewController: UITableViewController {
    
    
    let data: [String] = Data.ligands
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = self.data[indexPath.row]
        
        return cell
    }

}
