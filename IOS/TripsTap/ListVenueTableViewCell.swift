//
//  ListVenueTableViewCell.swift
//  TripsTap
//
//  Created by Piyawut Kamwiset on 4/2/2558 BE.
//  Copyright (c) 2558 Piyawut Kamwiset. All rights reserved.
//

import UIKit

class ListVenueTableViewCell: UITableViewCell {

    @IBOutlet var labLocation: UILabel!
    @IBOutlet var imagePlace: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
