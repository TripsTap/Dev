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
    var pageType : String!
    var latitude : String!
    var longitude : String!
    var mainViewController: UIViewController!
    var listOfTable : NSMutableArray!
    
    //MARK:-
    //MARK: cycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.hidden = true
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = storyboard.instantiateViewControllerWithIdentifier("MainViewController") as MainViewController
        self.mainViewController = UINavigationController(rootViewController: mainViewController)

        self.connection = Connection.sharedInstance
        self.listOfTable = NSMutableArray()
        
        self.viewLoader.hidden = false
        if(self.pageType == "restaurant"){
            self.labTitle.text = "Restaurant"
            var ll = "2,3"
            connection.getRestaurant(ll,{ (result, error) -> () in
                self.viewLoader.hidden = true
                if (error == nil){
                    self.listOfTable = (result.objectForKey("response") as NSDictionary).objectForKey("venues") as NSMutableArray
                    self.table.reloadData()
                }
                else{
                    
                }
            });
        }
        else{
            self.labTitle.text = "Hotel"
            
            var ll = "2,3"
            connection.getHotel(ll,{ (result, error) -> () in
                if (error == nil){
                    self.viewLoader.hidden = true
                    self.listOfTable = (result.objectForKey("response") as NSDictionary).objectForKey("venues") as NSMutableArray
                    self.table.reloadData()
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
        var cell : RestaAndHotelTableViewCell = table.dequeueReusableCellWithIdentifier("RestaAndHotelTableViewCell", forIndexPath: indexPath) as RestaAndHotelTableViewCell
        
        cell.labName.text = listOfTable.objectAtIndex(indexPath.row).objectForKey("name") as String
        
        //var cateID = (self.listOfTable.objectAtIndex(indexPath.row) as NSDictionary).objectForKey("categories")?.objectForKey("id")
        
//        if (cateID == "4bf58dd8d48988d1e0931735"){
//            cell.imagePlace.backgroundColor = UIColor.greenColor()
//        }
//        else if(cateID)
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var idStr : String = self.listOfTable.objectAtIndex(indexPath.row).objectForKey("id") as String
        connection.getInfoRestaAndHotel(idStr) { (result, error) -> () in
            var storyBroad = UIStoryboard(name: "Main", bundle: nil)
            var infoView : InfoViewController = storyBroad.instantiateViewControllerWithIdentifier("InfoViewController") as InfoViewController
            infoView.info = (result.objectForKey("response") as NSDictionary).objectForKey("venue") as NSDictionary
            infoView.pageType = self.labTitle.text
            self.navigationController?.pushViewController(infoView, animated: true)
            
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
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
