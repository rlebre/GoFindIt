//
//  AddEventViewController.swift
//  RatingsTest
//
//  Created by Rui Lebre on 12/24/16.
//  Copyright © 2016 Rui Lebre. All rights reserved.
//

import UIKit

class AddEventViewController: UITableViewController {

    @IBOutlet weak var nameTextField: UITextField!
    var event: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        let alert = UIAlertController(title: "Some Title", message: "Enter a text", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = "Some default text"
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(textField?.text)")
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        */
        
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
            
            event = Event(name: nameTextField.text!, location: "", completedBeacons: 0, addedDate: formatter.string(from: date), completedDate: "", rating: 0)
        }
    }
    
    @IBAction func saveBeacons(segue:UIStoryboardSegue) {
        if let registerBeaconsViewController = segue.source as? RegisterBeaconsTableViewController {
            
            if registerBeaconsViewController.beacons != nil {
                //----------------------
                //----------------------
                //----------------------
                //----------------------
                //----------------------
                //----------------------
            }
        }
    }

}
