//
//  LigandTableViewController.swift
//  SwiftyProteins
//
//  Created by Marc FAMILARI on 10/23/17.
//  Copyright © 2017 Marc FAMILARI. All rights reserved.
//

import UIKit

class LigandTableViewController: UITableViewController, UISearchBarDelegate, UISearchControllerDelegate {
    
    
    let ligands: [String] = Data.ligands
    var filteredLigands: [String]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ligands.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = self.ligands[indexPath.row]
        
        return cell
    }
    
    
    
    
    // MARK: - UISearchBar
    
    func searchDisplayController(controller: UISearchController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchText: searchString)
        return true
    }
    
    func filterContentForSearchText(searchText: String) {
        self.filteredLigands = self.ligands.filter({( name: String) -> Bool in
            return name.lowercased().range(of: searchText.lowercased()) != nil
        })
    }

}
