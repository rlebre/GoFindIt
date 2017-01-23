//
//  EventMapViewController.swift
//  GoFindIt
//
//  Created by Rui Lebre on 1/22/17.
//  Copyright © 2017 Rui Lebre. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import CoreLocation

class EventMapViewController: UIViewController, MKMapViewDelegate {
    // persistence
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var events:[Event] = []
    var selectedEvent:Event?
    
    @IBOutlet weak var mapViewGeneral: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapViewGeneral.delegate = self
        mapViewGeneral.mapType = MKMapType.hybrid
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "goToAddEventFromMap" {
            let temp = (segue.destination as! UINavigationController)
            let dest = temp.topViewController as! AddEventViewController
            dest.caller = "EventMap"
        }
        
        if segue.identifier == "goToEventDetailsFromMap" {
            let temp = (segue.destination as! UINavigationController)
            let dest = temp.topViewController as! EventDetailViewController
            dest.caller = "EventMap"
            dest.event = sender as? Event
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mapViewGeneral.removeAnnotations(mapViewGeneral.annotations)
        events = fetchData()
        populateMap()
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
    
    func populateMap() {
        for event in events {
            let coordinates = (event.location)?.characters.split{$0 == ":"}.map(String.init)[0]
            let latitude = (coordinates?.characters.split{$0 == ","}.map(String.init))?[0]
            let longitude = (coordinates?.characters.split{$0 == ","}.map(String.init))?[1]
            
            let pinLocation = CLLocationCoordinate2DMake(Double(latitude!)!, Double(longitude!)!)
            
            let dropPin = MKPointAnnotation()
            dropPin.coordinate = pinLocation
            dropPin.title = "Name: " + event.name!
            if event.completedDate != "" {
                dropPin.subtitle = "Event Completed!"
            } else {
                dropPin.subtitle = "Elapsed Time: " + "\(String(format: "%02d", event.elapsedTime / 3600)):\(String(format: "%02d", event.elapsedTime % 3600 / 60)):\(String(format: "%02d",(event.elapsedTime % 3600) % 60))"
            }
            
            mapViewGeneral.addAnnotation(dropPin)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = "MyIdentifier"
        
        if annotation is MKUserLocation { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.canShowCallout = true
            if (annotationView?.annotation?.subtitle)! == "Event Completed!" {
                annotationView?.pinTintColor = UIColor.green
            }else{
                annotationView?.pinTintColor = UIColor.yellow
            }
        } else {
            annotationView?.annotation = annotation
            annotationView?.canShowCallout = true
            if (annotationView?.annotation?.subtitle)! == "Event Completed!" {
                annotationView?.pinTintColor = UIColor.green
            }else{
                annotationView?.pinTintColor = UIColor.yellow
            }
        }
        
        annotationView?.calloutOffset = CGPoint(x: -5, y: 5)
        annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView

        return annotationView
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        for event in events {
            let annotationName = (view.annotation?.title)!?.replacingOccurrences(of: "Name: ", with: "")
            
            if event.name == annotationName {
                performSegue(withIdentifier: "goToEventDetailsFromMap", sender: event)
                selectedEvent = event
            }
        }
    }
    
    @IBAction func cancelToEventMapViewController(segue:UIStoryboardSegue) {
        if let editEventViewController = segue.source as? EventDetailViewController {
            
            if editEventViewController.wasEditted {
                if let event = editEventViewController.event {
                    if event.elapsedTime != event.elapsedTime {
                        events.remove(at: editEventViewController.indexOnTable!)
                        
                        removeFromPersistence(id: event.id!)
                        persistEvent(event: event, mainImageBase64: "")
                        events.append(event)
                    }
                }
            }
        }
    }
    
    @IBAction func saveEventMapDetail(segue:UIStoryboardSegue) {
        if let addEventViewController = segue.source as? AddEventViewController {
            
            //add the new event to the events array and write it on storage
            if let event = addEventViewController.event {
                persistEvent(event: event, mainImageBase64: "")
                
                events.append(event)
            }
        }
        
        if let editEventViewController = segue.source as? EventDetailViewController {
            
            if editEventViewController.wasEditted {
                if let event = editEventViewController.event {
                    removeFromPersistence(id: event.id!)
                    persistEvent(event: event, mainImageBase64: editEventViewController.image_main_base64)
                    events.append(event)
                }
            }
        }
    }
}
