//
//  ListVenueViewController.swift
//  TripsTap
//
//  Created by Piyawut Kamwiset on 3/30/2558 BE.
//  Copyright (c) 2558 Piyawut Kamwiset. All rights reserved.
//

import UIKit

class ListVenueViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var table: UITableView!
    
    var listPlan : NSDictionary!
    var location : String!
    var listInfo : NSMutableArray!
    var listImage : NSMutableArray!
    var connection : Connection = Connection.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        listInfo = NSMutableArray()
        listImage = NSMutableArray()
        
//        for(var i = 0 ; i < (listPlan.objectForKey("premises") as NSArray).count ; i++){
//            // index of image when func call back
//            let imageAtIndex : Int = i
//            
//            // load image
//            var urlFull : String = listPlan.objectForKey("premises")?.objectAtIndex(i).objectForKey("image") as String
//            var url : String = getUrlImage(urlFull)
//            if(url != ""){
//             loadImage(url, index: imageAtIndex)
//            }
//            
//            
//            // load info
//            var venueID : String = (listPlan.objectForKey("premises") as NSArray).objectAtIndex(i).objectForKey("venueId") as String
//            getInfoVenue(location, venueID: venueID)
//            
//            
//        }
//        
//        
//        
//        
//        for(var i = 0 ; i < (listPlan.objectForKey("conclusion") as NSArray).count ; i++){
//            
//
//            let imageAtIndex : Int = i + (listPlan.objectForKey("premises") as NSArray).count
//            
//            // load image
//            var urlFull : String = listPlan.objectForKey("conclusion")?.objectAtIndex(i).objectForKey("image") as String
//            var url : String = getUrlImage(urlFull)
//            if(url != ""){
//                loadImage(url, index: imageAtIndex)
//            }
//            
//            // load info of eact place
//            var venueID : String = (listPlan.objectForKey("conclusion") as NSArray).objectAtIndex(i).objectForKey("venueId") as String
//            getInfoVenue(location, venueID: venueID)
//            
//            
//            
//        }
    }
    
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


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (listPlan.objectForKey("premises") as NSArray).count + (listPlan.objectForKey("conclusion") as NSArray).count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : ListVenueTableViewCell = tableView.dequeueReusableCellWithIdentifier("ListVenueTableViewCell") as ListVenueTableViewCell
        
        if(indexPath.row < (listPlan.objectForKey("premises") as NSArray).count){
            cell.labLocation.text = (listPlan.objectForKey("premises") as NSArray).objectAtIndex(indexPath.row).objectForKey("venueName") as String
            

            
        }
        else{
            cell.labLocation.text = (listPlan.objectForKey("conclusion") as NSArray).objectAtIndex(indexPath.row  -  (listPlan.objectForKey("premises") as NSArray).count ).objectForKey("vunueName") as String
        }
        
        
        for(var i = 0 ; i < self.listImage.count ; i++ )
        {
            
            if ( listImage.objectAtIndex(i).objectForKey("index") as String == String(format: "%d",indexPath.row  as Int)){
                cell.imageView?.image = listImage.objectAtIndex(i).objectForKey("image") as UIImage
                break
            }
        }

        return cell
    }
    
    
    
    
    
    
    func getUrlImage(urlFull : String)->String{
        var imageArray : NSArray = urlFull.componentsSeparatedByString("oooo") as NSArray
        var url : String!
        for (var i = 0 ; i < imageArray.count ; i++){
            if(((imageArray.objectAtIndex(i)as String).componentsSeparatedByString("-") as NSArray).count == 3)
            {
                
                url = String(format: "%@70x70%@", ((imageArray.objectAtIndex(i)as String).componentsSeparatedByString("-") as NSArray).objectAtIndex(0)as String ,((imageArray.objectAtIndex(i)as String).componentsSeparatedByString("-") as NSArray).objectAtIndex(1) as String)
                return url
            }
        }
        return ""
    }
    
    func getInfoVenue(location : String , venueID : String) -> (){
        
        connection.getInfoVenue(location, venue: venueID  , completion: { (result, error) -> () in
            self.listInfo.addObject(result.objectAtIndex(0))
        })
    }
    
    
    @IBAction func clickBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        var infoView : InfoViewController = segue.destinationViewController as InfoViewController
        
        infoView.pageType = "TripMe"
        var indexPath = self.table.indexPathForSelectedRow()
        
        infoView.location = location
        
        if(indexPath!.row <  (self.listPlan.objectForKey("premises") as NSArray).count as Int ){
            
            // when load info not complete
            infoView.infoOld = (listPlan.objectForKey("premises") as NSArray).objectAtIndex(indexPath!.row) as NSDictionary
            
            for(var i = 0 ; i < self.listInfo.count ; i++ ){
                
                if((listPlan.objectForKey("premises") as NSArray).objectAtIndex(indexPath!.row).objectForKey("venueId") as String == listInfo.objectAtIndex(i).objectForKey("venues")?.objectAtIndex(0).objectForKey("venueId") as String){
                    
                    infoView.info = listInfo.objectAtIndex(i).objectForKey("venues")?.objectAtIndex(0) as NSDictionary

                }
                
            }
        }
        
        else{

            infoView.infoOld = (listPlan.objectForKey("conclusion") as NSArray).objectAtIndex(indexPath!.row - listPlan.objectForKey("premises")!.count) as NSDictionary
            
            for(var i = 0 ; i < self.listInfo.count ; i++ ){
                
                if((listPlan.objectForKey("conclusion") as NSArray).objectAtIndex(indexPath!.row - listPlan.objectForKey("premises")!.count).objectForKey("venueId") as String == listInfo.objectAtIndex(i).objectForKey("venues")?.objectAtIndex(0).objectForKey("venueId") as String){
                    
                    infoView.info = listInfo.objectAtIndex(i).objectForKey("venues")?.objectAtIndex(0) as NSDictionary
                }
                
            }
            
        }
        
        
    }


}
