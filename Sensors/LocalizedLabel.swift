//
//  LocalizedLabel.swift
//  SensorDataSend
//
//  Created by Ekaterina Ivanova on 08/11/15.
//  Copyright © 2015 Ekaterina Ivanova. All rights reserved.
//
import UIKit

class LocalizedLabel : UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        if let text = text {
            self.text = NSLocalizedString(text, tableName: "Localized", comment: "")
        }
    }
}