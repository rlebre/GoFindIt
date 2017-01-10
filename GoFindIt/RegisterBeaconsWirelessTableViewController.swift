//
//  RegisterBeaconsWirelessTableViewController.swift
//  RatingsTest
//
//  Created by Rui Lebre on 1/3/17.
//  Copyright © 2017 Rui Lebre. All rights reserved.
//

import UIKit
import KontaktSDK

class RegisterBeaconsWirelessTableViewController: UITableViewController, KTKEddystoneManagerDelegate {
    
    var foundBeacons: [String] = []
    var selectedUIDs: [String] = []
    
    @IBOutlet var uuidTableView: UITableView!
   
    @IBAction func searchButtonPressed(_ sender: Any) {
        uuidTableView.reloadData()
    }
    
    var eddystoneManager: KTKEddystoneManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eddystoneManager = KTKEddystoneManager(delegate: self)
        eddystoneManager.startEddystoneDiscovery(in: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = String(describing: foundBeacons[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foundBeacons.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedUIDs.append(String(describing: foundBeacons[indexPath.row]))
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedUIDs = selectedUIDs.filter{$0 != String(describing: foundBeacons[indexPath.row])}
    }
    
    func eddystoneManager(_ manager: KTKEddystoneManager, didDiscover eddystones: Set<KTKEddystone>, in region: KTKEddystoneRegion?) {
        foundBeacons = []
        for eddystone in eddystones {
            //print((eddystone.eddystoneUID?.instanceID)!)
            foundBeacons.append((eddystone.eddystoneUID?.instanceID)!)
        }
        tableView.reloadData()
    }
    
    func eddystoneManager(_ manager: KTKEddystoneManager, didUpdate eddystone: KTKEddystone, with frameType: KTKEddystoneFrameType) {
        //print((eddystone.eddystoneUID?.instanceID)!)
    }
}


