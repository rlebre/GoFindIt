//
//  EventDetailViewController.swift
//  RatingsTest
//
//  Created by Rui Lebre on 12/28/16.
//  Copyright © 2016 Rui Lebre. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController{

    var event: Event?
    
    @IBOutlet weak var label_name: UILabel!
    @IBOutlet weak var label_location: UILabel!
    @IBOutlet weak var label_comp_beacons: UILabel!
    @IBOutlet weak var label_comp_date: UILabel!
    @IBOutlet weak var label_creation_date: UILabel!
    
    @IBOutlet weak var image_main: UIImageView!
    @IBOutlet weak var image_rating: UIImageView!
    
    @IBOutlet weak var beaconsList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        label_name.text = event?.name
        label_location.text = event?.location
        label_creation_date.text = event?.addedDate
        label_comp_date.text = event?.completedBeacons.count == event?.beaconList.count ? event?.completedDate : "Go Find It!"
        label_comp_beacons.text = "\(event!.completedBeacons.count)"
        image_rating.image = imageForRating(rating: (event!.rating))
        
        let ratingTap = UITapGestureRecognizer(target: self, action: #selector(EventDetailViewController.tapDetected))
        ratingTap.numberOfTapsRequired = 1
        image_rating.isUserInteractionEnabled = true
        image_rating.addGestureRecognizer(ratingTap)
        
        
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
    
    func tapDetected() {
        event?.rating += 1
        
        if (event?.rating)! > 5 {
            event?.rating = 1
        }
        
        image_rating.image = imageForRating(rating: (event!.rating))
    }
}
