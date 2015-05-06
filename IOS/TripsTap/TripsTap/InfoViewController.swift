//
//  InfoViewController.swift
//  TripsTap
//
//  Created by Piyawut Kamwiset on 3/25/2558 BE.
//  Copyright (c) 2558 Piyawut Kamwiset. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    //MARK:-
    //MARK: IBOutlet
    //MARK:-
    @IBOutlet var labName: UILabel!
    @IBOutlet var image1: UIImageView!
    @IBOutlet var viewIndicator: UIView!
    @IBOutlet var labLocaton: UILabel!
    @IBOutlet var viewMap: UIView!
    @IBOutlet var labRating: UILabel!
    @IBOutlet var labPhone: UILabel!
    @IBOutlet var tableComment: UITableView!
    @IBOutlet var btnMap: UIButton!
    @IBOutlet var btnImage: UIButton!

    //MARK:-
    //MARK: Variable
    //MARK:-
    var connection : Connection!
    var info : NSDictionary! // info of place from FS
    var infoOld : NSDictionary! // info of place from rule
    var lat : Double! // latitude
    var lng : Double! // longtitude
    var location : String! //location thst user select
    var phone : String! = "Phone : " //phone number of place
    var rating : String! //rateing of place
    var pageType: String! //type of page before
    var listComment : NSMutableArray! //list of comment from FS
    var listSizeOfCell : NSMutableArray!
    //MARK:-
    //MARK: Cycel
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listSizeOfCell = NSMutableArray()
        if(pageType == "Near By Restaurant" || pageType == "Near By Hotels"){
            
            setLatAndLng()
            setMap()
            
            
            if info.objectForKey("tips")?.objectForKey("count") as! Int == 0 {
                listComment = NSMutableArray()
            }
            else {
            listComment = NSMutableArray(array: (info.objectForKey("tips")?.objectForKey("groups")?.objectAtIndex(0).objectForKey("items") as! NSMutableArray))
            }
            
            //load image
            loadImage(getUrlImage())
            
            setInfoOfView()
        }
        
            
        else if (pageType == "TripMe" || pageType == "TripForYou"){
            if(info == nil){
                self.btnMap.enabled = false
                connection = Connection.sharedInstance
                listComment = NSMutableArray()
                self.viewIndicator.hidden = false
                var venueID : String
                //load info
                if pageType == "TripMe" {
                    venueID = infoOld.objectForKey("venueId") as! String
                }
                else {
                   venueID = infoOld.objectForKey("VENUE_ID") as! String
                }
                getInfoVenue(venueID)

            }
            else{
                setLatAndLng()
                setMap()
                if info.objectForKey("tips")?.objectForKey("count") as! Int == 0 {
                    listComment = NSMutableArray()
                }
                else {
                    listComment = NSMutableArray(array: (info.objectForKey("tips")?.objectForKey("groups")?.objectAtIndex(0).objectForKey("items") as! NSMutableArray))
                }

                var urlImage : String = getUrlImage()
                loadImage(urlImage)
                
                setInfoOfView()
                
            }
        }
        
        if info == nil {
            btnMap.enabled = false
            btnImage.enabled = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:-
    //MARK: Event button
    //MARK:-
    
    @IBAction func clickBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    //MARK:-
    //MARK: Function
    //MARK:-
    
    /*
    des : load image
    
    para :
        url : url string of image
    */
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

    /*
    des : set latitude and longtitude
    
    para :

    */
    func setLatAndLng(){
        lat = ((info.objectForKey("location") as! NSDictionary).objectForKey("lat") as! NSNumber).doubleValue
        lng = ((info.objectForKey("location") as! NSDictionary).objectForKey("lng") as! NSNumber).doubleValue
    }
    
    /*
    des : set map view
    
    para :
    */
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
    
    /*
    des : get real image url
    
    para :

    */
    func getUrlImage()->String{
        
        var prefix : String = (info.objectForKey("bestPhoto") as! NSDictionary).objectForKey("prefix") as! String
        var suffix : String = (info.objectForKey("bestPhoto") as! NSDictionary).objectForKey("suffix") as! String
        return String(format: "%@500x500%@", prefix,suffix )
    }
    
    
    /*
    des : set info of place
    
    para :
    */
    func setInfoOfView(){
        location = ((info.objectForKey("location") as! NSDictionary).objectForKey("formattedAddress") as! NSArray).componentsJoinedByString(", ")
        
        if info.objectForKey("rating") != nil {
            labRating.text = String(format: "%.1f", (info.objectForKey("rating") as! NSNumber).doubleValue )
        }
        
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
    
    
    /*
    des : load in fo if it donthave data
    
    para :
        venueID : venue id of palce from FS
    */
    func getInfoVenue( venueID : String) -> (){
        
        connection.getInfoFromFoursquare(venueID  , completion: { (result, error) -> () in
           
            if error == nil {

                self.btnMap.enabled = true
                self.btnImage.enabled = true
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
            }
            else {
                self.btnMap.enabled = false
                self.viewIndicator.hidden = true
                UIAlertView(title: "Error occur!", message: "No request available", delegate: self, cancelButtonTitle: "OK").show()
            }
        })
    }
    
    //MARK:-
    //MARK: Table delegate
    //MARK:-
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listComment.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : InfoTableViewCell! = tableView.dequeueReusableCellWithIdentifier("InfoTableViewCell") as! InfoTableViewCell
        cell.labComment.text = listComment.objectAtIndex(indexPath.row).objectForKey("text") as? String

//        var dicSize : NSMutableDictionary = NSMutableDictionary()
//        dicSize.setObject(indexPath.row, forKey: "index")
//        dicSize.setObject(cell.labComment.frame.size.height, forKey: "size")
//        listSizeOfCell.addObject(dicSize)

        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        
        return 50
    }

    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if self.info != nil {
            if(segue.identifier == "MapViewController" ){
                
                var infoArray : NSMutableArray = NSMutableArray()
                infoArray.addObject(self.info)
                
                var mapView : MapViewController = segue.destinationViewController as! MapViewController
                mapView.listInfo = infoArray as NSMutableArray
            }
                
            else{
                var imageView : ImageViewController = segue.destinationViewController as! ImageViewController
                
                imageView.nameLocation = info.objectForKey("name") as? String
                
                if infoOld == nil{
                    imageView.venueID = info.objectForKey("id") as! String
                }
                
                else if infoOld.objectForKey("venueId") != nil {
                    imageView.venueID = infoOld.objectForKey("venueId") as! String
                }
                else{
                    imageView.venueID = info.objectForKey("id") as! String
                }
            }
        }
        

    }


}
