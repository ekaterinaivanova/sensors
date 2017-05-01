//
//  AccountTableViewCell.swift
//  SensorDataSend
//
//  Created by Ekaterina Ivanova on 25/01/16.
//  Copyright © 2016 Ekaterina Ivanova. All rights reserved.
//

import UIKit

protocol AccountTableViewCellDelegete {
        func textfieldTextWasChanged(_ newText: String, parentCell: AccountTableViewCell)
        func buttonWasTapped(_ parentCell: AccountTableViewCell)
}

class AccountTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var accountButton: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    
    let bigFont = Styles.bigFont
    
    let smallFont = Styles.smallFont
    
    let primaryColor = Styles.blackColor
    
    let secondaryColor = Styles.grayColor
    
    
    var delegate: AccountTableViewCellDelegete!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if label != nil {
            
            label.font = bigFont
            label.textColor = primaryColor
        }
        
        if textField != nil {
            textField.font = bigFont
            textField.textColor = primaryColor
            textField.delegate = self
        }
        if accountButton != nil{
            accountButton.titleLabel?.font = bigFont
            accountButton.backgroundColor = UIColor.red
            accountButton.setTitleColor(UIColor.white, for: UIControlState())
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    @IBAction func buttonTapped(_ sender: AnyObject) {
        if delegate != nil {
            delegate.buttonWasTapped(self)
        }
    }
    
    // MARK: UITextFieldDelegate Function
    
        
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if delegate != nil {
            delegate.textfieldTextWasChanged(textField.text!, parentCell: self)
        }
    }
    

}
