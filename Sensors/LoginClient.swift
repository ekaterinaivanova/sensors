//
//  LoginClient.swift
//  Sensors
//
//  Created by Ekaterina Ivanova on 01/05/2017.
//  Copyright © 2017 Ekaterina Ivanova. All rights reserved.
//

import Foundation

class LoginClient{
    
    var api = ApiClent.init()
    
    func login(user: NSDictionary, completion: @escaping (_ success: Bool, _ message: NSDictionary?) -> ()) {
        
        api.post(request: api.clientURLRequest(path: "login", params: user as? Dictionary<String, AnyObject>)) { (success, object) -> () in
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
