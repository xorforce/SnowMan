//
//  WeatherVC.swift
//  SnowMan
//
//  Created by Bhagat  Singh on 05/03/18.
//  Copyright © 2018 Bhagat Singh. All rights reserved.
//

import UIKit
import RealmSwift

class WeatherVC: UIViewController {

    @IBOutlet weak var mainThumbnail: UIImageView!
    @IBOutlet weak var mainWeather: UILabel!
    @IBOutlet weak var mainLocation: UILabel!
    @IBOutlet weak var mainTemprature: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var highLowTemprature: UILabel!
    @IBOutlet weak var tempratureText: UILabel!
    @IBOutlet weak var windText: UILabel!
    @IBOutlet weak var humidityText: UILabel!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var settingsButton : UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    let darkMode = UserDefaults.standard.bool(forKey: darkModeKey)
    var forecast : Forecast!
    var forecastsArray : [Forecast]?
    var currentWeather : CurrentWeather!
    var downloadSuccesful = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showViewAndLoader(view: loaderView, loader: indicatorView, darkMode: darkMode)
        initialiseVariables()
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        performUIUpdates()
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func updateUI() {
        DispatchQueue.main.async {
            self.setupUI(darkMode: self.darkMode)
        }
    }
    
    func setupUI(darkMode: Bool) {
        if darkMode {
            setDarkStyle(labels: [mainWeather, mainLocation, mainTemprature, highLowTemprature, humidityLabel, windSpeed, tempratureText, windText, humidityText])
        }
        else {
            setLightStyle(labels: [mainWeather, mainLocation, mainTemprature, highLowTemprature, humidityLabel, windSpeed, tempratureText, windText, humidityText])
        }
    }
}

extension WeatherVC {
    
    func getData() {
        let networkReachability = Reachability.forInternetConnection()
        let networkStatus = networkReachability?.currentReachabilityStatus()
        if networkStatus?.rawValue != NotReachable.rawValue {
            //internet available
            let latitude = UserDefaults.standard.double(forKey: latitudeKey)
            let longitude = UserDefaults.standard.double(forKey: longitudeKey)
            currentWeather = CurrentWeather()
            currentWeather.downloadWeatherDetails(url: getCurrentWeatherURL(latitudeCoords: latitude, longitudeCoords: longitude) ,completionHandler: { (success) in
                if success {
                    //request successful
                    self.downloadSuccesful = true
                    self.forecast.downloadForecastDetails(url: self.getCurrentForecastURL(latitudeCoords: latitude, longitudeCoords: longitude), completionHandler: { (success, forecasts) in
                        self.updateUI()
                        self.setDataFromObject(weather: self.currentWeather)
                        self.forecastsArray = forecasts
                        self.collectionView.reloadData()
                    })
                }
            })
            hideLoaderView(loaderView: loaderView, loader: indicatorView)
        }
        else {
            //internet not available
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            self.showAlert(title: "Error", message: "There is error internet", actions: [action])
            collectionView.reloadData()
            hideLoaderView(loaderView: loaderView, loader: indicatorView)
        }
    }
    
    func initialiseVariables() {
        forecast = Forecast()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    @IBAction func addButtonPressed() {
    
    let vc = storyboard?.instantiateViewController(withIdentifier: "locationListVC")
        navigationController?.pushViewController(vc!, animated: true)
    }
}

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return (topViewController?.preferredStatusBarStyle)!
    }
}

