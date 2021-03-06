//
//  ClientApi.swift
//  Sensors
//
//  Created by Ekaterina Ivanova on 09/04/2017.
//  Copyright © 2017 Ekaterina Ivanova. All rights reserved.
//

import Foundation

class ApiClent {
    
    
    func clientURLRequest(path: String, params: Dictionary<String, AnyObject>? = nil) -> NSMutableURLRequest {
        let ip = GlobalVariables.IP
        let port = GlobalVariables.port
        
        let url = "http://" + ip + ":" + port + "/"
        let request = NSMutableURLRequest(url: NSURL(string: url + path)! as URL)
        print(path)
        if let params = params {
            var paramString = ""
            for (key, value) in params {
                let escapedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                let escapedValue = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                paramString += "\(String(describing: escapedKey!))=\(String(describing: escapedValue!))&"
            }
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpBody = paramString.data(using: String.Encoding.utf8)
        }
        
        
        return request
    }
    
    func post(request: NSMutableURLRequest, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        dataTask(request: request, method: "POST", completion: completion)
    }
    
    func put(request: NSMutableURLRequest, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        print(request)
        dataTask(request: request, method: "PUT", completion: completion)
    }
    
    func get(request: NSMutableURLRequest, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        dataTask(request: request, method: "GET", completion: completion)
    }
    
    func delete(request: NSMutableURLRequest, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        dataTask(request: request, method: "delete", completion: completion)
    }
    
    private func dataTask(request: NSMutableURLRequest, method: String, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        request.httpMethod = method
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
                    completion(true, json as AnyObject)
                } else {
                    completion(false, json as AnyObject)
                }
            }
            }.resume()
    }

}
