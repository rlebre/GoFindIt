//
//  PickLocationViewController.swift
//  RatingsTest
//
//  Created by Rui Lebre on 1/5/17.
//  Copyright © 2017 Rui Lebre. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SystemConfiguration

class PickLocationViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate {

    var currentCoordinates: String = ""
    var currentCity: String = ""
    
    @IBOutlet weak var mapPickBeacon: MKMapView!
    var manager = CLLocationManager()
    var locationCoordinate = CLLocationCoordinate2DMake(0, 0)
    var pin = MKPointAnnotation()
    var loadingmap = false
    
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
            //print(locationCoordinate.latitude)
            //print(locationCoordinate.longitude)
            
            pin.coordinate.latitude = CLLocationDegrees(locationCoordinate.latitude)
            pin.coordinate.longitude = CLLocationDegrees(locationCoordinate.longitude)
            
            if !loadingmap {
                mapPickBeacon.addAnnotation(pin)
                currentCoordinates = "\(locationCoordinate.latitude),\(locationCoordinate.longitude)"
            }
        
            let status = Reach().connectionStatus()
            switch status {
            case .unknown, .offline:
                currentCity = ""
                break
            case .online(.wwan):
                let geoCoder = CLGeocoder()
                let location = CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
                
                geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                    var placeMark: CLPlacemark!
                    placeMark = placemarks?[0]
                    
                    if let city = placeMark.addressDictionary!["City"] as? NSString {
                        self.currentCity = city as String
                    } else {
                        self.currentCity = ""
                    }
                })
                break
            case .online(.wiFi):
                let geoCoder = CLGeocoder()
                let location = CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
                
                geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                    var placeMark: CLPlacemark!
                    placeMark = placemarks?[0]
                    
                    if let city = placeMark.addressDictionary!["City"] as? NSString {
                        self.currentCity = city as String
                    } else {
                        self.currentCity = ""
                    }
                })
                break
            }
        }
    }
}
