//
//  LoginModel.swift
//  SensorDataSend
//
//  Created by Ekaterina Ivanova on 16/02/16.
//  Copyright © 2016 Ekaterina Ivanova. All rights reserved.
//

import Foundation
import UIKit

class LoginModel{
    let dataLabels = ["Email","Password"]
    var data = ["",""]
    
    let client = LoginClient()
    
    
    func count()->Int{
        return dataLabels.count
    }
    
    func getData(_ index:Int)->NSDictionary{
        
        var hidden = false
        var emailKeyboard = false
        if index == 1{
            hidden = true
        }else if index == 0 {
            emailKeyboard = true
        }
        let temp:NSDictionary = ["label":dataLabels[index],"data":data[index], "hidden":hidden, "keyboard": emailKeyboard]
        return temp
        
    }
    
    func checkForEmptyTextFields()->Bool{
        for i in data{
            if i == "" {
                return true
            }
        }
        return false
    }
    
    func sendData(_ emitdataHandler:@escaping (_ result:String?)->Void){
        if !checkForEmptyTextFields(){
            if(GlobalVariables.loggedIn){
                if(GlobalVariables.email == self.data[0]){
                    emitdataHandler("EETLE")
                }else{
                    
//                    HTTPManager().logout({ (result) -> Void in
//                        HTTPManager().login(self.data[0], password: self.gvData[1]) { (status) -> Void in
//                            emitdataHandler(status)
//                        }
//                    })
                }
            }else{
                let user = ["Email":self.data[0], "Password": self.data[1],"PhoneName": UIDevice.current.name, "PhoneID": UIDevice.current.identifierForVendor!.uuidString]
                
                client.login(user: user as NSDictionary, completion: { (status, result) in
                    if let dictionnary : NSDictionary = result {
                        let readableStatus = dictionnary.object(forKey: "status") as! String
                        
                        emitdataHandler(readableStatus)
                        
                    }

                })

            }
            
        }else{
            //        empty fields
            emitdataHandler("EF")
        }
    }
    
    func setDataAtIndex(_ index:Int, data:String){
        self.data[index] = data
    }
    
    init(){
        
        if GlobalVariables.email != "" && GlobalVariables.password != ""{
            
            data[0] = GlobalVariables.email
            data[1] = GlobalVariables.password
            
        }
        
    }
    
}
