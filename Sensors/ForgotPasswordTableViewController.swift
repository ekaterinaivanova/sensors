//
//  ForgotPasswordTableViewController.swift
//  Sensors
//
//  Created by Ekaterina Ivanova on 09/07/2018.
//  Copyright © 2018 Ekaterina Ivanova. All rights reserved.
//

import UIKit

class ForgotPasswordTableViewController: UITableViewController, AccountTableViewCellDelegete {
    
    var model = ForgotPasswordModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureNavigationBar(){
        self.navigationItem.title = NSLocalizedString("Forgot password", tableName: "Localized", comment: "")
    }
    
    func configureTableView() {
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.register(UINib(nibName: "AccountCell", bundle: nil), forCellReuseIdentifier: "idCellTextFieldLabel")
        
        self.tableView.register(UINib(nibName: "ButtonCell", bundle: nil), forCellReuseIdentifier: "idCellButton")
    }
    
    func buttonWasTapped(_ parentCell: AccountTableViewCell){
        print("Button was tapped")
        loopThroughCells()
        model.sendData { (result) in
            switch result!{
            case "EF":
                self.displayAllertMessage("You have to fill all the fields")
            //                print("Empty fieldds");
            case "AOK":
                self.displayAllertMessage(NSLocalizedString("new pwd AOK", tableName: "Localized", comment: ""))
            case "UDNE":
                self.displayAllertMessage(NSLocalizedString("new pwd UDNE", tableName: "Localized", comment: ""))
            case "WPF":
                self.displayAllertMessage(NSLocalizedString("new pwd WPF", tableName: "Localized", comment: ""))
            case "NOK":
                self.displayAllertMessage(NSLocalizedString("new pwd NOK", tableName: "Localized", comment: ""))
                
            default:
                break
            }
        }
    }
    
    func loopThroughCells(){
        let rowCount = self.tableView.numberOfRows(inSection: 0)
        for index in 0 ..< rowCount - 1 {
            if let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! AccountTableViewCell?{
                model.setDataAtIndex(index, newData: (cell.textField.text as String?)!)
            }
        }
    }
    
    func textfieldTextWasChanged(_ newText: String, parentCell: AccountTableViewCell) {
        let parentCellIndexPath = self.tableView.indexPath(for: parentCell)
        model.setDataAtIndex((parentCellIndexPath! as NSIndexPath).row, newData: (parentCell.textField.text as String?)!)
    }
    
    func displayAllertMessage(_ message:String){
        let okString =  NSLocalizedString("OK", tableName: "Localized", comment: "")
        let title = NSLocalizedString("New Password", tableName: "Localized", comment: "")
        let lvAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let lvOkAction = UIAlertAction(title: okString, style: UIAlertActionStyle.default, handler: {action in
            //                self.popBackToPreviousViewController()
        })
        lvAlert.addAction(lvOkAction)
        OperationQueue.main.addOperation {
            self.present(lvAlert, animated: true, completion: nil)
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return model.count()
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = AccountTableViewCell()
        
        let data = model.getData((indexPath as NSIndexPath).row)
        
        if let button = data["button"] as! Bool?{
            if button{
                cell = tableView.dequeueReusableCell(withIdentifier: "idCellButton", for: indexPath) as! AccountTableViewCell
                cell.accountButton.setTitle(data["label"] as! String?, for: UIControlState())
                
            }else{
                cell = tableView.dequeueReusableCell(withIdentifier: "idCellTextFieldLabel", for: indexPath) as! AccountTableViewCell
                
                cell.label.text = data["label"] as! String?
                cell.textField.text = data["data"] as! String?
                cell.textField.isSecureTextEntry = (data["hidden"] as! Bool?)!
                cell.textField.placeholder = data["label"] as! String?
                cell.textField.isUserInteractionEnabled = true
                cell.textField.keyboardType = UIKeyboardType.emailAddress
            }
        }
        cell.delegate = self
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        loopThroughCells()
        self.tableView.reloadSections(IndexSet(integer: (indexPath as NSIndexPath).section), with: UITableViewRowAnimation.fade)
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
