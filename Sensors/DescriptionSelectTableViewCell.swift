//
//  DescriptionSelectTableViewCell.swift
//  Sensors
//
//  Created by Ekaterina Ivanova on 17/04/2017.
//  Copyright © 2017 Ekaterina Ivanova. All rights reserved.
//

import UIKit

class DescriptionSelectCell: UITableViewCell {

    @IBOutlet weak var cellTitle: LocalizedLabel!
    @IBOutlet weak var cellDescription: LocalizedLabel!
    
    let bigFont = Styles.bigFont
    
    let smallFont = Styles.smallFont
    
    let primaryColor = Styles.blackColor
    
    let secondaryColor = Styles.grayColor
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellTitle.font = bigFont
        cellDescription.font = smallFont
        
        cellTitle.textColor = primaryColor
        cellDescription.textColor = secondaryColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
