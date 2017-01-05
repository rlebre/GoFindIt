//
//  PickBeaconLocationViewController.swift
//  RatingsTest
//
//  Created by Rui Lebre on 1/5/17.
//  Copyright © 2017 Rui Lebre. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SystemConfiguration

class PickBeaconLocationViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate {
    
    var beaconId: String = ""
    var indexOnTable: Int = 0
    var currentCoordinates: String = ""
    
    
    
    @IBOutlet weak var mapPickBeacon: MKMapView!
    var manager = CLLocationManager()
    var locationCoordinate = CLLocationCoordinate2DMake(0, 0)
    var pin = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        
        manager.startUpdatingLocation()
        mapPickBeacon.mapType = MKMapType.hybrid
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        let userLocation:CLLocation = locations[0]
        let latitude:CLLocationDegrees = userLocation.coordinate.latitude
        let longitude:CLLocationDegrees = userLocation.coordinate.longitude
        let latDelta:CLLocationDegrees = 0.05
        let lonDelta:CLLocationDegrees = 0.05
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        mapPickBeacon.setRegion(region, animated: false)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: mapPickBeacon)
            mapPickBeacon.removeAnnotation(pin)
            
            locationCoordinate = mapPickBeacon.convert(position, toCoordinateFrom: mapPickBeacon)
            
            pin.coordinate.latitude = CLLocationDegrees(locationCoordinate.latitude)
            pin.coordinate.longitude = CLLocationDegrees(locationCoordinate.longitude)
            
            mapPickBeacon.addAnnotation(pin)
            currentCoordinates = "\(locationCoordinate.latitude),\(locationCoordinate.longitude)"
        }
    }
}

