//
//  SubjectClient.swift
//  Sensors
//
//  Created by Ekaterina Ivanova on 17/04/2017.
//  Copyright © 2017 Ekaterina Ivanova. All rights reserved.
//

import Foundation

class SubjectClient{
    var api = ApiClent.init()
    
    func listSubjects(completion: @escaping (_ success: Bool, _ message: NSDictionary?) -> ()) {
        
        
        api.get(request: api.clientURLRequest(path: "subject")) { (success, object) -> () in
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
    
    func readSubject(id: Int, completion: @escaping (_ success: Bool, _ message: NSDictionary?) -> ()) {
        
        api.get(request: api.clientURLRequest(path: "subject/\(id.description)")) { (success, object) -> () in
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
    
    func createSubject(subject: NSDictionary, completion: @escaping (_ success: Bool, _ message: NSDictionary?) -> ()) {
        
        api.get(request: api.clientURLRequest(path: "subject", params: subject as? Dictionary<String, AnyObject>)) { (success, object) -> () in
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
