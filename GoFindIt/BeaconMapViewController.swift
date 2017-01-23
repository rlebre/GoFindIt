//
//  BeaconMapViewController.swift
//  GoFindIt
//
//  Created by Rui Lebre on 1/23/17.
//  Copyright © 2017 Rui Lebre. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class BeaconMapViewController: UIViewController, MKMapViewDelegate {

    var event: Event?
    
    @IBOutlet weak var beaconMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beaconMap.delegate = self
        beaconMap.mapType = MKMapType.hybrid

        for beacon in (event?.beaconList)! {
            if (beacon.characters.split{$0 == "="}.map(String.init)).count == 2 {
                let beaconId = (beacon.characters.split{$0 == "="}.map(String.init))[0]
                let coordinate = (beacon.characters.split{$0 == "="}.map(String.init))[1]
                let latitude = (coordinate.characters.split{$0 == ","}.map(String.init))[0]
                let longitude = (coordinate.characters.split{$0 == ","}.map(String.init))[1]
                
                let pinLocation = CLLocationCoordinate2DMake(Double(latitude)!, Double(longitude)!)
                
                let dropPin = MKPointAnnotation()
                dropPin.coordinate = pinLocation
                
                if (event?.completedBeacons.contains(beacon))!{
                    dropPin.title = "Checked!"
                } else {
                    dropPin.title = beaconId
                }
                
                beaconMap.addAnnotation(dropPin)
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = "MyIdentifier"
        
        if annotation is MKUserLocation { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.canShowCallout = true
            if (annotationView?.annotation?.title)! == "Checked!" {
                annotationView?.pinTintColor = UIColor.green
            }
        } else {
            annotationView?.annotation = annotation
            annotationView?.canShowCallout = true
            if (annotationView?.annotation?.title)! == "Checked!" {
                annotationView?.pinTintColor = UIColor.green
            }
        }
        return annotationView
    }

}
