//
//  MeasurementClient.swift
//  Sensors
//
//  Created by Ekaterina Ivanova on 24/07/2018.
//  Copyright © 2018 Ekaterina Ivanova. All rights reserved.
//

import Foundation
class MeasurementClient {
    var api = ApiClent.init()
    
    func updateMeasurement(completion: @escaping (_ success: Bool, _ message: NSDictionary?) -> ()) {
        let measurementObject: Dictionary = ["Active": "0"] as [String : String]
        api.put(request: api.clientURLRequest(path: "measurements/" + "\(GlobalVariables.MeasurementID)", params: measurementObject as Dictionary<String, AnyObject>)) { (success, result) in
            completion(success, result as? NSDictionary)

        }
    }
    func createMeasurement(completion: @escaping (_ success: Bool, _ message: NSDictionary?) -> ()) {
        var coordinates = GlobalVariables.coordinates.split(separator: " ")
        let measurementObject: Dictionary = ["ExperimentID": "\(GlobalVariables.experiment)", "UserLoginID": String(describing: GlobalVariables.loginID!), "SubjectID": String(describing: GlobalVariables.subject!), "MeasurementDate": "\(Int64(Date().timeIntervalSince1970 * 1000))", "Latitude": coordinates[0], "Longitude": coordinates[1], "Address": GlobalVariables.address] as [String : AnyObject]
        api.post(request: api.clientURLRequest(path: "measurements", params: measurementObject)) { (success, object) -> () in
            DispatchQueue.main.async(execute: { () -> Void in
                if success {
                    if let _ : NSDictionary = object as? NSDictionary {
                        completion(true, object as? NSDictionary)
                    } else {
                        completion(false, object as? NSDictionary)
                    }
                } else {
                    //  TODO HANDLE ERRORS
                    completion(false, object as? NSDictionary)
                }
            })
        }
    }
}
