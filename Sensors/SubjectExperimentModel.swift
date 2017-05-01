//
//  SubjectExperimentModel.swift
//  Sensors
//
//  Created by Ekaterina Ivanova on 17/04/2017.
//  Copyright © 2017 Ekaterina Ivanova. All rights reserved.
//

import Foundation

class SubjectExperimentModel{
    
    var experimentclient = ExperimentClient()
    var subjectClient = SubjectClient()
    
    
    func listExperiments(completion: @escaping(_ result: [[String : AnyObject]]) -> ()){
        
        experimentclient.listExperiments(completion: {(success, message) in
            if success{
                if let dictionnary : NSDictionary = message {
                    let newDictData = dictionnary.object(forKey: "data")
                    if let array = newDictData as?  [[String : AnyObject]]  {
                        completion(array)
                    }
                }
            }
        })
        
    }
    func listSubjects(completion: @escaping(_ result: [[String : AnyObject]]) -> ()){
        
        subjectClient.listSubjects(completion: {(success, message) in
            if success{
                if let dictionnary : NSDictionary = message {
                    let newDictData = dictionnary.object(forKey: "data")
                    if let array = newDictData as?  [[String : AnyObject]]  {
                        completion(array)
                    }
                }
            }
        })
        
    }
    
    
    func getTitle(indexPath: IndexPath) -> String{
        switch indexPath.row {
        case 0:
            return  "Subject"
        case 1:
            return "Experiment"
        default:
            return ""
            
        }
    }
    
    func getDetails(indexPath: IndexPath, completion: @escaping (_ result: String) -> ()) {
        switch indexPath.row {
        case 0:
            if(GlobalVariables.subject != nil){

                subjectClient.readSubject(id: GlobalVariables.subject!, completion: { (success, data) in
                    if let dictionnary : NSDictionary = data {

                        let newDictData = dictionnary.object(forKey: "data")
                        
                        if let array = newDictData as?  [[String : AnyObject]]  {
                            if(array.count > 0){
                                let dataDict = array[0]

                                var name = (dataDict as NSDictionary).object(forKey: "FirstName")
                                let lastname = (dataDict as NSDictionary).object(forKey: "LastName")
                                if  name != nil{
                                    name = "\(String(describing: name!)) \(String(describing: lastname!))"
                                    
                                    GlobalVariables.subjectReadable = name as? String
                                    completion(name as! String)
                                }else{
                                    
                                    GlobalVariables.subjectReadable = "Unknown"
                                    completion("Unknown")
                                    
                                }
                            }else{
                                
                                GlobalVariables.subjectReadable = "Unknown"
                                completion("Unknown")
                                
                            }
                            
                        }else{
                            
                            GlobalVariables.subjectReadable = "Unknown"
                            completion("Unknown")
                            
                        }
                        
                    }else{
                        GlobalVariables.subjectReadable = "Unknown"
                        completion("Unknown")
                    }
                    
                    
                })
            }else{
                GlobalVariables.subjectReadable = "None"
                completion("None")
            }
            break;
        case 1:
           
            experimentclient.readExperiment(id: GlobalVariables.experiment, completion: { (success, data) in
                if let dictionnary : NSDictionary = data {

                    let newDictData = dictionnary.object(forKey: "data")
                    
                    if let array = newDictData as?  [[String : AnyObject]]  {
                        if(array.count > 0){
                            
                            let dataDict = array[0]
                            
                            let name = (dataDict as NSDictionary).object(forKey: "Name")
                            if  name != nil{
                                
                                GlobalVariables.experimentReadable = name as! String;
                                completion(name as! String)
                                
                            }else{
                                
                                GlobalVariables.experimentReadable = "Unknown"
                                completion("Unknown")
                                
                            }
                        }else{
                            
                            GlobalVariables.experimentReadable = "Unknown"
                            completion("Unknown")
                            
                        }
                      
                    }else{
                        
                        GlobalVariables.experimentReadable = "Unknown"
                        completion("Unknown")
                        
                    }
                    
                }else{
                    
                    GlobalVariables.experimentReadable = "Unknown"
                    completion("Unknown")
                }
                
            })

            break
        default:
            completion("Unknown")
        }
    }
}
