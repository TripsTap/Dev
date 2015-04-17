//
//  TripForYouViewController.swift
//  TripsTap
//
//  Created by Piyawut Kamwiset on 4/10/2558 BE.
//  Copyright (c) 2558 Piyawut Kamwiset. All rights reserved.
//

import UIKit

class TripForYouViewController: UIViewController {

//MARK: -
//MARK: IBOutlet
//MARK: -
    

    @IBOutlet var labNameUser: UILabel!
    @IBOutlet var imageUser: UIImageView!
    @IBOutlet var table: UITableView!
    @IBOutlet var viewPieChart: UIView!
    @IBOutlet var viewBarChart: UIView!
    

//MARK: -
//MARK: variable
//MARK: -
    
    var connection : Connection!


    var mainViewController: UIViewController!
    var pageType : String!
    var info : NSMutableDictionary!

    
    var planFile : PlanFile!
    
//MARK:-
//MARK: cycle
//MARK:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.hidden = true
        
        planFile = PlanFile.sharedInstance
        
        info = NSMutableDictionary(dictionary: planFile.behaviour as NSMutableDictionary)
        
        
        labNameUser.text = info.objectForKey("FBName") as? String
        imageUser.image = info.objectForKey("image") as? UIImage
        
        

        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    
//MARK: -
//MARK: button event
//MARK: -
    
    @IBAction func clickSelectLocation(sender: AnyObject) {

        
    }
    
//    @IBAction func clickDonePicker(sender: AnyObject) {
//        selectCategory.removeAllObjects()
//        viewPicker.hidden = true
//        
//        viewIndicator.hidden = false
//        
//        // send request
//        self.connection = Connection.sharedInstance
//        
//        connection.getCategoryTripsMe(textLocation.text, place: 0) { (result, error) -> () in
//            
//            self.viewIndicator.hidden = true
//            self.category.removeAllObjects()
//            self.table.reloadData()
//            if(error == nil){
//                if(  ((result.objectAtIndex(0) as! NSDictionary)["cats"] as! NSArray).count != 0){
//                    
//                    self.category = ((result.objectAtIndex(0) as! NSDictionary)["cats"] as! NSMutableArray).mutableCopy() as! NSMutableArray
//                    self.table.reloadData()
//                }
//                else{
//                    println("cate == 0")
//                }
//                
//            }
//        }
//        
//    }

    //MARK:-
    //MARK:  table function
    //MARK:-
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return category.count
                return 30
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
//        var cell  = tableView.dequeueReusableCellWithIdentifier("TripMeTableViewCell" ,forIndexPath: indexPath) as TripMeTableViewCell
        
        
//        //  set information
//        cell.labCategoryName.text = (self.category[indexPath.row] as NSDictionary) ["catName"] as String
//        cell.delegate = self
//        cell.index = indexPath.row
//        
//        
//        // check select category
//        var checkSelect : Bool = false
//        for(var i = 0 ; i < self.selectCategory.count ; i++){
//            if( (selectCategory.objectAtIndex(i) as Int) == indexPath.row){
//                checkSelect = true
//            }
//        }
//        
//        // select already
//        if (checkSelect){
//            cell.imageSelect.backgroundColor = UIColor.greenColor()
//        }
//            
//            // not select
//        else{
//            cell.imageSelect.backgroundColor = UIColor.redColor()
//        }
//        
        return UITableViewCell()
    }
    
    
    func  tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 80;
    }

    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "user1" {
            var listTripForU : ListVenueViewController = segue.destinationViewController as! ListVenueViewController
            listTripForU.pageType = "TripForYou"
            
            var planFile : PlanFile = PlanFile.sharedInstance
            
            listTripForU.dicPlan = planFile.behaviour.objectForKey("info")?.objectForKey("data")?.objectAtIndex(0) as! NSMutableDictionary
        }
        
    }


    @IBAction func clickBack(sender: AnyObject) {
        
        self.navigationController?.navigationBar.hidden = true
        var storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController : MainViewController = storyBoard.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
        self.mainViewController = UINavigationController(rootViewController: mainViewController)
        
        
        self.navigationController?.popViewControllerAnimated(true)
        self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)
    }

    
    
    
    @IBAction func clickUser2(sender: AnyObject) {
        
    }
    
    @IBAction func clickUser3(sender: AnyObject) {
        
    }
    
}
