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
    var tirpMeViewController: UIViewController!
    var restaAndHotelViewController: UIViewController!
    var storyboards = UIStoryboard(name: "Main", bundle: nil)
    var infoCateArr : NSMutableArray = NSMutableArray()
    var countTagPlace : Int!

//MARK:-
//MARK: cycle
//MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // facebook login
        fbView.delegate = self
        fbView.readPermissions = ["public_profile", "email", "user_friends","user_tagged_places"]
        
        
        let tirpMeViewController = storyboards.instantiateViewControllerWithIdentifier("TirpMeViewController") as TripMeViewController
        self.tirpMeViewController = UINavigationController(rootViewController: tirpMeViewController)
        
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
        var userEmail = user.objectForKey("email") as String
        println("User Email: \(userEmail)")
        
        getPlaceFromFB(user.objectID)
    }
    
    func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
        println("User Logged Out")
    }
    
    func loginView(loginView : FBLoginView!, handleError:NSError) {
        println("Error: \(handleError.localizedDescription)")
    }
    
    
    
    func getPlaceFromFB(userID : String){

        
        FBRequestConnection.startWithGraphPath("/"+userID+"?fields=tagged_places.limit(200)", completionHandler: { (connection : FBRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            
//            var jsonFeeds = result as FBGraphObject
            
//            var jsonArray : Array = ((jsonFeeds["tagged_places"] as FBGraphObject)["data"] as NSMutableArray)
//            for(var i = 0; i < jsonArray.count ; i++){
            
                println(result.description)
            
            var taggedPlaces : NSArray = (result as NSDictionary).objectForKey("tagged_places")?.objectForKey("data") as NSArray
            
            self.countTagPlace = taggedPlaces.count
            
            for(var i = 0 ; i < taggedPlaces.count ; i++){
                self.getInfoOfCategory((taggedPlaces.objectAtIndex(i).objectForKey("place") as NSDictionary).objectForKey("id") as String)
            }
//            }
            

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
                println("send request")
                println(self.infoCateArr)
            }
        })
        
    }
    
    
//MARK:-
//MARK: button action
//MARK:-
    
    @IBAction func clickTripMe(sender: AnyObject) {
        self.slideMenuController()?.changeMainViewController(self.tirpMeViewController, close: true)
    }
    
    @IBAction func clickRes(sender: AnyObject) {
        

        let restaAndHotelViewController = storyboards.instantiateViewControllerWithIdentifier("RestaAndHotelViewController") as RestaAndHotelViewController
        restaAndHotelViewController.pageType = "restaurant"
        self.restaAndHotelViewController = UINavigationController(rootViewController: restaAndHotelViewController)
        
        
        self.slideMenuController()?.changeMainViewController(self.restaAndHotelViewController, close: true)
    }
    
    
    @IBAction func clickHotel(sender: AnyObject) {
        let restaAndHotelViewController = storyboards.instantiateViewControllerWithIdentifier("RestaAndHotelViewController") as RestaAndHotelViewController
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
