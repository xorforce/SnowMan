//
//  WeatherVC+Extensions.swift
//  SnowMan
//
//  Created by Bhagat  Singh on 08/03/18.
//  Copyright © 2018 Bhagat Singh. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

extension WeatherVC {
    
    func performUIUpdates() {
        let darkMode = UserDefaults.standard.bool(forKey: "darkMode")
        if darkMode {
            setDarkStyle(labels: [mainWeather, mainLocation, mainTemprature, humidityLabel, windSpeed, highLowTemprature, tempratureText, windText, humidityText])
            view.backgroundColor = .black
            collectionView.backgroundColor = .black
            settingsButton.setImage(UIImage(named: "settingsW"), for: .normal)
            
        }
        else {
            setLightStyle(labels: [mainWeather, mainLocation, mainTemprature, humidityLabel, windSpeed, highLowTemprature, tempratureText, windText, humidityText])
            view.backgroundColor = .white
            collectionView.backgroundColor = .white
            settingsButton.setImage(UIImage(named: "settings"), for: .normal)
        }
        collectionView.reloadData()
        mainThumbnail.image = UIImage(named: imageToShow(darkMode: darkMode, code: currentWeather.weatherCode.value))
    }
}

extension WeatherVC : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = forecastsArray?.count {
            return count
        }
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "forecastCell", for: indexPath) as! ForecastCollectionViewCell
        let forecast = forecastsArray![indexPath.row]
        cell.configureCell(forecast: forecast)
        return cell
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if darkMode {
            return .lightContent
        }
        return .default
        
    }
    
    func setDataFromObject(weather: CurrentWeather) {
        mainThumbnail.image = UIImage(named: imageToShow(darkMode: darkMode, code: weather.weatherCode.value))
        mainWeather.attributedText = NSAttributedString(string: weather.weatherType)
        mainLocation.text = weather.cityName
        highLowTemprature.text = getHighLowTempString(max: weather.max.value, min: weather.min.value)
        humidityLabel.text = getHumidityString(humidity: weather.humidity.value)
        windSpeed.text = getWindSpeedString(windspeed: weather.windType.value)
        mainTemprature.text = getCurrentTempString(currentTemp: weather.currentTemprature.value)
    }
}

extension WeatherVC : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationAuthStatus()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location?.coordinate else {return}
        Location.shared.latitude = location.latitude
        Location.shared.longitude = location.longitude
        if !downloadSuccesful {
            getData()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        showAlert(title: "Error", message: error.localizedDescription, actions: [action])
    }
}



