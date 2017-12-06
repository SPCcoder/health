//
//  DataHelper.swift
//  TicTrac
//
//  Created by Sean on 06/12/2017.
//  Copyright © 2017 com.spcarlin. All rights reserved.
//

import Foundation
import Alamofire
import CoreData

protocol updateUIProtocol { // we're using this as an easy way to update the UI in our VC
    func updateUI()
}
// MARK: -
class DataHelper { // this class helps clean up the view controller. I didn't have a seperate 'webservice helper' class just to save time
    
    let urlString = "http://media.tictrac.com/tmp/users.json" // the VC doesn't need to know about this so its here
    
    var managedObjectContext : NSManagedObjectContext?
    var delegate : updateUIProtocol?
    public var userArray : [User] = []
    
    init(){
        
        if let appDel = UIApplication.shared.delegate as? AppDelegate  {
            
            self.managedObjectContext = appDel.persistentContainer.viewContext //getting the MOC here in the init stops issues 
        }
        self.loadFromStore()
    }
    // MARK: - Core Data
    func loadFromStore(){
        
        var managedObjsArray : [User] = []
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: KEY_USER)
        
        let error = NSError()
        do {
            self.userArray = try self.managedObjectContext?.fetch(fetchReq) as! [User]
            
        } catch {
            print("array not populated")
            print(error)
            
        }
        
        
    }
    
    func deleteOldData(){
        //delete existing users, we have the new users that will replace them
        for userMO in self.userArray {
            self.managedObjectContext?.delete(userMO)
            self.saveData()
            
        }
    }
    
    func saveData(){// we'll pulled this code out from getJSON func to tidy up a bit
        do {
            try self.managedObjectContext?.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: -
    public func getJSON(){
        let utilityQueue = DispatchQueue.global(qos: .utility)
        
        Alamofire.request(urlString).responseJSON(queue: utilityQueue) { response in
            // print("Executing response handler on utility queue")
            switch response.result {
            case .success:
                
                // print(response.result.value)
                
                if let mainDict = response.result.value as? [String : Any] {
                    //  print(mainDict)
                    if let usersArray = mainDict["users"] as? Array<Any>{
                        //print(usersArray)
                        
                        /*Since CRUD is not in the spec, we'll assume the json always
                         gives us the most up to date version of the users,
                         so we delete the ones stored locally */
                        for userMO in self.userArray {
                            if let managedObject = userMO as? NSManagedObject {
                                
                                self.deleteOldData()
                            }
                        }
                        self.userArray.removeAll()
                        
                        // print("DH array count: \(self.userArray.count)")
                        
                        for user in usersArray {
                            if let userD = user as? [AnyHashable: Any] {
                                //here we create new managed objects from our JSON. We'll load these next time the app launches while we wait for the web call to give us new data
                                if let newUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: self.managedObjectContext!) as? User {
                                    newUser.name = userD[KEY_NAME] as? String
                                    newUser.email = userD[KEY_EMAIL] as? String
                                    newUser.number = userD[KEY_NUMBER] as? String
                                    self.saveData()
                                    self.userArray.append(newUser)
                                    
                                    
                                }
                            }
                        }
                        print("DH array count: \(self.userArray.count)")
                    }
                    
                    //update UI on main thread
                    DispatchQueue.main.async {
                        self.delegate?.updateUI()
                        
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
