//
//  RegisterViewController.swift
//  Sensors
//
//  Created by Ekaterina Ivanova on 06/05/2017.
//  Copyright © 2017 Ekaterina Ivanova. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AccountTableViewCellDelegete {

    @IBOutlet weak var tableView: UITableView!
    
    let registerModel = RegisterModel()
    
    var pushBack = false
    
    func buttonWasTapped(_ parentCell: AccountTableViewCell){}
    
    func popBackToPreviousViewController(){
        
        if pushBack{
            
            navigationController?.popViewController(animated: true)
            
        }
        
    }
    
    func displayAllertMessage(_ message:String){
        
        let okString =  NSLocalizedString("OK", tableName: "Localized", comment: "")
        
        let title = NSLocalizedString("Register", tableName: "Localized", comment: "")

        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            
        let okAction = UIAlertAction(title: okString, style: UIAlertActionStyle.default, handler: {action in
            
            self.popBackToPreviousViewController()
            
        })
        
        alert.addAction(okAction)
        
        OperationQueue.main.addOperation {
            
            self.present(alert, animated: true, completion: nil)
            
        }
       
    }
    
    func registerButtonTapped(){
        
        loopThroughCells()
        registerModel.sendData { (result) -> Void in

            switch result!{
                
            case "AOK":
                self.pushBack = true
                self.displayAllertMessage(NSLocalizedString("Register AOK", tableName: "Localized", comment: ""))
                
                
                break
            case "UAE":
                self.pushBack = false
                self.displayAllertMessage(NSLocalizedString("Register UAE", tableName: "Localized", comment: ""))
                
                break
            case "WEF":
                self.pushBack = false
                self.displayAllertMessage(NSLocalizedString("Register WEF", tableName: "Localized", comment: ""))
                
                break
            case "NOK":
                self.pushBack = false
                self.displayAllertMessage(NSLocalizedString("Register NOK", tableName: "Localized", comment: ""))
                
                break
            default:
                break
                
            }
            
        }
        
    }
    
    func showLoginView(){
        
        self.performSegue(withIdentifier: "showLogin", sender: self)
        
    }
    
    func loopThroughCells(){
        
        let rowCount = self.tableView.numberOfRows(inSection: 0)
        for index in 0 ..< rowCount {

            if let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! AccountTableViewCell?{
                
                registerModel.setDataAtIndex(index, data: (cell.textField.text as String?)!)

            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureTableView()
    }
    
    func configureTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.tableView.register(UINib(nibName: "AccountCell", bundle: nil), forCellReuseIdentifier: "idCellTextFieldLabel")
    }
    
    func configureNavigationBar(){
        self.navigationItem.title = NSLocalizedString("Registration", tableName: "Localized", comment: "")
        
        let registerButton = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(RegisterViewController.registerButtonTapped))
        
        let loginButton = UIBarButtonItem(image: UIImage(named: "login.png")!, style: .plain, target: self, action: #selector(RegisterViewController.showLoginView))
        
        self.navigationItem.rightBarButtonItems = [registerButton, loginButton]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return registerModel.count()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCellTextFieldLabel", for: indexPath) as! AccountTableViewCell
        
        let data = registerModel.getData((indexPath as NSIndexPath).row)
        cell.label.text = data["label"] as! String!
        cell.textField.text = data["data"] as! String!
        cell.textField.isSecureTextEntry = data["hidden"] as! Bool!
        cell.textField.placeholder = data["label"] as! String!
        cell.textField.isUserInteractionEnabled = true
//        print(cell.textLabel?.text,cell.textField.text)
        if let emailKeyboard = data["keyboard"] as! Bool! {
            if emailKeyboard {
                cell.textField.keyboardType = UIKeyboardType.emailAddress
            }
        }
        
        return cell
    }
    
    func textfieldTextWasChanged(_ newText: String, parentCell: AccountTableViewCell) {
        let parentCellIndexPath = self.tableView.indexPath(for: parentCell)
        
        registerModel.setDataAtIndex((parentCellIndexPath! as NSIndexPath).row, data: (parentCell.textField.text as String?)!)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        loopThroughCells()
        self.tableView.reloadSections(IndexSet(integer: (indexPath as NSIndexPath).section), with: UITableViewRowAnimation.fade)
        
    }
    
        func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }


}
