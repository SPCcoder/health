//
//  DataHelper.swift
//  TicTrac
//
//  Created by Apple on 06/12/2017.
//  Copyright © 2017 com.spcarlin. All rights reserved.
//

import Foundation
import Alamofire
class DataHelper {
    public func getJSONFor(urlString : String){
    let utilityQueue = DispatchQueue.global(qos: .userInteractive)
    
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
