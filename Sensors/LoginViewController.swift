//
//  LoginVC.swift
//  SensorDataSend
//
//  Created by Ekaterina Ivanova on 16/02/16.
//  Copyright © 2016 Ekaterina Ivanova. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITableViewDataSource,UITableViewDelegate, AccountTableViewCellDelegete {
    
    func buttonWasTapped(_ parentCell: AccountTableViewCell){}
    
    
    @IBOutlet weak var verticallDistanceToTop: NSLayoutConstraint!
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activeText: UITextField!
    let loginModel = LoginModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureKeyboard()
        configureNavigationBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
 
    }
    
    @IBAction func loginButtonTapped(_ sender: AnyObject) {
        loopThroughCells()
        if ConnectionManager.sharedInstance.reachability!.isReachable{
            //            //////////////////////////
            self.loginModel.sendData { (result) -> Void in

                if let lvRes = result! as String?{
                    switch lvRes{
                    case "UDNE":
                        print("User does not exist")
                        self.alert(NSLocalizedString("Login failed", tableName: "Localized", comment: ""), message: NSLocalizedString("User does not exist", tableName: "Localized", comment: ""))
                    case "AOK":
                        print("You are Loged in")
                        self.alert(NSLocalizedString("Login successful", tableName: "Localized", comment: ""), message: "\(GlobalVariables.email) " + NSLocalizedString("is logged in", tableName: "Localized", comment: ""))
                    case "PDNM":
                        print("Wrong password")
                        self.alert(NSLocalizedString("Login failed", tableName: "Localized", comment: ""), message: NSLocalizedString("Wrong password", tableName: "Localized", comment: ""))
                    case "EETLE":
                        print("You are already logged in")
                        self.alert(NSLocalizedString("Login successful", tableName: "Localized", comment: ""), message: "\(GlobalVariables.email) " + NSLocalizedString("is already logged in.", tableName: "Localized", comment: ""))
                    default:
                        self.alert("Default alert", message: "\(lvRes) I forgot t create the alert message")
                    }
                }
            }
        }else{
            
            alert(NSLocalizedString("No connection", tableName: "Localized", comment: ""), message: NSLocalizedString("Connection error message", tableName: "Localized", comment: ""))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loopThroughCells(){
        let rowCount = tableView.numberOfRows(inSection: 0)
        
        for index in 0 ..< rowCount {
            let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! AccountTableViewCell
            
            loginModel.setDataAtIndex(index, data: (cell.textField.text as String?)!)
        }
        
    }
    
    func showRegisterView(){
        self.performSegue(withIdentifier: "showRegister", sender: self)
    }
    
    func configureNavigationBar(){

        self.navigationItem.title = NSLocalizedString("Login", tableName: "Localized", comment: "")
        
        let loginButton = UIBarButtonItem(title: NSLocalizedString("Login", tableName: "Localized", comment: ""), style: .plain, target: self, action: #selector(LoginViewController.loginButtonTapped))
        
        let registerButton = UIBarButtonItem(image: UIImage(named: "ic_person_add.png")!, style: .plain, target: self, action: #selector(LoginViewController.showRegisterView))
        
        self.navigationItem.rightBarButtonItems = [loginButton, registerButton]
    }

    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        //hides empty cells
        tableView.tableFooterView = UIView(frame: .zero)
        
        
        tableView.register(UINib(nibName: "AccountCell", bundle: nil), forCellReuseIdentifier: "idCellTextFieldLabel")
        
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    func configureKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow,object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //Looks for single or multiple taps to dissmiss keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    

    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeText = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeText = nil
    }
    
    func keyboardWillShow(_ note: Notification) {
        //        if let keyboardSize = ((note as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
        //            var frame = gvTableView.frame
        //            UIView.beginAnimations(nil, context: nil)
        //            UIView.setAnimationBeginsFromCurrentState(true)
        //            UIView.setAnimationDuration(0.3)
        //            frame.size.height -= keyboardSize.height
        //            gvTableView.frame = frame
        //            if gvActiveText != nil {
        //                let rect = gvTableView.convert(gvActiveText.bounds, from: gvActiveText)
        //                gvTableView.scrollRectToVisible(rect, animated: false)
        //            }
        //            UIView.commitAnimations()
        //        }
    }
    
    func keyboardWillHide(_ note: Notification) {
        if let keyboardSize = ((note as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            var frame = tableView.frame
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationBeginsFromCurrentState(true)
            UIView.setAnimationDuration(0.3)
            frame.size.height += keyboardSize.height
            tableView.frame = frame
            UIView.commitAnimations()
        }
    }
    
    func popBackToPreviousViewController(){
        if GlobalVariables.loggedIn{
            navigationController?.popViewController(animated: true)
        }
    }
    
    func alert(_ title: String, message: String) {
        let okString =  NSLocalizedString("OK", tableName: "Localized", comment: "")
            
        let myAlert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        myAlert.addAction(UIAlertAction(title: okString, style: .default, handler: { action in self.popBackToPreviousViewController()
        }))
        OperationQueue.main.addOperation {
            self.present(myAlert, animated: true, completion: nil)
        }
 
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return loginModel.count()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCellTextFieldLabel", for: indexPath) as! AccountTableViewCell
        
        let lvData = loginModel.getData((indexPath as NSIndexPath).row)
        cell.label.text = lvData["label"] as! String!
        cell.textField.text = lvData["data"] as! String!
        cell.textField.isSecureTextEntry = lvData["hidden"] as! Bool!
        
        cell.textField.placeholder = lvData["label"] as! String!
        
        
        cell.textField.isUserInteractionEnabled = true
        //
        if let emailKeyboard = lvData["keyboard"] as! Bool! {
            if emailKeyboard {
                cell.textField.keyboardType = UIKeyboardType.emailAddress
            }
        }
        
        cell.delegate = self
        
        return cell
    }
    
    func textfieldTextWasChanged(_ newText: String, parentCell: AccountTableViewCell) {
        
        let parentCellIndexPath = tableView.indexPath(for: parentCell)
        
        loginModel.setDataAtIndex((parentCellIndexPath! as NSIndexPath).row, data: (parentCell.textField.text as String?)!)
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        loopThroughCells()
        tableView.reloadSections(IndexSet(integer: (indexPath as NSIndexPath).section), with: UITableViewRowAnimation.fade)
        
    }
    
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
