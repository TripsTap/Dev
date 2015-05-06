 //
//  TripForYouViewController.swift
//  TripsTap
//
//  Created by Piyawut Kamwiset on 4/10/2558 BE.
//  Copyright (c) 2558 Piyawut Kamwiset. All rights reserved.
//

import UIKit

class TripForYouViewController: UIViewController  {

//MARK: -
//MARK: IBOutlet
//MARK: -

    @IBOutlet var labNameUser: UILabel!
    @IBOutlet var imageUser: UIImageView!
    @IBOutlet var progressArt: UIProgressView!
    @IBOutlet var progressEntertain: UIProgressView!
    @IBOutlet var progressHistoric: UIProgressView!
    @IBOutlet var progressNutual: UIProgressView!
    @IBOutlet var progressMesuem: UIProgressView!
    @IBOutlet var progressThemepark: UIProgressView!
    @IBOutlet var progressSea : UIProgressView!
    @IBOutlet var labPerArt: UILabel!
    @IBOutlet var labCatUser1: UILabel!
    @IBOutlet var labCatUser2: UILabel!
    @IBOutlet var labCatUser3: UILabel!
    @IBOutlet var labPer1: UILabel!
    @IBOutlet var labPer2: UILabel!
    @IBOutlet var labPer3: UILabel!
    
//MARK: -
//MARK: variable
//MARK: -
    
    var connection : Connection!
    var mainViewController: UIViewController!
    var pageType : String!
    
    var behaviourInfo : NSMutableDictionary! // bahaviour of user
//    var desRegion : NSMutableArray! 
    var desType : NSMutableArray! // list of category that user used to check in with facebook
    var sumDesType : Int = 0 // sum of all category that user used to check in
    var planFile : PlanFile!
    
    
//MARK:-
//MARK: cycle
//MARK:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.hidden = true
        
        
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        sumDesType = 0 
        planFile = PlanFile.sharedInstance
        
        behaviourInfo = NSMutableDictionary(dictionary: planFile.behaviour as NSMutableDictionary)
        
        labNameUser.text = behaviourInfo.objectForKey("FBName") as? String
        imageUser.image = UIImage( data : behaviourInfo.objectForKey("image") as! NSData)
        
        // set up description type
        desType = NSMutableArray()
        desType.addObject((behaviourInfo.objectForKey("info")!.objectForKey("des")?.objectForKey("art") as! String).toInt()!)
        desType.addObject((behaviourInfo.objectForKey("info")!.objectForKey("des")?.objectForKey("entertain") as! String).toInt()!)
        desType.addObject((behaviourInfo.objectForKey("info")!.objectForKey("des")?.objectForKey("historic") as! String).toInt()!)
        desType.addObject((behaviourInfo.objectForKey("info")!.objectForKey("des")?.objectForKey("nutual") as! String).toInt()!)
        desType.addObject((behaviourInfo.objectForKey("info")!.objectForKey("des")?.objectForKey("outdoor") as! String).toInt()!)
        desType.addObject((behaviourInfo.objectForKey("info")!.objectForKey("des")?.objectForKey("themepark") as! String).toInt()!)
        desType.addObject((behaviourInfo.objectForKey("info")!.objectForKey("des")?.objectForKey("sea") as! String).toInt()!)
        desType.addObject((behaviourInfo.objectForKey("info")!.objectForKey("des")?.objectForKey("mesuem") as! String).toInt()!)
        
        
        // find sum of description type
        for var i = 0 ; i < desType.count ; i++ {
            sumDesType += desType.objectAtIndex(i) as! Int
        }
        
        
        if sumDesType != 0 {
            // set up progress view
            progressArt.progress = Float((behaviourInfo.objectForKey("info")!.objectForKey("des")?.objectForKey("art") as! String).toInt()!) / Float(sumDesType)
            
            
            progressEntertain.progress = Float((behaviourInfo.objectForKey("info")!.objectForKey("des")?.objectForKey("entertain") as! String).toInt()!) / Float(sumDesType)
            
            
            progressHistoric.progress = Float((behaviourInfo.objectForKey("info")!.objectForKey("des")?.objectForKey("historic") as! String).toInt()!) / Float(sumDesType)
            
            
            progressNutual.progress = Float((behaviourInfo.objectForKey("info")!.objectForKey("des")?.objectForKey("nutual") as! String).toInt()!) / Float(sumDesType)
            
            
            progressMesuem.progress = Float((behaviourInfo.objectForKey("info")!.objectForKey("des")?.objectForKey("mesuem") as! String).toInt()!) / Float(sumDesType)
            
            
            
            progressThemepark.progress = (Float((behaviourInfo.objectForKey("info")!.objectForKey("des")?.objectForKey("themepark") as! String).toInt()!) + Float((behaviourInfo.objectForKey("info")!.objectForKey("des")?.objectForKey("outdoor") as! String).toInt()!) ) / Float(sumDesType)
            
            
            progressSea.progress = Float((behaviourInfo.objectForKey("info")!.objectForKey("des")?.objectForKey("sea") as! String).toInt()!) / Float(sumDesType)
            
        }
        
        labCatUser1.text = (behaviourInfo.objectForKey("info")!.objectForKey("maxCat") as! NSArray).objectAtIndex(0).objectForKey("catName") as! String
        
        labCatUser2.text = (behaviourInfo.objectForKey("info")!.objectForKey("maxCat") as! NSArray).objectAtIndex(1).objectForKey("catName") as! String
        
        labCatUser3.text = (behaviourInfo.objectForKey("info")!.objectForKey("maxCat") as! NSArray).objectAtIndex(2).objectForKey("catName") as! String
        
        labPer1.text = (behaviourInfo.objectForKey("info")!.objectForKey("maxCat") as! NSArray).objectAtIndex(0).objectForKey("num") as! String
        labPer2.text = (behaviourInfo.objectForKey("info")!.objectForKey("maxCat") as! NSArray).objectAtIndex(1).objectForKey("num") as! String
        labPer3.text = (behaviourInfo.objectForKey("info")!.objectForKey("maxCat") as! NSArray).objectAtIndex(2).objectForKey("num") as! String

    }
    
    func fullCatName(catName : String ) -> String{
        
        if catName == "art" {
            return "Art"
        }
        else if catName == "entertain" {
            return "Entertainment"
        }
        else if catName == "historic" {
            return "Historical"
        }
        else if catName == "mesuem" {
            return "Mesuem"
        }
        else if catName == "nutual" {
            return "Nature"
        }
        else if catName == "outdoor" {
            return "Outdoor"
        }
        else if catName == "sea" {
            return "Sea"
        }
        else {
            return "Outdoor"
        }
        
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


    //MARK:-
    //MARK: event button
    //MARK:-
    @IBAction func clickBack(sender: AnyObject) {
        
        self.navigationController?.navigationBar.hidden = true
        var storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController : MainViewController = storyBoard.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
        self.mainViewController = UINavigationController(rootViewController: mainViewController)
        
        
        self.navigationController?.popViewControllerAnimated(true)
        self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)
    }


    
}
