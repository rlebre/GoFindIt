//
//  Event.swift
//  RatingsTest
//
//  Created by Rui Lebre on 12/24/16.
//  Copyright © 2016 Rui Lebre. All rights reserved.
//

import UIKit


struct Event {
    
    var name:String?
    var location :String?
    var completedBeacons:Int
    var completedDate:String?
    var addedDate: String?
    var rating: Int
    
    init(name: String?, location: String?, completedBeacons: Int, addedDate: String?, completedDate: String?, rating: Int) {
        self.name = name
        self.location = location
        self.completedBeacons = completedBeacons
        self.completedDate = completedDate
        self.addedDate = addedDate
        self.rating = rating
    }
}
