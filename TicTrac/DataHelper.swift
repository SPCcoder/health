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

protocol updateUIProtocol { // we're using this as an easy way to update the UI in our VC
    func updateUI()
}
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
    
    public func loadFromStore(){
        
        var managedObjsArray : [User] = []
            let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            
            let error = NSError()
            do {
                 self.userArray = try self.managedObjectContext?.fetch(fetchReq) as! [User]

            } catch {
                print("array not populated")
                print(error)
  
            }
        

    }
    
    public func getJSON(){
        let utilityQueue = DispatchQueue.global(qos: .utility)
        
        Alamofire.request(urlString).responseJSON(queue: utilityQueue) { response in
            print("Executing response handler on utility queue")
            switch response.result {
            case .success:
                
               // print(response.result.value)
                
                if let mainDict = response.result.value as? [String : Any] {
                  //  print(mainDict)
                    if let usersArray = mainDict["users"] as? Array<Any>{
                        //print(usersArray)
                        
                        //Since CRUD is not in the spec, we'll assume the json always gives us the most up to date version of the users, so we delete the ones stored locally
                        for userMO in self.userArray {
                            if let managedObject = userMO as? NSManagedObject {
                                
                                    self.deleteOldData()
                            }
                        }
                        for user in usersArray {
                            if let userD = user as? [AnyHashable: Any] {
                                //here we create new managed objects from our JSON. We'll load these next time the app launches while we wait for the web call to give us new data
                                if let newUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: self.managedObjectContext!) as? User {
                                    newUser.name = userD["name"] as? String
                                    newUser.email = userD["email"] as? String
                                    newUser.number = userD["infos"] as? String
                                self.saveData()
                                    self.userArray.append(newUser)


                                }
                            }
                        }
                    }
                    //replace any existing MOs
                    //update UI
                    DispatchQueue.main.async {
                        self.delegate?.updateUI()

                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    func deleteOldData(){
        //delete existing users, we have the new users that will replace them
        for userMO in self.userArray {
            if let managedObject = userMO as? NSManagedObject {
                self.managedObjectContext?.delete(managedObject)
                self.saveData()
            }
        }
    }
    func saveData(){
        do {
            try self.managedObjectContext?.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
