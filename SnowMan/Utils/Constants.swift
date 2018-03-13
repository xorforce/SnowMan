//
//  Constants.swift
//  SnowMan
//
//  Created by Bhagat  Singh on 05/03/18.
//  Copyright © 2018 Bhagat Singh. All rights reserved.
//

import Foundation

struct Constants {
    static let current_base_url = "http://api.openweathermap.org/data/2.5/weather?"
    static let daily_base_url = "http://api.openweathermap.org/data/2.5/forecast/daily?"
    static let latitude = "lat="
    static let longitude = "&lon="
    static let app_id = "&appid="
    static let api_key = "a26524e13fd724411501e93ef445f9bc"
    static let defaultLat = 37.7749
    static let defaultLong = 122.4194
    
    typealias completed = (_ success: Bool) -> ()
    
    static let darkModeKey = "darkMode"
    static let firstLaunchKey = "firstLaunch"
    static let latitudeKey = "latitude"
    static let longitudeKey = "longitude"
}






