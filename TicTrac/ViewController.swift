//
//  ViewController.swift
//  TicTrac
//
//  Created by Apple on 06/12/2017.
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

/*where im at:
 - got data in table view - need expandable cells
 - core data subclass works, need to fecth exisiting data
 - put tableview code into extension
 - got json, but should use promisekit/alamo fire for asynchronous coding
 
 */
import UIKit
import Alamofire
//import CoreData

let urlString = "http://media.tictrac.com/tmp/users.json"

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, updateUIProtocol {
    
    @IBOutlet weak var userTableView: UITableView!
   
    var dataHelper = DataHelper()
    var userArray : [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataHelper.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        userArray = dataHelper.loadFromStore()
        if userArray.count > 0 {
            self.userTableView.reloadData()

        }
        
        getJSON()
    }
    
    func updateUI() {
        self.userArray = dataHelper.userArray
        self.userTableView.reloadData()
    }
    
    fileprivate func getJSON() {
        dataHelper.getJSONFor(urlString: urlString)
        
    }
    
    //TODO: use extension for table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("self.userArray.count: \(self.userArray.count)")
        return self.userArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserTableViewCell {
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

