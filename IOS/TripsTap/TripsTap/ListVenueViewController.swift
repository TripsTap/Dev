//
//  ListVenueViewController.swift
//  TripsTap
//
//  Created by Piyawut Kamwiset on 3/30/2558 BE.
//  Copyright (c) 2558 Piyawut Kamwiset. All rights reserved.
//

import UIKit

class ListVenueViewController: UIViewController, UITableViewDelegate,UITableViewDataSource ,ListVenueCellDelegate {

//MARK:-
//MARK:  IBOutlet
//MARK:-
    @IBOutlet var table: UITableView!
    @IBOutlet var btnMap: UIButton!
    @IBOutlet var btnAddTrip: UIButton!
    
    
//MARK:-
//MARK:  variable
//MARK:-
    var dicPlan : NSMutableDictionary!
    var location : String!
    var listInfo : NSMutableArray!
    var listImage : NSMutableArray!
    var connection : Connection = Connection.sharedInstance
    var pageType : String!
    var mainViewController : UIViewController?
    var listPlaceNotSelect : NSMutableArray!
    var addTripAlready : Bool!
    
//MARK:-
//MARK:  cycle
//MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
       
//        self.table.setEditing(true, animated: true)

        
        self.navigationController?.navigationBar.hidden = true
        var storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController : MainViewController = storyBoard.instantiateViewControllerWithIdentifier("MainViewController") as MainViewController
        self.mainViewController = UINavigationController(rootViewController: mainViewController)
        
        listPlaceNotSelect = NSMutableArray()
        if(pageType == "TripMe"){
            btnAddTrip.hidden = false

        }
        else if (pageType == "Main"){
            btnAddTrip.hidden = true
        }
        self.btnMap.enabled = false
        listInfo = NSMutableArray()
        listImage = NSMutableArray()
        addTripAlready = false
        
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
    
    override func viewDidAppear(animated: Bool) {
        if addTripAlready == true {
            self.navigationController?.popToRootViewControllerAnimated(false)
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
        var cell : ListVenueTableViewCell = tableView.dequeueReusableCellWithIdentifier("ListVenueTableViewCell" , forIndexPath: indexPath) as ListVenueTableViewCell
        
        if(indexPath.row < (dicPlan.objectForKey("premises") as NSArray).count){
            cell.labLocation.text = (dicPlan.objectForKey("premises") as NSArray).objectAtIndex(indexPath.row).objectForKey("venueName") as? String
            cell.labRate.text = String(format: "Rate : %@",(dicPlan.objectForKey("premises") as NSArray).objectAtIndex(indexPath.row).objectForKey("rate") as String!)
            
        }
        else{
            cell.labLocation.text = (dicPlan.objectForKey("conclusion") as NSArray).objectAtIndex(indexPath.row  -  (dicPlan.objectForKey("premises") as NSArray).count ).objectForKey("vunueName") as? String
            
            
            cell.labRate.text = String(format: "Rate : %@", (dicPlan.objectForKey("conclusion") as NSArray).objectAtIndex(indexPath.row  -  (dicPlan.objectForKey("premises") as NSArray).count ).objectForKey("rate") as String!)
        }
        
        
        for(var i = 0 ; i < self.listImage.count ; i++ )
        {
            
            if ( listImage.objectAtIndex(i).objectForKey("index") as String == String(format: "%d",indexPath.row  as Int)){
//                cell.imagePlace.layer.cornerRadius = 5.0
//                cell.imagePlace.clipsToBounds = true
                cell.imagePlace?.image = listImage.objectAtIndex(i).objectForKey("image") as? UIImage
                break
            }
        }
        

        if pageType != "Main"{
            
            cell.delegate = self
            cell.index = indexPath.row
            var checkSelect : Bool = false
            for(var i = 0 ; i < self.listPlaceNotSelect.count ; i++){
                if( (listPlaceNotSelect.objectAtIndex(i) as Int) == indexPath.row){
                    checkSelect = true
                }
            }
            
            // not select already
            if (checkSelect){
                cell.imageSelect.backgroundColor = UIColor.redColor()
            }
                
                //  select
            else{
                cell.imageSelect.backgroundColor = UIColor.greenColor()
            }
            
        }
        else{
            cell.imageSelect.hidden = true
            cell.btnSelectPlace.hidden = true
        }
        return cell
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Insert
        
    }
    

    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
//        if pageType  == "Main"{

            return true
//        }
//        else{
//            return false
//        }
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
        // case 1 in premises
        if(sourceIndexPath.row < (dicPlan.objectForKey("premises") as NSArray).count && destinationIndexPath.row < (dicPlan.objectForKey("premises") as NSArray).count ){
            ((dicPlan.objectForKey("premises") as NSMutableArray).insertObject((dicPlan.objectForKey("premises") as NSMutableArray).objectAtIndex(sourceIndexPath.row), atIndex: destinationIndexPath.row))
            (dicPlan.objectForKey("premises") as NSMutableArray).removeObjectAtIndex(sourceIndexPath.row)
            table.reloadData()
        }
        

        // case 2 premiss to conclusion
        
        // case 3 in counclusion
        
        // case 4 conclusion to conclusion
        
//        if(indexPath.row < (dicPlan.objectForKey("premises") as NSArray).count){
//            cell.labLocation.text = (dicPlan.objectForKey("premises") as NSArray).objectAtIndex(indexPath.row).objectForKey("venueName") as? String
//            
//        }
//        else{
//            cell.labLocation.text = (dicPlan.objectForKey("conclusion") as NSArray).objectAtIndex(indexPath.row  -  (dicPlan.objectForKey("premises") as NSArray).count ).objectForKey("vunueName") as? String
//        }
        
        
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
    
    @IBAction func clickAddTrip(sender: AnyObject) {
        
        addTripAlready = true
        var descriptor: NSSortDescriptor = NSSortDescriptor(key: "", ascending: true)
        var listPlaceNotSelectSort : NSArray = NSArray(array: listPlaceNotSelect.sortedArrayUsingDescriptors([descriptor]))
        
        
        var premiss : NSMutableArray = NSMutableArray(array: dicPlan.objectForKey("premises") as NSMutableArray)
        var conclusion : NSMutableArray = NSMutableArray(array: dicPlan.objectForKey("conclusion") as NSMutableArray)
        
        
        
        
        for(var i = 0 ; i < listPlaceNotSelectSort.count ; i++){
            if( (listPlaceNotSelectSort.objectAtIndex(i) as Int) < (dicPlan.objectForKey("premises") as NSArray).count as Int){
                premiss.removeObjectAtIndex(listPlaceNotSelectSort.objectAtIndex(i) as Int - i )
                
            }
        }
        
        var countDelete = 0
        for(var j = 0 ; j < listPlaceNotSelectSort.count ; j++){
            if( (listPlaceNotSelectSort.objectAtIndex(j) as Int) >= (dicPlan.objectForKey("premises") as NSArray).count as Int){
                conclusion.removeObjectAtIndex(listPlaceNotSelectSort.objectAtIndex(j) as Int - countDelete - (dicPlan.objectForKey("premises") as NSArray).count as Int )
                countDelete++
                
            }
        }
        
        var newPlan : NSMutableDictionary = NSMutableDictionary(dictionary: dicPlan)
        newPlan.removeObjectForKey("premises")
        newPlan.removeObjectForKey("conclusion")
        newPlan.setObject(premiss, forKey: "premises")
        newPlan.setObject(conclusion, forKey: "conclusion")
        var rate: String! = getRating(newPlan)
        newPlan.setObject(rate, forKey: "rate")
        
        
        
        var file : PlanFile = PlanFile.sharedInstance
        file.listPlan.addObject(newPlan)
        file.saveFile()
        
        
        self.slideMenuController()?.changeMainViewController(self.mainViewController!, close: true)
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

    
    func getRating(plan : NSMutableDictionary) -> String{
        var sumRate : Double = 0.0
        
        for var i = 0 ; i < (plan.objectForKey("premises")as NSArray).count ; i++ {
            sumRate += (plan.objectForKey("premises")as NSArray).objectAtIndex(i).objectForKey("rate")!.doubleValue
            
        }
        
        for var i = 0 ; i < (plan.objectForKey("conclusion")as NSArray).count ; i++ {
            sumRate += (plan.objectForKey("conclusion")as NSArray).objectAtIndex(i).objectForKey("rate")!.doubleValue
        }
        
        var countPremiese : Int = (plan.objectForKey("premises")as NSArray).count as Int
        var countConclusion : Int = (plan.objectForKey("conclusion")as NSArray).count as Int
        var rateAvg : Double = sumRate / (Double(countConclusion) + Double(countPremiese))
        
        return String(format: "%.2f",rateAvg)
        
    }
    
//MARK:-
//MARK: delegate cell
//MARK:-
    func clickCell(index: Int) {
        
        for(var i = 0 ; i < self.listPlaceNotSelect.count ; i++){
            if( (listPlaceNotSelect.objectAtIndex(i) as Int) == index){
                listPlaceNotSelect.removeObjectAtIndex(i)
                table.reloadData()

                return;
            }
        }
        listPlaceNotSelect.addObject(index)

        table.reloadData()
    }

}
