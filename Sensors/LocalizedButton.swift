//
//  LocalizedButton.swift
//  SensorDataSend
//
//  Created by Ekaterina Ivanova on 08/11/15.
//  Copyright © 2015 Ekaterina Ivanova. All rights reserved.
//

import UIKit


    class LocalizedButton : UIButton {
        override func awakeFromNib() {
            for state in [UIControl.State.highlighted, UIControl.State.selected, UIControl.State.disabled] {
                if let title = title(for: state) {
                    setTitle(NSLocalizedString(title,tableName: "Localized", comment: ""), for: state)
                }
            }
        }
    }


