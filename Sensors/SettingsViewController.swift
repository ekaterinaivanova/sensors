
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

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var tblExpandable: UITableView!
    
    
    var cellDescriptors: NSMutableArray!
    
    var visibleRowsPerSection = [[Int]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCellDescriptors()
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


    
    func loadCellDescriptors() {
        
        if let path = Bundle.main.path(forResource: "CellDescriptor", ofType: "plist") {
            cellDescriptors = NSMutableArray(contentsOfFile: path)
            getIndicesOfVisibleRows()
            tblExpandable.reloadData()
        }
        
        for section in 0..<cellDescriptors.count{
            for row in 0..<(cellDescriptors[section] as AnyObject).count {
                let cellObject:String = (((cellDescriptors[section] as! NSMutableArray)[row] as AnyObject)["itemID"] as!  String?)!
                
                print(cellObject)
                
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
                    
                default:
                    print("default")
                }
                
                
            }
        }
        
    }


}
