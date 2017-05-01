//
//  Globals.swift
//  Sensors
//
//  Created by Ekaterina Ivanova on 17/04/2017.
//  Copyright © 2017 Ekaterina Ivanova. All rights reserved.
//

import Foundation

struct GlobalVariables {
    
    static var coordinates = String()
    
    static var sessionID = Int()
    
    static var MIN_SLIDER_VALUE:Float{ return 0.001 }
    
    static var MAX_SLIDER_VALUE:Float { return  1 }
    
    static var experiment:Int{
        get{
            if let temp = UserDefaults.standard.integer(forKey: "experiment") as Int!{
                
                return temp
            }else{
                UserDefaults.standard.set(1, forKey: "experiment")
                return 1
            }
        }
        set{
            
            UserDefaults.standard.set(newValue, forKey: "experiment")
    
            UserDefaults.standard.synchronize()
        }
    }
    
    static var experimentReadable:String{
        get{
            if let temp = UserDefaults.standard.string(forKey: "experimentReadable") as String!{
                
                return temp
            }else{
                UserDefaults.standard.set("Unknown", forKey: "experimentReadable")
                return "Unknown"
            }
        }
        set{
            
            UserDefaults.standard.set(newValue, forKey: "experimentReadable")
            
            UserDefaults.standard.synchronize()
        }
    }
    
    static var subject:Int?{
        get{
            let temp = UserDefaults.standard.integer(forKey: "subject")
                
            return temp
          
        }
        set{
            
            UserDefaults.standard.set(newValue, forKey: "subject")
            
            UserDefaults.standard.synchronize()
        }
    }
    
    static var subjectReadable:String?{
        get{
            let temp = UserDefaults.standard.string(forKey: "subjectReadable")
            
            return temp
            
        }
        set{
            
            UserDefaults.standard.set(newValue, forKey: "subjectReadable")
            
            UserDefaults.standard.synchronize()
        }
    }
    
    static var speed:Double{
        get{
            if let temp = UserDefaults.standard.double(forKey: "frequency") as Double!{
           
                return temp
            }else{
                UserDefaults.standard.set(0.001, forKey: "frequency")
                return 0.001
            }
        }
        set{
            
            UserDefaults.standard.set(newValue, forKey: "frequency")
            
            UserDefaults.standard.synchronize()
        }
    }
    
    static var sliderPosition:Float{
        get{
            if let temp = UserDefaults.standard.float(forKey: "sliderPos") as Float!{
                return temp
            }else{
                UserDefaults.standard.set(0, forKey: "sliderPos")
                return 0
            }
        }
        set{
            
            UserDefaults.standard.set(newValue, forKey: "sliderPos")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var IP:String{
        get{
            if let temp = UserDefaults.standard.string(forKey: "ip"){
                return temp
            }else{
                UserDefaults.standard.setValue("localhost", forKey: "ip")
                return "localhost"
            }
        }
        set{
            UserDefaults.standard.setValue("\(newValue)", forKey: "ip")
        }
    }
    static var port:String{
        get{
            if let temp = UserDefaults.standard.string(forKey: "port") {
                return temp
            }else{
                UserDefaults.standard.setValue("8484", forKey: "port")
                return "8484"
            }
        }
        set{
            UserDefaults.standard.setValue("\(newValue)", forKey: "port")
        }
    }
    
    static var cloudProtocol:String{
        get{
            if let temp = UserDefaults.standard.string(forKey: "cloudProtocol") {
                return temp
            }else{
                UserDefaults.standard.setValue("UDP", forKey: "cloudProtocol")
                return "UDP"
            }
        }
        set{
            UserDefaults.standard.setValue("\(newValue)", forKey: "cloudProtocol")
        }
    }
    static var LANProtocol:String{
        get{
            if let temp = UserDefaults.standard.string(forKey: "LANProtocol") {
                return temp
            }else{
                UserDefaults.standard.setValue("UDP", forKey: "LANProtocol")
                return "UDP"
            }
        }
        set{
            UserDefaults.standard.setValue("\(newValue)", forKey: "LANProtocol")
        }
    }
    static var IPlocal:String{
        get{
            if let temp = UserDefaults.standard.string(forKey: "iplocal"){
                return temp
            }else{
                UserDefaults.standard.setValue("localhost", forKey: "iplocal")
                return "localhost"
            }
        }
        set{
            UserDefaults.standard.setValue("\(newValue)", forKey: "iplocal")
        }
    }
    static var Portlocal:String{
        get{
            if let temp = UserDefaults.standard.string(forKey: "portlocal") {
                return temp
            }else{
                UserDefaults.standard.setValue("8484", forKey: "portlocal")
                return "8484"
            }
        }
        set{
            UserDefaults.standard.setValue("\(newValue)", forKey: "portlocal")
        }
    }
    
    static var userName:String{
        get{
            
            if let lvTempName:String = UserDefaults.standard
                .string(forKey: "userName") as String! {
                return lvTempName
            }
            return ""
        }
        set{
            UserDefaults.standard.setValue(newValue, forKey: "userName")
            UserDefaults.standard.synchronize()
        }
    }
    static var lastName:String {
        get{
            if let lvTempLastname:String = UserDefaults.standard
                .string(forKey: "userLastname") as String!{
                return lvTempLastname
            }
            return ""
        }
        set{
            UserDefaults.standard.setValue(newValue, forKey: "userLastname")
            UserDefaults.standard.synchronize()
        }
    }
    static var email:String{
        get{
            if let lvTempEmail:String = UserDefaults.standard
                .string(forKey: "userEmail") as String!{
                return lvTempEmail
            }
            
            return ""
        }
        set{
            UserDefaults.standard.setValue(newValue, forKey: "userEmail")
            UserDefaults.standard.synchronize()
        }
    }
    static var password:String
    {
        get{
            if let lvTempPwd:String = UserDefaults.standard
                .string(forKey: "userPassword") as String!{
                return lvTempPwd
            }
            return ""
        }
        set{
            UserDefaults.standard.setValue(newValue, forKey: "userPassword")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var loggedIn:Bool{
        get{
            if  GlobalVariables.sessionID == 0{
                return false
            }
            if let lvTemp =  UserDefaults.standard.bool(forKey: "isUserLoggedIn") as Bool? {
                return lvTemp
            }
            UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
            UserDefaults.standard.synchronize()
            return false
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "isUserLoggedIn")
        }
    }
    
    static var maxGraphPoints:Int{
        get{
            return 100
        }
        
    }
    
    
}
