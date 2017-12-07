//
//  DataHelper.swift
//  TicTrac
//
//  Created by Sean on 06/12/2017.
//  Copyright © 2017 com.spcarlin. All rights reserved.
//

import Foundation
import Alamofire// this project only uses 1 Alamofire func, so it's not a great time saver for this project - though the code is a bit cleaner and of course its there to use if we want to add more functionality in future. I also thought it would be good to demo pods in a workspace
import CoreData

protocol updateUIProtocol { // we're using this as an easy way to update the UI in our VC
    func updateUI()
}
// MARK: -
class DataHelper { // this class helps clean up the view controller. I didn't have a seperate 'webservice helper' class just to save time
    
    let urlString = "http://media.tictrac.com/tmp/users.json" // the VC doesn't need to know about this so its here
    
    var managedObjectContext : NSManagedObjectContext?
    var delegate : updateUIProtocol?
    public var userArray : [User] = []// this is what the view controller uses to update it's own array - which is used for display
    
    init(){
        
        if let appDel = UIApplication.shared.delegate as? AppDelegate  {
            
            self.managedObjectContext = appDel.persistentContainer.viewContext // we know we need this so we set it up asap before use in funcs
        }
        self.loadFromStore()// we do the load in the init because we want the stored data asap after the user opens the app
    }
    
    // MARK: - Core Data
    func loadFromStore(){
        
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
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
        
        // so we run our request on the utility queue, which is recommended for network calls
        Alamofire.request(urlString).responseJSON(queue: utilityQueue) { response in
            // print("Executing response handler on utility queue")
            switch response.result {
            case .success:
                
                // print(response.result.value)
                
                if let mainDict = response.result.value as? [String : Any] {
                    //  print(mainDict)
                    if let usersArray = mainDict["users"] as? Array<Any>{
                        //print(usersArray)
                        
                        /* Since CRUD is not in the spec, we'll assume the json always
                         gives us the most up to date version of the users,
                         so we delete the ones stored locally */
                       
                        self.deleteOldData()
                        self.userArray.removeAll()// now we have empty array ready for new data from web call
                        
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
                       // print("DH array count: \(self.userArray.count)")
                    }
                    
                    //update UI on main thread
                    DispatchQueue.main.async {
                        self.delegate?.updateUI()
                        
                    }
                }
                
            case .failure(let error):
                print(error)
                // here we would want to tell the user that we can not update their user list
            }
        }
    }
    
}
