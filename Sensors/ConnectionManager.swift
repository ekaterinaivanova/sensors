//
//  ConnectionManager.swift
//  SensorDataSend
//
//  Created by Ekaterina Ivanova on 31/03/16.
//  Copyright © 2016 Ekaterina Ivanova. All rights reserved.
//

import Foundation
import Reachability

public let ConnectonChangedNotification = "ConnectonChangedNotification"

class ConnectionManager{
    
    static let sharedInstance = ConnectionManager()
    
    var reachability: Reachability?
    
    func setupReachability(){

        reachability =  Reachability()
        
        do{
            try reachability!.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
        
    }
    
    //    func setConnectionData(){
    //        if reachability!.isReachable() {
    ////            reachable = true
    //
    //            if reachability!.isReachableViaWiFi() {
    ////                gvData[1] = "Connection WiFi"
    ////                celular = false
    //                                print("Reachable via WiFi")
    //            } else {
    ////                gvData[1] = "Connection Cellular"
    ////                celular = true
    //                                print("Reachable via Cellular")
    //            }
    //        } else {
    ////            celular = false
    ////            reachable = false
    ////            gvData[1] = "Connection NO"
    //
    //                        print("Not reachable")
    //        }
    //    }
    @objc func change(_ note: Notification){
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: ConnectonChangedNotification), object:self)
        
        print("Connection was changed")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    init(){
        
        setupReachability()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.change(_:)), name: ReachabilityChangedNotification, object: reachability)

    }
}
