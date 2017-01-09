//
//  Event.swift
//  RatingsTest
//
//  Created by Rui Lebre on 12/24/16.
//  Copyright © 2016 Rui Lebre. All rights reserved.
//

import UIKit

struct Event {
    
    var id:String?
    var name:String?
    var location :String?
    var completedBeacons: [String]
    var completedDate:String?
    var addedDate: String?
    var rating: Int
    var beaconList: [String]
    var mainImage: UIImage
    var elapsedTime: Int
    var photosReferences: [String]
    
    init(id:String?, name: String?, location: String?, addedDate: String?, completedDate: String?, rating: Int, beaconList:[String], elapsedTime: Int, photoReferences: [String]) {
        self.id = id
        self.name = name
        self.location = location
        self.completedBeacons = []
        self.completedDate = completedDate
        self.addedDate = addedDate
        self.rating = rating
        self.beaconList = beaconList
        self.mainImage = UIImage()
        self.elapsedTime = elapsedTime
        photosReferences = photoReferences
        self.mainImage = self.resizeImage(image: UIImage(named: "tap_to_load")!, newWidth: CGFloat(100))
    }
    
    init(id:String?, name: String?, location: String?, addedDate: String?, completedDate: String?, rating: Int, beaconList:[String], completedBeacons:[String], mainImage:UIImage, elapsedTime: Int, photoReferences: [String]) {
        self.id = id
        self.name = name
        self.location = location
        self.completedBeacons = completedBeacons
        self.completedDate = completedDate
        self.addedDate = addedDate
        self.rating = rating
        self.beaconList = beaconList
        self.mainImage = UIImage()
        self.elapsedTime = elapsedTime
        photosReferences = photoReferences
        self.mainImage = self.resizeImage(image: mainImage, newWidth: CGFloat(100))
    }
    
    init(name: String?, location: String?, addedDate: String?, completedDate: String?, rating: Int, beaconList:[String], elapsedTime: Int, photoReferences: [String]) {
        self.id = NSUUID().uuidString
        self.name = name
        self.location = location
        self.completedBeacons = []
        self.completedDate = completedDate
        self.addedDate = addedDate
        self.rating = rating
        self.beaconList = beaconList
        self.mainImage = UIImage()
        self.elapsedTime = elapsedTime
        photosReferences = photoReferences
        self.mainImage = self.resizeImage(image: UIImage(named: "tap_to_load")!, newWidth: CGFloat(100))
    }
    
    init(name: String?, location: String?, addedDate: String?, completedDate: String?, rating: Int, beaconList:[String], completedBeacons:[String], mainImage:UIImage, elapsedTime: Int, photoReferences: [String]) {
        self.id = NSUUID().uuidString
        self.name = name
        self.location = location
        self.completedBeacons = completedBeacons
        self.completedDate = completedDate
        self.addedDate = addedDate
        self.rating = rating
        self.beaconList = beaconList
        self.mainImage = UIImage()
        self.elapsedTime = elapsedTime
        photosReferences = photoReferences
        self.mainImage = self.resizeImage(image: mainImage, newWidth: CGFloat(100))
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
