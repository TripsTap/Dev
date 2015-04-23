//
//  RestaAndHotelTableViewCell.swift
//  TripsTap
//
//  Created by Piyawut Kamwiset on 3/24/2558 BE.
//  Copyright (c) 2558 Piyawut Kamwiset. All rights reserved.
//

import UIKit

class RestaAndHotelTableViewCell: UITableViewCell {

    @IBOutlet var labName: UILabel!
    @IBOutlet var labKM: UILabel!
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
