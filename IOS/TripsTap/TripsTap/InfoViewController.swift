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
    @IBOutlet var viewIndicator: UIView!
    @IBOutlet var labLocaton: UILabel!
    @IBOutlet var viewMap: UIView!
    @IBOutlet var labRating: UILabel!
    
    @IBOutlet var labPhone: UILabel!
    
    var connection : Connection!
    var info : NSDictionary!
    var infoOld : NSDictionary!
    var lat : Double!
    var lng : Double!
    var location : String!
    var phone : String! = "Phone : "

    var rating : String!
    var pageType: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if(pageType == "Restaurant" || pageType == "Hotel"){
            
            setLatAndLng()
            setMap()
            
            
            //load image
            loadImage(getUrlImage())
            
            setInfoOfView()
        }
        
            
        else if (pageType == "TripMe"){
            if(info == nil){
                self.viewIndicator.hidden = false
                
                setLatAndLng()
                setMap()
                
                // load image
                var imageUrl : String = getUrlImage()
                loadImage(imageUrl)
                
                //load info
                var venueID : String = infoOld.objectForKey("venueId") as String
                getInfoVenue(location, venueID: venueID)

            }
            else{
                setLatAndLng()
                setMap()
                
                var urlImage : String = getUrlImage()
                loadImage(urlImage)
                
                setInfoOfView()
                
            }
        }
        
        
        
        
        
        
        
    }
    
    
    
    func loadImage(url : String){
        //         load image
        connection = Connection.sharedInstance
        
        connection.getImage(url, completion: { (image) -> () in
            if(image != nil){
                self.image1.contentMode = UIViewContentMode.ScaleAspectFill
                self.image1.layer.cornerRadius = 20.0
                self.image1.clipsToBounds = true
                self.image1.image = image
                self.setInfoOfView()
            }
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    func setLatAndLng(){
        lat = ((info.objectForKey("location") as NSDictionary).objectForKey("lat") as NSNumber).doubleValue
        lng = ((info.objectForKey("location") as NSDictionary).objectForKey("lng") as NSNumber).doubleValue
    }
    
    func setMap(){
        
        var camera = GMSCameraPosition.cameraWithLatitude( lat , longitude: lng   , zoom:13)
        var mapView = GMSMapView.mapWithFrame(self.viewMap.bounds, camera:camera)
        mapView.myLocationEnabled = false
        
        var marker = GMSMarker()
        marker.position = camera.target
//        marker.snippet = info.objectForKey("name") as String
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.map = mapView
        self.viewMap.addSubview(mapView)
        
        self.viewMap.contentMode = UIViewContentMode.ScaleAspectFill
        self.viewMap.layer.cornerRadius = 10.0
        self.viewMap.clipsToBounds = true
        
        
    }
    
    func getUrlImage()->String{
        
        
        var prefix : String = (info.objectForKey("bestPhoto") as NSDictionary).objectForKey("prefix") as String
        var suffix : String = (info.objectForKey("bestPhoto") as NSDictionary).objectForKey("suffix") as String
        return String(format: "%@500x500%@", prefix,suffix )
//        if(pageType == "TripMe"){
//            
//            var imageArray : NSArray = urlFull.componentsSeparatedByString("oooo") as NSArray
//            var url : String = ""
//            let diceRoll = Int(arc4random_uniform(3))
//            
//            println(diceRoll)
//            var a : NSArray = ((imageArray.objectAtIndex(diceRoll)as String).componentsSeparatedByString("-") as NSArray)
//            
//            for(var i = 0 ; i < a.count - 1 ; i++){
//                if(i == 0){
//                    url += a.objectAtIndex(i) as String
//                }
//                else if i == 1{
//                    url += String(format: "%@%@",a.objectAtIndex(a.count - 1)as String, a.objectAtIndex(i)as String)
//                }
//                else{
//                    url += String(format: "-%@", a.objectAtIndex(i)as String)
//                }
//                
//            }
//            return url
//
//        }
//        else{
//            return ""
//        }
    }
    
    
    func setInfoOfView(){
        location = ((info.objectForKey("location") as NSDictionary).objectForKey("formattedAddress") as NSArray).componentsJoinedByString(", ")
        
        
        labRating.text = (info.objectForKey("rating") as NSNumber).stringValue
        
        if ( (info.objectForKey("contact") as NSDictionary).objectForKey("phone") == nil) {
            phone = "-"
        }
        else{
            phone = (info.objectForKey("contact") as NSDictionary).objectForKey("phone") as String
        }
        labName.text = info.objectForKey("name") as String
        labName.sizeToFit()
        labPhone.text = String(format: "Phone : %@", phone)
        
        var text = NSString(format: "%@", location) as String
        labLocaton.text = text
        
    }
    
    
    func getInfoVenue(location : String , venueID : String) -> (){
        
        connection.getInfoVenue(location, venue: venueID  , completion: { (result, error) -> () in
            self.viewIndicator.hidden = true
            self.info = (result.objectAtIndex(0) as NSDictionary).objectForKey("venues") as NSDictionary
            self.setInfoOfView()
        })
    }
    
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var infoArray : NSMutableArray = NSMutableArray()
        infoArray.addObject(self.info)
        
        var mapView : MapViewController = segue.destinationViewController as MapViewController
        mapView.listInfo = infoArray as NSArray
        

    }


}
