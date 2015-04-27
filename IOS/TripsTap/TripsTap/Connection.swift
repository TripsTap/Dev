//
//  Connection.swift
//  TripsTap
//
//  Created by Piyawut Kamwiset on 3/11/2558 BE.
//  Copyright (c) 2558 Piyawut Kamwiset. All rights reserved.
//

import UIKit
import Alamofire
class Connection: NSObject {


    
//MARK: -
//MARK: singleton
//MARK: -
    class var sharedInstance: Connection {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: Connection? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = Connection()
        }
        return Static.instance!
    }
    
    override init() {
        println("init class")
    }
    
//
//MARK: -
//MARK: variable
//MARK: -
//
    
    let apiKey : String = "pssG0fVnXU2G1hV3eI9_SuidpTGqSi4N"
    
    
    let CLIENT_ID = "VQFA1NFZFVHNCSQL1GTBVAOWBDQOHSQEHOW5YZKU1IS1JRFO"
    let CLIENT_SECRET = "KMIYI5FXHQFHCQYKRE35EKX125UEH4AQERSJRXMAZXDRFLDF"
    
    
//
//MARK: -
//MARK: Trip me
//MARK: -
    
    /*
        des :   request for get category of location
    
        para :
                location : location that select
    
                completion : call back when request is finish

    */
    func getCategoryTripsMe(location : String , place : Int  , completion :((result : AnyObject! , error : NSError! ) ->()) )
    {
        
        var url = "https://api.mongolab.com/api/1/databases/triptap_location_category/collections/category"
        var parameter : String = String(format:  "{  \"state_init\" : \"%@\"   }", location)
        
        Alamofire.request(.GET, url, parameters: ["q": parameter , "apiKey" : apiKey ]  ).responseJSON { (request, response, data, error) -> Void in
            println("---------------------")
            println("get category")
            println("---------------------")
            completion(result: data, error: error)
        }
    }
    
    /*
    des :
            request for get get plan in category that select
    
    para :
            location : location that select
            category : category that select (must sort already)
        
            completion : call back when request is finish
    */
    func getRuleTripsMe(location: String , category : NSArray , completion :((result : AnyObject! , error : NSError! ) ->())){
        var url = "https://api.mongolab.com/api/1/databases/triptap_tripme_rules/collections/rules"
        var descriptor: NSSortDescriptor = NSSortDescriptor(key: "", ascending: true)
        var categorySort: NSArray = category.sortedArrayUsingDescriptors([descriptor])
        
//        {"state_init":"Phuket","catAll.catName":{$all:["Beach","Bridge","Buddhist%20Temple"]}}
        var parameter : String = String(format: "{\"state_init\":\"%@\",\"catAll.catName\":{$all:[\"%@\"]}}",location,categorySort.componentsJoinedByString("\",\"") as String)
        
        Alamofire.request(.GET, url, parameters: ["q":parameter , "apiKey" : apiKey]  ).responseJSON { (request, response, data, error) -> Void in
            
            println("---------------------")
            println("getRuleTripsMe")
            println("---------------------")
            completion(result: data, error: error)
        }
    }
    
    /*
    des :
            request for get info of each place
    
    para :
            location : location that select
            venue : is id of place from FS
    
            completion : call back when request is finish
    */

    
    func getInfoVenue(location : String, venue : String , completion :(result : AnyObject! , error : NSError!) ->()){
        var url = "https://api.mongolab.com/api/1/databases/triptap_venue_information/collections/venues"
        
        var parameterQ : String = String(format: "{\"state_init\":\"%@\"}", location)
        var parameterF : String = String(format: "{venues:{$elemMatch:{venueId:\"%@\"}}}", venue)
        
        Alamofire.request(.GET, url, parameters: ["q" : parameterQ , "f" : parameterF ,"apiKey" : apiKey]).responseJSON { (request, response , data , error) -> Void in
            println("---------------------")
            println("getInfoVenue")
            println("---------------------")
            completion(result: data, error: error)
        }
        
    }
    
//MARK:-
//MARK: trip for you
//MARK:-
    
    
    /*
    des :
        POST request for save behaviour of user for find trip
    
    para :
        info : place that user used to go already
        userID : facebook ID
    
    */

    func setBehaviour(info : NSArray , userID : String! ){
        
        var url = "https://api.mongolab.com/api/1/databases/triptap_user_data/collections/user_data?apiKey=pssG0fVnXU2G1hV3eI9_SuidpTGqSi4N"
        
        var userIDDupicate = userID
        
        Alamofire.request(.POST , url , parameters:["userID":userID , "info": info ], encoding: .JSON ).responseJSON { (request, response, data, error) -> Void in

            println("---------------------")
            println("set Behaviour ")
            println("---------------------")
            self.getSameBehaviour(userIDDupicate)
            
        }
        
    }
    
    /*
    des :
        Get trip that same with behaviour of user
    
    para :
        userID : facebook ID
    
    */
    
    func getSameBehaviour(userID : String!){
        
//        Alamofire.request(.GET , "https://api.mongolab.com/api/1/databases/knn_result/collections/user_id?apiKey=pssG0fVnXU2G1hV3eI9_SuidpTGqSi4N" , parameters: nil ).responseJSON { (request, response, data, error) -> Void in
//            println("---------------------")
//            println("get same Behaviour ")
//            println(data)
//            if error == nil {
//                // save plan
//                var planFile : PlanFile = PlanFile.sharedInstance
//                var trip : NSDictionary! = NSDictionary(dictionary: data?.objectAtIndex(1) as! NSDictionary)
//                planFile.behaviour.setObject( trip , forKey: "info")
//                planFile.saveBehaviour()
//            }
//        }

        
        var url = "http://128.199.130.63:3000/triptap"

        
        Alamofire.request(.GET , url , parameters: ["userId" : userID] ).responseJSON { (request, response, data, error) -> Void in
            println("---------------------")
            println("get same Behaviour ")
            println("---------------------")
            println(data?.description)
            println(data?.objectForKey("des"))
            if error == nil && data?.objectForKey("response") as? String != "try again" && data != nil {
                var planFile : PlanFile = PlanFile.sharedInstance
                var trip : NSMutableDictionary! = NSMutableDictionary(dictionary: data as! [NSObject : AnyObject])
                planFile.behaviour.setObject( trip , forKey: "info")
                planFile.saveBehaviour()
            }
        }

        
    }
    
    /*
    des :
        load profile image from facebook
    
    para :
        userID : facebook ID
    
    */
    func getImageFacebook(userID : String!){
        
        var url = "https://graph.facebook.com/\(userID)/picture?type=large"
        ImageLoader.sharedLoader.imageForUrl(url) { (image, url) -> () in
            if image != nil {
                var planFile : PlanFile = PlanFile.sharedInstance
                var imageData : NSData = UIImagePNGRepresentation(image)
                
                planFile.behaviour.setObject(imageData, forKey: "image")
                planFile.saveBehaviour()
            }

        }
        
    }

    
//MARK:-
//MARK: Rstaurant and Hotel
//MARK:-
    
    /*
    des :
        GET request for ger list reataurant
    
    para :
        ll : latatude and longtitude
    
        completion : call back
    
    */
    
    func getRestaurant(ll : String ,completion :( ( result : AnyObject! , error : NSError! )  ->()) ){
        
        var url = "https://api.foursquare.com/v2/venues/search?ll="+ll+"&client_id="+(self.CLIENT_ID as String)+"&client_secret="+(self.CLIENT_SECRET as String)+"&categoryId=4d4b7105d754a06374d81259&v=20130815"
        
        Alamofire.request(.GET, url, parameters: nil  ).responseJSON { (request, response, data, error) -> Void in    
            println("---------------------")
            println("get Restaurant ")
            println(data)
            completion(result: data, error: error)
            
        }
        
        
    }
    
    /*
    des :
        GET request for ger list hotel
    
    para :
        ll : latatude and longtitude
    
        completion : call back
    
    */
    func getHotel(ll : String ,completion :( ( result : AnyObject! , error : NSError! )  ->()) ){
        
        var url = "https://api.foursquare.com/v2/venues/search?ll="+ll+"&client_id="+(self.CLIENT_ID as String)+"&client_secret="+(self.CLIENT_SECRET as String)+"&categoryId=4bf58dd8d48988d1fa931735&v=20130815"
        
        Alamofire.request(.GET, url, parameters: nil  ).responseJSON { (request, response, data, error) -> Void in
            println("---------------------")
            println("get Hotel")
            println(data)
            completion(result: data, error: error)
            
        }
        
    }
    

//MARK:-
//MARK: info from FS
//MARK:-
    
    /*
    des :
        GET request for get info of each place
    
    para :
        idString : id of place from FS
    
        completion : call back
    
    */
    
    func getInfoFromFoursquare(idString : String, completion : (result : AnyObject! , error : NSError!) ->() ){
        
        var url = "https://api.foursquare.com/v2/venues/"+idString+"?&client_id="+(self.CLIENT_ID as String)+"&client_secret="+(self.CLIENT_SECRET as String)+"&v=20130815"
        
        Alamofire.request(.GET, url, parameters: nil  ).responseJSON { (request, response, data, error) -> Void in
            println("---------------------")
            if error == nil {
                println("get info venue success")
            }
            else {
                println("get info venue not success")
            }
            println("---------------------")
            completion(result: data, error: error)
        }
    }
    
    
    /*
    des :
        GET request for get list URL image
    
    para :
        venueID : venue id of place
    
        completion : call back
    
    */
    func getAllImageFromFS(venueID : String , completion : (result : AnyObject! , error : NSError!) -> () ){
        var url = String(format: "https://api.foursquare.com/v2/venues/%@/photos?client_id=%@&client_secret=%@&&v=20130815&limit=200", venueID, CLIENT_ID,CLIENT_SECRET)
        
        Alamofire.request(.GET, url, parameters: nil  ).responseJSON { (request, response, data, error) -> Void in
            println("---------------------")

            if error == nil {
                println("get all url of image ss")
            }
            else {
                println("get all url of image n ss")
            }
            println("---------------------")
            completion(result: data, error: error)
        }
        
    }
    

    /*
    des :
        load image
    
    para :
        url : String url
    
        completion : call back
    
    */
    func getImage(url : String , completion : (image : UIImage! )->() ){
        ImageLoader.sharedLoader.imageForUrl(url) { (image, url) -> () in
            completion(image: image)
        }
    }

}
