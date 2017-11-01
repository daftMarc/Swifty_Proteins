//
//  SplashScreenViewController.swift
//  SwiftyProteins
//
//  Created by Marc FAMILARI on 10/23/17.
//  Copyright © 2017 Marc FAMILARI. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {
    
    
    @IBOutlet weak var activityMonitor: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityMonitor.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let path = Bundle.main.path(forResource: "ligands", ofType: "txt") {
            if let data = try? String(contentsOfFile: path, encoding: .utf8) {
                Ressources.ligands = data.characters.split{$0 == "\n"}.map(String.init)
                let destinationVC = storyboard?.instantiateViewController(withIdentifier: "Authentication View Controller") as! AuthenticationViewController
                self.present(destinationVC, animated: true, completion: nil)
            } else {
                self.showAlert(message: "Application can't get data of ligands.txt")
            }
        } else {
            self.showAlert(message: "ligands.txt file not find")
        }
    }
    
    
    
    
    // MARK: - UIAlert
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.view.tintColor = UIColor.red
        
        let actionButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(actionButton)
        self.present(alertController, animated: true, completion: nil)
        self.activityMonitor.stopAnimating()
    }
    
}
