
//
//  SettingsViewController.swift
//  Sensors
//
//  Created by Ekaterina Ivanova on 02/09/2017.
//  Copyright © 2017 Ekaterina Ivanova. All rights reserved.
//

import UIKit

public let LocalConnectionChangedNotification = "LocalConnectionChangedNotification"
public let CloudConnectionChangedNotification = "CloudConnectionChangedNotification"

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CustomCellDelegate {
 
    @IBOutlet weak var tblExpandable: UITableView!
    var cellDescriptors: NSMutableArray!
    var visibleRowsPerSection = [[Int]]()
//    var datypes = DataTpeModel()
    
    func textfieldTextWasChanged(_ newText: String, parentCell: CustomCell) {
        let parentCellIndexPath = tblExpandable.indexPath(for: parentCell)
        if (parentCellIndexPath as NSIndexPath?)?.section == 0{
            if (parentCellIndexPath as NSIndexPath?)?.row == 1 {
                GlobalVariables.IP = newText
            }
            else {
                GlobalVariables.port = newText
            }
            ((cellDescriptors[0] as! NSMutableArray)[0] as AnyObject).setValue("\(GlobalVariables.IP): \(GlobalVariables.port)", forKey: "primaryTitle")
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: CloudConnectionChangedNotification), object:self)
        }else if (parentCellIndexPath as NSIndexPath?)?.section == 1{
            
            if (parentCellIndexPath as NSIndexPath?)?.row == 1 {
                GlobalVariables.IPlocal = newText
            }
            else {
                GlobalVariables.Portlocal = newText
            }
            ((cellDescriptors[1] as! NSMutableArray)[0] as AnyObject).setValue("\(GlobalVariables.IPlocal): \(GlobalVariables.Portlocal)", forKey: "primaryTitle")
            NotificationCenter.default.post(name: Notification.Name(rawValue: LocalConnectionChangedNotification), object:self)
        }else{
            if let newSpeed = Double(newText){
                ((cellDescriptors[2] as! NSMutableArray)[0] as AnyObject).setValue("\(newSpeed)", forKey: "primaryTitle")
                ((cellDescriptors[2] as! NSMutableArray)[0] as AnyObject).setValue("\(newSpeed)", forKey: "value")
                GlobalVariables.speed = newSpeed
            }
            
            //            tblExpandable.reloadSections(NSIndexSet(index: 3) as IndexSet, with: UITableViewRowAnimation.none)
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: LocalConnectionChangedNotification), object:self)
        
        tblExpandable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentCellDescriptor = getCellDescriptorForIndexPath(indexPath)
        
        switch currentCellDescriptor["cellIdentifier"] as! String {
        case "idCellNormal":
            return 60.0
        case "idCellDatePicker":
            return 270.0
        case "idCellTextfield":
            return 50.0
        default:
            return 44.0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleRowsPerSection[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Cloud connection"
        case 1:
            return "Local connection"
        case 2:
            return "Sampling interval"
        case 3:
            return "Account"
        default:
            return ""
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentCellDescriptor = getCellDescriptorForIndexPath(indexPath)
        let identifier = currentCellDescriptor["cellIdentifier"] as! String
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) 
        if currentCellDescriptor["cellIdentifier"] as! String == "normalCell" {
            
            if let primaryTitle = currentCellDescriptor["primaryTitle"] {
                (cell as! NormalCell).textLabel!.text = primaryTitle as? String
            }
            
            if let secondaryTitle = currentCellDescriptor["secondaryTitle"] {
                (cell as! NormalCell).detailTextLabel?.text = secondaryTitle as? String
            }
        }
        else if currentCellDescriptor["cellIdentifier"] as! String == "idCellTextfield" {
            
            
            if currentCellDescriptor["itemID"] as! String == "IP"{
                (cell as! CustomCell).textField.text = GlobalVariables.IP
            }else if currentCellDescriptor["itemID"] as! String == "PORT"{
                 (cell as! CustomCell).textField.text = GlobalVariables.port
            }else if currentCellDescriptor["itemID"] as! String == "PORTlocal"{
                 (cell as! CustomCell).textField.text = GlobalVariables.Portlocal
            }else if currentCellDescriptor["itemID"] as! String == "IPlocal"{
                 (cell as! CustomCell).textField.text = GlobalVariables.IPlocal
            }else if currentCellDescriptor["itemID"] as! String == "speedSlider"{
                //                cell.textField.keyboardType = UIKeyboardType.NumberPad
                 (cell as! CustomCell).textField.text = "\(GlobalVariables.speed)"
            }
            (cell as! CustomCell).ncTextLabel.text = currentCellDescriptor["primaryTitle"] as? String
            (cell as! CustomCell).delegate = self

        }
//        else if currentCellDescriptor["cellIdentifier"] as! String == "idCellSwitch" {
//            cell.lblSwitchLabel.text = currentCellDescriptor["primaryTitle"] as? String
//
//            let value = currentCellDescriptor["value"] as? String
//            cell.swSwitchStatus.isOn = (value == "true") ? true : false
//        }
        else if currentCellDescriptor["cellIdentifier"] as! String == "idCellValuePicker" {
            cell.textLabel?.text = currentCellDescriptor["primaryTitle"] as? String
        }
//        else if currentCellDescriptor["cellIdentifier"] as! String == "idCellSlider" {
//            cell.slSamplingInterval.value = GlobalVariables.sliderPosition
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexOfTappedRow = visibleRowsPerSection[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        let checkCell = ((cellDescriptors[indexPath.section]as! NSMutableArray)[indexOfTappedRow] as AnyObject)
        if checkCell["isExpandable"] as! Bool == true {
            var shouldExpandAndShowSubRows = false
            if checkCell["isExpanded"] as! Bool == false {
                shouldExpandAndShowSubRows = true
            }

            ((cellDescriptors[indexPath.section] as! NSMutableArray)[indexOfTappedRow] as AnyObject).setValue(shouldExpandAndShowSubRows, forKey: "isExpanded")

            for i in (indexOfTappedRow + 1)...(indexOfTappedRow + (checkCell["additionalRows"] as! Int)) {
                ((cellDescriptors[indexPath.section]  as! NSMutableArray)[i] as AnyObject).setValue(shouldExpandAndShowSubRows, forKey: "isVisible")
            }

        } else {
            if checkCell["cellIdentifier"] as! String == "idCellValuePicker" {
                var indexOfParentCell: Int!
                for  i in (0...indexOfTappedRow - 1).reversed(){
                    if ((cellDescriptors[indexPath.section]as! NSMutableArray)[i] as AnyObject)["isExpandable"] as! Bool == true {
                        indexOfParentCell = i
                        break
                    }

                }
                ((cellDescriptors[indexPath.section] as! NSMutableArray)[indexOfParentCell!] as AnyObject).setValue((tblExpandable.cellForRow(at: indexPath) as! ValuePickerCell).textLabel?.text, forKey: "primaryTitle")


                if checkCell["itemID"] as! String == "standardData" || checkCell["itemID"] as! String == "testData"{
//                    gvDataType.gvSelectedSensorIndex = (indexPath as NSIndexPath).row - 1
//
//
                } else if checkCell["itemID"]! as! String == "tcpCloud" || checkCell["itemID"]! as! String == "udpCloud"{
//
                    GlobalVariables.cloudProtocol = checkCell["primaryTitle"]! as! String
                    NotificationCenter.default.post(name: Notification.Name(rawValue: CloudConnectionChangedNotification), object:self)

                }else{
                    GlobalVariables.LANProtocol = checkCell["primaryTitle"]! as! String
                    NotificationCenter.default.post(name: Notification.Name(rawValue: LocalConnectionChangedNotification), object:self)


                }
                ((cellDescriptors[indexPath.section] as! NSMutableArray)[indexOfTappedRow] as AnyObject).setValue(false, forKey: "isExpanded")

                for i in (indexOfParentCell! + 1)...(indexOfParentCell! + (((cellDescriptors[indexPath.section]as! NSMutableArray)[indexOfParentCell!] as AnyObject)["additionalRows"] as! Int)) {
                    ((cellDescriptors[indexPath.section] as! NSMutableArray)[i] as AnyObject).setValue(false, forKey: "isVisible")

                }
            }else if checkCell["itemID"] as! String == "account"{
                self.performSegue(withIdentifier: "toAccountData", sender: self)
            }
        }

        getIndicesOfVisibleRows()

        tblExpandable.reloadSections(IndexSet(integer: (indexPath as NSIndexPath).section), with: UITableViewRowAnimation.fade)
    }
    
    func getCellDescriptorForIndexPath(_ indexPath: IndexPath) -> [String: AnyObject] {
        let indexOfVisibleRow = visibleRowsPerSection[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        
        let cellDescriptor = (cellDescriptors[(indexPath as NSIndexPath).section] as! NSMutableArray)[indexOfVisibleRow] as! [String: AnyObject]
        
        return cellDescriptor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //Looks for single or multiple taps to dissmiss keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCellDescriptors()
        configureTableView()
    }
    

    func getIndicesOfVisibleRows() {
        visibleRowsPerSection.removeAll()
        for currentSectionCells in cellDescriptors.objectEnumerator().allObjects as! [[[String:Any]]]{
            var visibleRows = [Int]()
            
            for row in 0..<currentSectionCells.count {
                if currentSectionCells[row]["isVisible"] as! Bool == true {
                    visibleRows.append(row)
                }
            }
            visibleRowsPerSection.append(visibleRows)
        }
        
        for currentSectionCells in cellDescriptors {
            var visibleRows = [Int]()
            
            for row in 0...((currentSectionCells as! [[String: AnyObject]]).count - 1) {
                
                let checkCell = ((currentSectionCells as! NSMutableArray)[row] as AnyObject)
                if checkCell["isVisible"] as! Bool == true {
                    
                    visibleRows.append(row)
                }
            }
            visibleRowsPerSection.append(visibleRows)
        }
    }

    func configureTableView() {
        tblExpandable.delegate = self
        tblExpandable.dataSource = self
        tblExpandable.tableFooterView = UIView(frame: CGRect.zero)
        
        tblExpandable.register(UINib(nibName: "NormalCell", bundle: nil), forCellReuseIdentifier: "normalCell")
        tblExpandable.register(UINib(nibName: "TextfieldCell", bundle: nil), forCellReuseIdentifier: "idCellTextfield")
        tblExpandable.register(UINib(nibName: "DatePickerCell", bundle: nil), forCellReuseIdentifier: "idCellDatePicker")
        tblExpandable.register(UINib(nibName: "SwitchCell", bundle: nil), forCellReuseIdentifier: "idCellSwitch")
        tblExpandable.register(UINib(nibName: "ValuePickerCell", bundle: nil), forCellReuseIdentifier: "idCellValuePicker")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if cellDescriptors != nil {
            return cellDescriptors.count
        } else {
            return 0
        }
    }
    
    func loadCellDescriptors() {
        if let path = Bundle.main.path(forResource: "CellDescriptor", ofType: "plist") {
            cellDescriptors = NSMutableArray(contentsOfFile: path)
            getIndicesOfVisibleRows()
            tblExpandable.reloadData()
        }
        
        for section in 0..<cellDescriptors.count{
            for row in 0..<(cellDescriptors[section] as AnyObject).count {
                let cellObject:String = (((cellDescriptors[section] as! NSMutableArray)[row] as AnyObject)["itemID"] as!  String?)!

                switch cellObject {
                case "PORT":
                    ((cellDescriptors[section] as! NSMutableArray)[row] as AnyObject).setValue("\(GlobalVariables.port)", forKey: "secondaryTitle")
                    break
                case "IP": ((cellDescriptors[section] as! NSMutableArray)[row] as AnyObject).setValue("\(GlobalVariables.IP)", forKey: "secondaryTitle")
                    break
                case "PORTlocal": ((cellDescriptors[section] as! NSMutableArray)[row] as AnyObject).setValue("\(GlobalVariables.Portlocal)", forKey: "secondaryTitle")
                    break
                case "IPlocal": ((cellDescriptors[section] as! NSMutableArray)[row] as AnyObject).setValue("\(GlobalVariables.IPlocal)", forKey: "secondaryTitle")
                    break
                case "adress": ((cellDescriptors[section] as! NSMutableArray)[row] as AnyObject).setValue("\(GlobalVariables.IP):\(GlobalVariables.port)", forKey: "primaryTitle")
                    break
                case "adresslocal": ((cellDescriptors[section] as! NSMutableArray)[row] as AnyObject).setValue("\(GlobalVariables.IPlocal):\(GlobalVariables.Portlocal)", forKey: "primaryTitle")
                    break
                
                case "cloudProtocol": ((cellDescriptors[section] as! NSMutableArray)[row] as AnyObject).setValue("\(GlobalVariables.cloudProtocol)", forKey: "primaryTitle")
                    break
                case "LANProtocol": ((cellDescriptors[section] as! NSMutableArray)[row] as AnyObject).setValue("\(GlobalVariables.LANProtocol)", forKey: "primaryTitle")
                    break
                case "speed": ((cellDescriptors[section] as! NSMutableArray)[row] as AnyObject).setValue("\(GlobalVariables.speed)", forKey: "primaryTitle")
                    break
                    
                default:
                    print("default")
                }
            }
        }
    }
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    

}
