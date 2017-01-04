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
    var selectedRow: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow = indexPath.row
        performSegue(withIdentifier: "goToEventDetail", sender: events[indexPath.row])
      //  prepare(for: "goToEventDetail", sender: events[indexPath.row])
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
        
        if let editEventViewController = segue.source as? EventDetailViewController {
            
            //add the new event to the events array
            if editEventViewController.wasEditted {
                if let event = editEventViewController.event {
                    events.append(event)
                    events.remove(at: editEventViewController.indexOnTable!)
                    //update the tableView
                    /*
                     var indexPath = NSIndexPath(row: editEventViewController.indexOnTable!, section: 2)
                     tableView.deleteRows(at: [indexPath as IndexPath], with: .automatic)
                
                     indexPath = NSIndexPath(row: events.count-1, section: 0)
                     tableView.insertRows(at: [indexPath as IndexPath], with: .automatic)
                     */
                
                    tableView.reloadData()
                }
            }
        }

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEventDetail" {
            let temp = (segue.destination as! UINavigationController)
            let dest = temp.topViewController as! EventDetailViewController
            dest.event = sender as? Event
            dest.indexOnTable = self.selectedRow
        }
    }

}
