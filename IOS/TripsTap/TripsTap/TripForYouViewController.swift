//
//  TripForYouViewController.swift
//  TripsTap
//
//  Created by Piyawut Kamwiset on 4/10/2558 BE.
//  Copyright (c) 2558 Piyawut Kamwiset. All rights reserved.
//

import UIKit

class TripForYouViewController: UIViewController , XYPieChartDataSource , XYPieChartDelegate   {

//MARK: -
//MARK: IBOutlet
//MARK: -
    

    @IBOutlet var labNameUser: UILabel!
    @IBOutlet var labMail: UILabel!
    @IBOutlet var labGender: UILabel!
    @IBOutlet var imageUser: UIImageView!
    @IBOutlet var viewPieChart: XYPieChart!
    
   

//MARK: -
//MARK: variable
//MARK: -
    
    var connection : Connection!


    var mainViewController: UIViewController!
    var pageType : String!
    var info : NSMutableDictionary!
    var desRegion : NSMutableArray!
    
    var desType : NSMutableArray!
    var sumDesType : Int = 0
    var planFile : PlanFile!
    var sliceColors : NSArray!
    
    
    @IBOutlet var progressArt: UIProgressView!
    @IBOutlet var progressEntertain: UIProgressView!
    @IBOutlet var progressHistoric: UIProgressView!
    @IBOutlet var progressNutual: UIProgressView!
    @IBOutlet var progressOutdoor: UIProgressView!
    @IBOutlet var progressThemepark: UIProgressView!
    @IBOutlet var progressSea : UIProgressView!
    
    
//MARK:-
//MARK: cycle
//MARK:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.hidden = true
        
        planFile = PlanFile.sharedInstance
        
        info = NSMutableDictionary(dictionary: planFile.behaviour as NSMutableDictionary)
        
        self.sliceColors = NSArray(array: [UIColor(red:246/255.0 ,green:155/255.0 ,blue:0/255.0 ,alpha:1) ,
        UIColor(red:129/255.0 , green:195/255.0 , blue:29/255.0  , alpha:1) ,
        UIColor(red:62/255.0  , green:173/255.0 , blue:219/255.0 , alpha:1) ,
        UIColor(red:229/255.0 , green:66/255.0  , blue:115/255.0 , alpha:1) ,
        UIColor(red:148/255.0 , green:141/255.0 , blue:139/255.0 , alpha:1) ])
            
        desRegion = NSMutableArray()
        desRegion.addObject((info.objectForKey("info")!.objectForKey("des")?.objectForKey("region_1") as! String).toInt()!)
        desRegion.addObject((info.objectForKey("info")!.objectForKey("des")?.objectForKey("region_2") as! String).toInt()!)
        desRegion.addObject((info.objectForKey("info")!.objectForKey("des")?.objectForKey("region_3") as! String).toInt()!)
        desRegion.addObject((info.objectForKey("info")!.objectForKey("des")?.objectForKey("region_4") as! String).toInt()!)
        desRegion.addObject((info.objectForKey("info")!.objectForKey("des")?.objectForKey("region_5") as! String).toInt()!)
        desRegion.addObject((info.objectForKey("info")!.objectForKey("des")?.objectForKey("region_6") as! String).toInt()!)
        
        
        
        labNameUser.text = info.objectForKey("FBName") as? String
        labMail.text = info.objectForKey("FBMail") as? String
        labGender.text = info.objectForKey("FBGender") as? String
        imageUser.image = UIImage( data : info.objectForKey("image") as! NSData)
        
        self.viewPieChart.delegate = self
        self.viewPieChart.dataSource = self
        self.viewPieChart.showPercentage = false
        self.viewPieChart.center = CGPointMake(150, 150)
        self.viewPieChart.labelColor = UIColor.blackColor()

        
        desType = NSMutableArray()
        desType.addObject((info.objectForKey("info")!.objectForKey("des")?.objectForKey("art") as! String).toInt()!)
        desType.addObject((info.objectForKey("info")!.objectForKey("des")?.objectForKey("entertain") as! String).toInt()!)
        desType.addObject((info.objectForKey("info")!.objectForKey("des")?.objectForKey("historic") as! String).toInt()!)
        desType.addObject((info.objectForKey("info")!.objectForKey("des")?.objectForKey("nutual") as! String).toInt()!)
        desType.addObject((info.objectForKey("info")!.objectForKey("des")?.objectForKey("outdoor") as! String).toInt()!)
        desType.addObject((info.objectForKey("info")!.objectForKey("des")?.objectForKey("themepark") as! String).toInt()!)
        desType.addObject((info.objectForKey("info")!.objectForKey("des")?.objectForKey("sea") as! String).toInt()!)




        
        
        
        for var i = 0 ; i < desType.count ; i++ {
            sumDesType += desType.objectAtIndex(i) as! Int
        }
        
        
        progressArt.progress = Float((info.objectForKey("info")!.objectForKey("des")?.objectForKey("art") as! String).toInt()!) / Float(sumDesType)
        
        progressEntertain.progress = Float((info.objectForKey("info")!.objectForKey("des")?.objectForKey("entertain") as! String).toInt()!) / Float(sumDesType)
        
        progressHistoric.progress = Float((info.objectForKey("info")!.objectForKey("des")?.objectForKey("historic") as! String).toInt()!) / Float(sumDesType)
        
        progressNutual.progress = Float((info.objectForKey("info")!.objectForKey("des")?.objectForKey("nutual") as! String).toInt()!) / Float(sumDesType)
        
        progressOutdoor.progress = Float((info.objectForKey("info")!.objectForKey("des")?.objectForKey("outdoor") as! String).toInt()!) / Float(sumDesType)
        
        progressThemepark.progress = Float((info.objectForKey("info")!.objectForKey("des")?.objectForKey("themepark") as! String).toInt()!) / Float(sumDesType)
        
        progressSea.progress = Float((info.objectForKey("info")!.objectForKey("des")?.objectForKey("sea") as! String).toInt()!) / Float(sumDesType)
        
       
        
        
        
        
        
        
        
        
        
        
        
        
        
        
//        self.viewBarChart.delegate = self
//        self.viewBarChart.dataSource = self
//        self.viewBarChart.showPercentage = false

        


    }
    
    override func viewWillAppear(animated: Bool) {
        self.viewPieChart.reloadData()
//        self.viewBarChart.reloadData()
    }
    
    func numberOfSlicesInPieChart(pieChart: XYPieChart!) -> UInt {
        if pieChart == viewPieChart{
            return UInt(desRegion.count)
        }
        else {
            return UInt(desType.count)
        }
    }
    
    func pieChart(pieChart: XYPieChart!, valueForSliceAtIndex index: UInt) -> CGFloat {
        
        if pieChart == viewPieChart{
            return CGFloat(desRegion.objectAtIndex(Int(index)) as! Int)
        }
        else {
            return CGFloat(desType.objectAtIndex(Int(index)) as! Int)
        }

    }
    
    func pieChart(pieChart: XYPieChart!, colorForSliceAtIndex index: UInt) -> UIColor! {
        return nil
//            self.sliceColors.objectAtIndex(Int(index) % self.sliceColors.count) as! UIColor
    }
    
    func pieChart(pieChart: XYPieChart!, textForSliceAtIndex index: UInt) -> String! {
        return "test"
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
        
        else if segue.identifier == "user2" {
            var listTripForU : ListVenueViewController = segue.destinationViewController as! ListVenueViewController
            listTripForU.pageType = "TripForYou"
            
            var planFile : PlanFile = PlanFile.sharedInstance
            
            listTripForU.dicPlan = planFile.behaviour.objectForKey("info")?.objectForKey("data")?.objectAtIndex(1) as! NSMutableDictionary
        }
        else if segue.identifier == "user3" {
            var listTripForU : ListVenueViewController = segue.destinationViewController as! ListVenueViewController
            listTripForU.pageType = "TripForYou"
            
            var planFile : PlanFile = PlanFile.sharedInstance
            
            listTripForU.dicPlan = planFile.behaviour.objectForKey("info")?.objectForKey("data")?.objectAtIndex(2) as! NSMutableDictionary
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
