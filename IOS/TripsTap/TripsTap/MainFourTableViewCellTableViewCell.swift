//
//  MainFourTableViewCellTableViewCell.swift
//  TripsTap
//
//  Created by Piyawut Kamwiset on 4/20/2558 BE.
//  Copyright (c) 2558 Piyawut Kamwiset. All rights reserved.
//

import UIKit

class MainFourTableViewCellTableViewCell: UITableViewCell {

    @IBOutlet var imageOne: UIImageView!
    @IBOutlet var labRate: UILabel!
    @IBOutlet var labName: UILabel!
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
