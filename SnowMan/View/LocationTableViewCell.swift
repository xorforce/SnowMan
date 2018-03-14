//
//  LocationTableViewCell.swift
//  SnowMan
//
//  Created by Bhagat  Singh on 12/03/18.
//  Copyright © 2018 Bhagat Singh. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    @IBOutlet weak var locationLabel: UILabel!
    
    
    func configureCell(_ location: LocationModel) {
        let darkMode = UserDefaults.standard.bool(forKey: Constants.darkModeKey)
        if darkMode {
            backgroundColor = .black
            locationLabel.textColor = .white
        }
        else {
            backgroundColor = .white
            locationLabel.textColor = .black
        }
        locationLabel.text = "\(location.locationString!)"
    }

}
