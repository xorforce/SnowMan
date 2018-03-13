//
//  ForecastCollectionViewCell.swift
//  SnowMan
//
//  Created by Bhagat  Singh on 07/03/18.
//  Copyright © 2018 Bhagat Singh. All rights reserved.
//

import UIKit

class ForecastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var highLowTempLabel: UILabel!
    
    
    func configureCell(forecast: Forecast) {
        let darkMode = UserDefaults.standard.bool(forKey: Constants.darkModeKey)
        if darkMode {
            setLightStyle(views: [highLowTempLabel, dayLabel])
        }
        else {
            setDarkStyle(views: [highLowTempLabel, dayLabel])
        }
        
        dayLabel.text = forecast.date
        if let weathercode = forecast.weatherCode.value {
            iconView.image = UIImage(named: imageToShow(darkMode: darkMode, weatherCode: weathercode))
        }
        if let high = forecast.high.value, let low = forecast.low.value {
            highLowTempLabel.text = "\(Int(high))°/\(Int(low))°"
        }
    }
    
    func extractCode(code: Int) -> String {
        switch code {
        case 200..<260 : return "Thunderstorm"
        case 300..<340 : return "Drizzle"
        case 500..<540 : return "Rain"
        case 600..<640 : return "Snow"
        case 700..<790 : return "Atmosphere"
        case 800..<800 : return "Clear"
        case 801..<810 : return "Clouds"
        case 900..<903 : return "Tornado"
        case 903 : return "Snow"
        case 904 : return "Clear"
        case 905 : return "Windy"
        case 903 : return "Hail"
        case 951..<960 : return "Windy"
        case 960..<965 : return "Tornado"
        default : return "Atmosphere"
        }
    }
    
    func imageToShow(darkMode: Bool, weatherCode: Int) -> String {
        let string = extractCode(code: weatherCode)
        if darkMode {
            return "\(string)W"
        }
        return string
    }
    
    func setLightStyle(views: [UILabel]) {
        for label in views {
            label.textColor = .white
        }
    }
    
    func setDarkStyle(views: [UILabel]) {
        for label in views {
            label.textColor = .black
        }
    }
}
