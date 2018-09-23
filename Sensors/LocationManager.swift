//
//  LocationManager.swift
//  SensorDataSend
//
//  Created by Ekaterina Ivanova on 12/02/16.
//  Copyright © 2016 Ekaterina Ivanova. All rights reserved.
//

import Foundation
import CoreMotion
import CoreLocation

public let LocationChangedNotification = "LocationChangedNotification"


class LocationManager:NSObject, CLLocationManagerDelegate{
    
    var locationManager:CLLocationManager
    var startLocation: CLLocation!
    
    func coordinatesToString(_ latitude:Double, longitude:Double) -> String {
        GlobalVariables.coordinates = "\(latitude) \(longitude)"
        var latSeconds = Int(latitude * 3600)
        let latDegrees = latSeconds / 3600
        latSeconds = abs(latSeconds % 3600)
        let lvLatMinutes = latSeconds / 60
        latSeconds %= 60
        var longSeconds = Int(longitude * 3600)
        let longDegrees = longSeconds / 3600
        longSeconds = abs(longSeconds % 3600)
        let lvLongMinutes = longSeconds / 60
        longSeconds %= 60
        return String(format:"%d°%d'%d\"%@ %d°%d'%d\"%@", abs(latDegrees), lvLatMinutes, latSeconds,
                      {
                        return latDegrees >= 0 ? "N" : "S"
        }(),
                      abs(longDegrees), lvLongMinutes, longSeconds,
                      {
                        return longDegrees >= 0 ? "E" : "W"
        }()
        )
    }
    
    func stopObservingLocationChange(){
        
        locationManager.stopUpdatingLocation()
        
    }
    
    func displayLocationInfo2(_ placemark: CLPlacemark?) -> [String:String]{
        
        var lvLocationData = [String:String]()
        
        let lvCoordinates = coordinatesToString((locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
        
        lvLocationData["coordinates"] = lvCoordinates
        
        if let containsPlacemark = placemark{
            
            if let lvAddressDict = containsPlacemark.addressDictionary as? NSDictionary{
                
                if let lvStreet = lvAddressDict["FormattedAddressLines"] as? [String] {
                    
                    lvLocationData["street"] = "\(lvStreet[0])"
                    
                }
                
            }
            
            if let lvPostalCode = containsPlacemark.postalCode as? String{
                
                if let lvAdministrativeArea = containsPlacemark.administrativeArea as? String{
                    
                    lvLocationData["city"] = "\(lvPostalCode) \(lvAdministrativeArea)"
                    
                }
                
            }
            if let lvCountry = containsPlacemark.country as String!{
                
                lvLocationData["country"] = "\(lvCountry)"
                
            }

        }
        return lvLocationData
        
    }
    
    func displayLocationInfo(_ placemark: CLPlacemark?) -> [String]{
        
        var lvLocationData:[String] = []
        let lvCoordinates = coordinatesToString((locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
        lvLocationData.append(lvCoordinates)
        
        if let containsPlacemark = placemark{
            
            if let lvAddressDict = containsPlacemark.addressDictionary as NSDictionary!{
                
                if let lvStreet = lvAddressDict["FormattedAddressLines"] as? [String] {
                    
                    lvLocationData.append("\(lvStreet[0])")

                }
                
            }
            
            if let lvPostalCode = containsPlacemark.postalCode as String!{
                
                if let lvAdministrativeArea = containsPlacemark.administrativeArea as String!{
                    
                    lvLocationData.append("\(lvPostalCode) \(lvAdministrativeArea)")

                }
                
            }
            if let lvCountry = containsPlacemark.country as String!{
                
                lvLocationData.append(lvCountry)
                
            }

            return lvLocationData
            
        } else {
            
            return [""]
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: LocationChangedNotification), object:self)
        
    }
    
    func getPlaceName(_ completion: @escaping (_ answer: [String]) -> Void) {
        
        let lvCoordinates = locationManager.location?.coordinate
        
        if lvCoordinates != nil {
            
            let coordinates = CLLocation(latitude: (lvCoordinates?.latitude)!, longitude: (lvCoordinates?.longitude)!)
            
            CLGeocoder().reverseGeocodeLocation(coordinates, completionHandler: {(placemarks, error) -> Void in
                
                if (error != nil) {
                    
                    print("Reverse geocoder failed with an error" + error!.localizedDescription)
                    completion([""])
                    
                } else if placemarks!.count > 0 {
                    
                    let pm = placemarks![0] as CLPlacemark
                    completion(self.displayLocationInfo(pm))
                    
                } else {
                    
                    print("Problems with the data received from geocoder.")
                    completion([""])
                    
                }
                
            })
            
        }
        
    }
    
    func setupLocation(){
        
        locationManager = CLLocationManager()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.startUpdatingLocation()
        startLocation = nil
        
    }
    
    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        
        self.setupLocation()
        
    }
    
}
