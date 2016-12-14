//
//  ViewEventViewController.swift
//  pt.ua.goFindIt
//
//  Created by Rui Lebre on 12/13/16.
//  Copyright © 2016 Rui Lebre. All rights reserved.
//

import UIKit

class ViewEventViewController: UIViewController {

    var mtitle = ""
    var location = ""
    var completedBeacons = ""
    var completedDate = ""
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var completedBeaconsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = mtitle
        locationLabel.text = location
        completedBeaconsLabel.text = completedBeacons
        dateLabel.text = completedDate
    }

    
}
