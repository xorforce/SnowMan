//
//  Forecast.swift
//  SnowMan
//
//  Created by Bhagat  Singh on 06/03/18.
//  Copyright © 2018 Bhagat Singh. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import RealmSwift

class Forecast {
    
    var date : String! = ""
    var high = RealmOptional<Double>()
    var low = RealmOptional<Double>()
    var weatherType : String!
    var weatherCode = RealmOptional<Int>()
    
    func downloadForecastDetails(url: String, completionHandler: @escaping (_ success: Bool, _ forecasts: [Forecast]?) -> Void) {
        var forecasts = [Forecast]()
        let networkReachability = Reachability.forInternetConnection()
        let networkStatus = networkReachability?.currentReachabilityStatus()
        
        if networkStatus?.rawValue == NotReachable.rawValue {
            completionHandler(false, nil)
        }
        else {
            Alamofire.request(url, method: .get).responseJSON { (response) in
                let result = response.result
                
                if let dict = result.value as? Dictionary<String,AnyObject> {
                    if let list = dict["list"] as? [Dictionary<String,AnyObject>] {
                        for obj in list {
                            let forecast = self.buildForecast(weatherDict: obj)
                            forecasts.append(forecast)
                        }
                    }
                }
                completionHandler(true, forecasts)
            }
        }
    }
    
    func buildForecast(weatherDict: Dictionary<String,AnyObject>) -> Forecast {
        
        let tempForecast = Forecast()
        
        if let temp = weatherDict["temp"] as? Dictionary<String,AnyObject> {
            if let min = temp["min"] as? Double {
                 tempForecast.low.value = self.kelvinToCelcius(temprature: min)
            }
            if let max = temp["max"] as? Double {
                tempForecast.high.value = self.kelvinToCelcius(temprature: max)
            }
        }
        
        if let date = weatherDict["dt"] as? Double{
            let unixConvertedDate = Date(timeIntervalSince1970: date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .full
            dateFormatter.timeStyle = .none
            let temp = unixConvertedDate.dayOfTheWeek()
            let index = temp.index(temp.startIndex, offsetBy: 3)
            tempForecast.date = temp.substring(to: index).capitalized
        }
        
        if let weather = weatherDict["weather"] as? [Dictionary<String,AnyObject>]{
            if let main = weather[0]["main"] as? String{
                tempForecast.weatherType = main
            }
            
            if let id = weather[0]["id"] as? Int{
                tempForecast.weatherCode.value = id
            }
        }
        return tempForecast
    }
    
    func kelvinToCelcius(temprature: Double) -> Double{
        let newTemp = Double(round(temprature - 273.15))
        return newTemp
    }
    
}

extension Date {
    func dayOfTheWeek() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
}

