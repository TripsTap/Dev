//
//  TripMeTableViewCell.swift
//  TripsTap
//
//  Created by Piyawut Kamwiset on 3/12/2558 BE.
//  Copyright (c) 2558 Piyawut Kamwiset. All rights reserved.
//

import UIKit

protocol TripMeCellDelegate  {
    func clickCell(index: Int)
}



class TripMeTableViewCell: UITableViewCell, TripMeCellDelegate {

    @IBOutlet weak var labCategoryName: UILabel!
    @IBOutlet var imageCategory: UIImageView!
    @IBOutlet var imageSelect: UIImageView!
    
    var index : Int!
    
    
    var delegate: TripMeCellDelegate?
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:-
    //MARK:  delegate cell
    //MARK:-
    
    
    func clickCell(index: Int) {
        self.delegate?.clickCell(index)
    }
    
    @IBAction func clickSelectCell(sender: AnyObject) {
        self.clickCell(index)
        
    }
    

}
