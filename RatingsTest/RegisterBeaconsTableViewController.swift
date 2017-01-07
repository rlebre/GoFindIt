//
//  RegisterBeaconsTableViewController.swift
//  RatingsTest
//
//  Created by Rui Lebre on 12/26/16.
//  Copyright © 2016 Rui Lebre. All rights reserved.
//

import UIKit

class RegisterBeaconsTableViewController: UITableViewController {

    var invoker: String = ""
    
    var beacons: [String] = []
    var selectedRow: Int = 0
    
    @IBAction func donePressed(_ sender: Any) {
        if invoker == "AddViewController" {
            performSegue(withIdentifier: "SaveBeaconsAdd", sender: self)
        }
        
        if invoker == "EditViewController" {
            performSegue(withIdentifier: "SaveBeaconsEdit", sender: self)
        }
    }
    
    @IBOutlet var tableVIew: UITableView!
    @IBAction func addButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "New Beacon", message: "Enter ID", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = ""
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            let text = (textField?.text)!
            
            if text != "" {
                self.beacons.append((textField?.text)!)
                self.tableVIew.reloadData()
            }
        }))
        
        self.present(alert, animated: true, completion: nil)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beacons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BeaconCell", for: indexPath)
        
        let beaconPlusLocation = (beacons[indexPath.row] as String).characters.split{$0 == "="}.map(String.init)
        
        if beaconPlusLocation.count == 1 {
            cell.textLabel?.text = beaconPlusLocation[0]
            cell.detailTextLabel?.text = "Pick Location Please"
        }else if beaconPlusLocation.count == 2 {
            cell.textLabel?.text = beaconPlusLocation[0]
            cell.detailTextLabel?.text = beaconPlusLocation[1]
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            beacons.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow = indexPath.row
        performSegue(withIdentifier: "goToPickBeaconLocation", sender: beacons[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPickBeaconLocation" {
            let temp = (segue.destination as! UINavigationController)
            let dest = temp.topViewController as! PickBeaconLocationViewController
            dest.beaconId = sender as! String
            dest.indexOnTable = self.selectedRow
        }
    }
    
    @IBAction func unwindToRegisterBeacons(segue: UIStoryboardSegue) {
        if let qrScanner = segue.source as? QRScannerController {
            if qrScanner.qr != "" {
                beacons.append(qrScanner.qr)
                tableVIew.reloadData()
            }
        }
        
        if let wirelessScanner = segue.source as? RegisterBeaconsWirelessTableViewController {
            for uid in wirelessScanner.selectedUIDs {
                beacons.append(uid)
            }
            
            tableVIew.reloadData()
        }
        
        if let beaconLocationPickerViewController = segue.source as? PickBeaconLocationViewController {
            
            beacons.remove(at: beaconLocationPickerViewController.indexOnTable)
            beacons.append("\(beaconLocationPickerViewController.beaconId)=\(beaconLocationPickerViewController.currentCoordinates)")
            
            tableVIew.reloadData()
        }
    }

    @IBAction func cancelToRegisterBeacons(segue: UIStoryboardSegue) {
    }
}
