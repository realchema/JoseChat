//
//  ProfileTableViewController.swift
//  JoseChat
//
//  Created by Jose M Arguinzzones on 2021-07-07.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var messageButtonOutlet: UIButton!
    @IBOutlet weak var callButtonOutlet: UIButton!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var blockButtonOutlet: UIButton!
    var user: FUser?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        //title = "Profile"
    }
    
    
    //MARK: IBActions
    
    @IBAction func callButtonPressed(_ sender: UIButton) {
        print("call user \(user!.fullname)")
    }
    
    @IBAction func chatButtonPressed(_ sender: UIButton) {
        print("chat with user \(user!.fullname)")
    }
    
    @IBAction func blockUserButtonPressed(_ sender: UIButton) {
        var currentBlockedIds = FUser.currentUser()!.blockedUsers
        
        if currentBlockedIds.contains(user!.objectId){
            let index = currentBlockedIds.firstIndex(of: user!.objectId)
            currentBlockedIds.remove(at: index!)
        }else {
            currentBlockedIds.append(user!.objectId)
        }
        
        updateCurrentUserInFirestore(withValues: [kBLOCKEDUSERID: currentBlockedIds]) { (error) in
            if error != nil {
                print("error updating user \(error!.localizedDescription)")
                return
            }
            self.updateBlockStatus()
        }
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    //to set the title of section in blank
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    //to get clean space between sections
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    //to set the height of the header section
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // if section is equals to 0 set height 0, else set 30
        if section == 0 {
            return 0
        }
        
        return 30
    }
    
    //MAK: Setup UI
    
    func setupUI() {
        
        if user != nil{
            self.title = "Profile"
            fullNameLabel.text = user!.fullname
            phoneNumberLabel.text = user!.phoneNumber
            
            updateBlockStatus()
            
            imageFromData(pictureData: user!.avatar) { (avatarImage) in
                if avatarImage != nil {
                    self.avatarImageView.image = avatarImage!.circleMasked
                }
            }
        }
    }
    
    func updateBlockStatus() {
        if user!.objectId != FUser.currentId() {
            blockButtonOutlet.isHidden = false
            messageButtonOutlet.isHidden = false
            callButtonOutlet.isHidden =  false
        }else {
            blockButtonOutlet.isHidden = true
            messageButtonOutlet.isHidden = true
            callButtonOutlet.isHidden =  true
        }
        
        if FUser.currentUser()!.blockedUsers.contains(user!.objectId){
            blockButtonOutlet.setTitle("Unlock User", for: .normal)
        }else {
            blockButtonOutlet.setTitle("Block User", for: .normal)
        }
    }
}
