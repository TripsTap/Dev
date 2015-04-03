//
//  MainTwoTableViewCell.swift
//  TripsTap
//
//  Created by Piyawut Kamwiset on 3/30/2558 BE.
//  Copyright (c) 2558 Piyawut Kamwiset. All rights reserved.
//

import UIKit

class MainTwoTableViewCell: UITableViewCell {

    @IBOutlet var imageOne: UIImageView!

    @IBOutlet var imageTwo: UIImageView!
    @IBOutlet var imageThree: UIImageView!
    
    @IBOutlet var labCountRate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
