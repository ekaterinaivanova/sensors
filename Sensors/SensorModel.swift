//
//  SensorsModel.swift
//  SensorDataSend
//
//  Created by Ekaterina Ivanova on 24/10/15.
//  Copyright © 2015 Ekaterina Ivanova. All rights reserved.
//

import Foundation
import UIKit

class SensorModel{
    var sensors:[String] = [
        "Acceleration",
        "Rotation",
        "Gravity",
        "Magnetometer",
        "RawAcceleration"
    ]
    
    struct SensorData {
        var name:String
        var willSend:Bool
        var speed:Double
        var data: [[Double]]
    }
    
    var sendingStatus = 0
    
    var maxPoints = GlobalVariables.maxGraphPoints;
    
    var maxValues:[Double] = [2, 7, 1.1, 100, 2]
    
    var graphPoints: [[Points]] = [[ Points(x: 0, y: 0, z: 0)],[ Points(x: 0, y: 0, z: 0)],[ Points(x: 0, y: 0, z: 0)],[ Points(x: 0, y: 0, z: 0)],[ Points(x: 0, y: 0, z: 0)]]
    
    var sendingText:String{
        var temp = [NSLocalizedString("Send", tableName: "Localized", comment: ""), NSLocalizedString("Stop", tableName: "Localized", comment: "")]
        return temp[sendingStatus]
    }
    
    var backgroubdColor:UIColor{
        var temp = [UIColor(red: 0x2A/255, green: 0xBB/255, blue: 0x1A/255, alpha: 1.0), UIColor.red]
        return temp[sendingStatus]
    }
    var segmentedContrColor:UIColor{
        var temp = [UIColor(red: 0x2A/255, green: 0xBB/255, blue: 0x1A/255, alpha: 1.0),UIColor( red: 0x2A/255, green: 0xBB/255, blue: 0x1A/255, alpha: 0.8)]
        
        let odg = temp[sendingStatus]
        return odg
        
    }
    
    func addRawAcc(_ data:[Double]){
        if graphPoints[sensors.count - 1].count >= maxPoints{
            graphPoints[sensors.count - 1] = Array(graphPoints[sensors.count - 1].dropFirst())
        }
        graphPoints[sensors.count - 1].append(Points(x: data[0], y: data[1], z: data[2]))
        
    }
    func dropDeviceMotionData(){
        for index in 0 ..< sensors.count - 1{
            graphPoints[index].removeAll(keepingCapacity: false)
        }
    }
    
    func addPoint(_ data: [[Double]]){
        for index in 0 ..< sensors.count - 1{ //without raw acc
            if graphPoints[index].count >= maxPoints {
                graphPoints[index] = Array(graphPoints[index].dropFirst())
            }
            graphPoints[index].append(Points(x: data[index][0], y: data[index][1], z: data[index][2]))
            
        }
    }
    
    fileprivate var sensorsData:[SensorData]
    
    
    
    func getIndexOf(_ name:String)->Int{
        return sensors.index(of: name)!
    }
    
    func getSensorsModel()-> [SensorData]{
        return sensorsData
    }
    func getName(_ row:Int)->String{
        return sensorsData[row].name
    }
    
    func setWillSend(_ row:Int,send:Bool){
        sensorsData[row].willSend = send
    }
    
    func getWillSend(_ row:Int)->Bool{
        return sensorsData[row].willSend
    }
    
    
    func getSpeed(_ row:Int)->Double{
        
        if let temp = UserDefaults.standard.double(forKey: "frequency") as Double?{
            return temp
        }else{
            UserDefaults.standard.set(0.5, forKey: "frequency")
            return 0.5
        }
        
    }
    func getSize()->Int{
        return sensorsData.count
    }
    
    func getData(_ row:Int)->[[Double]]{
        return sensorsData[row].data
    }
    
    init() {
        sensorsData = []
        for sensorName in sensors{
            sensorsData.append(SensorData(name: sensorName, willSend: true, speed: 0.1, data:[[0],[0],[0]]))
            
        }
    }
    
    
}
