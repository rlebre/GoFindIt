//
//  MapViewController.swift
//  RatingsTest
//
//  Created by students@deti on 04/01/2017.
//  Copyright © 2017 Rui Lebre. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate{
    
    @IBOutlet var map: MKMapView!
    //@IBOutlet var map: MKMapView!
    var manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        
        manager.startUpdatingLocation()
        map.mapType = MKMapType.satellite
        
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
        
        map.setRegion(region, animated: false)
        
        
    }
    
    /*
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: map)
            let locationCoordinate = map.convert(position, toCoordinateFrom: map)
            print(locationCoordinate.latitude)
            print(locationCoordinate.longitude)
            
            let pin = MKPointAnnotation()
            pin.coordinate.latitude = CLLocationDegrees(locationCoordinate.latitude)
            pin.coordinate.longitude = CLLocationDegrees(locationCoordinate.longitude)
            pin.title = "Beacon"
            
            map.addAnnotation(pin)
        }
    }
    
    */
    
}

