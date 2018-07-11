//
//  SubjectExperementDetailsViewController.swift
//  Sensors
//
//  Created by Ekaterina Ivanova on 17/04/2017.
//  Copyright © 2017 Ekaterina Ivanova. All rights reserved.
//

import UIKit

class SubjectExperementDetailsViewController: UIViewController {
    
    var settingType = Int()
    var model = SubjectExperimentModel()
    var data: [[String : AnyObject]] = []
    

    @IBOutlet weak var tableView: UITableView!
    

    func getTitle(row:Int) -> String{
        
        let object = self.data[row]
        
        switch(settingType){
        case 0:
            let name = (object as NSDictionary).object(forKey: "FirstName") as! String
            let lastname = (object as NSDictionary).object(forKey: "LastName") as! String

            return name + "" + lastname
        case 1:
            let name = (object as NSDictionary).object(forKey: "Name") as! String
            return name
        default:
            return ""
        }
        
    }
    
    func getDescription(row:Int) -> String{
        
        let object = self.data[row]
        switch(settingType){
        case 0:
            let remark = (object as NSDictionary).object(forKey: "Remark") as! String
            return remark
            
        case 1:
            let description = (object as NSDictionary).object(forKey: "Description") as! String
            return description
        default:
            return ""
        }
        
    }
    
    func isSelected(row:Int) -> Bool{

        switch(settingType){
        case 0:
            if let dictionnary = data[row] as NSDictionary?  {
                let ID = dictionnary.object(forKey: "ID") as! Int
                return GlobalVariables.subject == ID
            }
         
            break
        case 1:
            if let dictionnary = data[row] as NSDictionary?  {
                let ID = dictionnary.object(forKey: "ID") as! Int
                return GlobalVariables.experiment == ID
            }
            return false
        default:
            break
        }
        return false
    }
    
    func setSelected(row:Int){
        switch settingType {
        case 0:
            if let dictionnary = data[row] as NSDictionary?  {
                let ID = dictionnary.object(forKey: "ID") as! Int
                GlobalVariables.subject = ID
            }
            break;
        case 1:
            if let dictionnary = data[row] as NSDictionary?  {
                let ID = dictionnary.object(forKey: "ID") as! Int
                GlobalVariables.experiment = ID
            }
            break;
        default:
            break;
        }
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        print("Device", UIDevice.current.modelName)

        switch settingType {
        case 0:
            model.listSubjects(completion: { (result) in

                self.data = result;
                
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                }
            })

            break
        case 1:
            model.listExperiments(completion: { (result) in
                self.data = result;
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                }
            })
            break
        default:
            break
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.register(UINib(nibName: "DescriptionSelectCell", bundle: nil), forCellReuseIdentifier: "descriptionSelect")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension SubjectExperementDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows

        return self.data.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "descriptionSelect", for: indexPath) as! DescriptionSelectCell
        
        if isSelected(row: indexPath.row){
            cell.accessoryType = .checkmark
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableViewScrollPosition.bottom)
        } else {
            cell.accessoryType = .none
        }
    
        cell.cellTitle.text = getTitle(row: indexPath.row)
        
        cell.cellDescription.text = getDescription(row: indexPath.row)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0

    }
    
    private func tableView (tableView:UITableView , heightForHeaderInSection section:Int)->Float
    {

        return 0.0
    }

    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.reloadData()
        setSelected(row: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: false)

        
        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .checkmark
    }
    
    private func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: NSIndexPath) {
//        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .none
    }
    
    
}

extension SubjectExperementDetailsViewController: UITableViewDelegate {

}


public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}

