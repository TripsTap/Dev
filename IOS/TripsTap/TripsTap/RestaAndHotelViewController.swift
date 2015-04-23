//
//  RestaAndHotelViewController.swift
//  TripsTap
//
//  Created by Piyawut Kamwiset on 3/24/2558 BE.
//  Copyright (c) 2558 Piyawut Kamwiset. All rights reserved.
//

import UIKit

class RestaAndHotelViewController: UIViewController,CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource {

//MARK:-
//MARK: IBOutlet
//MARK:-
    @IBOutlet var labTitle: UILabel!
    @IBOutlet var table: UITableView!
    @IBOutlet var viewLoader: UIView!
    
//MARK:-
//MARK: variable
//MARK:-
    var connection : Connection!
    var pageType : String! // type of page before
    var latitude : NSString!  = "7.884734708567935" // latitude of user
    var longitude : NSString! = "98.3899876985871" // longtitude of user
    var mainViewController: UIViewController! //main page
    var listOfTable : NSMutableArray! // array of place
    var listImageIcon : NSMutableArray! // list icon
    
//MARK:-
//MARK: cycle
//MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.hidden = true
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = storyboard.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
        self.mainViewController = UINavigationController(rootViewController: mainViewController)

        
        self.connection = Connection.sharedInstance
        self.listOfTable = NSMutableArray()
        listImageIcon = NSMutableArray()
        
        self.viewLoader.hidden = false
        
        if(self.pageType == "restaurant"){
            self.labTitle.text = "Restaurant"
            var ll = "2,3"
            connection.getRestaurant(ll,completion: { (result, error) -> () in
                self.viewLoader.hidden = true
                if (error == nil){
                    self.listOfTable = NSMutableArray(array: (result.objectForKey("response") as! NSDictionary).objectForKey("venues") as! NSMutableArray)
                    
                    self.setDictanceToObject()
                    var descriptor: NSSortDescriptor = NSSortDescriptor(key: "distance", ascending: true)
                    self.listOfTable = NSMutableArray(array: self.listOfTable.sortedArrayUsingDescriptors([descriptor]))
                    
                    self.getImageIcon()
                    self.table.reloadData()
                }
                else {
                    UIAlertView(title: "Error occur!", message: "No request available", delegate: self, cancelButtonTitle: "OK").show()
                }
            });
        }
        else{
            
            self.labTitle.text = "Hotel"
            var ll = String(format: "%@,%@",latitude,longitude)
            connection.getHotel(ll,completion: { (result, error) -> () in
                self.viewLoader.hidden = true
                if (error == nil){
                    self.listOfTable = NSMutableArray(array: (result.objectForKey("response") as! NSDictionary).objectForKey("venues") as! NSMutableArray)
                    
                    self.setDictanceToObject()
                    var descriptor: NSSortDescriptor = NSSortDescriptor(key: "distance", ascending: true)
                    self.listOfTable = NSMutableArray(array: self.listOfTable.sortedArrayUsingDescriptors([descriptor]))

                    self.getImageIcon()
                    self.table.reloadData()
                }
                else {
                    UIAlertView(title: "Error occur!", message: "No request available", delegate: self, cancelButtonTitle: "OK").show()
                }
                
            });
        }

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    
//MARK:-
//MARK:  table delegate
//MARK:-
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listOfTable.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : RestaAndHotelTableViewCell = table.dequeueReusableCellWithIdentifier("RestaAndHotelTableViewCell", forIndexPath: indexPath) as! RestaAndHotelTableViewCell
        
        cell.labName.text = listOfTable.objectAtIndex(indexPath.row).objectForKey("name") as? String
        var cateShortName : String = (self.listOfTable.objectAtIndex(indexPath.row) as! NSDictionary).objectForKey("categories")?.objectAtIndex(0).objectForKey("shortName") as! String!
        
        

        cell.labKM.text = String(format: "%.2f km",(self.listOfTable.objectAtIndex(indexPath.row) as! NSDictionary).objectForKey("distance") as! Double)
        
//        if pageType == "restaurant"{
//            // bakery
//            if (cateShortName.rangeOfString("Bakery") != nil || cateShortName.rangeOfString("Café") != nil){
//                cell.imagePlace.backgroundColor = UIColor.greenColor()
//            }
//                // coffee
//            else if(cateShortName.rangeOfString("Coffee") != nil ){
//                cell.imagePlace.backgroundColor = UIColor.redColor()
//            }
//                // food
//            else{
//                cell.imagePlace.backgroundColor = UIColor.blackColor()
//            }
//        }
//        
//        else {
//            // hotel
//            if (cateShortName.rangeOfString("Hotel") != nil ){
//                cell.imagePlace.backgroundColor = UIColor.greenColor()
//            }
//                // Resort
//            else if(cateShortName.rangeOfString("Resort") != nil ){
//                cell.imagePlace.backgroundColor = UIColor.redColor()
//            }
//                //Hostel
//            else if cateShortName.rangeOfString("Hostel") != nil{
//                cell.imagePlace.backgroundColor = UIColor.purpleColor()
//            }
//                // other
//            else{
//                cell.imagePlace.backgroundColor = UIColor.blackColor()
//            }
//            
//        }
        
        for var i = 0 ; i  < self.listImageIcon.count ; i++ {
            if self.listImageIcon.objectAtIndex(i).objectForKey("index") as! Int == indexPath.row{
                cell.imagePlace.image = self.listImageIcon.objectAtIndex(i).objectForKey("image") as! UIImage
                break
            }
        }
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        viewLoader.hidden = false
        var idStr : String = self.listOfTable.objectAtIndex(indexPath.row).objectForKey("id") as! String
        
        // load info of place that user select
        connection.getInfoFromFoursquare(idStr) { (result, error) -> () in
            self.viewLoader.hidden = true
            if error == nil {
                var storyBroad = UIStoryboard(name: "Main", bundle: nil)
                var infoView : InfoViewController = storyBroad.instantiateViewControllerWithIdentifier("InfoViewController") as! InfoViewController
                infoView.info = (result.objectForKey("response") as! NSDictionary).objectForKey("venue") as! NSDictionary
                infoView.pageType = self.labTitle.text
                self.navigationController?.pushViewController(infoView, animated: true)
            }
            else {
                UIAlertView(title: "Error occur!", message: "No request available", delegate: self, cancelButtonTitle: "OK").show()
            }
            
        }
    }

    //MARK:-
    //MARK: button action
    //MARK:-
    @IBAction func clickBack(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
        self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)
    }
    
    
    //MARK:-
    //MARK: LocationManager
    //MARK:-
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        
        let currentLocation : CLLocation = newLocation
        latitude = "\(currentLocation.coordinate.latitude)"
        longitude = "\(currentLocation.coordinate.longitude)"
        println("longitude \(self.latitude)")
        println("latitude \(self.longitude)")
    }
    
    func setDictanceToObject(){
    
        for var i = 0 ; i < listOfTable.count ; i++ {
            var oldDic : NSMutableDictionary = NSMutableDictionary(dictionary: (self.listOfTable.objectAtIndex(i) as! NSDictionary))
            
            var lat : Double = ((self.listOfTable.objectAtIndex(i) as! NSDictionary).objectForKey("location")!.objectForKey("lat") as! NSNumber!).doubleValue
            
            var lng : Double = ((self.listOfTable.objectAtIndex(i) as! NSDictionary).objectForKey("location")!.objectForKey("lng") as! NSNumber!).doubleValue
            
            var distance : Double = getDistance(lat, lng: lng)
            
            oldDic.setObject(distance, forKey: "distance")
            listOfTable.replaceObjectAtIndex(i, withObject: oldDic)
        }
    }
    
    func getDistance(lat : Double , lng : Double) -> Double{
        var localPlace : CLLocation = CLLocation(latitude: CLLocationDegrees(latitude.doubleValue)   , longitude: CLLocationDegrees(longitude.doubleValue))
        
        var destination : CLLocation = CLLocation(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lng))
        return localPlace.distanceFromLocation(destination) / 1000
        
    }
    
    func getImageIcon(){

        for var i = 0 ; i < self.listOfTable.count ;i++ {
            var prefix : String = ((self.listOfTable.objectAtIndex(i).objectForKey("categories") as! NSArray).objectAtIndex(0).objectForKey("icon") as! NSDictionary).objectForKey("prefix") as! String
            var suffix : String = ((self.listOfTable.objectAtIndex(i).objectForKey("categories") as! NSArray).objectAtIndex(0).objectForKey("icon") as! NSDictionary).objectForKey("suffix") as! String
            
            var url : String = String(format: "%@bg_64%@", prefix, suffix)
            println(url)
            let index : Int = i
            Connection.sharedInstance.getImage(url, completion: { (image) -> () in
                if image != nil{
                    var dic : NSMutableDictionary = NSMutableDictionary()
                    dic.setObject(image , forKey: "image")
                    dic.setObject(index, forKey: "index")
                    self.listImageIcon.addObject(dic)
                    self.table.reloadData()
                }
            })
        }
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
