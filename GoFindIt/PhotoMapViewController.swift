//
//  PhotoMapViewController.swift
//  RatingsTest
//
//  Created by Rui Lebre on 1/9/17.
//  Copyright © 2017 Rui Lebre. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class PhotoMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate {
    
    var imageList: [String] = []
    
    var manager = CLLocationManager()
    var locationCoordinate = CLLocationCoordinate2DMake(0, 0)
    var pin = MKPointAnnotation()
    
    @IBOutlet weak var photoMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        photoMap.mapType = MKMapType.hybrid
        photoMap.showsUserLocation = true
        
        
        
        var first = true
        for image in imageList {
            let imageData = image.characters.split{$0 == "="}.map(String.init)
            
            if imageData.count == 2 {
                let reference = imageData[0]
                let latitude = (imageData[1].characters.split{$0 == ","}.map(String.init))[0]
                let longitude = (imageData[1].characters.split{$0 == ","}.map(String.init))[1]
                
                let pinLocation = CLLocationCoordinate2DMake(Double(latitude)!, Double(longitude)!)
                
                let dropPin = MKPointAnnotation()
                dropPin.coordinate = pinLocation
                dropPin.title = reference
                photoMap.addAnnotation(dropPin)
                
                if first {
                    
                    let latDelta:CLLocationDegrees = 0.005
                    let lonDelta:CLLocationDegrees = 0.005
                    let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
                    let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(Double(latitude)!, Double(longitude)!)
                    let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
                    photoMap.setRegion(region, animated: true)

                    //let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude:Double(latitude)!, longitude: Double(longitude)!))
                    //photoMap.setRegion(region, animated: true)
                    
                    first = false
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
           /*
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation() // ESTA A PARAR DE OBTER A POSICAO!!!!!
        let userLocation:CLLocation = locations[0]
        let currentLatitude = userLocation.coordinate.latitude
        self.currentLongitude = userLocation.coordinate.longitude
        let latDelta:CLLocationDegrees = 0.05
        let lonDelta:CLLocationDegrees = 0.05
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(self.currentLatitude, self.currentLongitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        mainMap.setRegion(region, animated: false)
    }

*/
}
