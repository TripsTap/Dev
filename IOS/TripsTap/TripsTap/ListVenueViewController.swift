//
//  ListVenueViewController.swift
//  TripsTap
//
//  Created by Piyawut Kamwiset on 3/30/2558 BE.
//  Copyright (c) 2558 Piyawut Kamwiset. All rights reserved.
//

import UIKit

class ListVenueViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

//MARK:-
//MARK:  IBOutlet
//MARK:-
    @IBOutlet var table: UITableView!
    @IBOutlet var btnMap: UIButton!
    @IBOutlet var btnAddTrip: UIButton!
    
    
//MARK:-
//MARK:  variable
//MARK:-
    var dicPlan : NSDictionary!
    var location : String!
    var listInfo : NSMutableArray!
    var listImage : NSMutableArray!
    var connection : Connection = Connection.sharedInstance
    var pageType : String!
    var mainViewController : UIViewController?
    
//MARK:-
//MARK:  cycle
//MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.navigationController?.navigationBar.hidden = true
        var storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController : MainViewController = storyBoard.instantiateViewControllerWithIdentifier("MainViewController") as MainViewController
        self.mainViewController = UINavigationController(rootViewController: mainViewController)
        
        
        if(pageType == "TripMe"){
            btnAddTrip.hidden = false
        }
        else if (pageType == "Main"){
            btnAddTrip.hidden = true
        }
        self.btnMap.enabled = false
        listInfo = NSMutableArray()
        listImage = NSMutableArray()
        
        for(var i = 0 ; i < (dicPlan.objectForKey("premises") as NSArray).count ; i++){
            // index of image when func call back
            let imageAtIndex : Int = i
            
            // load image
            var urlFull : String = dicPlan.objectForKey("premises")?.objectAtIndex(i).objectForKey("image") as String
            var url : String = getUrlImage(urlFull)
            if(url != ""){
             loadImage(url, index: imageAtIndex)
            }
            
            // load info
            var venueID : String = (dicPlan.objectForKey("premises") as NSArray).objectAtIndex(i).objectForKey("venueId") as String
            getInfoVenue(venueID)
            
        }

        
        for(var i = 0 ; i < (dicPlan.objectForKey("conclusion") as NSArray).count ; i++){
            
            let imageAtIndex : Int = i + (dicPlan.objectForKey("premises") as NSArray).count
            
            // load image
            var urlFull : String = dicPlan.objectForKey("conclusion")?.objectAtIndex(i).objectForKey("image") as String
            var url : String = getUrlImage(urlFull)
            loadImage(url, index: imageAtIndex)

            
            // load info of eact place
            var venueID : String = (dicPlan.objectForKey("conclusion") as NSArray).objectAtIndex(i).objectForKey("venueId") as String
            getInfoVenue(venueID)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
 
    }
    
//MARK:-
//MARK:  table delegate
//MARK:-
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dicPlan.objectForKey("premises") as NSArray).count + (dicPlan.objectForKey("conclusion") as NSArray).count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : ListVenueTableViewCell = tableView.dequeueReusableCellWithIdentifier("ListVenueTableViewCell") as ListVenueTableViewCell
        
        if(indexPath.row < (dicPlan.objectForKey("premises") as NSArray).count){
            cell.labLocation.text = (dicPlan.objectForKey("premises") as NSArray).objectAtIndex(indexPath.row).objectForKey("venueName") as? String
            
        }
        else{
            cell.labLocation.text = (dicPlan.objectForKey("conclusion") as NSArray).objectAtIndex(indexPath.row  -  (dicPlan.objectForKey("premises") as NSArray).count ).objectForKey("vunueName") as? String
        }
        
        
        for(var i = 0 ; i < self.listImage.count ; i++ )
        {
            
            if ( listImage.objectAtIndex(i).objectForKey("index") as String == String(format: "%d",indexPath.row  as Int)){
                cell.imagePlace.layer.cornerRadius = 5.0
                cell.imagePlace.clipsToBounds = true
                cell.imagePlace?.image = listImage.objectAtIndex(i).objectForKey("image") as? UIImage
                break
            }
        }
        return cell
    }
    
//MARK:-
//MARK:  function
//MARK:-
    
    func loadImage(url : String , index : Int){
        
        let imageAtIndex : Int = index
        
        connection.getImage(url, completion: { (image) -> () in
            if(image != nil){
                var data : NSMutableDictionary = NSMutableDictionary()
                data.setObject(String(format: "%d", imageAtIndex), forKey: "index")
                data.setObject(image, forKey: "image")
                self.listImage.addObject(data)
                self.table.reloadData()
            }
        })
    }
    
    func getUrlImage(urlFull : String)->String{
        var imageArray : NSArray = urlFull.componentsSeparatedByString("oooo") as NSArray
        var url : String = ""
        
        println("------------------------")
        var a : NSArray = ((imageArray.objectAtIndex(1)as String).componentsSeparatedByString("-") as NSArray)
        
        for(var i = 0 ; i < a.count - 1 ; i++){
            if(i == 0){
                url += a.objectAtIndex(i) as String
            }
            else if i == 1{
                url += String(format: "100x100%@", a.objectAtIndex(i)as String)
            }
            else{
                url += String(format: "-%@", a.objectAtIndex(i)as String)
            }
            
        }
        return url
    }
    
    func getInfoVenue(venueID : String) -> (){
        
        connection.getInfoFromFoursquare(venueID , completion: { (result, error) -> () in
            self.listInfo.addObject((result.objectForKey("response") as NSDictionary).objectForKey("venue") as NSDictionary)
            
            if(self.listInfo.count == (self.dicPlan.objectForKey("premises") as NSArray).count + (self.dicPlan.objectForKey("conclusion") as NSArray).count){
                
                self.btnMap.enabled = true
            }
        })
    }
    
    
//MARK:-
//MARK: button action
//MARK:-
    
    
    @IBAction func clickBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    

//MARK:-
//MARK: Navigation
//MARK:-
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // click cell
        if(segue.identifier == "InfoView"){
            var infoView : InfoViewController = segue.destinationViewController as InfoViewController
            
            infoView.pageType = "TripMe"
            var indexPath = self.table.indexPathForSelectedRow()
            
            
            if(indexPath!.row <  (self.dicPlan.objectForKey("premises") as NSArray).count as Int ){
                
                // when load info not complete
                infoView.infoOld = (dicPlan.objectForKey("premises") as NSArray).objectAtIndex(indexPath!.row) as NSDictionary
                
                for(var i = 0 ; i < self.listInfo.count ; i++ ){
                    
                    if((dicPlan.objectForKey("premises") as NSArray).objectAtIndex(indexPath!.row).objectForKey("venueId") as String == listInfo.objectAtIndex(i).objectForKey("id") as String){
                        
                        infoView.info = listInfo.objectAtIndex(i) as NSDictionary
                    }
                }
            }
                
            else{
                
                infoView.infoOld = (dicPlan.objectForKey("conclusion") as NSArray).objectAtIndex(indexPath!.row - dicPlan.objectForKey("premises")!.count) as NSDictionary
                
                for(var i = 0 ; i < self.listInfo.count ; i++ ){
                    
                    if((dicPlan.objectForKey("conclusion") as NSArray).objectAtIndex(indexPath!.row - dicPlan.objectForKey("premises")!.count).objectForKey("venueId") as String == listInfo.objectAtIndex(i).objectForKey("id") as String){
                        
                        infoView.info = listInfo.objectAtIndex(i) as NSDictionary
                    }
                }
            }
        }
        
            // click map button
        else if (segue.identifier == "MapViewController"){
            var mapView : MapViewController = segue.destinationViewController as MapViewController
            mapView.listInfo = self.listInfo
            mapView.listImage = self.listImage
        }
        
        
    }

    @IBAction func clickAddTrip(sender: AnyObject) {
        var file : PlanFile = PlanFile.sharedInstance
        file.listPlan.addObject(dicPlan)
        file.saveFile()
        self.navigationController?.popToRootViewControllerAnimated(true)
        
        self.slideMenuController()?.changeMainViewController(self.mainViewController!, close: true)
    }

}
