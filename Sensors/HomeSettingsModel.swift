//
//  HomeModel.swift
//  SensorDataSend
//
//  Created by Ekaterina Ivanova on 08/02/16.
//  Copyright © 2016 Ekaterina Ivanova. All rights reserved.
//



import Foundation
import UIKit
import CoreMotion

public var LoginStatusChanged = "LoginStatusChanged"

public let HomeModelChangedNotification = "HomeModelChangedNotification"


class HomeSettingsModel:NSObject{
    
    var locationManager:LocationManager
    
    var notificationCenter = NotificationCenter.default
    
    var reachable:Bool{
        return ConnectionManager.sharedInstance.reachability!.isReachable
    }
    var celular:Bool{
        return !ConnectionManager.sharedInstance.reachability!.isReachableViaWiFi
    }
    
    
    fileprivate let sections = ["User data"]
    fileprivate var dataRows = ["User", "WIFI", "GPS: ", "Address: ", "City: ", "Country: ", "Cloud connection: ", "Local connection: ", "Subject: ", "Experiment: "]
    
    
    func getNumberOfSections()-> Int{
        return sections.count
    }
    
    func getNumberOfRowsInSection(_ section:Int)->Int{
        return dataRows.count
    }
    func getDataInRows(_ section:Int, row:Int)->String{
        switch(row){
        case 0:
            return  "\(GlobalVariables.loggedIn ? "\(GlobalVariables.email) (logged in)":"Offline")"
        case 1:
            return dataRows[1]
        case 6:
            return "Cloud connection: \(GlobalVariables.IP):\(GlobalVariables.port). \(GlobalVariables.cloudProtocol) "
        case 7:
            return "Local connection: \(GlobalVariables.IPlocal):\(GlobalVariables.Portlocal). \(GlobalVariables.LANProtocol) "
        case 8:
            return "Subject: \(String(describing: GlobalVariables.subjectReadable!))"
        case 9:
            return "Experiment: \(GlobalVariables.experimentReadable)"
        default:
            break
        }
        return dataRows[row]
    }
    
    
    func setFontOfRow(_ indexPath:IndexPath) -> NSArray{
        if (indexPath as NSIndexPath).section == 0 && (indexPath as NSIndexPath).row == 0{
            return [ Styles.linkFont!,
                     UIColor.blue]
        }else{
            return [Styles.smallFont!,
                    Styles.grayColor]
        }
    }
    
    func setupAccount(){
        
        dataRows[0] = "\(GlobalVariables.loggedIn ? "\(GlobalVariables.email) (logged in)":"(offline)")"
        setConnectionData()
    }
    
    func setupLocation() {
        locationManager.getPlaceName { (answer) -> Void in
            if answer.count == 4{
                
                self.dataRows[2] = "GPS: \(answer[0])"
                self.dataRows[3] = "Address: \(answer[1])"
                self.dataRows[4] = "City: \(answer[2])"
                self.dataRows[5] = "Country: \(answer[3])"
                self.notificationCenter.post(name: Notification.Name(rawValue: HomeModelChangedNotification), object:self)
                self.locationManager.stopObservingLocationChange()
                
            }
        }
    }
    
    
    
    func setConnectionData(){
        if reachable {
            
            if !(celular) {
                
                dataRows[1] = "Connection WiFi"
                
            } else {
                
                dataRows[1] = "Connection Cellular"
                
            }
            
        } else {
            
            dataRows[1] = "Connection NO"
            
        }
    }
    
    func reachabilityChanged(_ note: Notification) {
        
        setConnectionData()
        notificationCenter.post(name: Notification.Name(rawValue: HomeModelChangedNotification), object:self)
        
    }
    
    func locationChanged(_ note:Notification){
        
        setupLocation()
        notificationCenter.post(name: Notification.Name(rawValue: HomeModelChangedNotification), object:self)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override init() {
        
        locationManager = LocationManager()
        
        super.init()
        
        notificationCenter.addObserver(self, selector: #selector(HomeSettingsModel.reachabilityChanged(_:)), name: NSNotification.Name(rawValue: ConnectonChangedNotification), object: nil)
        
        
        notificationCenter.addObserver(self, selector: #selector(HomeSettingsModel.reachabilityChanged(_:)), name: NSNotification.Name(rawValue: LoginStatusChanged), object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(HomeSettingsModel.locationChanged(_:)), name: NSNotification.Name(rawValue: LocationChangedNotification), object: nil)
        self.setupLocation()
        
    }
    
}
