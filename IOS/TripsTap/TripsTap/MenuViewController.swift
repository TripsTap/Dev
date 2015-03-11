//
//  MenuViewController.swift
//  TripsTap
//
//  Created by Piyawut Kamwiset on 3/10/2558 BE.
//  Copyright (c) 2558 Piyawut Kamwiset. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, FBLoginViewDelegate {

    
    @IBOutlet weak var fbView: FBLoginView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fbView.delegate = self
        fbView.readPermissions = ["public_profile", "email", "user_friends","user_tagged_places"]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // facebook sdk
    
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
//            }
            

        })

        

    }
    
    
    func getInfoOfCategory(cateID : String){
        
        FBRequestConnection.startWithGraphPath("/"+cateID, completionHandler: { (connection : FBRequestConnection!, result : AnyObject!, error : NSError!) -> Void in

            println(result.description)
        })
        
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
