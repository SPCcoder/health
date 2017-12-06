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
class ViewController: UIViewController {
    fileprivate var managedObjectContext : NSManagedObjectContext?
var dataHelper = DataHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let appDel = UIApplication.shared.delegate as? AppDelegate {
        self.managedObjectContext = appDel.persistentContainer.viewContext
        } else {
            print("We do not have access to a ManagedObjectContext")
        }
        getJSON()
    }

    fileprivate func getJSON() {

        dataHelper.getJSONFor(urlString: urlString)

        
    }


}

