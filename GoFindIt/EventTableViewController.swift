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
        
        if events[indexPath.row].completedDate != "" {
            cell.backgroundColor = UIColor(red: 135/255, green: 211/255, blue: 124/255, alpha: 0.3);
            //let swiftColor = UIColor(red: 1, green: 165/255, blue: 0, alpha: 1)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow = indexPath.row
        performSegue(withIdentifier: "goToEventDetail", sender: events[indexPath.row])
      //  prepare(for: "goToEventDetail", sender: events[indexPath.row])
    }
 
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            removeFromPersistence(id: events[indexPath.row].id!)
            events.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func imageForRating(rating:Int) -> UIImage? {
        let imageName = "\(rating)Stars"
        return UIImage(named: imageName)
    }
    
    
    @IBAction func cancelToEventTableViewController(segue:UIStoryboardSegue) {
        if let editEventViewController = segue.source as? EventDetailViewController {
            
            if editEventViewController.wasEditted {
                if let event = editEventViewController.event {
                    if event.elapsedTime != events[selectedRow].elapsedTime {
                        events.remove(at: editEventViewController.indexOnTable!)
                    
                        removeFromPersistence(id: event.id!)
                        persistEvent(event: event, mainImageBase64: "")
                        events.append(event)
                    
                        tableView.reloadData()
                    }
                }
            }
        }
    }
    
    @IBAction func saveEventDetail(segue:UIStoryboardSegue) {
        if let addEventViewController = segue.source as? AddEventViewController {
            
            //add the new event to the events array and write it on storage
            if let event = addEventViewController.event {
                persistEvent(event: event, mainImageBase64: "")
                
                events.append(event)
                mainTableView.reloadData()
            }
        }
        
        if let editEventViewController = segue.source as? EventDetailViewController {
            
            if editEventViewController.wasEditted {
                if let event = editEventViewController.event {
                    events.remove(at: editEventViewController.indexOnTable!)

                    removeFromPersistence(id: event.id!)
                    persistEvent(event: event, mainImageBase64: editEventViewController.image_main_base64)
                    events.append(event)
                    
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
                
                let id = match.value(forKey: "id") as? String
                let name = match.value(forKey: "name") as? String
                let location = match.value(forKey:"location") as? String
                let addedDate = match.value(forKey:"addedDate") as? String
                let completedDate = match.value(forKey:"completedDate") as? String
                let rating = String(match.value(forKey:"rating") as! Int16)
                
                var aux = match.value(forKey:"beaconList") as? String
                let beaconList = aux?.characters.split{$0 == ":"}.map(String.init)
                
                aux = match.value(forKey:"completedBeacons") as? String
                let completedBeacons = aux?.characters.split{$0 == ":"}.map(String.init)
                
                aux = match.value(forKey:"photoReferences") as? String
                let photoReferences = aux?.characters.split{$0 == ":"}.map(String.init)
                
                aux = match.value(forKey:"mainImage") as? String
                let dataDecoded:NSData = NSData(base64Encoded: aux!, options: .ignoreUnknownCharacters)!
                let mainImage = UIImage(data: dataDecoded as Data)!
                
                let elapsedTime = Int(match.value(forKey:"elapsedTime") as! Int32)
               
                let event = Event(id: id, name: name, location: location, addedDate: addedDate, completedDate: completedDate, rating: Int(rating)!, beaconList: beaconList!, completedBeacons: completedBeacons!, mainImage: mainImage, elapsedTime: elapsedTime, photoReferences: photoReferences!)
                
                eventsList.append(event)
            }
        } catch let error {
            NSLog("ERROR", error.localizedDescription)
            return []
        }
        
        return eventsList
    }

    func persistEvent(event: Event, mainImageBase64:String) {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Events", in: managedObjectContext)
        let persistEvent = Events(entity: entityDescription!, insertInto: managedObjectContext)
        
        persistEvent.id = event.id
        persistEvent.name = event.name
        persistEvent.location = event.location
        persistEvent.completedBeacons = event.completedBeacons.joined(separator: ":")
        persistEvent.completedDate = event.completedDate
        persistEvent.addedDate = event.addedDate
        persistEvent.rating = Int16(event.rating)
        persistEvent.beaconList = event.beaconList.joined(separator: ":")
        persistEvent.elapsedTime = Int32(event.elapsedTime)
        persistEvent.photoReferences = event.photosReferences.joined(separator: ":")
        
        if mainImageBase64 == "" {
            let imageData = UIImagePNGRepresentation(event.mainImage)! as NSData
            let imageStr = imageData.base64EncodedString(options: .lineLength64Characters)
            persistEvent.mainImage = imageStr
        } else {
            persistEvent.mainImage = mainImageBase64
        }
        
        DispatchQueue.global(qos: .background).async {
            do {
                try self.managedObjectContext.save()
            } catch let error {
                NSLog("ERROR", error.localizedDescription)
            }
            print("Object saved!")
        }
    }
    
    func removeFromPersistence(id: String) {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Events", in: managedObjectContext)
        
        let request: NSFetchRequest<Events> = Events.fetchRequest()
        request.entity = entityDescription
        
        do {
            let results = try managedObjectContext.fetch(request as! NSFetchRequest<NSFetchRequestResult>)
            
            for result in results {
                let match = result as! NSManagedObject
                let idPersistence = match.value(forKey: "id") as? String
            
                if idPersistence == id {
                    managedObjectContext.delete(result as! NSManagedObject)
                }
            }
            
            try managedObjectContext.save()
        } catch let error {
            NSLog("ERROR", error.localizedDescription)
        }
    }
}
