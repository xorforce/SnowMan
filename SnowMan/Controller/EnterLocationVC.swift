//
//  EnterLocationVC.swift
//  SnowMan
//
//  Created by Bhagat  Singh on 12/03/18.
//  Copyright © 2018 Bhagat Singh. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class EnterLocationVC: UIViewController{

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    var locationForRealm : LocationModel!
    var fromLocationVC : Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.bool(forKey: Constants.firstLaunchKey) == true {
            UserDefaults.standard.set(false, forKey: Constants.firstLaunchKey)
        }
        else {
            performSegue(withIdentifier: "toWeatherVC", sender: self)
        }
        
        let buttonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelVc))
        navigationItem.leftBarButtonItem = buttonItem
        
    }
    
    @objc func cancelVc() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchButton.layer.cornerRadius = 4.0
        searchButton.layer.borderColor = UIColor.black.cgColor
        searchButton.layer.borderWidth = 0.75
        
        if UserDefaults.standard.bool(forKey: Constants.firstLaunchKey) {
            navigationItem.leftBarButtonItem?.isEnabled = false
        }
    }
    
    @IBAction func searchButton(_ sender: Any) {
        geocode { (success) in
            if success {
                self.performSegue(withIdentifier: "toWeatherVC", sender: self)
            }
            else {
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                self.showAlert(title: "Error", message: "There was some error. Try again", actions: [action])
            }
        }
    }
    
    func geocode(completion: @escaping (_ success: Bool) -> Void) {
        if validateText() {
            if let text = locationTextField.text {
                let geocoder = CLGeocoder()
                
                geocoder.geocodeAddressString(text, completionHandler: { (placemarks, error) in
                    if let error = error {
                        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        self.showAlert(title: "Error", message: "Try again. Geolocation could not be done.", actions: [action])
                        print("\(error.localizedDescription)")
                        completion(false)
                    }
                    else {
                        if let placemark = placemarks?[0] {
                            let p = MKPlacemark(placemark: placemark)
                            let latitude = p.coordinate.latitude
                            let longitude = p.coordinate.longitude
                            
                            UserDefaults.standard.set(latitude, forKey: Constants.latitudeKey)
                            UserDefaults.standard.set(longitude, forKey: Constants.longitudeKey)
                            UserDefaults.standard.synchronize()
                            
                            self.locationForRealm = LocationModel(locationString: text, latitude: latitude, longitude: longitude)
                            self.writeToRealm(model: self.locationForRealm)
                            completion(true)
                        }
                    }
                })
            }
        }
    }
    
    func validateText() -> Bool {
        if let text = locationTextField.text {
            print("\(text)")
            return true
        }
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        showAlert(title: "Error", message: "Enter location in text field", actions: [action])
        return false
    }
    
    func writeToRealm(model: LocationModel) {
        RealmService.shared.create(model)
    }
}
