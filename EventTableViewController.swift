//
//  EventTableViewController.swift
//  RatingsTest
//
//  Created by Rui Lebre on 12/24/16.
//  Copyright © 2016 Rui Lebre. All rights reserved.
//

import UIKit
import CoreData

class EventTableViewController: UITableViewController {

    // persistence
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var events:[Event] = []
    var selectedRow: Int = 0
    
    @IBOutlet var mainTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        events = fetchData()
        mainTableView.reloadData()
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
                
                //events.append(event)
                
                let entityDescription = NSEntityDescription.entity(forEntityName: "Events", in: managedObjectContext)
                let persistEvent = Events(entity: entityDescription!, insertInto: managedObjectContext)
                
                persistEvent.name = event.name
                persistEvent.location = event.location
                persistEvent.completedBeacons = event.completedBeacons.joined(separator: ":")
                persistEvent.completedDate = event.completedDate
                persistEvent.addedDate = event.addedDate
                persistEvent.rating = Int16(event.rating)
                persistEvent.beaconList = event.beaconList.joined(separator: ":")
                
                let imageData = UIImagePNGRepresentation(event.mainImage)! as NSData
                
                let imageStr = imageData.base64EncodedString(options: .lineLength64Characters)
                persistEvent.mainImage = imageStr
                
                
                do {
                    try managedObjectContext.save()
                } catch let error {
                    NSLog("ERROR", error.localizedDescription)
                }
                
                //update the tableView
                //let indexPath = NSIndexPath(row: events.count-1, section: 1)
                //tableView.insertRows(at: [indexPath as IndexPath], with: .automatic)
                events.append(event)
                mainTableView.reloadData()
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
    
    func fetchData() -> [Event] {
        var eventsList: [Event] = []
        
        let entityDescription = NSEntityDescription.entity(forEntityName: "Events", in: managedObjectContext)
        
        let request: NSFetchRequest<Events> = Events.fetchRequest()
        request.entity = entityDescription
        
        do {
            let results = try managedObjectContext.fetch(request as! NSFetchRequest<NSFetchRequestResult>)
            
            if results.count <= 0 {
                return []
            }
            print("Matches found: \(results.count)")
            
            for result in results {
                let match = result as! NSManagedObject
                
                let name = match.value(forKey: "name") as? String
                let location = match.value(forKey:"location") as? String
                let addedDate = match.value(forKey:"addedDate") as? String
                let completedDate = match.value(forKey:"completedDate") as? String
                let rating = String(match.value(forKey:"rating") as! Int16)
                
                var aux = match.value(forKey:"beaconList") as? String
                let beaconList = aux?.characters.split{$0 == ":"}.map(String.init)
                
                aux = match.value(forKey:"completedBeacons") as? String
                let completedBeacons = aux?.characters.split{$0 == ":"}.map(String.init)
                
                aux = match.value(forKey:"mainImage") as? String
                let dataDecoded:NSData = NSData(base64Encoded: aux!, options: .ignoreUnknownCharacters)!
                let mainImage = UIImage(data: dataDecoded as Data)!
               
                let event = Event(name: name, location: location, addedDate: addedDate, completedDate: completedDate, rating: Int(rating)!, beaconList: beaconList!, completedBeacons: completedBeacons!, mainImage: mainImage)
                
                eventsList.append(event)
            }
        } catch let error {
            NSLog("ERROR", error.localizedDescription)
            return []
        }
        
        return eventsList
    }

}
