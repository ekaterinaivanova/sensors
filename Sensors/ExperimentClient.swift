//
//  SubjectApi.swift
//  Sensors
//
//  Created by Ekaterina Ivanova on 17/04/2017.
//  Copyright © 2017 Ekaterina Ivanova. All rights reserved.
//

import Foundation

class ExperimentClient{
    var api = ApiClent.init()

    func listExperiments(completion: @escaping (_ success: Bool, _ message: NSDictionary?) -> ()) {
        
        
        api.get(request: api.clientURLRequest(path: "experiments")) { (success, object) -> () in
            DispatchQueue.main.async(execute: { () -> Void in
                if success {
                    
                    completion(success, object as? NSDictionary )
                    
                } else {
                    //                    TODO HANDLE ERRORS
                    completion(false, object as? NSDictionary)
                    
                }
            })
        }
    }
    
    func readExperiment(id: Int, completion: @escaping (_ success: Bool, _ message: NSDictionary?) -> ()) {
        
        api.get(request: api.clientURLRequest(path: "experiments/\(id.description)")) { (success, object) -> () in
            DispatchQueue.main.async(execute: { () -> Void in

                if success {
                    completion(success, object as? NSDictionary )
                    
                } else {
                    //                    TODO HANDLE ERRORS
                    completion(false, object as? NSDictionary)
                    
                }
            })
        }
    }

}
