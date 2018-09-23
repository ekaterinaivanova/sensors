//
//  AccountTableViewController.swift
//  Sensors
//
//  Created by Ekaterina Ivanova on 08/07/2018.
//  Copyright © 2018 Ekaterina Ivanova. All rights reserved.
//

import UIKit

class AccountTableViewController: UITableViewController {
    
    enum AlertType{
        case delete, update, ok, notLoggedin, pwdMissMatch, successUpdate, wrongPwd, userDoesNotExist
    }
    var accountModel = AccountModel()
    var currentAlertType:AlertType?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureTableView()
        self.configureNavigationBar()
        //        //Looks for single or multiple taps to dissmiss keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AccountTableViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AccountTableViewController.dataChange), name: NSNotification.Name(rawValue: LoginStatusChanged), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.register(UINib(nibName: "AccountCell", bundle: nil), forCellReuseIdentifier: "idCellTextFieldLabel")
        self.tableView.register(UINib(nibName: "NewAccountCell", bundle: nil), forCellReuseIdentifier: "idNormalLabelCell")
        self.tableView.register(UINib(nibName: "ButtonCell", bundle: nil), forCellReuseIdentifier: "idCellButton")
    }
    
    func configureNavigationBar(){
        self.navigationItem.title = NSLocalizedString("Account", tableName: "Localized", comment: "")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func dataChange(){
        OperationQueue.main.addOperation {
            self.tableView.reloadData()
        }
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func deleteAccount(){
        if GlobalVariables.loggedIn{
            UserClient().deleteAcc({ (result) -> Void in
                switch result{
                case "AOK":
                    self.removeAllAccountData()
                    self.dataChange()
                    self.currentAlertType = AlertType.ok
                    self.deleteAction( NSLocalizedString("Delete AOK", tableName: "Localized", comment: ""))
                case "UDNE":
                    self.currentAlertType = AlertType.ok
                    self.deleteAction(NSLocalizedString("UDNE", tableName: "Localized", comment: ""))
                    
                    break
                case "PDNM":
                    self.currentAlertType = AlertType.ok
                    self.deleteAction(NSLocalizedString("Delete PDNM", tableName: "Localized", comment: ""))
                    break
                default:
                    break
                }
            })
        }else{
            currentAlertType = AlertType.notLoggedin
            self.deleteAction( NSLocalizedString("Delete need to login", tableName: "Localized", comment: ""))
            
        }
    }
    
    func deleteAction(_ message:String){
        let title = NSLocalizedString("Delete", tableName: "Localized", comment: "")
        switch currentAlertType! {
        case AlertType.delete:
            let okString =  NSLocalizedString("OK", tableName: "Localized", comment: "")
            let cancelString = NSLocalizedString("Cancel", tableName: "Localized", comment: "")
            let myAlert: UIAlertController = UIAlertController(title: title, message:  message, preferredStyle: .alert)
            
            myAlert.addAction(UIAlertAction(title: okString, style: .default, handler:{action in
                self.deleteAccount()
            }))
            
            myAlert.addAction(UIAlertAction(title: cancelString, style: .default, handler: nil))
            OperationQueue.main.addOperation {
                self.present(myAlert, animated: true, completion: nil)
            }
            break
        case AlertType.ok:
            okButtonAlert(title, message: message)
        case AlertType.notLoggedin:
            notLoggedInAlert(title, message: message)
            break
        default:
            break
        }
    }
    
    func removeAllAccountData(){
        GlobalVariables.email = ""
        GlobalVariables.password = ""
        GlobalVariables.loggedIn = false
        GlobalVariables.userName = ""
        GlobalVariables.lastName = ""
    }

    func okButtonAlert(_ title:String, message:String){
        let okString =  NSLocalizedString("OK", tableName: "Localized", comment: "")
        let myAlert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        myAlert.addAction(UIAlertAction(title: okString, style: .default, handler:nil))
        OperationQueue.main.addOperation {
            self.present(myAlert, animated: true, completion: nil)
        }
    }
    
    func notLoggedInAlert(_ title:String, message:String){
        let loginString =  NSLocalizedString("Login", tableName: "Localized", comment: "")
        let registerString = NSLocalizedString("Register", tableName: "Localized", comment: "")
        let cancelString = NSLocalizedString("Cancel", tableName: "Localized", comment: "")
        let myAlert: UIAlertController = UIAlertController(title: "Delete", message:  message, preferredStyle: .alert)
        myAlert.addAction(UIAlertAction(title: cancelString, style: .default, handler:nil))
        myAlert.addAction(UIAlertAction(title: loginString, style: .default, handler: {
            action in
            self.performSegue(withIdentifier: "showLogin", sender: self)
        }))
        myAlert.addAction(UIAlertAction(title: registerString, style: .default, handler: {
            action in
            self.performSegue(withIdentifier: "showRegister", sender: self)
        }))
                
        OperationQueue.main.addOperation {
            self.present(myAlert, animated: true, completion: nil)
        }
    }
    
    func updateAction(_ message:String){
        let title = NSLocalizedString("Pwd change", tableName: "Localized", comment: "")
        switch currentAlertType!{
        case AlertType.update:
            let okString =  NSLocalizedString("OK", tableName: "Localized", comment: "")
            let cancelString = NSLocalizedString("Cancel", tableName: "Localized", comment: "")
            
            let myAlert: UIAlertController = UIAlertController(title: title, message:  message, preferredStyle: .alert)
            
            myAlert.addAction(UIAlertAction(title: okString, style: .default, handler:{action in
                self.changePassword()
            }))
            myAlert.addAction(UIAlertAction(title: cancelString, style: .default, handler: nil))
            OperationQueue.main.addOperation {
                self.present(myAlert, animated: true, completion: nil)
            }
            break
        case AlertType.ok:
            okButtonAlert(title, message: message)
        case AlertType.notLoggedin:
            notLoggedInAlert(title, message: message)
        default:
            break
        }
    }
    
    func changePassword(){
        let oldPassword = self.accountModel.getData(IndexPath(row: 0, section: 1))["data"] as! String?
        let newPassword = self.accountModel.getData(IndexPath(row: 1, section: 1))["data"] as! String?
        
        UserClient().changePassword(oldPassword: oldPassword!,newPassword: newPassword!, completion: { (result) -> Void in
            switch result {
            case "AOK":
                self.currentAlertType = AlertType.ok
                self.updateAction(NSLocalizedString("Update AOK", tableName: "Localized", comment: ""))
                GlobalVariables.password = newPassword! //update pwd
            case "PDNM":
                self.currentAlertType = AlertType.ok
                self.updateAction(NSLocalizedString("Wrong password", tableName: "Localized", comment: ""))
            case "UDNE":
                self.currentAlertType = AlertType.ok
                self.deleteAction(NSLocalizedString("UDNE", tableName: "Localized", comment: ""))
            default:
                break
            }
        })
    }
    
    func loopThroughCellsInPasswordSection(){
        let rowCount = self.tableView.numberOfRows(inSection: 1)
        //            let list = [TableViewCell]()
        
        for index in 0 ..< rowCount-1 {
            if let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 1)) as! AccountTableViewCell?{
                accountModel.setDataAtIndex(index, data: (cell.textField.text as String?)!)
            }
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return accountModel.sectionsNumber
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountModel.numberOfRowsInSection(section)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return GlobalVariables.loggedIn ? accountModel.sections[section] : ""
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData:NSDictionary = accountModel.getData(indexPath)
        var cell = AccountTableViewCell()
        if let button = cellData["button"] as! Bool?{
            if button {
                cell = self.tableView.dequeueReusableCell(withIdentifier: "idCellButton", for: indexPath) as! AccountTableViewCell
                cell.accountButton.setTitle(cellData["label"] as! String?, for: UIControl.State())
            }else{
                cell = self.tableView.dequeueReusableCell(withIdentifier: "idCellTextFieldLabel", for: indexPath) as! AccountTableViewCell
                
                cell.label.text = cellData["label"] as! String?
                
                cell.textField.text = cellData["data"] as! String?
                
                cell.textField.isSecureTextEntry = (cellData["hidden"] as! Bool?)!
                
                if let editing = cellData["editing"] as! Bool?{
                    if editing {
                        cell.textField.isUserInteractionEnabled = true
                        cell.textField.placeholder = cellData["label"] as! String?
                    }
                }
            }
        }
        cell.delegate =  self
        return cell
    }
}

extension AccountTableViewController:AccountTableViewCellDelegete{
    func textfieldTextWasChanged(_ newText: String, parentCell: AccountTableViewCell){}
    func buttonWasTapped(_ parentCell: AccountTableViewCell){
        let parentCellIndexPath = self.tableView.indexPath(for: parentCell)
        if GlobalVariables.loggedIn{
            if (parentCellIndexPath! as NSIndexPath).section == 0{
                if GlobalVariables.loggedIn{
                    currentAlertType = AlertType.delete
                    deleteAction(NSLocalizedString("Delete msg", tableName: "Localized", comment: ""))
                }else{
                    currentAlertType = AlertType.notLoggedin
                    self.deleteAction( NSLocalizedString("Delete need to login", tableName: "Localized", comment: ""))
                }
            }else  if (parentCellIndexPath! as NSIndexPath).section == 1{
                loopThroughCellsInPasswordSection()
                if GlobalVariables.loggedIn{
                    let pwd1 = accountModel.getData(IndexPath(row: 1, section: 1))["data"] as! String
                    let pwd2 = accountModel.getData(IndexPath(row: 2, section: 1))["data"] as! String
                    let oldPwd = accountModel.getData(IndexPath(row: 0, section: 1))["data"] as! String
                    if pwd1 != pwd2{
                        currentAlertType = AlertType.ok
                        updateAction(NSLocalizedString("Pwd miss match", tableName: "Localized", comment: ""))
                    }else if pwd1 == "" || oldPwd == "" {
                        currentAlertType = AlertType.ok
                        updateAction(NSLocalizedString("Pwd empty fields", tableName: "Localized", comment: ""))
                    }else{
                        currentAlertType = AlertType.update
                        updateAction(NSLocalizedString("Update msg", tableName: "Localized", comment: ""))
                    }
                }else{
                    currentAlertType =  AlertType.notLoggedin
                    updateAction(NSLocalizedString("Update need to login", tableName: "Localized", comment: ""))
                }
            }else{
                self.performSegue(withIdentifier: "forgotpassword", sender: self)
            }
        }else{ // if is not logged in
            if (parentCellIndexPath! as NSIndexPath).row == 0{
                self.performSegue(withIdentifier: "showLogin", sender: self)
            }else if (parentCellIndexPath! as NSIndexPath).row == 1{
                self.performSegue(withIdentifier: "showRegister", sender: self)
            }else{
                self.performSegue(withIdentifier: "forgotpassword", sender: self)
                
            }
        }
    }
}

