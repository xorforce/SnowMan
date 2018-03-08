//
//  Location.swift
//  SnowMan
//
//  Created by Bhagat  Singh on 05/03/18.
//  Copyright © 2018 Bhagat Singh. All rights reserved.
//

import Foundation

class Location {
    static var shared = Location()
    private init() {}
    
    var latitude : Double!
    var longitude : Double!
}
