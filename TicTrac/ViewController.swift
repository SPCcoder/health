//
//  ViewController.swift
//  TicTrac
//
//  Created by Sean on 06/12/2017.
//  Copyright © 2017 com.spcarlin. All rights reserved.
//
/* TASK
 - fetch data from url  http://media.tictrac.com/tmp/users.json
 - Display the list of users with the name​ and email​ for each user. - table view
 - Tapping on a row should expand the cell to then show the phone​ ​number​ in addition to
 the name and email.
 - Bonus​ ​points​: Use a mechanism to persist the data for offline functionality. - core data
 */
/*
 EVALUATED ON:
 The work is to be evaluated on:
 - How the data is fetched and parsed within the app
 - Frameworks used
 - Design patterns used
 - Project structure
 - UI
 - Good quality of code: readable, maintainable, structured
 */

import UIKit
// VC doesnt need to know about core data or Alamofire so we don't import them

//Constants
// Normally I'd put these in their own file but they're ok here for now
let KEY_NAME = "name"
let KEY_NUMBER = "infos"
let KEY_EMAIL = "email"
let KEY_USER = "user"
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
        // userArray = dataHelper.loadFromStore()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //check if cell is expanded
        // no: expand cell and show phone number also
        // yes : shrink cell
        
    }
}

