//
//  EventCell.swift
//  RatingsTest
//
//  Created by Rui Lebre on 12/24/16.
//  Copyright © 2016 Rui Lebre. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var eventImageView: UIImageView!
    
    var event: Event! {
        didSet {
            dateLabel.text = event.addedDate
            nameLabel.text = event.name
            ratingImageView.image = imageForRating(rating: event.rating)
            eventImageView.image = event.mainImage
            
            if event.completedDate == "" {
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
               
                if event.addedDate == formatter.string(from: date) {
                    statusImageView.image = UIImage(named: "NewEvent")
                }else{
                    statusImageView.image = UIImage(named: "UncheckedEvent")
                }
            } else {
                statusImageView.image = UIImage(named: "CheckedEvent")
            }
        }
    }
    
    func imageForRating(rating:Int) -> UIImage? {
        let imageName = "\(rating)Stars"
        return UIImage(named: imageName)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
