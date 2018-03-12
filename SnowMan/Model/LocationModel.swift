//
//  LocationModel.swift
//  SnowMan
//
//  Created by Bhagat  Singh on 12/03/18.
//  Copyright © 2018 Bhagat Singh. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class LocationModel : Object {
    
    dynamic var locationString : String! = ""
    let latitude = RealmOptional<Double>()
    let longitude = RealmOptional<Double>()
    
    convenience init(locationString: String, latitude: Double, longitude: Double) {
        self.init()
        self.locationString = locationString
        self.latitude.value = latitude
        self.longitude.value = longitude
    }
    
    
}
