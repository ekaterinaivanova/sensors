//
//  TCPClient.swift
//  SensorDataSend
//
//  Created by Ekaterina Ivanova on 17/08/16.
//  Copyright © 2016 Ekaterina Ivanova. All rights reserved.
//

import Foundation
import CocoaAsyncSocket;

class TCPClient: NSObject, GCDAsyncSocketDelegate {
    
    var IP = String()
    var PORT = UInt16()
    var socket: GCDAsyncSocket!
    
    override init() {
        super.init()
    }
    
    init(type: Int){
        
        super.init()
        if type == 0{
            IP = GlobalVariables.IPlocal
            PORT = UInt16(GlobalVariables.Portlocal)!
        }else{
            IP = GlobalVariables.IP
            PORT = 8888
        }
    }
    
    func sendString(_ message:String){
        
        let message1 = "\(message)\n"
        let data = message1.data(using: String.Encoding.utf8)
        if socket == nil || socket.isDisconnected{
            setupConnection()
            
        }
        socket.write(data!, withTimeout: 5, tag: 0)
    }
    
    func send(_ message:NSDictionary){
        if self.socket == nil || self.socket.isDisconnected{
            setupConnection()
        }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: message, options: JSONSerialization.WritingOptions.prettyPrinted)
            self.socket.write(jsonData, withTimeout: 5, tag: 1)
        } catch let error as NSError {
            print(error)
        }
        
    }
    
    func setupConnection(){
        self.socket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.global(qos: DispatchQoS.QoSClass.default))
        do{
            
            print("TCP is trying to connect to \(IP):\(PORT)")
            try self.socket.connect(toHost: IP, onPort: PORT)
            
        }catch let error as NSError{
            
            print("Something went wrong at setup TCP connection Error: \(error)")
        }
        
    }
    
    func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
//        print("TCP didWriteDataWithTag \(tag)")
    }
    
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        print("TCP didConnectToHost \(host) \(port)")
    }
    
    func disconnect(){
        if self.socket.isConnected && socket != nil{
            self.socket.disconnect()
        }
        
    }
    
}
