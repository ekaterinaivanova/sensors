//
//  LocalizedToolBarButton.swift
//  SensorDataSend
//
//  Created by Ekaterina Ivanova on 13/02/16.
//  Copyright © 2016 Ekaterina Ivanova. All rights reserved.
//

import UIKit

class LocalizedBarButton : UIBarButtonItem{
    
    override func awakeFromNib() {
        super.awakeFromNib()
       self.title = NSLocalizedString(title!,tableName: "Localized", comment: "")

        
    }
}
