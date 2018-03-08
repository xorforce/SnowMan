//
//  Constants.swift
//  SnowMan
//
//  Created by Bhagat  Singh on 05/03/18.
//  Copyright © 2018 Bhagat Singh. All rights reserved.
//

import Foundation

let current_base_url = "http://api.openweathermap.org/data/2.5/weather?"
let daily_base_url = "http://api.openweathermap.org/data/2.5/forecast/daily?"
let latitude = "lat="
let longitude = "&lon="
let app_id = "&appid="
let api_key = "a26524e13fd724411501e93ef445f9bc"
let darkModeEnabled = UserDefaults.standard.bool(forKey: "darkMode")

typealias completed = (_ success: Bool) -> ()

let currentWeatherUrl = "\(current_base_url)\(latitude)\(Location.shared.latitude!)\(longitude)\(Location.shared.longitude!)\(app_id)\(api_key)"


let forecastWeatherUrl = "\(daily_base_url)\(latitude)\(Location.shared.latitude!)\(longitude)\(Location.shared.longitude!)&cnt=10&mode=json\(app_id)\(api_key)"
