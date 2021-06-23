//
//  WelcomeViewController.swift
//  JoseChat
//
//  Created by Jose M Arguinzzones on 2021-06-23.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


    // MARK: - Navigation

   
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        print("login")
    }
    
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        print("register")
    }
    
    
    @IBAction func backgroundTap(_ sender: Any) {
        print("dismiss")
    }
    
}
