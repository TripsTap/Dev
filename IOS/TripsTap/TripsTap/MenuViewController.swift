//
//  MenuViewController.swift
//  TripsTap
//
//  Created by Piyawut Kamwiset on 3/10/2558 BE.
//  Copyright (c) 2558 Piyawut Kamwiset. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, FBLoginViewDelegate {

//MARK:- 
//MARK: IBOutlet
//MARK:-
    @IBOutlet weak var fbView: FBLoginView!
    
    
//MARK:-
//MARK: variable
//MARK:-
    var mainViewController: UIViewController!
    var tripMeViewController: UIViewController!
    var tripForYouViewController: UIViewController!
    var restaAndHotelViewController: UIViewController!
    var storyboards = UIStoryboard(name: "Main", bundle: nil)
    var infoCateArr : NSMutableArray = NSMutableArray()
    var countTagPlace : Int!
    
    var FBID : String!
    var FBName : String!

    
//MARK:-
//MARK: cycle
//MARK:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // facebook login
        fbView.delegate = self
        fbView.readPermissions = ["public_profile", "email", "user_friends","user_tagged_places"]
        
        
        
        
        let tripForYouViewController = storyboards.instantiateViewControllerWithIdentifier("TripForYouViewController") as! TripForYouViewController
        self.tripForYouViewController = UINavigationController(rootViewController: tripForYouViewController)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

//MARK:-
//MARK: facebook delegate
//MARK:-
    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
        println("User Logged In")
    }
    
    func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser) {
        println("User: \(user)")
        println("User ID: \(user.objectID)")
        println("User Name: \(user.name)")

        FBID = (user.objectID) as String
        FBName = (user.name) as String
        var planFile : PlanFile = PlanFile.sharedInstance
        if(planFile.getBehaviour("behaviour.piyawut") as NSDictionary? == nil ){
            getPlaceFromFB()
        }
    }
    
    func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
        println("User Logged Out")
    }
    
    func loginView(loginView : FBLoginView!, handleError:NSError) {
        println("Error: \(handleError.localizedDescription)")
    }
    
    
//MARK:-
//MARK: function
//MARK:-
    func getPlaceFromFB(){

        FBRequestConnection.startWithGraphPath("/"+FBID+"?fields=tagged_places.limit(200)", completionHandler: { (connection : FBRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            
                println(result.description)
            
            var taggedPlaces : NSArray = (result as! NSDictionary).objectForKey("tagged_places")?.objectForKey("data") as! NSArray
            
            self.countTagPlace = taggedPlaces.count
            
            for(var i = 0 ; i < taggedPlaces.count ; i++){
                self.getInfoOfCategory((taggedPlaces.objectAtIndex(i).objectForKey("place") as! NSDictionary).objectForKey("id") as! String)
            }
            
        })

    }
    
    
    func getInfoOfCategory(cateID : String){

        FBRequestConnection.startWithGraphPath("/"+cateID, completionHandler: { (connection : FBRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            var infoCateDic : NSMutableDictionary = NSMutableDictionary()
            infoCateDic.setObject(result.objectForKey("category")!, forKey: "category")
            infoCateDic.setObject(result.objectForKey("category_list")!, forKey: "category_list")
            infoCateDic.setObject(result.objectForKey("location")!, forKey: "location")
            
            self.infoCateArr.addObject(infoCateDic)

            if self.countTagPlace == self.infoCateArr.count{
                println("send load place complete")
                var connection : Connection = Connection.sharedInstance
                
                connection.setBehaviour( self.infoCateArr, userID: self.FBID, completion: { (result, error) -> () in
                    println("set behaviour success")
                })
            }
        })
        
    }
    
    
//MARK:-
//MARK: button action
//MARK:-
    
    @IBAction func clickTripMe(sender: AnyObject) {
        
        let tripMeViewController = storyboards.instantiateViewControllerWithIdentifier("TirpMeViewController") as! TripMeViewController
        tripMeViewController.pageType = "Menu"
        self.tripMeViewController = UINavigationController(rootViewController: tripMeViewController)
        
        self.slideMenuController()?.changeMainViewController(self.tripMeViewController, close: true)
    }
    
    @IBAction func clickTripForYou(sender: AnyObject) {
        self.slideMenuController()?.changeMainViewController(self.tripForYouViewController, close: true)
    }
    
    @IBAction func clickRes(sender: AnyObject) {
        

        let restaAndHotelViewController = storyboards.instantiateViewControllerWithIdentifier("RestaAndHotelViewController") as! RestaAndHotelViewController
        restaAndHotelViewController.pageType = "restaurant"
        self.restaAndHotelViewController = UINavigationController(rootViewController: restaAndHotelViewController)
        
        
        self.slideMenuController()?.changeMainViewController(self.restaAndHotelViewController, close: true)
    }
    
    
    @IBAction func clickHotel(sender: AnyObject) {
        let restaAndHotelViewController = storyboards.instantiateViewControllerWithIdentifier("RestaAndHotelViewController") as! RestaAndHotelViewController
        restaAndHotelViewController.pageType = "hotel"
        self.restaAndHotelViewController = UINavigationController(rootViewController: restaAndHotelViewController)
        
        self.slideMenuController()?.changeMainViewController(self.restaAndHotelViewController, close: true)
        
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
