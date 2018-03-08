//
//  SettingsTableViewCell.swift
//  SnowMan
//
//  Created by Bhagat  Singh on 08/03/18.
//  Copyright © 2018 Bhagat Singh. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let darkMode = UserDefaults.standard.bool(forKey: "darkMode")
        
        if darkMode {
            settingsLabel.textColor = .white
            backgroundColor = .black
            switchButton.isOn = true
        }
        else {
            settingsLabel.textColor = .black
            backgroundColor = .white
            switchButton.isOn = false
        }
    }
    
    @IBAction func valueChanged(_ sender: Any) {
        let switchButton = sender as! UISwitch
        if switchButton.isOn {
            UserDefaults.standard.set(true, forKey: "darkMode")
        }
        else {
            UserDefaults.standard.set(false, forKey: "darkMode")
        }
        UserDefaults.standard.synchronize()
    }
    
    
}
