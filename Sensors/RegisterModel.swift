//
//  RegisterModel.swift
//  Sensors
//
//  Created by Ekaterina Ivanova on 06/05/2017.
//  Copyright © 2017 Ekaterina Ivanova. All rights reserved.
//

import Foundation


class RegisterModel{
    
    let dataLabels = ["Name","Lastname","Email","Password", "Re-password"]
    var data = ["","","","", ""]
    let registerClient = RegisterClient()
    let loginClient = UserClient()
    
    
    func count()->Int{
        return dataLabels.count
    }
    
    func getData(_ index:Int)->NSDictionary{
        
        var hidden = false
        var emailKeyboard = false
        if index == 3 || index == 4{
            
            hidden = true
            
        }else if index == 2 {
            
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
    
    func checkPasswordsMatch()->Bool{
        
        if data[3] != data[4]{
            
            return false
            
        }
        
        return true
        
    }
    
    func sendData(_ emitdataHandler:@escaping (_ result:String?)->Void){

        if checkForEmptyTextFields(){

            emitdataHandler("Empty fields")
            return
        }
        
        if(!checkPasswordsMatch()){
       
            emitdataHandler("Password do not match")
            return
        }

        let param = ["Email":data[2], "Password":data[3], "FirstName":data[0], "LastName": data[1]]
        
        registerClient.register(user: param as NSDictionary) { (status, result) in
            
            if let dictionnary : NSDictionary = result {
                
                let readableStatus = dictionnary.object(forKey: "status") as! String
                
                emitdataHandler(readableStatus)
                
                if readableStatus == "AOK"{
                    
                    GlobalVariables.email = self.data[2]
                    GlobalVariables.password = self.data[3]
                    GlobalVariables.userName = self.data[0]
                    GlobalVariables.lastName = self.data[1]
                    
                    let user = ["Email":GlobalVariables.email, "Password": GlobalVariables.password]
                    
                    self.loginClient.login(user: user as NSDictionary, completion: { (status, result) in
                        
                        print("Loged in after registration")
                        
                    })
                    
                }
                
                emitdataHandler(readableStatus)
                
            }
            
        }
        
    }
    
    func setDataAtIndex(_ index:Int, data:String){
        
        self.data[index] = data
        
    }
}
