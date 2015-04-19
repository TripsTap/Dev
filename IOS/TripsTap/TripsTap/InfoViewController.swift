//
//  InfoViewController.swift
//  TripsTap
//
//  Created by Piyawut Kamwiset on 3/25/2558 BE.
//  Copyright (c) 2558 Piyawut Kamwiset. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {


    @IBOutlet var labName: UILabel!
    @IBOutlet var image1: UIImageView!
    @IBOutlet var viewIndicator: UIView!
    @IBOutlet var labLocaton: UILabel!
    @IBOutlet var viewMap: UIView!
    @IBOutlet var labRating: UILabel!
    @IBOutlet var labPhone: UILabel!
    @IBOutlet var tableComment: UITableView!
    
    var connection : Connection!
    var info : NSDictionary!
    var infoOld : NSDictionary!
    var lat : Double!
    var lng : Double!
    var location : String!
    var phone : String! = "Phone : "
    var rating : String!
    var pageType: String!
    var listComment : NSMutableArray!
    var listImageComment : NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if(pageType == "Restaurant" || pageType == "Hotel"){
            
            setLatAndLng()
            setMap()
            
            listComment = NSMutableArray(array: info.objectForKey("tips")?.objectForKey("groups")?.objectAtIndex(0).objectForKey("items") as! NSMutableArray)
            
            //load image
            loadImage(getUrlImage())
            
            setInfoOfView()
        }
        
            
        else if (pageType == "TripMe" || pageType == "TripForYou"){
            if(info == nil){
                connection = Connection.sharedInstance
                listComment = NSMutableArray()
                self.viewIndicator.hidden = false
                
                //load info
                var venueID : String = infoOld.objectForKey("venueId") as! String
                getInfoVenue(venueID)

            }
            else{
                setLatAndLng()
                setMap()
                listComment = NSMutableArray(array: info.objectForKey("tips")?.objectForKey("groups")?.objectAtIndex(0).objectForKey("items") as! NSMutableArray)
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
        lat = ((info.objectForKey("location") as! NSDictionary).objectForKey("lat") as! NSNumber).doubleValue
        lng = ((info.objectForKey("location") as! NSDictionary).objectForKey("lng") as! NSNumber).doubleValue
    }
    
    func setMap(){
        
        var camera = GMSCameraPosition.cameraWithLatitude( lat , longitude: lng   , zoom:13)
        var mapView = GMSMapView.mapWithFrame(self.viewMap.bounds, camera:camera)
        mapView.myLocationEnabled = false
        
        var marker = GMSMarker()
        marker.position = camera.target
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.map = mapView
        self.viewMap.addSubview(mapView)
        
        self.viewMap.contentMode = UIViewContentMode.ScaleAspectFill
        
    }
    
    func getUrlImage()->String{
        
        
        var prefix : String = (info.objectForKey("bestPhoto") as! NSDictionary).objectForKey("prefix") as! String
        var suffix : String = (info.objectForKey("bestPhoto") as! NSDictionary).objectForKey("suffix") as! String
        return String(format: "%@500x500%@", prefix,suffix )
    }
    
    
    func setInfoOfView(){
        location = ((info.objectForKey("location") as! NSDictionary).objectForKey("formattedAddress") as! NSArray).componentsJoinedByString(", ")
        
        
        labRating.text = String(format: "%.2f", (info.objectForKey("rating") as! NSNumber).doubleValue )
        
        if ( (info.objectForKey("contact") as! NSDictionary).objectForKey("phone") == nil) {
            phone = "-"
        }
        else{
            phone = (info.objectForKey("contact") as! NSDictionary).objectForKey("phone") as! String
        }
        labName.text = info.objectForKey("name") as? String
        labPhone.text = String(format: "Phone : %@", phone)
        
        var text = NSString(format: "%@", location) as! String
        labLocaton.text = text
        
    }
    
    
    func getInfoVenue( venueID : String) -> (){
        
        
        
        connection.getInfoFromFoursquare(venueID  , completion: { (result, error) -> () in
            self.viewIndicator.hidden = true
            self.info =  ((result.objectForKey("response") as! NSDictionary).objectForKey("venue") as! NSDictionary)
            self.setInfoOfView()
            
            
            self.setLatAndLng()
            self.setMap()
            
            // load image
            var imageUrl : String = self.getUrlImage()
            self.loadImage(imageUrl)
            
            self.listComment = NSMutableArray(array: self.info.objectForKey("tips")?.objectForKey("groups")?.objectAtIndex(0).objectForKey("items") as! NSMutableArray)
            self.tableComment.reloadData()
        })
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listComment.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : InfoTableViewCell! = tableView.dequeueReusableCellWithIdentifier("InfoTableViewCell") as! InfoTableViewCell
        cell.labComment.text = listComment.objectAtIndex(indexPath.row).objectForKey("text") as! String
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }

    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "MapViewController"){
            var infoArray : NSMutableArray = NSMutableArray()
            infoArray.addObject(self.info)
            
            var mapView : MapViewController = segue.destinationViewController as! MapViewController
            mapView.listInfo = infoArray as NSArray
        }
        
        else{
            var imageView : ImageViewController = segue.destinationViewController as! ImageViewController
            if infoOld.objectForKey("venueId") != nil {
                imageView.venueID = infoOld.objectForKey("venueId") as! String
            }
            else{
                imageView.venueID = info.objectForKey("id") as! String
            }
        }
        

    }


}
