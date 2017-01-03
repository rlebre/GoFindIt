//
//  EventDetailViewController.swift
//  RatingsTest
//
//  Created by Rui Lebre on 12/28/16.
//  Copyright © 2016 Rui Lebre. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDataSource, UITableViewDelegate {

    var event: Event?
    var wasEditted = false
    var indexOnTable: Int?
    
    @IBOutlet weak var label_name: UILabel!
    @IBOutlet weak var label_location: UILabel!
    @IBOutlet weak var label_comp_beacons: UILabel!
    @IBOutlet weak var label_comp_date: UILabel!
    @IBOutlet weak var label_creation_date: UILabel!
    
    @IBOutlet weak var image_main: UIImageView!
    @IBOutlet weak var image_rating: UIImageView!
    
    @IBOutlet weak var beaconsList: UITableView!
    
    let image = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        image.delegate = self
        beaconsList.delegate = self
        beaconsList.dataSource = self
        
        label_name.text = event?.name
        label_location.text = event?.location
        label_creation_date.text = event?.addedDate
        label_comp_date.text = event?.completedBeacons.count == event?.beaconList.count ? event?.completedDate : "Go Find It!"
        label_comp_beacons.text = "\(event!.completedBeacons.count)"
        image_rating.image = imageForRating(rating: (event!.rating))
        image_main.image = event?.mainImage
        
        let ratingTap = UITapGestureRecognizer(target: self, action: #selector(EventDetailViewController.ratingTapDetected))
        ratingTap.numberOfTapsRequired = 1
        image_rating.isUserInteractionEnabled = true
        image_rating.addGestureRecognizer(ratingTap)
        
        let mainImageTap = UITapGestureRecognizer(target: self, action: #selector(EventDetailViewController.mainImageTapDetected))
        mainImageTap.numberOfTapsRequired = 1
        image_main.isUserInteractionEnabled = true
        image_main.addGestureRecognizer(mainImageTap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imageForRating(rating:Int) -> UIImage? {
        var imageName = "\(rating)Stars"
        
        if rating == 0{
            imageName = "\(1)Stars"
        }
        
        return UIImage(named: imageName)
    }
    
    
    
    func ratingTapDetected() {
        wasEditted = true

        event?.rating += 1
        
        if (event?.rating)! > 5 {
            event?.rating = 1
        }
        
        image_rating.image = imageForRating(rating: (event!.rating))
    }
    
    func mainImageTapDetected() {
        wasEditted = true
        
        let alert = UIAlertController(title: "Event Image", message: "Choose from", preferredStyle: .alert)

        
        alert.addAction(UIAlertAction(title: "Photos", style: .default, handler: { (_) in
            self.imageChoser(type: "photos")
        }))

        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
            self.imageChoser(type: "camera")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

    func imageChoser(type: String) {
       
        switch type {
        case "photos":
            image.sourceType = UIImagePickerControllerSourceType.photoLibrary
            break
        case "camera":
            image.sourceType = UIImagePickerControllerSourceType.camera
            break
        default:
            break
        }
        
        image.allowsEditing = false
        
        present(image, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        completion:
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                self.image_main.image = image
                event?.mainImage = image
            }
        
            dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = event?.beaconList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (event?.beaconList.count)!
    }
}
