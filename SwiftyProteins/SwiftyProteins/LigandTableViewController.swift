//
//  LigandTableViewController.swift
//  SwiftyProteins
//
//  Created by Marc FAMILARI on 10/25/17.
//  Copyright © 2017 Marc FAMILARI. All rights reserved.
//

import UIKit

class LigandTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var filteredProteins: [String]?
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.definesPresentationContext = true
        
        self.filteredProteins = Ressources.ligands
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ligandCell", for: indexPath) as! LigandTableViewCell
        
        // Design
        if indexPath.row % 2 == 0 { cell.colors = (UIColor.black, UIColor.white) }
        else { cell.colors = (UIColor.white, UIColor.black) }
        
        cell.proteinName = self.filteredProteins?[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let ligand = self.filteredProteins?[indexPath.row] {
            self.tableView.isUserInteractionEnabled = false
            _ = GetLigandData(self, ligand)
        }
    }
    
    
    
    
    // MARK: - UISearchResultsUpdating Protocol
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            self.filteredProteins = Ressources.ligands.filter { protein in
                return protein.lowercased().contains(searchText.lowercased())
            }
        } else {
            self.filteredProteins = Ressources.ligands
        }
        self.tableView.reloadData()
    }
    
    
    func displayAlert(_ ligand: String) {
        self.tableView.isUserInteractionEnabled = true
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        let alertController = UIAlertController(title: "Error", message: "Can't get data for \(ligand)", preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func prepareForSceneKit(ligand: Ligand) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        self.tableView.isUserInteractionEnabled = true
        
        let destinationvc = storyboard?.instantiateViewController(withIdentifier: "SceneKit View") as! SceneKitViewController
        destinationvc.myLigand = ligand
        
        self.navigationController?.pushViewController(destinationvc, animated: true)
    }
    
}
