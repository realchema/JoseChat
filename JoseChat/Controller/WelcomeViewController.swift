//
//  WelcomeViewController.swift
//  JoseChat
//
//  Created by Jose M Arguinzzones on 2021-06-23.
//

import UIKit
import ProgressHUD
class WelcomeViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        

    }
    


    // MARK: - @IBAction

   
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        dismissKeyboard()
        print("login")
        
        if emailTextField.text != "" && passwordTextField.text != "" {
            loginUser()
        } else {
            ProgressHUD.showError("Email and Password is missing!")
        }
    }
    
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        dismissKeyboard()
        print("register")
        if emailTextField.text != "" && passwordTextField.text != "" && repeatPasswordTextField.text != "" {
            
            if passwordTextField.text == repeatPasswordTextField.text {
                registerUser()
            }else {
                ProgressHUD.showError("Password do not match!")
            }
            
        } else {
            ProgressHUD.showError("All fields are required!")
        }
    }
    
    
    @IBAction func backgroundTap(_ sender: Any) {
        dismissKeyboard()
        print("dismiss")
    }
    
    // MARK: - HelperFunctions
    
    func loginUser(){
        ProgressHUD.show("Login...")
        FUser.loginUserWith(email: emailTextField.text!, password: passwordTextField.text!)
        { (Error) in
            if Error != nil{
                ProgressHUD.showError(Error!.localizedDescription)
                return
            }
            
            self.goToApp()
        }
    }
    
    func registerUser(){
        
        performSegue(withIdentifier: "welcomeToFinishRegistration", sender: self)
        cleanTextFields()
        dismissKeyboard()
        
        
        print("register in")
    }
    
    func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
    func cleanTextFields() {
        emailTextField.text = ""
        passwordTextField.text = ""
        repeatPasswordTextField.text = ""
    }
    
    // MARK: GoToApp
    
    func goToApp(){
        ProgressHUD.dismiss()
        cleanTextFields()
        dismissKeyboard()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: USER_DID_LOGIN_NOTIFICATION), object: nil, userInfo: [kUSERID: FUser.currentId()])
        
        //present app here
        print("show the app")
        
        let mainView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainApplication") as! UITabBarController
        
        self.present(mainView, animated: true, completion: nil)
    }
    
    //MARk: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "welcomeToFinishRegistration" {
            
            let vc = segue.destination as! FinishRegistrationViewController
            vc.email = emailTextField.text
            vc.password = passwordTextField.text
        }
    }
    
    
}
