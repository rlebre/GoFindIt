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
    
    var event: Event! {
        didSet {
            dateLabel.text = event.addedDate
            nameLabel.text = event.name
            ratingImageView.image = imageForRating(rating: event.rating)
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
