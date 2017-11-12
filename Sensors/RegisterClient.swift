//
//  RegisterClient.swift
//  Sensors
//
//  Created by Ekaterina Ivanova on 06/05/2017.
//  Copyright © 2017 Ekaterina Ivanova. All rights reserved.
//

import Foundation

class RegisterClient{
    
    var api = ApiClent.init()
    
    func register(user: NSDictionary, completion: @escaping (_ success: Bool, _ message: NSDictionary?) -> ()) {
        
        api.post(request: api.clientURLRequest(path: "user", params: user as? Dictionary<String, AnyObject>)) { (success, object) -> () in
            DispatchQueue.main.async(execute: { () -> Void in
                
                if success {
                    completion(success, object as? NSDictionary )
                    
                } else {
                    //                    TODO HANDLE ERRORS
                    completion(false, object as? NSDictionary)
                    
                }
            })
        }
    }
    
    
}
