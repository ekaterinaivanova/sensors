//
//  File.swift
//  UDPClient
//
//  Created by Ekaterina Ivanova on 22/11/15.
//  Copyright © 2015 Ekaterina Ivanova. All rights reserved.
//

import Foundation
import CocoaAsyncSocket;

class Client: NSObject, GCDAsyncUdpSocketDelegate {
    
    var IP = String()
    var PORT = UInt16()
    
    var socket:GCDAsyncUdpSocket!
    
    override init(){
        
        super.init()
        setupConnection()
        
    }
    
    init(type: Int){
        
        super.init()
        if type == 0{
            IP = GlobalVariables.IPlocal
            PORT = UInt16(GlobalVariables.Portlocal)!
        }else{
            IP = GlobalVariables.IP
            PORT = UInt16(GlobalVariables.port)!
        }
        setupConnection()
        
    }
    
    fileprivate func checkSetups(){
        
        let lvPort =  UserDefaults.standard.string(forKey: "port")
        if lvPort == nil{
            
            UserDefaults.standard.set("8484", forKey: "port")
            
        }
        let lvIP =  UserDefaults.standard.string(forKey: "ip")
        if lvIP == nil{
            
            UserDefaults.standard.set("localhost", forKey: "ip")
            
        }
        
        let lvFrequency =  UserDefaults.standard.string(forKey: "frequency")
        if lvFrequency == nil{
            
            UserDefaults.standard.set(0.1, forKey: "frequency")
            
        }
        UserDefaults.standard.synchronize()
        IP = UserDefaults.standard.string(forKey: "ip")!
        PORT =  UInt16(UserDefaults.standard.string(forKey: "port")!)!
        
    }
    
    func setupConnection(){
        //        checkSetups()
        socket = GCDAsyncUdpSocket(delegate: self, delegateQueue: DispatchQueue.main)
        do{
            try socket.connect(toHost: IP, onPort: PORT)
        }catch{
            print("Something went wrong at setup connection")
        }
    }
    
    
    func send(_ message:NSDictionary){
        
        do {
            
            print(socket.isConnected())
            let jsonData = try JSONSerialization.data(withJSONObject: message, options: JSONSerialization.WritingOptions.prettyPrinted)
            socket.send(jsonData, withTimeout: 2, tag: 0)
            
        } catch let error as NSError {
            print(error)
        }
        
    }
    
    func sendString(_ message:String){
        
        let data = message.data(using: String.Encoding.utf8)
        socket.send(data!, withTimeout: 2, tag: 0)
        
    }
    
    func udpSocket(_ sock: GCDAsyncUdpSocket, didConnectToAddress address: Data) {
        print("udpSocket didConnectToAddress");
    }
    
    func udpSocket(_ sock: GCDAsyncUdpSocket, didNotConnect error: Error?) {
        print("udpSocket didNotConnect \(String(describing: error))")
    }
    
    func udpSocket(_ sock: GCDAsyncUdpSocket, didSendDataWithTag tag: Int) {
        //        print("didSendDataWithTag")
    }
    
    func udpSocket(_ sock: GCDAsyncUdpSocket, didNotSendDataWithTag tag: Int, dueToError error: Error?) {
        print("udpSocket didNotSendDataWithTag: \(String(describing: error))")
    }
}
