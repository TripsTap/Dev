//
//  ListVenueTableViewCell.swift
//  TripsTap
//
//  Created by Piyawut Kamwiset on 4/2/2558 BE.
//  Copyright (c) 2558 Piyawut Kamwiset. All rights reserved.
//

import UIKit
protocol ListVenueCellDelegate  {
    func clickCell(index: Int)
}

class ListVenueTableViewCell: UITableViewCell , ListVenueCellDelegate {

    @IBOutlet var labLocation: UILabel!
    @IBOutlet var imagePlace: UIImageView!
    @IBOutlet var imageSelect: UIImageView!
    @IBOutlet var btnSelectPlace: UIButton!
    @IBOutlet var labRate: UILabel!
    
    var delegate : ListVenueCellDelegate?
    var index : Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func clickCell(index: Int) {
        self.delegate?.clickCell(index)
    }
    
    @IBAction func clickSelectCell(sender: AnyObject) {
        self.clickCell(index)
        
    }

}
