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
            if let dictionnary = data[row] as NSDictionary!  {
                let ID = dictionnary.object(forKey: "ID") as! Int
                return GlobalVariables.subject == ID
            }
         
            break
        case 1:
            if let dictionnary = data[row] as NSDictionary!  {
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
            if let dictionnary = data[row] as NSDictionary!  {
                let ID = dictionnary.object(forKey: "ID") as! Int
                GlobalVariables.subject = ID
            }
            break;
        case 1:
            if let dictionnary = data[row] as NSDictionary!  {
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

        // Do any additional setup after loading the view.
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

