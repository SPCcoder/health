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
protocol updateUIProtocol {
    func updateUI()
}
class DataHelper {
    
    var managedObjectContext : NSManagedObjectContext?
    var delegate : updateUIProtocol?
    public var userArray : [User] = []
    init(){
    
        if let appDel = UIApplication.shared.delegate as? AppDelegate  {
            
            self.managedObjectContext = appDel.persistentContainer.viewContext
        }
        
    }
    public func loadFromStore()->[User]{
//        DispatchQueue.global(qos: .userInteractive).async {
        var managedObjsArray : [User] = []
            //fetch objects
            let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            
            let error = NSError()
            do {
                 managedObjsArray = try self.managedObjectContext?.fetch(fetchReq) as! [User]
                // self.myTableView.reloadData()
//                DispatchQueue.main.async {
//                    return managedObjsArray
//
//                }
            } catch {
                print("array not populated")
                print(error)
//                DispatchQueue.main.async {
//                    return [User]()
//
//                }
                
            }
     //   }
        
        return managedObjsArray
    }
    
    public func getJSONFor(urlString : String){
        let utilityQueue = DispatchQueue.global(qos: .utility)
        
        Alamofire.request(urlString).responseJSON(queue: utilityQueue) { response in
            print("Executing response handler on utility queue")
            switch response.result {
            case .success:
                
               // print(response.result.value)
                
                if let mainDict = response.result.value as? [String : Any] {
                    print(mainDict)
                    if let usersArray = mainDict["users"] as? Array<Any>{
                        print(usersArray)
                        for user in usersArray {
                            if let userD = user as? [AnyHashable: Any] {
                              
                                if let newUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: self.managedObjectContext!) as? User {
                                    newUser.name = userD["name"] as? String
                                    newUser.email = userD["email"] as? String
                                    newUser.number = userD["infos"] as? String
                                    // try self.managedObjectContext!.save()
                                    
                                    do {
                                        try self.managedObjectContext?.save()
                                        self.userArray.append(newUser)
                                    } catch {
                                        print(error.localizedDescription)
                                    }
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
    
    
}
