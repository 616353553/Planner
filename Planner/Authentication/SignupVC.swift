//
//  SignupVC.swift
//  Planner
//
//  Created by bainingshuo on 4/9/19.
//  Copyright © 2019 Ningshuo Bai. All rights reserved.
//

import UIKit
import Firebase

class SignupVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func cancelIsPushed(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

    @IBAction func signupIsPushed(_ sender: UIButton) {
        if emailTextField.text == "" {
            
        } else if passwordTextField.text == "" {
            
        } else {
            let email = emailTextField.text ?? ""
            let password = passwordTextField.text ?? ""
            UIApplication.shared.beginIgnoringInteractionEvents()
            let spinner = UIActivityIndicatorView()
            self.view.addSubview(spinner)
            spinner.startAnimating()
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                spinner.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                } else {
                    Auth.auth().signIn(withEmail: email, password: password, completion: { (reesult, error) in
                        if error != nil {
                            let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true)
                        } else {
                            let alert = UIAlertController(title: "Success", message: "Account created successfully", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in
                                self.navigationController?.dismiss(animated: true, completion: nil)
                            }))
                            self.present(alert, animated: true)
                        }
                    })
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
