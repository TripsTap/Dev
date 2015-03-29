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
    @IBOutlet var image7: UIImageView!
    @IBOutlet var textInfo: UITextView!
    
    var conection : Connection!
    
    var info : NSDictionary!
    
    var lat : String!
    var lng : String!
    var location : String!
    var phone : String!
    var name : String!
    var rating : String!
    var pageType: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(pageType == "Restaurant" || pageType == "Hotel"){
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
            
            var prefix : String = (info.objectForKey("bestPhoto") as NSDictionary).objectForKey("prefix") as String
            var suffix : String = (info.objectForKey("bestPhoto") as NSDictionary).objectForKey("suffix") as String
            var urlImage = String(format: "%@250x250%@", prefix,suffix )
            
            loadImage(urlImage)
        }
        
        else if (pageType == "TripMe"){
            location = (info.objectForKey("description") as NSDictionary).objectForKey("address") as String
            textInfo.text = location
            
            name = info.objectForKey("venueName") as String
            labName.text = name
            
            var imageString : String = (info.objectForKey("description") as NSDictionary).objectForKey("photo") as String
            
            var imageArray : NSArray = ((imageString.componentsSeparatedByString("oooo") as NSArray).objectAtIndex(0)as String).componentsSeparatedByString("-") as NSArray
            
            var url : String = String(format: "%@250x250%@", imageArray.objectAtIndex(0)as String ,imageArray.objectAtIndex(1) as String)
        }
        
        
        
        
        
        
        
    }
    
    func loadImage(url : String){
        //         load image
        conection = Connection.sharedInstance
        
//        
        conection.getImage(url, completion: { (image) -> () in
            self.image1.layer.cornerRadius = 10.0
            self.image1.clipsToBounds = true
            self.image1.image = image
        })
        
        
        
        
        
        
//
//        prefix  = (((((info.objectForKey("photos") as NSDictionary).objectForKey("groups") as NSArray).objectAtIndex(0) as NSDictionary).objectForKey("items") as NSArray).objectAtIndex(1) as NSDictionary).objectForKey("prefix") as String
//        suffix  = (((((info.objectForKey("photos") as NSDictionary).objectForKey("groups") as NSArray).objectAtIndex(0) as NSDictionary).objectForKey("items") as NSArray).objectAtIndex(1) as NSDictionary).objectForKey("suffix") as String
//        urlImage = String(format: "%@500x500%@", prefix,suffix )
//        
//        conection.getImage(urlImage, completion: { (image) -> () in
//            self.image2.image = image
//        })
//
//        prefix  = (((((info.objectForKey("photos") as NSDictionary).objectForKey("groups") as NSArray).objectAtIndex(0) as NSDictionary).objectForKey("items") as NSArray).objectAtIndex(2) as NSDictionary).objectForKey("prefix") as String
//        suffix  = (((((info.objectForKey("photos") as NSDictionary).objectForKey("groups") as NSArray).objectAtIndex(0) as NSDictionary).objectForKey("items") as NSArray).objectAtIndex(2) as NSDictionary).objectForKey("suffix") as String
//        urlImage = String(format: "%@100x100%@", prefix,suffix )
//        
//        conection.getImage(urlImage, completion: { (image) -> () in
//            self.image3.image = image
//        })
//        
//        prefix  = (((((info.objectForKey("photos") as NSDictionary).objectForKey("groups") as NSArray).objectAtIndex(0) as NSDictionary).objectForKey("items") as NSArray).objectAtIndex(3) as NSDictionary).objectForKey("prefix") as String
//        suffix  = (((((info.objectForKey("photos") as NSDictionary).objectForKey("groups") as NSArray).objectAtIndex(0) as NSDictionary).objectForKey("items") as NSArray).objectAtIndex(3) as NSDictionary).objectForKey("suffix") as String
//        urlImage = String(format: "%@100x100%@", prefix,suffix )
//        
//        conection.getImage(urlImage, completion: { (image) -> () in
//            self.image4.image = image
//        })
//        
//        prefix  = (((((info.objectForKey("photos") as NSDictionary).objectForKey("groups") as NSArray).objectAtIndex(0) as NSDictionary).objectForKey("items") as NSArray).objectAtIndex(4) as NSDictionary).objectForKey("prefix") as String
//        suffix  = (((((info.objectForKey("photos") as NSDictionary).objectForKey("groups") as NSArray).objectAtIndex(0) as NSDictionary).objectForKey("items") as NSArray).objectAtIndex(4) as NSDictionary).objectForKey("suffix") as String
//        urlImage = String(format: "%@100x100%@", prefix,suffix )
//        
//        conection.getImage(urlImage, completion: { (image) -> () in
//            self.image5.image = image
//        })
//        
//        prefix  = (((((info.objectForKey("photos") as NSDictionary).objectForKey("groups") as NSArray).objectAtIndex(0) as NSDictionary).objectForKey("items") as NSArray).objectAtIndex(5) as NSDictionary).objectForKey("prefix") as String
//        suffix  = (((((info.objectForKey("photos") as NSDictionary).objectForKey("groups") as NSArray).objectAtIndex(0) as NSDictionary).objectForKey("items") as NSArray).objectAtIndex(5) as NSDictionary).objectForKey("suffix") as String
//        urlImage = String(format: "%@100x100%@", prefix,suffix )
//        
//        conection.getImage(urlImage, completion: { (image) -> () in
//            self.image6.image = image
//        })

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
