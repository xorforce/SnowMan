//
//  UIViewController+Extensions.swift
//  SnowMan
//
//  Created by Bhagat  Singh on 07/03/18.
//  Copyright © 2018 Bhagat Singh. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func setLightStyle(labels: [UILabel]) {
        for label in labels {
            label.textColor = .black
        }
    }
    
    func setDarkStyle(labels: [UILabel]) {
        for label in labels {
            label.textColor = .white
        }
    }
    
    func getHighLowTempString(max: Double?, min: Double?) -> String {
        if let max = max, let min = min {
            return "\(max)°/ \(min)°"
        }
        return ""
    }
    
    func getHumidityString(humidity: Double?) -> String {
        if let humidity = humidity {
            return "\(humidity)%"
        }
        return ""
    }
    
    func getWindSpeedString(windspeed: Double?) -> String {
        if let windspeed = windspeed {
            return "\(Int(windspeed)) km/h"
        }
        return ""
    }
    
    func getCurrentTempString(currentTemp: Double?) -> String {
        if let currentTemp = currentTemp {
            return "\(currentTemp)°C"
        }
        return ""
    }
    
    func showViewAndLoader(view: UIView, loader: UIActivityIndicatorView, darkMode: Bool) {
        view.alpha = 1.0
        loader.startAnimating()
        if darkMode {
            view.backgroundColor = .black
            loader.color = .white
        }
        else {
            view.backgroundColor = .white
            loader.color = .darkGray
        }
    }
    
    func hideLoaderView(loaderView: UIView, loader: UIActivityIndicatorView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            loader.stopAnimating()
            loader.hidesWhenStopped = true
            UIView.animate(withDuration: 0.7) {
                loaderView.alpha = 0.0
            }
        }
    }
    
    func showAlert(title: String, message: String, actions: [UIAlertAction]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alertController.addAction(action)
        }
        present(alertController, animated: true, completion: nil)
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
    
    func imageToShow(darkMode: Bool, code: Int?) -> String {
        if let code = code {
            let string = extractCode(code: code)
            if darkMode {
                return "\(string)W"
            }
            return string
        }
        return "Placeholder"
    }
    
    
}
