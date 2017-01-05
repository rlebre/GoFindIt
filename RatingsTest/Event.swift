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
    var completedBeacons: [String]
    var completedDate:String?
    var addedDate: String?
    var rating: Int
    var beaconList: [String]
    var mainImage: UIImage
    
    
    init(name: String?, location: String?, addedDate: String?, completedDate: String?, rating: Int, beaconList:[String]) {
        self.name = name
        self.location = location
        self.completedBeacons = []
        self.completedDate = completedDate
        self.addedDate = addedDate
        self.rating = rating
        self.beaconList = beaconList
        self.mainImage = UIImage(named: "tap_to_load")!
    }
    
    init(name: String?, location: String?, addedDate: String?, completedDate: String?, rating: Int, beaconList:[String], completedBeacons:[String], mainImage:UIImage) {
        self.name = name
        self.location = location
        self.completedBeacons = completedBeacons
        self.completedDate = completedDate
        self.addedDate = addedDate
        self.rating = rating
        self.beaconList = beaconList
        self.mainImage = mainImage
    }
}
