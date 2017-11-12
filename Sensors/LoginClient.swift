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
    
    func logout() {
        api.put(request: api.clientURLRequest(path:  "user-login/\(String(describing: GlobalVariables.loginID))")){
            (success, object) -> () in
            
            print(success, object);
            GlobalVariables.loggedIn = false;
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "LoginStatusChanged"), object:self)
        }
    }
    
    func login(user: NSDictionary, completion: @escaping (_ success: Bool, _ message: NSDictionary?) -> ()) {
        
        api.post(request: api.clientURLRequest(path: "user-login", params: user as? Dictionary<String, AnyObject>)) { (success, object) -> () in
            DispatchQueue.main.async(execute: { () -> Void in
                
                if success {
                    completion(success, object as? NSDictionary );
                    
                    if let resultDictionnary : NSDictionary = object as? NSDictionary {
                        let readableStatus = resultDictionnary.object(forKey: "status") as! String
                        if(readableStatus == "AOK"){

                            GlobalVariables.loggedIn = true;
                            
                            GlobalVariables.loginID = Int(resultDictionnary.object(forKey: "LoginID") as! Int)
                        }else{
                            GlobalVariables.loggedIn = false;
                        }
                        
                         NotificationCenter.default.post(name: Notification.Name(rawValue: LoginStatusChanged), object:self)

                    }
                } else {
                    //                    TODO HANDLE ERRORS
                    completion(false, object as? NSDictionary)
                    
                }
            })
        }
    }

    
}
