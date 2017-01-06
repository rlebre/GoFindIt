//
//  LetsFindItViewController.swift
//  RatingsTest
//
//  Created by Rui Lebre on 1/6/17.
//  Copyright © 2017 Rui Lebre. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class LetsFindItViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate {

    var event: Event?
    
    @IBOutlet weak var mainMap: MKMapView!
    
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelComBeacons: UILabel!
    @IBOutlet weak var labelRemainBeacons: UILabel!
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        
    }
    
    var manager = CLLocationManager()
    var locationCoordinate = CLLocationCoordinate2DMake(0, 0)
    var pin = MKPointAnnotation()
    var loadingmap = false
    
    var timer = Timer()
    var seconds = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        
        manager.startUpdatingLocation()
        mainMap.mapType = MKMapType.hybrid
        mainMap.showsUserLocation = true
        
        var index = 0
        for beacon in (event?.beaconList)! {
            if (beacon.characters.split{$0 == "="}.map(String.init)).count == 2 {
                let beaconId = (beacon.characters.split{$0 == "="}.map(String.init))[0]
                let coordinate = (beacon.characters.split{$0 == "="}.map(String.init))[1]
                let latitude = (coordinate.characters.split{$0 == ","}.map(String.init))[0]
                let longitude = (coordinate.characters.split{$0 == ","}.map(String.init))[1]
                
                let pinLocation = CLLocationCoordinate2DMake(Double(latitude)!, Double(longitude)!)
            
                let dropPin = MKPointAnnotation()
                dropPin.coordinate = pinLocation
                dropPin.title = "\(index) = \(beaconId)"
                mainMap.addAnnotation(dropPin)
                index += 1
            }
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(LetsFindItViewController.updateTime)), userInfo: nil, repeats: true)
        
        labelComBeacons.text = "\((event?.completedBeacons.count)!)"
        labelRemainBeacons.text = "\((event?.beaconList.count)! - (event?.completedBeacons.count)!)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation() // ESTA A PARAR DE OBTER A POSICAO!!!!!
        let userLocation:CLLocation = locations[0]
        let latitude:CLLocationDegrees = userLocation.coordinate.latitude
        let longitude:CLLocationDegrees = userLocation.coordinate.longitude
        let latDelta:CLLocationDegrees = 0.05
        let lonDelta:CLLocationDegrees = 0.05
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        mainMap.setRegion(region, animated: false)
    }
    
    func updateTime() {
        seconds += 1
        labelTime.text = "\(String(format: "%02d", seconds / 3600)): \(String(format: "%02d", seconds % 3600 / 60)):\(String(format: "%02d",(seconds % 3600) % 60))"
    }
}
