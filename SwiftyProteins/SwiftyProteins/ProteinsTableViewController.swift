//
//  ProteinsTableViewController.swift
//  SwiftyProteins
//
//  Created by Marc FAMILARI on 23/10/2017.
//  Copyright © 2017 Marc FAMILARI. All rights reserved.
//

import UIKit

class ProteinsTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var filteredProteins: [String]?
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.filteredProteins = Data.proteins
        
        // Setup the Search Controller
        self.searchController.searchResultsUpdater = self
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = false
        self.tableView.tableHeaderView = searchController.searchBar
    }
    
    // Dismiss the UISearchController when we navigate away
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.searchController.dismiss(animated: false, completion: nil)
    }
    
    
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let proteins = self.filteredProteins else {
            return 0
        }
        return proteins.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "proteinCell", for: indexPath) as! ProteinTableViewCell
        
        // Design
        if indexPath.row % 2 == 0 { cell.colors = (UIColor.black, UIColor.white) }
        else { cell.colors = (UIColor.white, UIColor.black) }
        
        cell.proteinName = self.filteredProteins?[indexPath.row]
        
        return cell
    }
    
    
    
    
    // MARK: - UISearchResultsUpdating Protocol
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            self.filteredProteins = Data.proteins.filter { protein in
                return protein.lowercased().contains(searchText.lowercased())
            }
        } else {
            self.filteredProteins = Data.proteins
        }
        self.tableView.reloadData()
    }
    
}
