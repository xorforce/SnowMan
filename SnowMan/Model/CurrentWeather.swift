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

class CurrentWeather {
    
    var cityName : String!
    var weatherType : String!
    var currentTemprature : Double!
    var min : Double!
    var max : Double!
    var weatherCode : Int!
    var humidity : Double!
    var windType : Double!
    
    var reachability = Reachability()!
    
    func downloadWeatherDetails(url: String, completionHandler: @escaping (_ success: Bool) -> Void) {
        let networkReachability = Reachability.forInternetConnection()
        let networkStatus = networkReachability?.currentReachabilityStatus()
        
        if networkStatus?.rawValue == NotReachable.rawValue {
            completionHandler(false)
        }
        else {
            Alamofire.request(url, method: .get).responseJSON { (response) in
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
                            self.weatherCode = code
                        }
                    }
                    
                    if let main = dict["main"] as? Dictionary<String,AnyObject> {
                        if let temp = main["temp"] as? Double {
                            self.currentTemprature = self.kelvinToCelcius(temprature: temp)
                        }
                        if let minimum = main["temp_min"] as? Double {
                            self.min = self.kelvinToCelcius(temprature: minimum)
                        }
                        if let maximum = main["temp_max"] as? Double {
                            self.max = self.kelvinToCelcius(temprature: maximum)
                        }
                        if let humid = main["humidity"] as? Double {
                            self.humidity = humid
                        }
                    }
                    
                    if let wind = dict["wind"] as? Dictionary<String,AnyObject> {
                        if let speed = wind["speed"] as? Double {
                            self.windType = speed
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
