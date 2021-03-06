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
    var mainViewController: UIViewController! // main view page
    var tripMeViewController: UIViewController!  // trip me page
    var tripForYouViewController: UIViewController!  // trip for u page
    var mapViewController: UIViewController!  // map view page
    var restaAndHotelViewController: UIViewController! // restaurant and hotel page
    var storyboards = UIStoryboard(name: "Main", bundle: nil)
    var infoCateArr : NSMutableArray = NSMutableArray() // info of category that user used to check in from facebook
    var countTagPlace : Int! // check place load all complete
    var FBID : String! // user id of facebook
    var FBName : String! // user name of facebook
    var isLogin : Int! = 0

    
//MARK:-
//MARK: cycle
//MARK:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // facebook login set premissions
        fbView.delegate = self
        fbView.readPermissions = ["public_profile", "email","user_tagged_places" ,"publish_actions"]
        
        
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
        
        // save info of user
        planFile.behaviour.setObject(FBID, forKey: "FBID")
        planFile.behaviour.setObject(FBName, forKey: "FBName")
//        planFile.behaviour.setObject(user.objectForKey("email"), forKey: "FBMail")
//        planFile.behaviour.setObject(user.objectForKey("gender"), forKey: "FBGender")
        planFile.saveBehaviour()
//        Connection.sharedInstance.getSameBehaviour(FBID)
        
        if isLogin == 0 {
            getProfileImage()
            getPlaceFromFB()
            isLogin = 1
        }
        
    }
    
    func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
        PlanFile.sharedInstance.behaviour.removeAllObjects()
        PlanFile.sharedInstance.saveBehaviour()
        isLogin = 0
        println("User Logged Out")
    }
    
    func loginView(loginView : FBLoginView!, handleError:NSError) {
        println("Error: \(handleError.localizedDescription)")
    }
    
    
//MARK:-
//MARK: function
//MARK:-
    
    /*
    des :   get place of user that used to cehck in with facebook
    
    */
    func getPlaceFromFB(){
        
        self.infoCateArr.removeAllObjects()

        FBRequestConnection.startWithGraphPath("/"+FBID+"?fields=tagged_places.limit(100)", completionHandler: { (connection : FBRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            
            if error == nil {

                if (result as! NSDictionary).objectForKey("tagged_places") != nil {
                    var taggedPlaces : NSArray = (result as! NSDictionary).objectForKey("tagged_places")?.objectForKey("data") as! NSArray
                    
                    self.countTagPlace = taggedPlaces.count
                    
                    println(taggedPlaces.count)
                    for(var i = 0 ; i < taggedPlaces.count ; i++){
                        
                        self.getInfoOfCategory((taggedPlaces.objectAtIndex(i).objectForKey("place") as! NSDictionary).objectForKey("id") as! String)
                    }
                }
            }

            
        })

    }
    
    /*
    des :   get cate info of each plach
    
    para :
            cateID : catogory id of each place
    
    */
    func getInfoOfCategory(cateID : String){

        FBRequestConnection.startWithGraphPath("/"+cateID, completionHandler: { (connection : FBRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            
            
            if error == nil {
                var infoCateDic : NSMutableDictionary = NSMutableDictionary()
                infoCateDic.setObject(result.objectForKey("category")!, forKey: "category")
                infoCateDic.setObject(result.objectForKey("category_list")!, forKey: "category_list")
                infoCateDic.setObject(result.objectForKey("location")!, forKey: "location")
                
                self.infoCateArr.addObject(infoCateDic)
                println(self.infoCateArr.count)
                if self.countTagPlace == self.infoCateArr.count  || self.infoCateArr.count == 100 {
                    var connection : Connection = Connection.sharedInstance
                    
                    connection.setBehaviour( self.infoCateArr, userID: self.FBID)
                    
                }
            
            }
            else{
                self.countTagPlace = self.countTagPlace - 1
            }
            
        })
        
    }
    
    /*
    des :   load image of user from facebook
    
    */
    func getProfileImage(){
        
        var connection : Connection = Connection.sharedInstance
         
        connection.getImageFacebook(FBID)
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
        PlanFile.sharedInstance.saveBehaviour()
        
        if PlanFile.sharedInstance.behaviour.objectForKey("info") != nil{
            self.slideMenuController()?.changeMainViewController(self.tripForYouViewController, close: true)
        }
        else{
            // must login before
            if PlanFile.sharedInstance.behaviour.objectForKey("FBID") == nil{
                UIAlertView(title: nil, message: "Please login with Facebook!", delegate: self, cancelButtonTitle: "OK").show()
            }
            // wait info
            else{
                
            }
        }
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
    
    @IBAction func clickMap(sender: AnyObject) {
        
        if PlanFile.sharedInstance.listPlan.count != 0 {
            let mapViewController = storyboards.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
            mapViewController.pageType = "Main"
            self.mapViewController = UINavigationController(rootViewController: mapViewController)
            
            self.slideMenuController()?.changeMainViewController(self.mapViewController, close: true)
        }
        
    }
    


}
