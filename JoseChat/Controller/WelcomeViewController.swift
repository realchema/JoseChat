//
//  WelcomeViewController.swift
//  JoseChat
//
//  Created by Jose M Arguinzzones on 2021-06-23.
//

import UIKit

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
    }
    
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        dismissKeyboard()
        print("register")
    }
    
    
    @IBAction func backgroundTap(_ sender: Any) {
        dismissKeyboard()
        print("dismiss")
    }
    
    // MARK: - HelperFunctions
    
    func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
    func cleanTextFields() {
        emailTextField.text = ""
        passwordTextField.text = ""
        repeatPasswordTextField.text = ""
    }
    
    
}
