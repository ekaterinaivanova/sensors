//
//  AccountModel.swift
//  Sensors
//
//  Created by Ekaterina Ivanova on 08/07/2018.
//  Copyright © 2018 Ekaterina Ivanova. All rights reserved.
//

import Foundation

public  let AccountModelChangedNotification = "AccountModelChangedNotification"

class AccountModel:NSObject{
    
    var dataSectionNumber:Int {
        return dataSection.count
    }
    var passwordSectionNumber:Int {
        return passwordSection.count
    }
    var forgotPasswordSectionNumber:Int {
        return forgotPwdSection.count
    }
    var sectionsNumber:Int {
        if GlobalVariables.loggedIn{
            return sections.count
        }
        return 1
    }
    var dataSection = [ NSLocalizedString("Email", tableName: "Localized", comment: ""),
                          NSLocalizedString("Name", tableName: "Localized", comment: ""),
                          NSLocalizedString("Lastname", tableName: "Localized", comment: ""),
                          NSLocalizedString("Delete", tableName: "Localized", comment: "")]
    
    var passwordSection = [ NSLocalizedString("Old password", tableName: "Localized", comment: ""),
                              NSLocalizedString("New password", tableName: "Localized", comment: ""),
                              NSLocalizedString("Re-password", tableName: "Localized", comment: ""),
                              NSLocalizedString("Save", tableName: "Localized", comment: "")]
    
    var forgotPwdSection = [NSLocalizedString("Forgot password", tableName: "Localized", comment: "")]
    
    var sections = [ NSLocalizedString("Account data", tableName: "Localized", comment: ""),
                       NSLocalizedString("Change password", tableName: "Localized", comment: ""),
                       NSLocalizedString("Forgot password", tableName: "Localized", comment: "")]
    
    
    var passwordData = ["","","",""]
    
    func numberOfRowsInSection(_ section:Int)->Int{
        if GlobalVariables.loggedIn{
            if section == 0{
                return dataSectionNumber
            }else if section == 1{
                return passwordSectionNumber
            }else{
                return forgotPasswordSectionNumber
            }
        }else{
            return 3
        }
        
    }
    func setDataAtIndex(_ index:Int, data:String){
        passwordData[index] = data
    }
    fileprivate func getDataAtIndex(_ indexPath:IndexPath) ->String{
        let data = [GlobalVariables.email, GlobalVariables.userName, GlobalVariables.lastName, ""]
        
        switch (indexPath as NSIndexPath).section{
        case 0:
            return data[(indexPath as NSIndexPath).row]
        case 1:
            return passwordData[(indexPath as NSIndexPath).row]
        case 2:
            return forgotPwdSection[(indexPath as NSIndexPath).row]
        default:
            return ""
        }
    }
    func getLabelName(_ indexPath:IndexPath) ->String{
        switch (indexPath as NSIndexPath).section{
        case 0:
            return dataSection[(indexPath as NSIndexPath).row]
        case 1:
            return passwordSection[(indexPath as NSIndexPath).row]
        case 2:
            return forgotPwdSection[(indexPath as NSIndexPath).row]
        default: return ""
        }
    }
    
    func getData(_ indexPath:IndexPath) -> NSDictionary{
        //        let index = indexPath.row
        var hidden = true
        var editing = true
        var button = false
        var label = ""
        if GlobalVariables.loggedIn{
            switch (indexPath as NSIndexPath).section{
            case 0:
                hidden = false
                editing = false
            case 2:
                button = true
            default: break
            }
            if (indexPath as NSIndexPath).row == 3{
                button = true
            }
            label = getLabelName(indexPath)
        } else {
            button = true
            if (indexPath as NSIndexPath).row == 0 {
                label = NSLocalizedString("Login", tableName: "Localized", comment: "")
            }else if (indexPath as NSIndexPath).row == 1{
                label = NSLocalizedString("Register", tableName: "Localized", comment: "")
                
            }else{
                label = NSLocalizedString("Forgot password", tableName: "Localized", comment: "")
            }
        }
        
        let dataDictionary:NSDictionary = ["data": self.getDataAtIndex(indexPath), "label":label,"hidden":hidden, "editing": editing, "button":button]
        return dataDictionary
        
        
    }
    @objc func dataChanged(){
        NotificationCenter.default.post(name: Notification.Name(rawValue: AccountModelChangedNotification), object: self)
    }
    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(AccountModel.dataChanged), name: NSNotification.Name(rawValue: LoginStatusChanged), object: nil)
    }
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
}
