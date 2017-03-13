//
//  LoginVC.swift
//  Maps me
//
//  Created by XGus on 2/22/2560 BE.
//  Copyright © 2560 Wizardapp.me. All rights reserved.
//

import UIKit
import Parse


class LoginVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var activityIndicator = UIActivityIndicatorView()
    
    var signupMode = true
    
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var signupOrLogin: UIButton!
    @IBOutlet var changeSignupModeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signupOrLogin(_ sender: AnyObject) {
        emailTextField.backgroundColor = UIColor.white
        passwordTextField.backgroundColor = UIColor.white
        
        if signupMode {
            
            // Signup mode
            if emailTextField.text != "" && passwordTextField.text != ""{
                
                if (emailTextField.text?.characters.count)! < 6 && (passwordTextField.text?.characters.count)! < 6 {
                    print("Email และ Password ต้องมากกว่า 6 ตัวอักษร")
                    showAlert(title: "ข้อผิดพลาด!", message: "Email และ Password ต้องมากกว่า 6 ตัวอักษร")
                    
                    emailTextField.backgroundColor = UIColor.red
                    passwordTextField.backgroundColor = UIColor.red
                }else{
                    print("Signup success")
                    emailTextField.backgroundColor = UIColor.white
                    passwordTextField.backgroundColor = UIColor.white
                    
                    
                    
                    activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                    activityIndicator.center = self.view.center
                    activityIndicator.hidesWhenStopped = true
                    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
                    view.addSubview(activityIndicator)
                    activityIndicator.startAnimating()
                    UIApplication.shared.beginIgnoringInteractionEvents()
                    
                    
                    let user = PFUser()
                    
                    user.username = emailTextField.text
                    user.email = emailTextField.text
                    user.password = passwordTextField.text
                    
                    user.signUpInBackground(block: { (success, error) in // user.signUpInBackground({ (success, error) is now user.signUpInBackground(block: { (success, error)
                        
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        
                        if error != nil {
                            
                            var displayErrorMessage = "Please try again later."
                            
                            let error = error as? NSError
                            
                            if let errorMessage = error?.userInfo["error"] as? String {
                                
                                displayErrorMessage = errorMessage
                                
                            }
                            
                            self.showAlert(title: "Login Error", message: displayErrorMessage)
                            
                        } else {
                            
                            self.performSegue(withIdentifier: "showPlaceTable", sender: self)
                            
                        }
                        
                        
                    })
                    
                    
                }
                
                
            }else{
                
                if emailTextField.text?.characters.count == 0 || passwordTextField.text?.characters.count == 0{
                    emailTextField.backgroundColor = UIColor.red
                    passwordTextField.backgroundColor = UIColor.red
                }
                showAlert(title: "ข้อผิดพลาด!", message: "คุณยังไม่ได้กรอก Email หรือ Password")
            }
            
        
        }else{
           
            // login mode
            if emailTextField.text != "" && passwordTextField.text != ""{
                
                if (emailTextField.text?.characters.count)! < 6 && (passwordTextField.text?.characters.count)! < 6 {
                    print("Email และ Password ต้องมากกว่า 6 ตัวอักษร")
                    showAlert(title: "ข้อผิดพลาด!", message: "Email และ Password ต้องมากกว่า 6 ตัวอักษร")
                    
                    emailTextField.backgroundColor = UIColor.red
                    passwordTextField.backgroundColor = UIColor.red
                }else{
                    print("login success")
                    emailTextField.backgroundColor = UIColor.white
                    passwordTextField.backgroundColor = UIColor.white
                    
                    
                    
                    activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                    activityIndicator.center = self.view.center
                    activityIndicator.hidesWhenStopped = true
                    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
                    view.addSubview(activityIndicator)
                    activityIndicator.startAnimating()
                    UIApplication.shared.beginIgnoringInteractionEvents()
                    
                    
                    
                    PFUser.logInWithUsername(inBackground: emailTextField.text!, password: passwordTextField.text!, block: { (user, error) in
                        
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        
                        
                        if error != nil {
                            
                            var displayErrorMessage = "Please try again later."
                            
                            let error = error as NSError?
                            
                            if let errorMessage = error?.userInfo["error"] as? String {
                                displayErrorMessage = errorMessage
                            }
                            
                            self.showAlert(title: "Login Error", message: displayErrorMessage)
                            
                            
                        } else {
                            self.performSegue(withIdentifier: "showPlaceTable", sender: self)
                            
                        }
                        
                        
                    })
                    
                }
                
                
            }else{
                
                if emailTextField.text?.characters.count == 0 || passwordTextField.text?.characters.count == 0{
                    emailTextField.backgroundColor = UIColor.red
                    passwordTextField.backgroundColor = UIColor.red
                }
                showAlert(title: "ข้อผิดพลาด!", message: "คุณยังไม่ได้กรอก Email หรือ Password")
            }
        
        }
        
        
        emailTextField.text = ""
        passwordTextField.text = ""
        dismissKeyboard()
    
    }
    
    @IBAction func changeSignupMode(_ sender: AnyObject) {
        
        if signupMode {
            // Change to login mode
            
            signupOrLogin.setTitle("Log In", for: [])
            
            changeSignupModeButton.setTitle("Sign Up", for: [])
            
            messageLabel.text = "Don't have an account?"
            
            signupMode = false
            
            
        } else {
            // Change to signup mode
            
            signupOrLogin.setTitle("Sign Up", for: [])
            
            changeSignupModeButton.setTitle("Log In", for: [])
            
            messageLabel.text = "Already have an account?"
            
            signupMode = true
            
            
        }
        
    }
    
    
    
    func showAlert(title:String,message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let resultAlert = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(resultAlert)
        present(alert, animated: true, completion: nil)
        
    }
    
    
}
