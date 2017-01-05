//
//  AddEventViewController.swift
//  RatingsTest
//
//  Created by Rui Lebre on 12/24/16.
//  Copyright © 2016 Rui Lebre. All rights reserved.
//

import UIKit
import CoreLocation

class AddEventViewController: UITableViewController {

    @IBOutlet weak var nameTextField: UITextField!
    var event: Event?
    var addedBeacons:[String] = []
    //var loc = CLLocationCoordinate2DMake(0, 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            nameTextField.becomeFirstResponder()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SaveNewEvent" {
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            event = Event(name: nameTextField.text!, location: "", addedDate: formatter.string(from: date), completedDate: "", rating: 0, beaconList: self.addedBeacons)
        }
        
        if segue.identifier == "goToRegisterBeacons" {
            let temp = (segue.destination as! UINavigationController)
            let dest = temp.topViewController as! RegisterBeaconsTableViewController
            dest.beacons = addedBeacons
        }
        /*
        if segue.identifier == "goToLocation" {
            let temp = (segue.destination as! UINavigationController)
            let dest = temp.topViewController as! LocationViewController
            dest.locationCoordinate = loc
            print("loc ")
            
        }*/
    }
    
    
    
    @IBAction func saveBeacons(segue:UIStoryboardSegue) {
        if let registerBeaconsViewController = segue.source as? RegisterBeaconsTableViewController {
            
            if !registerBeaconsViewController.beacons.isEmpty{
               self.addedBeacons=registerBeaconsViewController.beacons
            }
        }
    }

}
