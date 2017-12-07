//
//  ViewController.swift
//  TicTrac
//
//  Created by Sean on 06/12/2017.
//  Copyright © 2017 com.spcarlin. All rights reserved.
//


/* MY NOTES
 - There's no localisation set up
 - The DataHelper class handles update/changes to data
 - There is more safety/error handling that needs to be done, especially in DataHelper - I wanted to use PromiseKit but it ate into time so I left it out
 - For this project I assume the new JSON is the update to date data so delete the local data and store the new data
 - Didn't have time to do more layout work on the UI
 - I ran out of time!
 */
import UIKit
// VC doesnt need to know about core data or Alamofire so we don't import them

//Constants
// Normally I'd put these in their own file but they're ok here for now
let KEY_NAME = "name"
let KEY_NUMBER = "infos"// infos is the key in the json but I'm assuming I can call it a number as per the spec
let KEY_EMAIL = "email"
let KEY_USER = "User"
let KEY_USER_CELL = "UserCell"

// MARK: -

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, updateUIProtocol {
    
    @IBOutlet weak var userTableView: UITableView!
    
    var dataHelper = DataHelper() // this class
    var userArray : [User] = [] // this will store the user's we'll display, this can be populated from the core data store or the web call
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataHelper.delegate = self //set VC as delegate to update the UI
        
        if userArray.count > 0 {
            self.userTableView.reloadData()
            
        }
        
        getJSON()
    }
    
    func updateUI() {
        self.userArray = dataHelper.userArray // update VC array from data helper
        self.userTableView.reloadData() // since we updated our tableview data source we update the tableview to show changes
    }
    
    func getJSON() {
        // with bigger data, we might put up an activity indicator to let the user know the app is working on something
        dataHelper.getJSON()
        
    }
    
    // MARK: - Table View
    //There's no benefit to using an extension for table view delegate funcs at this point
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("self.userArray.count: \(self.userArray.count)")
        return self.userArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: KEY_USER_CELL) as? UserTableViewCell {
            cell.nameLabel.text = self.userArray[indexPath.row].name
            cell.emailLabel.text = self.userArray[indexPath.row].email
            cell.numberLabel.text = self.userArray[indexPath.row].number
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { // not implemented
        //check if selected cell is expanded
        // if no: expand cell and unhide phone number also
        // if yes : shrink cell and hide phone number
        
    }
}

