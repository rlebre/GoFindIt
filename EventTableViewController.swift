//
//  EventTableViewController.swift
//  RatingsTest
//
//  Created by Rui Lebre on 12/24/16.
//  Copyright © 2016 Rui Lebre. All rights reserved.
//

import UIKit

class EventTableViewController: UITableViewController {

    var events:[Event] = eventsData
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell
        let event = events[indexPath.row] as Event
        cell.event = event
        return cell
    }
 
    func imageForRating(rating:Int) -> UIImage? {
        let imageName = "\(rating)Stars"
        return UIImage(named: imageName)
    }
    
    
    @IBAction func cancelToEventTableViewController(segue:UIStoryboardSegue) {
    }
    
    @IBAction func saveEventDetail(segue:UIStoryboardSegue) {
        if let addEventViewController = segue.source as? AddEventViewController {
            
            //add the new event to the events array
            if let event = addEventViewController.event {
                events.append(event)
                
                //update the tableView
                let indexPath = NSIndexPath(row: events.count-1, section: 0)
                tableView.insertRows(at: [indexPath as IndexPath], with: .automatic)
            }
        }
    }

}
