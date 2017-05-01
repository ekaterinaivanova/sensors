//
//  HomeCell.swift
//  Sensors
//
//  Created by Ekaterina Ivanova on 01/05/2017.
//  Copyright © 2017 Ekaterina Ivanova. All rights reserved.
//

import UIKit

class HomeCell: UITableViewCell {

    @IBOutlet weak var sensorLabel: LocalizedLabel!
    @IBOutlet weak var dataLabel: UILabel!
    
    
    
    // MARK: Constants
    
    let bigFont = Styles.bigFont
    
    let smallFont = Styles.smallFont
    
    let primaryColor = Styles.blackColor
    
    let secondaryColor = Styles.grayColor
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if sensorLabel != nil{
            sensorLabel.font = bigFont
            sensorLabel.textColor = primaryColor
        }
        
        
        if dataLabel != nil{
            dataLabel.font = smallFont
            dataLabel.textColor = secondaryColor
        }
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }


}
