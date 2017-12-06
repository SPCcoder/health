//
//  DataHelper.swift
//  TicTrac
//
//  Created by Apple on 06/12/2017.
//  Copyright © 2017 com.spcarlin. All rights reserved.
//

import Foundation
import Alamofire
import CoreData
class DataHelper {
    var managedObjectContext : NSManagedObjectContext?
    
    
    public func loadFromStore()->[User]{
        if let appDel = UIApplication.shared.delegate as? AppDelegate {
            self.managedObjectContext = appDel.persistentContainer.viewContext
        } else {
            print("We do not have access to a ManagedObjectContext")
            return [User]()
        }
        //fetch objects
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        let error = NSError()
        do {
            let managedObjsArray = try managedObjectContext?.fetch(fetchReq) as! [User]
            // self.myTableView.reloadData()
            return managedObjsArray
        } catch {
            print("array not populated")
            print(error)
            return [User]()
        }
    }
    
    public func getJSONFor(urlString : String){
        let utilityQueue = DispatchQueue.global(qos: .utility)
        
        Alamofire.request(urlString).responseJSON(queue: utilityQueue) { response in
            print("Executing response handler on utility queue")
            switch response.result {
            case .success:
                print("Validation Successful")
                
                //replace any existing MOs
                //update UI
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
}
