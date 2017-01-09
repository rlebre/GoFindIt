//
//  RegisterBeaconsWirelessTableViewController.swift
//  RatingsTest
//
//  Created by Rui Lebre on 1/3/17.
//  Copyright © 2017 Rui Lebre. All rights reserved.
//

import UIKit
import CoreLocation

class RegisterBeaconsWirelessTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    var foundBeacons: [CLBeacon] = []
    var selectedUIDs: [String] = []
    
    let locationManager = CLLocationManager()
    //let region = CLBeaconRegion(proximityUUID: NSUUID(uuidString: "f7826da6-bc5b71e0-893e656d-336b7a59") as! UUID, identifier: "Beacons")
    let region = CLBeaconRegion(proximityUUID: NSUUID(uuidString: "9e4c5a69-6705-47c1-9564-471c99459331") as! UUID, identifier: "Beacons")
    
    @IBOutlet var uuidTableView: UITableView!
   
    @IBAction func searchButtonPressed(_ sender: Any) {
        uuidTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.startRangingBeacons(in: region)
    }

    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        self.foundBeacons = beacons
        print(beacons)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = String(describing: foundBeacons[indexPath.row].major) + "/" + String(describing: foundBeacons[indexPath.row].minor);
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foundBeacons.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedUIDs.append(String(describing: foundBeacons[indexPath.row].major) + "/" + String(describing: foundBeacons[indexPath.row].minor))
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedUIDs = selectedUIDs.filter{$0 != String(describing: foundBeacons[indexPath.row].major) + "/" + String(describing: foundBeacons[indexPath.row].minor)}
    }
}
