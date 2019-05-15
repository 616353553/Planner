//
//  LogInVC.swift
//  Planner
//
//  Created by Ningshuo Bai on 4/8/19.
//  Copyright © 2019 Ningshuo Bai. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class LoginVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fbLoginButton = FBSDKLoginButton()
        fbLoginButton.delegate = self
        fbLoginButton.center.x = self.view.center.x
        fbLoginButton.center.y = self.view.frame.height * 0.9
        self.view.addSubview(fbLoginButton)
        loginButton.layer.cornerRadius = loginButton.frame.height / 2
        loginButton.clipsToBounds = true
//        loginButton.layer.borderWidth = 2
//        loginButton.layer.borderColor = UIColor.white.cgColor
        
    }
    

    @IBAction func cancelIsPushed(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginIsPushed(_ sender: UIButton) {
        if emailTextField.text == "" {
            let alert = UIAlertController(title: "Error", message: "Email cannot be empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        } else if passwordTextField.text == "" {
            let alert = UIAlertController(title: "Error", message: "Password cannot be empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        } else {
            UIApplication.shared.beginIgnoringInteractionEvents()
            let spinner = UIActivityIndicatorView()
            self.view.addSubview(spinner)
            spinner.startAnimating()
            Auth.auth().signIn(withEmail: emailTextField.text ?? "", password: passwordTextField.text ?? "") { (result, error) in
                spinner.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                } else {
                    self.navigationController?.dismiss(animated: true, completion: nil)
//                    self.dismiss(animated: true, completion: nil)
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

extension LoginVC: FBSDKLoginButtonDelegate {
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if result.isCancelled {
            print("user canceled log in")
        } else {
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "Unable to log in, please try again later", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            } else {
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
                    if error != nil {
                        let alert = UIAlertController(title: "Error", message: "Unable to retrive user crediential, please try again later", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    } else {
//                        self.dismiss(animated: true, completion: nil)
                        self.navigationController?.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        //
    }
    
    
}
