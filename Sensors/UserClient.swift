//
//  LoginClient.swift
//  Sensors
//
//  Created by Ekaterina Ivanova on 01/05/2017.
//  Copyright © 2017 Ekaterina Ivanova. All rights reserved.
//

import Foundation

class UserClient{
    
    var api = ApiClent.init()
    
    func logout() {
        api.put(request: api.clientURLRequest(path:  "user-login/\(String(describing: GlobalVariables.loginID))")){
            (success, object) -> () in            
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
    
    func requestNewPassword(_ email:String, complition:@escaping (_ result:String)-> Void){
        let param = ["email":"\(email)"] as Dictionary<String, String>
        api.put(request: api.clientURLRequest(path:  "forgotpassword)", params: param as Dictionary<String, AnyObject>)){
            (success, object) -> () in
            GlobalVariables.loggedIn = false;
            if let status = object!["status"] as? String{
                complition(status)
            }else{
                complition("NR")
            }
        }
    }
    
    func changePassword(oldPassword:String, newPassword:String, completion: @escaping (_ message: String?) -> ()) {
        let param = ["pwd":"\(oldPassword)", "new_pwd":"\(newPassword)"] as Dictionary<String, String>
        api.put(request: api.clientURLRequest(path:  "users/\(String(describing: GlobalVariables.loginID))", params: param as Dictionary<String, AnyObject>)){
            (success, object) -> () in
            GlobalVariables.loggedIn = false;
            NotificationCenter.default.post(name: Notification.Name(rawValue: "LoginStatusChanged"), object:self)
            completion("OK")
        }
    }
    
    func deleteAcc(_ complition:@escaping (_ result:String)-> Void){
        let param = ["email":"\(GlobalVariables.email)", "pwd":GlobalVariables.password] as Dictionary<String, String>
        api.delete(request: api.clientURLRequest(path: "users", params: param as? Dictionary<String, AnyObject>)) { (success, object) -> () in
            DispatchQueue.main.async(execute: { () -> Void in
                
                if success {
                    complition("OK")
                    
                } else {
                    //                    TODO HANDLE ERRORS
                    complition("NOK")
                    
                }
            })
        }
        
    }
    
}
