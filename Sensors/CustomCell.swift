//
//  CustomCell.swift
//  Sensors
//
//  Created by Ekaterina Ivanova on 02/06/2018.
//  Copyright © 2018 Ekaterina Ivanova. All rights reserved.
//

import Foundation
import UIKit

protocol CustomCellDelegate {    
    func textfieldTextWasChanged(_ newText: String, parentCell: CustomCell)
    
}

class CustomCell: UITableViewCell, UITextFieldDelegate {
    
    // MARK: IBOutlet Properties
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var lblSwitchLabel: UILabel!
    
    @IBOutlet weak var swSwitchStatus: UISwitch!
    
    @IBOutlet weak var slSamplingInterval: UISlider!
    
    @IBOutlet weak var ncTextLabel: UILabel!
    
    
    // MARK: Constants
    
    let bigFont = Styles.bigFont
    
    let smallFont = Styles.smallFont
    
    let primaryColor = Styles.blackColor
    
    let secondaryColor = Styles.grayColor
    
    // MARK: Variables
    
    var delegate: CustomCellDelegate!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if textLabel != nil {
            textLabel?.font = bigFont
            textLabel?.textColor = primaryColor
        }
        
        if detailTextLabel != nil {
            detailTextLabel?.font = smallFont
            detailTextLabel?.textColor = secondaryColor
        }
        
        if textField != nil {
            textField.font = bigFont
            textField.delegate = self
        }
        
        if lblSwitchLabel != nil {
            lblSwitchLabel.font = bigFont
        }
        if ncTextLabel != nil{
            ncTextLabel?.font = smallFont
            ncTextLabel?.textColor = secondaryColor
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    // MARK: UITextFieldDelegate Function
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if delegate != nil {
            delegate.textfieldTextWasChanged(textField.text!, parentCell: self)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if delegate != nil {
            delegate.textfieldTextWasChanged(textField.text!, parentCell: self)
        }
        return true
    }
    
}
