//
//  RegisterBeaconsTableViewController.swift
//  RatingsTest
//
//  Created by Rui Lebre on 12/26/16.
//  Copyright © 2016 Rui Lebre. All rights reserved.
//

import UIKit

class RegisterBeaconsTableViewController: UITableViewController {

    var beacons: [String] = []
    
    @IBOutlet var tableVIew: UITableView!
    @IBAction func addButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "New Beacon", message: "Enter ID", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = ""
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            self.beacons.append((textField?.text)!)
            self.tableVIew.reloadData()
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
        
        let beacon = beacons[indexPath.row] as String
        cell.textLabel?.text = beacon
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            beacons.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SaveBeaconsList" {
            print("blablabla")
        }
    }

}
