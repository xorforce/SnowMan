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
let defaultLat = 37.7749
let defaultLong = 122.4194

typealias completed = (_ success: Bool) -> ()

let darkModeKey = "darkMode"
let firstLaunchKey = "firstLaunch"
let latitudeKey = "latitude"
let longitudeKey = "longitude"


