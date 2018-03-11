//
//  WeatherVC.swift
//  SnowMan
//
//  Created by Bhagat  Singh on 05/03/18.
//  Copyright © 2018 Bhagat Singh. All rights reserved.
//

import UIKit
import CoreLocation
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
    @IBOutlet weak var refreshButton: UIButton!
    
    let darkMode = UserDefaults.standard.bool(forKey: "darkMode")
    var locationManager = CLLocationManager()
    var currentLocation : CLLocation!
    var forecast : Forecast!
    var forecastsArray : [Forecast]?
    var currentWeather : CurrentWeather!
    var currentList : Results<CurrentWeather>!
    var currentWeatherFromRealm : CurrentWeather?
    var downloadSuccesful = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showViewAndLoader(view: loaderView, loader: indicatorView, darkMode: darkMode)
        initialiseVariables()
        setupLocationCode()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        performUIUpdates()
        locationAuthStatus()
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
            currentWeather.downloadWeatherDetails(completionHandler: { (success) in
                if success {
                    //request successful
                    self.downloadSuccesful = true
                    self.forecast.downloadForecastDetails(completionHandler: { (success, forecasts) in
                        self.updateUI()
                        self.setDataFromObject(weather: self.currentWeather)
                        self.forecastsArray = forecasts
                        self.collectionView.reloadData()
                        if self.downloadSuccesful {
                            RealmService.shared.create(self.currentWeather)
                            if self.currentList.count > 1 {
                                if let firstObj = self.currentList.first {
                                    RealmService.shared.delete(firstObj)
                                }
                            }
                        }
                    })
                }
            })
        }
        else {
            //internet not available
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            self.showAlert(title: "Error", message: "There is error internet", actions: [action])
            
            //show data from Realm
            if let currentDBObject = currentWeatherFromRealm {
                setDataFromObject(weather: currentDBObject)
                collectionView.isHidden = true
                errorLabel.text = "Connect to internet for Forecast data"
            }
        }
        collectionView.reloadData()
        hideLoaderView(loaderView: loaderView, loader: indicatorView)
    }
    
    func setupLocationCode() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager.location
        }
        else {
            // no location available
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func initialiseVariables() {
        currentWeather = CurrentWeather()
        forecast = Forecast()
        collectionView.dataSource = self
        collectionView.delegate = self
        let realm = RealmService.shared.realm
        currentWeatherFromRealm = realm.objects(CurrentWeather.self).last
        currentList = realm.objects(CurrentWeather.self)
    }
    
    @IBAction func refreshLocation() {
        showViewAndLoader(view: loaderView, loader: indicatorView, darkMode: darkMode)
        locationManager.requestLocation()
    }
}

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return (topViewController?.preferredStatusBarStyle)!
    }
}

