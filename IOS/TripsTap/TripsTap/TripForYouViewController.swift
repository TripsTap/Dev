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
    @IBOutlet var progressMesuem: UIProgressView!
    @IBOutlet var progressThemepark: UIProgressView!
    @IBOutlet var progressSea : UIProgressView!
    
    @IBOutlet var labPerArt: UILabel!
    @IBOutlet var labperEntertain: UILabel!
    @IBOutlet var labPerHistory: UILabel!
    @IBOutlet var labPerMesuem: UILabel!
    @IBOutlet var labPerNutual: UILabel!
    @IBOutlet var labPerThemePark: UILabel!
    @IBOutlet var labPerSea: UILabel!
    
    
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
//        labMail.text = info.objectForKey("FBMail") as? String
//        labGender.text = info.objectForKey("FBGender") as? String
        imageUser.image = UIImage( data : info.objectForKey("image") as! NSData)
        
//        self.viewPieChart.delegate = self
//        self.viewPieChart.dataSource = self
//        self.viewPieChart.showPercentage = false
//        self.viewPieChart.center = CGPointMake(150, 150)
//        self.viewPieChart.labelColor = UIColor.blackColor()

        
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
        labPerArt.text = (info.objectForKey("info")!.objectForKey("des")?.objectForKey("art") as! String)
        
        progressEntertain.progress = Float((info.objectForKey("info")!.objectForKey("des")?.objectForKey("entertain") as! String).toInt()!) / Float(sumDesType)
        labperEntertain.text = (info.objectForKey("info")!.objectForKey("des")?.objectForKey("entertain") as! String)
        
        
        progressHistoric.progress = Float((info.objectForKey("info")!.objectForKey("des")?.objectForKey("historic") as! String).toInt()!) / Float(sumDesType)
        labPerHistory.text = (info.objectForKey("info")!.objectForKey("des")?.objectForKey("historic") as! String)
        
        progressNutual.progress = Float((info.objectForKey("info")!.objectForKey("des")?.objectForKey("nutual") as! String).toInt()!) / Float(sumDesType)
        labPerNutual.text = (info.objectForKey("info")!.objectForKey("des")?.objectForKey("nutual") as! String)
        
        progressMesuem.progress = Float((info.objectForKey("info")!.objectForKey("des")?.objectForKey("mesuem") as! String).toInt()!) / Float(sumDesType)
        labPerMesuem.text = (info.objectForKey("info")!.objectForKey("des")?.objectForKey("mesuem") as! String)
        
        progressThemepark.progress = (Float((info.objectForKey("info")!.objectForKey("des")?.objectForKey("themepark") as! String).toInt()!) + Float((info.objectForKey("info")!.objectForKey("des")?.objectForKey("outdoor") as! String).toInt()!) ) / Float(sumDesType)
        labPerThemePark.text = (info.objectForKey("info")!.objectForKey("des")?.objectForKey("themepark") as! String)
        
        
//            ((info.objectForKey("info")!.objectForKey("des")?.objectForKey("outdoor") as! String).toInt()!)
        
        progressSea.progress = Float((info.objectForKey("info")!.objectForKey("des")?.objectForKey("sea") as! String).toInt()!) / Float(sumDesType)
        labPerSea.text = (info.objectForKey("info")!.objectForKey("des")?.objectForKey("sea") as! String)
        


    }
    
    override func viewWillAppear(animated: Bool) {
//        self.viewPieChart.reloadData()
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
