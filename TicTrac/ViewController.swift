//
//  ViewController.swift
//  TicTrac
//
//  Created by Apple on 06/12/2017.
//  Copyright © 2017 com.spcarlin. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

let urlString = "http://media.tictrac.com/tmp/users.json"
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, updateUIProtocol {
    
    @IBOutlet weak var userTableView: UITableView!
    fileprivate var managedObjectContext : NSManagedObjectContext?
    var dataHelper = DataHelper()
    var userArray : [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        userArray = dataHelper.loadFromStore()
        getJSON()
    }
    func updateUI() {
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

