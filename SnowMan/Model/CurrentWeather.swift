//
//  CurrentWeather.swift
//  SnowMan
//
//  Created by Bhagat  Singh on 05/03/18.
//  Copyright © 2018 Bhagat Singh. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire
import Reachability

@objcMembers class CurrentWeather : Object {
    
    dynamic var cityName : String! = ""
    dynamic var weatherType : String! = ""
    let currentTemprature = RealmOptional<Double>()
    var min = RealmOptional<Double>()
    var max = RealmOptional<Double>()
    var weatherCode = RealmOptional<Int>()
    var humidity = RealmOptional<Double>()
    var windType = RealmOptional<Double>()
    
    var reachability = Reachability()!
    
    func downloadWeatherDetails(completionHandler: @escaping (_ success: Bool) -> Void) {
        let networkReachability = Reachability.forInternetConnection()
        let networkStatus = networkReachability?.currentReachabilityStatus()
        
        if networkStatus?.rawValue == NotReachable.rawValue {
            completionHandler(false)
        }
        else {
            Alamofire.request(currentWeatherUrl, method: .get).responseJSON { (response) in
                let result = response.result
                
                if let dict = result.value as? Dictionary<String, AnyObject> {
                    
                    if let name = dict["name"] as? String {
                        self.cityName = name.capitalized
                    }
                    
                    if let weather = dict["weather"] as? [Dictionary<String,AnyObject>] {
                        if let type = weather[0]["main"] as? String {
                            self.weatherType = type.capitalized
                        }
                        
                        if let code = weather[0]["id"] as? Int {
                            self.weatherCode.value = code
                        }
                    }
                    
                    if let main = dict["main"] as? Dictionary<String,AnyObject> {
                        if let temp = main["temp"] as? Double {
                            self.currentTemprature.value = self.kelvinToCelcius(temprature: temp)
                        }
                        if let minimum = main["temp_min"] as? Double {
                            self.min.value = self.kelvinToCelcius(temprature: minimum)
                        }
                        if let maximum = main["temp_max"] as? Double {
                            self.max.value = self.kelvinToCelcius(temprature: maximum)
                        }
                        if let humid = main["humidity"] as? Double {
                            self.humidity.value = humid
                        }
                    }
                    
                    if let wind = dict["wind"] as? Dictionary<String,AnyObject> {
                        if let speed = wind["speed"] as? Double {
                            self.windType.value = speed
                        }
                    }
                }
                completionHandler(true)
            }
        }
    }
   
    func kelvinToCelcius(temprature:Double) -> Double{
        let newTemp = Double(round(temprature - 273.15))
        return newTemp
    }
    
    
}
