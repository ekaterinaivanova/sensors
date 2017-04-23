//
//  TableViewCell.swift
//  Sensors
//
//  Created by Ekaterina Ivanova on 17/04/2017.
//  Copyright © 2017 Ekaterina Ivanova. All rights reserved.
//

import UIKit

class NormalCell: UITableViewCell {
    
    let bigFont = Styles.bigFont
    
    let smallFont = Styles.smallFont
    
    let primaryColor = Styles.blackColor
    
    let secondaryColor = Styles.grayColor

    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellDetails: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellTitle.font = bigFont
        cellDetails.font = smallFont
        
        cellTitle.textColor = primaryColor
        cellDetails.textColor = secondaryColor
        
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
