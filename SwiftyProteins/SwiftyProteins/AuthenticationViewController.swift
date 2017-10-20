//
//  AuthenticationViewController.swift
//  SwiftyProteins
//
//  Created by Marc FAMILARI on 10/20/17.
//  Copyright © 2017 Marc FAMILARI. All rights reserved.
//

import UIKit
import LocalAuthentication

class AuthenticationViewController: UIViewController {
    
    
    @IBAction func loginAction(_ sender: UIButton) {
    }
    @IBAction func touchIDAction(_ sender: UIButton) {
    }
    
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var touchIDButton: UIButton!
    @IBOutlet weak var loginView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.touchIDButton.isHidden = true
        self.loginButton.isHidden = true
        
        self.loginView.layer.cornerRadius = 15
    }

}
