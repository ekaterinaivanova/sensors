//
//  ForgotPasswordModel.swift
//  Sensors
//
//  Created by Ekaterina Ivanova on 09/07/2018.
//  Copyright © 2018 Ekaterina Ivanova. All rights reserved.
//
import Foundation

class ForgotPasswordModel{
    
    let dataLabels = [NSLocalizedString("Email", tableName: "Localized", comment: ""),
                        NSLocalizedString("Forgot password", tableName: "Localized", comment: "")]
    var data = ["",""]
    
    func count()->Int{
        return dataLabels.count
    }
    
    func getData(_ index:Int)->NSDictionary{
        var button = true
        var hidden = false
        var emailKeybaord = false
        if index == 1{
            hidden = true
        }else if index == 0 {
            emailKeybaord = true
            button = false
            
        }
        let lvTemp:NSDictionary = ["label":dataLabels[index],"data":data[index], "hidden":hidden, "keyboard": emailKeybaord,"button": button]
        return lvTemp
    }
    
    func checkForEmptyTextFields()->Bool{
        if data[0] == "" {
            return true
        }
        return false
    }
    
    func setDataAtIndex(_ index:Int, newData:String){
        data[index] = newData
        
    }
    
    func sendData(_ emitdataHandler:@escaping (_ result:String?)->Void){
        if !checkForEmptyTextFields(){
            UserClient().requestNewPassword(data[0], complition: {
                (result) in
                emitdataHandler(result)
            })
        }else{
            //        empty fields
            emitdataHandler("EF")
        }
    }
    
}
