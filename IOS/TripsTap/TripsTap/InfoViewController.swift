//
//  InfoViewController.swift
//  TripsTap
//
//  Created by Piyawut Kamwiset on 3/25/2558 BE.
//  Copyright (c) 2558 Piyawut Kamwiset. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {


    @IBOutlet var labName: UILabel!
    @IBOutlet var image1: UIImageView!
    @IBOutlet var image2: UIImageView!
    @IBOutlet var image3: UIImageView!
    @IBOutlet var image4: UIImageView!
    @IBOutlet var image5: UIImageView!
    @IBOutlet var image6: UIImageView!
    @IBOutlet var textInfo: UITextView!
    @IBOutlet var viewLoader: UIView!
    
    
    var info : NSDictionary!
    
    var lat : String!
    var lng : String!
    var location : String!
    var phone : String!
    var name : String!
    var rating : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        location = ((info.objectForKey("location") as NSDictionary).objectForKey("formattedAddress") as NSArray).componentsJoinedByString(", ")
//        phone = (info.objectForKey("contact") as NSDictionary).objectForKey("phone") as String
        name = info.objectForKey("name") as String
//        rating = info.objectForKey("rating") as String
        
        if ( (info.objectForKey("contact") as NSDictionary).objectForKey("phone") == nil) {
            phone = "-"
        }
        else{
            phone = (info.objectForKey("contact") as NSDictionary).objectForKey("phone") as String
        }
        labName.text = name
        
        var text = NSString(format: "Location : %@ /n Phone : %@ /n", location, phone) as String
        textInfo.text = text
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
