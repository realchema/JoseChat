//
//  FinishRegistrationViewController.swift
//  JoseChat
//
//  Created by Jose M Arguinzzones on 2021-06-25.
//

import UIKit
import ProgressHUD

class FinishRegistrationViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    var email: String!
    var password: String!
    var avatarImage: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print(email, password)
    }
    
    @IBAction func cancellButtonPressed(_ sender: Any) {
        cleanTextFields()
        dismissKeyboard()
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func dondeButtonPressed(_ sender: Any) {
        dismissKeyboard()
        ProgressHUD.show("Registering...")
        
        if nameTextField.text != "" && lastNameTextField.text != "" && countryTextField.text != "" && cityTextField.text != "" && phoneTextField.text != "" {
            
            FUser.registerUserWith(email: email, password: password, firstName: nameTextField.text!, lastName: lastNameTextField.text!) { (error) in
                
                if error != nil {
                    ProgressHUD.dismiss()
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
                
                self.registerUser()
            }
            
        } else {
            ProgressHUD.showError("All fields are required!")
        }
        
    }
    
    
    //MARK: Helpers
    
    func registerUser() {
        let fullName = nameTextField.text! + " " + lastNameTextField.text!
        var tempDiccionary : Dictionary = [kFIRSTNAME : nameTextField.text!, kLASTNAME : lastNameTextField.text!, kFULLNAME : fullName,
        kCOUNTRY : countryTextField.text!, kCITY : cityTextField.text!, kPHONE : phoneTextField.text! ] as [String: Any]
        
        if avatarImage == nil {
            imageFromInitials(firstName: nameTextField.text!, lastName: lastNameTextField.text!) {
                (avatarInitials) in
                let avartIMG = avatarInitials.jpegData(compressionQuality: 0.7)
                let avatar = avartIMG?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
                
                tempDiccionary[kAVATAR] = avatar
                
                //finish Registration
                self.finishRegistration(withValues: tempDiccionary)
            }
        } else {
            let avaterData = avatarImage?.jpegData(compressionQuality: 0.7)
            let avatar = avaterData!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            
            tempDiccionary[kAVATAR] = avatar
            
            // finish Registration
            self.finishRegistration(withValues: tempDiccionary)
            
        }
    }
    
    func finishRegistration(withValues: [String : Any]) {
        updateCurrentUserInFirestore(withValues: withValues) {(error) in
            
            if error != nil {
                DispatchQueue.main.async {
                    ProgressHUD.showError(error!.localizedDescription)
                    print(error?.localizedDescription)
                }
                return
            }
            
            ProgressHUD.dismiss()
            self.goToApp()
            // go to app 
        }
    }
    
    func goToApp(){
        ProgressHUD.dismiss()
        cleanTextFields()
        dismissKeyboard()
        
        let mainView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainApplication") as! UITabBarController
        
        self.present(mainView, animated: true, completion: nil)
    }
    
    func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
    func cleanTextFields() {
        nameTextField.text = ""
        lastNameTextField.text = ""
        countryTextField.text = ""
        cityTextField.text = ""
        phoneTextField.text = ""
    }
    
}
