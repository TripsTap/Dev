//
//  ListVenueViewController.swift
//  TripsTap
//
//  Created by Piyawut Kamwiset on 3/30/2558 BE.
//  Copyright (c) 2558 Piyawut Kamwiset. All rights reserved.
//

import UIKit

class ListVenueViewController: UIViewController, UITableViewDelegate,UITableViewDataSource ,ListVenueCellDelegate , UIAlertViewDelegate {

//MARK:-
//MARK:  IBOutlet
//MARK:-
    @IBOutlet var table: UITableView!
    @IBOutlet var btnMap: UIButton!
    @IBOutlet var btnAddTrip: UIButton!
    @IBOutlet var labNameTrip: UILabel!
    
    
//MARK:-
//MARK:  variable
//MARK:-
    
    var dicPlan : NSMutableDictionary!  // info from page before
    var listInfo : NSMutableArray!      // load info from FS
    var listImage : NSMutableArray!
    var connection : Connection = Connection.sharedInstance //HTTP request
    var pageType : String!
    var mainViewController : UIViewController?
    var listPlaceNotSelect : NSMutableArray! // place that user dont choose
    var addTripAlready : Bool!  // bool that check user add trip already
    var indexPlan : Int? // index of plan that user select
    
//MARK:-
//MARK:  cycle
//MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.hidden = true
        var storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController : MainViewController = storyBoard.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
        self.mainViewController = UINavigationController(rootViewController: mainViewController)
       
        
        listPlaceNotSelect = NSMutableArray()
        // hide "get trip" btn
        if(pageType == "TripMe" || pageType == "TripForYou"){
            btnAddTrip.setTitle("Create Trip", forState: UIControlState.Normal)

        }
        else if (pageType == "Main"){
            btnAddTrip.setTitle("Share With Facebook", forState: UIControlState.Normal)

            var name : String? = dicPlan.objectForKey("tripname") as? String
            if name == nil {
                labNameTrip.text = "Trip"
            }
            else {
                labNameTrip.text = name
            }
        }
        
        self.btnMap.enabled = false
        listInfo = NSMutableArray()
        listImage = NSMutableArray()
        addTripAlready = false
        
        
        // get info from FS
        if(pageType == "TripForYou" || dicPlan.objectForKey("type") as? String == "TripForYou"){
            
            allocArray((dicPlan.objectForKey("user_checkin") as! NSArray).count)
            
            for(var i = 0 ; i < (dicPlan.objectForKey("user_checkin") as! NSArray).count ; i++){
                // index of image when func call back
                let imageAtIndex : Int = i
                
                // load image
                var urlFull : String = dicPlan.objectForKey("user_checkin")?.objectAtIndex(i).objectForKey("PHOTO") as! String
                var url : String = getUrlImage(urlFull)
                if(url != ""){
                    loadImage(url, index: imageAtIndex)
                }
                
                // load info
                var venueID : String = (dicPlan.objectForKey("user_checkin") as! NSArray).objectAtIndex(i).objectForKey("VENUE_ID") as! String
                getInfoVenue(venueID , index: i)
                
            }

            
        }
        
        else{
            
            var countPlan : Int = (dicPlan.objectForKey("premises") as! NSArray).count + (dicPlan.objectForKey("conclusion") as! NSArray).count
            
            allocArray(countPlan)
            
            for(var i = 0 ; i < (dicPlan.objectForKey("premises") as! NSArray).count ; i++){
                // index of image when func call back
                let imageAtIndex : Int = i
                
                // load image
                var urlFull : String = dicPlan.objectForKey("premises")?.objectAtIndex(i).objectForKey("image") as! String
                var url : String = getUrlImage(urlFull)
                if(url != ""){
                    loadImage(url, index: imageAtIndex)
                }
                
                // load info
                var venueID : String = (dicPlan.objectForKey("premises") as! NSArray).objectAtIndex(i).objectForKey("venueId") as! String
                getInfoVenue(venueID , index: i)
                
            }
            
            
            for(var i = 0 ; i < (dicPlan.objectForKey("conclusion") as! NSArray).count ; i++){
                
                let imageAtIndex : Int = i + (dicPlan.objectForKey("premises") as! NSArray).count
                
                // load image
                var urlFull : String = dicPlan.objectForKey("conclusion")?.objectAtIndex(i).objectForKey("image") as! String
                var url : String = getUrlImage(urlFull)
                loadImage(url, index: imageAtIndex)
                
                
                // load info of eact place
                var venueID : String = (dicPlan.objectForKey("conclusion") as! NSArray).objectAtIndex(i).objectForKey("venueId") as! String
                getInfoVenue(venueID, index: imageAtIndex)
                
            }
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
        if pageType == "TripForYou" || dicPlan.objectForKey("type") as? String == "TripForYou"  {
            return dicPlan.objectForKey("user_checkin")!.count 
        }
        else{
            return (dicPlan.objectForKey("premises") as! NSArray).count + (dicPlan.objectForKey("conclusion") as! NSArray).count
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : ListVenueTableViewCell = tableView.dequeueReusableCellWithIdentifier("ListVenueTableViewCell" , forIndexPath: indexPath) as! ListVenueTableViewCell
        
        
        if pageType == "TripForYou" || dicPlan.objectForKey("type") as? String == "TripForYou" {
            
            var rate : String = String(format: "Rating : %@", dicPlan.objectForKey("user_checkin")?.objectAtIndex(indexPath.row).objectForKey("RATE") as! String )
            var locationString : String = (dicPlan.objectForKey("user_checkin")?.objectAtIndex(indexPath.row).objectForKey("VENUE_NAME") as? String)!
            cell.labLocation.text = locationString
            cell.labRate.text = rate
            
        }
        
            // Trip me plan
        else {
            
            if(indexPath.row < (dicPlan.objectForKey("premises") as! NSArray).count){
                
                if((dicPlan.objectForKey("premises") as! NSArray).objectAtIndex(indexPath.row).objectForKey("venueName") as? String == nil){
                    cell.labLocation.text = (dicPlan.objectForKey("premises") as! NSArray).objectAtIndex(indexPath.row).objectForKey("vunueName") as? String
                }
                else{
                    cell.labLocation.text = (dicPlan.objectForKey("premises") as! NSArray).objectAtIndex(indexPath.row).objectForKey("venueName") as? String
                }
                
                cell.labRate.text = String(format: "Rating : %@",(dicPlan.objectForKey("premises") as! NSArray).objectAtIndex(indexPath.row).objectForKey("rate") as! String!)
                
            }
            else{
                
                if ((dicPlan.objectForKey("conclusion") as! NSArray).objectAtIndex(indexPath.row  -  (dicPlan.objectForKey("premises") as! NSArray).count ).objectForKey("vunueName") as? String == nil){
                    
                    cell.labLocation.text = (dicPlan.objectForKey("conclusion") as! NSArray).objectAtIndex(indexPath.row  -  (dicPlan.objectForKey("premises") as! NSArray).count ).objectForKey("venueName") as? String
                    
                }
                else{
                    cell.labLocation.text = (dicPlan.objectForKey("conclusion") as! NSArray).objectAtIndex(indexPath.row  -  (dicPlan.objectForKey("premises") as! NSArray).count ).objectForKey("vunueName") as? String
                }
                
                
                cell.labRate.text = String(format: "Rating : %@", (dicPlan.objectForKey("conclusion") as! NSArray).objectAtIndex(indexPath.row  -  (dicPlan.objectForKey("premises") as! NSArray).count ).objectForKey("rate") as! String!)
            }
            
        }
        
        // load image
        for(var i = 0 ; i < self.listImage.count ; i++ )
        {
            
            if ( listImage.objectAtIndex(i).objectForKey("index") as! String == String(format: "%d",indexPath.row  as Int)){
                cell.imagePlace?.image = listImage.objectAtIndex(i).objectForKey("image") as? UIImage
                break
            }
        }
        
        
        // when request plan from server for add plan
        if pageType != "Main"{
            
            cell.delegate = self
            cell.index = indexPath.row
            var checkSelect : Bool = false
            for(var i = 0 ; i < self.listPlaceNotSelect.count ; i++){
                if( (listPlaceNotSelect.objectAtIndex(i) as! Int) == indexPath.row){
                    checkSelect = true
                }
            }
            
            // not select already
            if (checkSelect){
                cell.imageSelect.image = UIImage(named: "uncheck.png")
                
            }
                
                //  select
            else{
                cell.imageSelect.image = UIImage(named: "check.png")
            }
            
        }
        else{
            cell.imageSelect.hidden = true
            cell.btnSelectPlace.hidden = true
        }
        
        return cell
    }
    
//MARK : move cell
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        
        return UITableViewCellEditingStyle.None
        
    }
    
    // dont show delete icon
    func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
       
        return false
        
    }
    

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
       
        return true
        
    }

    // can move cell from main page only
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        if pageType  == "Main"{

            return true
        }
        else{
            
            return false
            
        }
        
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
        if sourceIndexPath.row as Int == destinationIndexPath.row as Int {
            return
        }
        
        listInfo.exchangeObjectAtIndex(sourceIndexPath.row, withObjectAtIndex: destinationIndexPath.row)
        
        if dicPlan.objectForKey("type") as? String == "TripForYou" {
            (dicPlan.objectForKey("user_checkin") as! NSMutableArray).exchangeObjectAtIndex(sourceIndexPath.row, withObjectAtIndex: destinationIndexPath.row)
            

        }
            
        else{
            
            // case 1  premises to premiss
            if(sourceIndexPath.row < (dicPlan.objectForKey("premises") as! NSArray).count && destinationIndexPath.row < (dicPlan.objectForKey("premises") as! NSArray).count ){
                
                var clone : NSMutableDictionary = NSMutableDictionary(dictionary: (dicPlan.objectForKey("premises") as! NSMutableArray).objectAtIndex(sourceIndexPath.row) as! NSMutableDictionary)
                
                
                (dicPlan.objectForKey("premises") as! NSMutableArray).removeObjectAtIndex(sourceIndexPath.row)
                
                (dicPlan.objectForKey("premises") as! NSMutableArray).insertObject(clone, atIndex: destinationIndexPath.row)
                
                table.reloadData()
                
                
                
            }
                
                
                // case 2 premiss to conclusion
                
            else if(sourceIndexPath.row < (dicPlan.objectForKey("premises") as! NSArray).count && destinationIndexPath.row >= (dicPlan.objectForKey("premises") as! NSArray).count ){
                
                
                var clone : NSMutableDictionary = NSMutableDictionary(dictionary: (dicPlan.objectForKey("premises") as! NSMutableArray).objectAtIndex(sourceIndexPath.row) as! NSMutableDictionary)
                
                (dicPlan.objectForKey("premises") as! NSMutableArray).removeObjectAtIndex(sourceIndexPath.row)
                
                (dicPlan.objectForKey("conclusion") as! NSMutableArray).insertObject( clone , atIndex: destinationIndexPath.row - dicPlan.objectForKey("premises")!.count )
                
                
                
                table.reloadData()
                
            }
                
                
                // case 3 in counclusion to conclusion
                
            else if(sourceIndexPath.row >= (dicPlan.objectForKey("premises") as! NSArray).count && destinationIndexPath.row >= (dicPlan.objectForKey("premises") as! NSArray).count ){
                
                var clone : NSMutableDictionary = NSMutableDictionary(dictionary: (dicPlan.objectForKey("conclusion") as! NSMutableArray).objectAtIndex(sourceIndexPath.row) as! NSMutableDictionary)
                
                (dicPlan.objectForKey("conclusion") as! NSMutableArray).removeObjectAtIndex(sourceIndexPath.row - dicPlan.objectForKey("premises")!.count )
                
                ((dicPlan.objectForKey("conclusion") as! NSMutableArray).insertObject( clone , atIndex: destinationIndexPath.row - dicPlan.objectForKey("premises")!.count ))
                
                
                table.reloadData()
                
            }
                
                // case 4 conclusion to premiss
                
                
            else if(sourceIndexPath.row >= (dicPlan.objectForKey("premises") as! NSArray).count && destinationIndexPath.row < (dicPlan.objectForKey("premises") as! NSArray).count ){
                
                var clone : NSMutableDictionary = NSMutableDictionary(dictionary: (dicPlan.objectForKey("conclusion") as! NSMutableArray).objectAtIndex(sourceIndexPath.row) as! NSMutableDictionary)
                
                (dicPlan.objectForKey("conclusion") as! NSMutableArray).removeObjectAtIndex(sourceIndexPath.row - dicPlan.objectForKey("premises")!.count)
                
                
                (dicPlan.objectForKey("conclusion") as! NSMutableArray).insertObject( clone , atIndex: destinationIndexPath.row)
                table.reloadData()
                
            }
        }
        
        PlanFile.sharedInstance.listPlan.replaceObjectAtIndex(indexPlan!, withObject: dicPlan)
        PlanFile.sharedInstance.saveFile()
        
    }
    
//MARK:-
//MARK:  function
//MARK:-
    
    /*
    des :   save trip to file
    
    para :
    tirpName : trip name that user fill in
    */
    func saveTrip(tripName : String?){
        addTripAlready = true
        
        //sort place
        var descriptor: NSSortDescriptor = NSSortDescriptor(key: "", ascending: true)
        var listPlaceNotSelectSort : NSArray = NSArray(array: listPlaceNotSelect.sortedArrayUsingDescriptors([descriptor]))
        
        if pageType == "TripForYou" || dicPlan.objectForKey("type") as? String == "TripForYou"{
            var user_checkin : NSMutableArray = NSMutableArray(array: dicPlan.objectForKey("user_checkin") as! NSMutableArray)
            
            // find  place that same with list that user select
            for(var i = 0 ; i < listPlaceNotSelectSort.count ; i++){
                if( (listPlaceNotSelectSort.objectAtIndex(i) as! Int) < (dicPlan.objectForKey("user_checkin") as! NSArray).count as Int){
                    user_checkin.removeObjectAtIndex(listPlaceNotSelectSort.objectAtIndex(i) as! Int - i )
                    
                }
            }
            
            // add nwe plan
            var newPlan : NSMutableDictionary = NSMutableDictionary(dictionary: dicPlan)
            newPlan.removeObjectForKey("user_checkin")
            newPlan.setObject(user_checkin, forKey: "user_checkin")
            newPlan.setObject("TripForYou", forKey: "type")
            newPlan.setObject(tripName!, forKey: "tripname")
            var rate: String! = getRating(newPlan)
            newPlan.setObject(rate, forKey: "rate")
            
            // save new plan
            var file : PlanFile = PlanFile.sharedInstance
            file.listPlan.addObject(newPlan)
            file.saveFile()
            
        }
        else{
            
            var premiss : NSMutableArray = NSMutableArray(array: dicPlan.objectForKey("premises") as! NSMutableArray)
            var conclusion : NSMutableArray = NSMutableArray(array: dicPlan.objectForKey("conclusion") as! NSMutableArray)
            
            // find  place that same with list that user select
            for(var i = 0 ; i < listPlaceNotSelectSort.count ; i++){
                if( (listPlaceNotSelectSort.objectAtIndex(i) as! Int) < (dicPlan.objectForKey("premises") as! NSArray).count as Int){
                    premiss.removeObjectAtIndex(listPlaceNotSelectSort.objectAtIndex(i) as! Int - i )
                    
                }
            }
            
            var countDelete = 0
            for(var j = 0 ; j < listPlaceNotSelectSort.count ; j++){
                if( (listPlaceNotSelectSort.objectAtIndex(j) as! Int) >= (dicPlan.objectForKey("premises") as! NSArray).count as Int){
                    conclusion.removeObjectAtIndex(listPlaceNotSelectSort.objectAtIndex(j) as! Int - countDelete - (dicPlan.objectForKey("premises") as! NSArray).count as Int )
                    countDelete++
                    
                }
            }
            
            // add new plan
            var newPlan : NSMutableDictionary = NSMutableDictionary(dictionary: dicPlan)
            newPlan.removeObjectForKey("premises")
            newPlan.removeObjectForKey("conclusion")
            newPlan.setObject(premiss, forKey: "premises")
            newPlan.setObject(conclusion, forKey: "conclusion")
            newPlan.setObject("TripMe", forKey: "type")
            newPlan.setObject(tripName!, forKey: "tripname")
            var rate: String! = getRating(newPlan)
            newPlan.setObject(rate, forKey: "rate")
            
            //save plan
            var file : PlanFile = PlanFile.sharedInstance
            file.listPlan.addObject(newPlan)
            file.saveFile()
        }
        self.slideMenuController()?.changeMainViewController(self.mainViewController!, close: true)
    }
    

    /*
    des :

    para : 
            source
    */
    func updateListImage( source : Int , dest : Int){
        
        for(var i = 0 ; i < listImage.count ; i++){
                
        }
        
    }
    
    /*
        des :   load and show image from url
    
        para :
                url : String url image
                index : image at index
    */
    
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
    
    /*
    des :   find true url from list of image url
    
    para :
            urlFull :  String full url   (...oooo...)
    */
    func getUrlImage(urlFull : String)->String{
        var imageArray : NSArray = urlFull.componentsSeparatedByString("oooo") as NSArray
        var url : String = ""
        
        println("------------------------")
        var a : NSArray = ((imageArray.objectAtIndex(1) as! String).componentsSeparatedByString("-") as NSArray)
        
        for(var i = 0 ; i < a.count - 1 ; i++){
            if(i == 0){
                url += a.objectAtIndex(i) as! String
            }
            else if i == 1{
                url += String(format: "100x100%@", a.objectAtIndex(i) as! String)
            }
            else{
                url += String(format: "-%@", a.objectAtIndex(i) as! String)
            }
            
        }
        return url
    }
    
    /*
    des :   get info from FS by veune id
    
    para :
            venueID : veune id of place
            index : position of venue
    */
    
    func getInfoVenue(venueID : String , index : Int) -> (){
        
        if pageType == "TripForYou" || dicPlan.objectForKey("type") as? String == "TripForYou"{
            
            connection.getInfoFromFoursquare(venueID , completion: { (result, error) -> () in
               
                if error == nil {
                    
                    self.listInfo.replaceObjectAtIndex(index, withObject: (result.objectForKey("response") as! NSDictionary).objectForKey("venue") as! NSDictionary)
                    
                    if(self.listInfo.count == (self.dicPlan.objectForKey("user_checkin") as! NSArray).count ){
                        
                        self.btnMap.enabled = true
                        
                    }
                }

            })
        }
            
        else
        {
            connection.getInfoFromFoursquare(venueID , completion: { (result, error) -> () in
                if error == nil {
                    
                    self.listInfo.replaceObjectAtIndex(index, withObject: (result.objectForKey("response") as! NSDictionary).objectForKey("venue") as! NSDictionary)
                    
                    if(self.listInfo.count == (self.dicPlan.objectForKey("premises") as! NSArray).count + (self.dicPlan.objectForKey("conclusion") as! NSArray).count){
                        
                        self.btnMap.enabled = true
                    }
                }
            })
        }
    }
    
    func allocArray(countOfArray : Int){
        for var i = 0 ; i < countOfArray ; i++ {
            listInfo.addObject("")
        }
    }
    
    
//MARK:-
//MARK: button action
//MARK:-
    
    
    @IBAction func clickBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    /*
    des :   event that user click add trip
    
    */
    @IBAction func clickAddTrip(sender: AnyObject) {
        
        var inputTextField: UITextField?
        
        var textAlert : String = ""
        if (btnAddTrip.titleLabel?.text == "Create Trip"){
            textAlert = "Name Your Trip"
        }
        else{
            textAlert = "Comment"
        }
        
        if let gotModernAlert: AnyClass = NSClassFromString("UIAlertController") {
            
            
            
            let actionSheetController: UIAlertController = UIAlertController(title: nil, message: textAlert , preferredStyle: .Alert)
            
            //Create and add the Cancel action
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
                //Do some stuff
            }
            actionSheetController.addAction(cancelAction)
            
            
            //Create and an option action
            let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .Default) { action -> Void in
                if (self.btnAddTrip.titleLabel?.text == "Create Trip"){
                    self.saveTrip(inputTextField?.text)
                }
                else{
                    self.clickPostFacebook(inputTextField?.text)
                }
                
            }
            actionSheetController.addAction(okAction)
            //Add a text field
            actionSheetController.addTextFieldWithConfigurationHandler { textField -> Void in
                //TextField configuration
                textField.placeholder = textAlert
                inputTextField = textField
            }
            
            //Present the AlertController
            self.presentViewController(actionSheetController, animated: true, completion: nil)
        }
        else {
            
            var alert : UIAlertView = UIAlertView(title: nil, message: textAlert, delegate: self, cancelButtonTitle: "Cancle")
            alert.addButtonWithTitle("OK")
            alert.alertViewStyle = UIAlertViewStyle.PlainTextInput
            alert.show()


        }
        
        
        
    }

    
    //MARK:-
    //MARK: alert view
    //MARK:
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            var tripName : String? = alertView.textFieldAtIndex(0)!.text
            
            if (self.btnAddTrip.titleLabel?.text == "Create Trip"){
                self.saveTrip(tripName)
            }
            else{
                self.clickPostFacebook(tripName)
            }
        }
    }
    
    
//MARK:-
//MARK: Navigation
//MARK:-
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // click cell
        if(segue.identifier == "InfoView"){
            var infoView : InfoViewController = segue.destinationViewController as! InfoViewController
            
            var indexPath = self.table.indexPathForSelectedRow()
            
            if pageType == "TripForYou"  || dicPlan.objectForKey("type") as? String == "TripForYou"{
                
                infoView.pageType = "TripForYou"
                
                infoView.infoOld = (dicPlan.objectForKey("user_checkin") as! NSArray).objectAtIndex(indexPath!.row) as! NSDictionary
                
                
                if listInfo.objectAtIndex(indexPath!.row) is String {
                    
                }
                else{
                    infoView.info = listInfo.objectAtIndex(indexPath!.row) as! NSDictionary
                }
                
            }
            else{
                
                infoView.pageType = "TripMe"
                
                
                
                if listInfo.objectAtIndex(indexPath!.row) is String {
                    
                }
                else{
                    infoView.info = listInfo.objectAtIndex(indexPath!.row) as! NSDictionary
                }
                
                
                if(indexPath!.row <  (self.dicPlan.objectForKey("premises") as! NSArray).count as Int ){
                    
                    // when load info not complete
                    infoView.infoOld = (dicPlan.objectForKey("premises") as! NSArray).objectAtIndex(indexPath!.row) as! NSDictionary
                    
                }
                    
                else{
                    
                    infoView.infoOld = (dicPlan.objectForKey("conclusion") as! NSArray).objectAtIndex(indexPath!.row - dicPlan.objectForKey("premises")!.count) as! NSDictionary
                    
                }
            }
        }
        
            // click map button
        else if (segue.identifier == "MapViewController"){
            var mapView : MapViewController = segue.destinationViewController as! MapViewController
            
            var newListByTbList : NSMutableArray = NSMutableArray()
            
            
            mapView.listInfo = self.listInfo
        }

        
    }

    
    func getRating(plan : NSMutableDictionary) -> String{
        var sumRate : Double = 0.0
        
        if pageType == "TripForYou" {

            for(var i = 0 ; i < (plan.objectForKey("user_checkin")as! NSArray).count ; i++ ){
                sumRate += (plan.objectForKey("user_checkin") as! NSArray).objectAtIndex(i).objectForKey("RATE")!.doubleValue
            }
            var rateAvg : Double = sumRate / Double((plan.objectForKey("user_checkin")as! NSArray).count as Int)
            return String(format: "%.1f",rateAvg)
        }
        else{
            
            for var i = 0 ; i < (plan.objectForKey("premises")as! NSArray).count ; i++ {
                sumRate += (plan.objectForKey("premises")as! NSArray).objectAtIndex(i).objectForKey("rate")!.doubleValue
                
            }
            
            for var i = 0 ; i < (plan.objectForKey("conclusion")as! NSArray).count ; i++ {
                sumRate += (plan.objectForKey("conclusion")as! NSArray).objectAtIndex(i).objectForKey("rate")!.doubleValue
            }
            
            var countPremiese : Int = (plan.objectForKey("premises")as! NSArray).count as Int
            var countConclusion : Int = (plan.objectForKey("conclusion")as! NSArray).count as Int
            var rateAvg : Double = sumRate / (Double(countConclusion) + Double(countPremiese))
            return String(format: "%.1f",rateAvg)
        }

        
    }
    
//MARK:-
//MARK: delegate cell
//MARK:-
    func clickCell(index: Int) {
        
        for(var i = 0 ; i < self.listPlaceNotSelect.count ; i++){
            if( (listPlaceNotSelect.objectAtIndex(i) as! Int) == index){
                listPlaceNotSelect.removeObjectAtIndex(i)
                table.reloadData()

                return;
            }
        }
        listPlaceNotSelect.addObject(index)

        table.reloadData()
    }

    @IBAction func longPressEditCell(sender: AnyObject) {
        if (pageType == "Main" && (sender as! UILongPressGestureRecognizer).state == UIGestureRecognizerState.Began){
            self.table.setEditing(!self.table.editing, animated: true)
        }
    }
    
    func clickPostFacebook(messageString : String?) {
        
        
        var message : String = messageString!
        
        if pageType == "TripForYou" || dicPlan.objectForKey("type") as? String == "TripForYou" {
            
            
            for var i = 0 ; i < dicPlan.objectForKey("user_checkin")!.count ; i++ {
                
                var namePlace : String = (dicPlan.objectForKey("user_checkin")?.objectAtIndex(i).objectForKey("VENUE_NAME") as? String)!
                
                message += "\(i+1). \(namePlace) "
                
            }
            
        }
            
        else {
            
            var countVenue : Int = (dicPlan.objectForKey("premises") as! NSArray).count + (dicPlan.objectForKey("conclusion") as! NSArray).count
            
            for var i = 0 ; i < countVenue ; i++ {
                var namePlace : String! = ""
                
                if(i < (dicPlan.objectForKey("premises") as! NSArray).count){
                    if((dicPlan.objectForKey("premises") as! NSArray).objectAtIndex(i).objectForKey("venueName") as? String == nil){
                        namePlace = (dicPlan.objectForKey("premises") as! NSArray).objectAtIndex(i).objectForKey("vunueName") as? String
                    }
                    else{
                        namePlace = (dicPlan.objectForKey("premises") as! NSArray).objectAtIndex(i).objectForKey("venueName") as? String
                    }
                    
                   
                    
                }
                else{
                    if ((dicPlan.objectForKey("conclusion") as! NSArray).objectAtIndex(i - (dicPlan.objectForKey("premises") as! NSArray).count ).objectForKey("vunueName") as? String == nil){
                        
                        namePlace = (dicPlan.objectForKey("conclusion") as! NSArray).objectAtIndex(i  -  (dicPlan.objectForKey("premises") as! NSArray).count ).objectForKey("venueName") as? String
                        
                    }
                    else{
                        namePlace = (dicPlan.objectForKey("conclusion") as! NSArray).objectAtIndex(i  -  (dicPlan.objectForKey("premises") as! NSArray).count ).objectForKey("vunueName") as? String
                    }
                }
                
                message += "\(i+1). \(namePlace) "
            }
            
        }
        
        message += "by #TripsTap"
        
        
        var conFB : FBRequestConnection = FBRequestConnection()
        var dicPost : NSMutableDictionary = NSMutableDictionary()
        dicPost.setValue(UIImage(named: "logo_02_circle-2.png"), forKey: "picture")
        dicPost.setValue(message, forKey: "message")
        
        var request : FBRequest = FBRequest(graphPath: "me/photos", parameters: dicPost as [NSObject : AnyObject] , HTTPMethod: "POST")
        conFB.addRequest(request, completionHandler: { (fbResCon, data, error) -> Void in
            
            if error == nil{
                var alert : UIAlertView = UIAlertView(title: nil, message: "Post complete", delegate: self, cancelButtonTitle: "OK")
                alert.show()
            }
            else{
                var alert : UIAlertView = UIAlertView(title: "Error!", message: "Can't Post trip", delegate: self, cancelButtonTitle: "OK")
                alert.show()
            }
        })
        
        conFB.start()
    }
}
