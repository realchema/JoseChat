//
//  UsersTableViewController.swift
//  JoseChat
//
//  Created by Jose M Arguinzzones on 2021-07-05.
//

import UIKit
import Firebase
import ProgressHUD
class UsersTableViewController: UITableViewController, UISearchResultsUpdating {
    
    
    
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var filterSegmentedControll: UISegmentedControl!
    
    var allUsers: [FUser] = []
    var filteredUsers: [FUser] = []
    var allUsersGroup = NSDictionary() as! [String : [FUser]]
    var sectionTitleList : [String] = []
    
    //to add search bar
    let searchController  = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Users"
        navigationItem.largeTitleDisplayMode = .never
        tableView.tableFooterView = UIView()
        
        //to add search bar
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation  = false
        definesPresentationContext = true
        
        loadUsers(filter: kCITY)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        if searchController.isActive && searchController.searchBar.text != "" {
            return 1
        }else {
            
            return allUsersGroup.count
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredUsers.count
        } else {
            //find section title
            let sectionTitle = self.sectionTitleList[section]
            
            //user for given title
            let users = self.allUsersGroup[sectionTitle]
            return users!.count
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UserTableViewCell
        
        var user: FUser
        
        if searchController.isActive && searchController.searchBar.text != ""{
            user = filteredUsers[indexPath.row]
        }else {
            
            let sectionTitle = self.sectionTitleList[indexPath.section]
            
            let users = self.allUsersGroup[sectionTitle]
            
            user = users![indexPath.row]
        }

        cell.generateCellWith(fUser: allUsers[indexPath.row], indexPath: indexPath)
        return cell
    }
    
    func loadUsers(filter: String) {
        ProgressHUD.show()
        var query: Query!
        
        switch filter {
        case kCITY:
            query = reference(.User).whereField(kCITY, isEqualTo: FUser.currentUser()!.city).order(by: kFIRSTNAME, descending: false)
        case kCOUNTRY:
            query = reference(.User).whereField(kCOUNTRY, isEqualTo: FUser.currentUser()!.country).order(by: kFIRSTNAME, descending: false)
        default:
            query = reference(.User).order(by: kFIRSTNAME, descending: false)
        }
        
        query.getDocuments { (snapshot, error) in
            self.allUsers = []
            self.sectionTitleList = []
            self.allUsersGroup = [:]
            
            if error != nil {
                print(error!.localizedDescription)
                ProgressHUD.dismiss()
                self.tableView.reloadData()
                return
            }
            
            guard let snapshot = snapshot else {
                ProgressHUD.dismiss()
                return
            }
            
            if !snapshot.isEmpty {
                for userDiccionary in snapshot.documents {
                    let userDiccionary = userDiccionary.data() as NSDictionary
                    let fUser = FUser(_dictionary: userDiccionary)
                    
                    if fUser.objectId != FUser.currentId() {
                        self.allUsers.append(fUser)
                    }
                }
                //split to groups
                self.splitDataIntoSetion()
                self.tableView.reloadData()
            }
            
            self.tableView.reloadData()
            ProgressHUD.dismiss()
        }
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Tableview Delegate
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchController.isActive && searchController.searchBar.text != ""{
            return ""
        }else {
            return sectionTitleList[section]
        }
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if searchController.isActive && searchController.searchBar.text != "" {
            return nil
        }else {
            return self.sectionTitleList
        }
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    
    //MARK: IBActions
    
    @IBAction func filterSegmentValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            loadUsers(filter: kCITY)
        case 1:
            loadUsers(filter: kCOUNTRY)
        case 2:
            loadUsers(filter: "")
        default:
            return
        }
    }
    
    
    //MARK: Search controller functions
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredUsers = allUsers.filter({ (user) -> Bool in
            return user.firstname.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    //MARK: helper fucntions
    
    fileprivate func splitDataIntoSetion(){
        var sectionTitle: String = ""
        for i in 0..<self.allUsers.count {
            let currentUser  = self.allUsers[i]
            let firstCharacter = currentUser.firstname.first!
            
            let firstCharacterString = "\(firstCharacter)"
            
            if firstCharacterString != sectionTitle {
                sectionTitle = firstCharacterString
                self.allUsersGroup[sectionTitle] = []
                sectionTitleList.append(sectionTitle)
            }
            
            self.allUsersGroup[firstCharacterString]?.append(currentUser)
        }
    }

}
