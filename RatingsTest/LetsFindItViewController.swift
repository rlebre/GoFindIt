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

class LetsFindItViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate {

    var event: Event?
    
    @IBOutlet weak var mainMap: MKMapView!
    
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelComBeacons: UILabel!
    @IBOutlet weak var labelRemainBeacons: UILabel!
    
    var  currentLatitude:CLLocationDegrees = 0.0
    var currentLongitude:CLLocationDegrees = 0.0
    
    let image = UIImagePickerController()
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        present(image, animated: true, completion: nil)
    }
    
    var manager = CLLocationManager()
    var locationCoordinate = CLLocationCoordinate2DMake(0, 0)
    var pin = MKPointAnnotation()
    var loadingmap = false
    
    var timer = Timer()
    var seconds = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.camera
        image.allowsEditing = false
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        mainMap.mapType = MKMapType.hybrid
        mainMap.showsUserLocation = true
        seconds = (event?.elapsedTime)!
        labelTime.text = "\(String(format: "%02d", (event?.elapsedTime)! / 3600)):\(String(format: "%02d", (event?.elapsedTime)! % 3600 / 60)):\(String(format: "%02d",((event?.elapsedTime)! % 3600) % 60))"
        
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
        self.currentLatitude = userLocation.coordinate.latitude
        self.currentLongitude = userLocation.coordinate.longitude
        let latDelta:CLLocationDegrees = 0.05
        let lonDelta:CLLocationDegrees = 0.05
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(self.currentLatitude, self.currentLongitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        mainMap.setRegion(region, animated: false)
    }
    
    func updateTime() {
        seconds += 1
        labelTime.text = "\(String(format: "%02d", seconds / 3600)):\(String(format: "%02d", seconds % 3600 / 60)):\(String(format: "%02d",(seconds % 3600) % 60))"
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        completion:
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            /*let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as? String
                // self.fileName is whatever the filename that you need to append to base directory here.
                let path = documentsDirectory.stringByAppendingPathComponent(self.fileName)
                let success = data.writeToFile(path, atomically: true)
                if !success { // handle error
                }*/
                saveImageDocumentDirectory(image: image)
            }
        
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToScanQrCode" {
            let temp = (segue.destination as! QRScannerController)
            temp.invoker = "LetsFindItViewController"
        }else if segue.identifier == "stopEventRunning" {
            event?.elapsedTime = seconds
            seconds = 0
            timer = Timer()
        }
    }
    
    @IBAction func qrScanCompleted(segue: UIStoryboardSegue) {
        if let qrScanner = segue.source as? QRScannerController {
            print(qrScanner)
        }
    }
    
    func saveImageDocumentDirectory(image: UIImage){
        let fileManager = FileManager.default
        let imageUUID = "IMG_" + NSUUID().uuidString
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent((event?.id)! + "/" + imageUUID)
        print(paths)
        let imageData = UIImageJPEGRepresentation(image, 0.5)
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
        self.event?.photosReferences.append(imageUUID + "=" + "\(self.currentLatitude),\(self.currentLongitude)")
    }
}
