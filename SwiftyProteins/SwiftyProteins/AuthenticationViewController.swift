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
        self.authenticateUser()
    }
    
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var touchIDButton: UIButton!
    @IBOutlet weak var loginView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginView.layer.cornerRadius = 15
        
        self.authenticateUser()
    }
    
    
    
    
    // MARK: - Authenticate
    
    func authenticateUser() {
        let myContext = LAContext()
        let myLocalizedReasonString = "This application is confidential. You need to be authenticate to use it !"
        var authError: NSError?
        
        if myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            self.loginButton.isHidden = true
            myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString) { success, evaluateError in
                if success {
                    self.prepareForLigandTableView()
                } else {
                    if let error = evaluateError as? LAError {
                        DispatchQueue.main.async {
                            self.displayErrorMessage(error: error)
                        }
                    }
                }
            }
        } else {
            self.touchIDButton.isHidden = true
        }
    }
    
    func displayErrorMessage(error: LAError) {
        var message = ""
        
        switch error.code {
        case LAError.authenticationFailed:
            message = "Authentication was not successful because the user failed to provide valid credentials."
        case LAError.userCancel:
            message = "Authentication was canceled by the user"
        case LAError.userFallback:
            message = "Authentication was canceled because the user tapped the fallback button"
        case LAError.touchIDNotEnrolled:
            message = "Authentication could not start because Touch ID has no enrolled fingers."
        case LAError.passcodeNotSet:
            message = "Passcode is not set on the device."
        case LAError.systemCancel:
            message = "Authentication was canceled by system"
        default:
            message = error.localizedDescription
        }
        
        self.showAlertWith(title: "Authentication Failed", message: message)
    }
    
    func showAlertWith(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(actionButton)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    // MARK: - Navigation
    
    func prepareForLigandTableView() {
        let destinationVC = storyboard?.instantiateViewController(withIdentifier: "Ligand Table View") as! LigandTableViewController
        
        DispatchQueue.main.async { self.navigationController?.pushViewController(destinationVC, animated: true) }
    }
    
}
