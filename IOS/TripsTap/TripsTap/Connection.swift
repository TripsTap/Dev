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
//

    func getCategoryTripsMe(location : String ,place : Int  , completion :((result : AnyObject! , error : NSError! ) ->()) )
    {
        
        var url = "https://api.mongolab.com/api/1/databases/triptap_location_category/collections/category"

//        var parameter : NSMutableDictionary! = NSMutableDictionary()
//        parameter.setObject(location, forKey: "state_init")
        
        var parameter : String = String(format:  "{  \"state_init\" : \"%@\"   }", location)

        Alamofire.request(.GET, url, parameters: ["q": parameter , "apiKey" : apiKey ]  ).responseJSON { (request, response, data, error) -> Void in
            
            println("---------------------")
            println("get category")
            println("---------------------")
            completion(result: data, error: error)
        }
        
        

    }
    
    func getRuleTripsMe(location: String , category : NSArray , completion :((result : AnyObject! , error : NSError! ) ->())){
        var url = "https://api.mongolab.com/api/1/databases/triptap_tripme_rules/collections/rules"
        
        
        
        
        
        var descriptor: NSSortDescriptor = NSSortDescriptor(key: "", ascending: true)
        var categorySort: NSArray = category.sortedArrayUsingDescriptors([descriptor])
        
        
//        var parameter : String = String(format: " { \"state_init\" : \"%@\" , \"catsPremiss.catName\" : {$all:[\"%@\"]} }", location,categorySort.componentsJoinedByString("\",\"") as String)
        
        var parameter : String = String(format: "{\"state_init\":\"%@\",\"$or\":[{\"catsPremiss.catName\":{$all:[\"%@\"]}},{\"catsConclu.catName\":{$all:[\"%@\"]}}]}",location,categorySort.componentsJoinedByString("\",\"") as String , categorySort.componentsJoinedByString("\",\"") as String )
        
        Alamofire.request(.GET, url, parameters: ["q":parameter , "apiKey" : apiKey]  ).responseJSON { (request, response, data, error) -> Void in
            
            println("---------------------")
            println("getRuleTripsMe")
            println("---------------------")
            completion(result: data, error: error)
        }
    }
    
    func getInfoVenue(location : String, venue : String , completion :(result : AnyObject! , error : NSError!) ->()){
        var url = "https://api.mongolab.com/api/1/databases/triptap_venue_information/collections/venues"
        
        var parameterQ : String = String(format: "{\"state_init\":\"%@\"}", location)
        var parameterF : String = String(format: "{venues:{$elemMatch:{venueId:\"%@\"}}}", venue)

        Alamofire.request(.GET, url, parameters: ["q" : parameterQ , "f" : parameterF ,"apiKey" : apiKey]).responseJSON { (request, response , data , error) -> Void in
            
            println("getInfoVenue")
            completion(result: data, error: error)
        }

    }
//MARK:-
//MARK: trip for you
//MARK:-
    
    func setBehaviour(info : NSArray , userID : String! , completion : (result : AnyObject! , error : NSError!) -> ()){
        
        var url = "https://api.mongolab.com/api/1/databases/triptap_user_data/collections/user_data?apiKey=pssG0fVnXU2G1hV3eI9_SuidpTGqSi4N"
        
        var userIDDupicate = userID
        
        Alamofire.request(.POST , url , parameters:["userID":userID , "info": info ], encoding: .JSON ).responseJSON { (request, response, data, error) -> Void in
            println("---------------------")
            println("set Behaviour ")
            println(data)
            
            self.getSameBehaviour(userIDDupicate)
            
            
            completion(result: data, error: error)
            
        }
        
    }
    
    func getSameBehaviour(userID : String!){
        
        println("userID : \(userID)")
        var url = "http://128.199.130.63:3000/triptap?userId=\(userID)"
        println("url : \(url)")
        
        
        
        Alamofire.request(.POST , url , parameters: nil ).responseJSON { (request, response, data, error) -> Void in
            println("---------------------")
            println("get same Behaviour ")
            println(data)
            
        }

        
    }
    
//MARK:-
//MARK: Rstaurant and Hotel
//MARK:-
    
    func getRestaurant(ll : String ,completion :( ( result : AnyObject! , error : NSError! )  ->()) ){
        
        var url = "https://api.foursquare.com/v2/venues/search?near=phuket&client_id="+(self.CLIENT_ID as String)+"&client_secret="+(self.CLIENT_SECRET as String)+"&categoryId=4d4b7105d754a06374d81259&v=20130815"
        
        Alamofire.request(.GET, url, parameters: nil  ).responseJSON { (request, response, data, error) -> Void in    
            println("---------------------")
            println("get Restaurant ")
            println(data)
            completion(result: data, error: error)
            
        }
        
        
    }
    
    func getHotel(ll : String ,completion :( ( result : AnyObject! , error : NSError! )  ->()) ){
        
        var url = "https://api.foursquare.com/v2/venues/search?near=phuket&client_id="+(self.CLIENT_ID as String)+"&client_secret="+(self.CLIENT_SECRET as String)+"&categoryId=4bf58dd8d48988d1fa931735&v=20130815"
        
        Alamofire.request(.GET, url, parameters: nil  ).responseJSON { (request, response, data, error) -> Void in
            println("---------------------")
            println("get Hotel")
            println(data)
            completion(result: data, error: error)
            
        }
        
    }
    

//MARK:-
//MARK: Rstaurant and Hotel
//MARK:-
    
    func getInfoFromFoursquare(idString : String, completion : (result : AnyObject! , error : NSError!) ->() ){
        
        var url = "https://api.foursquare.com/v2/venues/"+idString+"?&client_id="+(self.CLIENT_ID as String)+"&client_secret="+(self.CLIENT_SECRET as String)+"&v=20130815"
        
        Alamofire.request(.GET, url, parameters: nil  ).responseJSON { (request, response, data, error) -> Void in
            println("---------------------")
            println("get info resraurant and hotel")
            println("---------------------")
            completion(result: data, error: error)
        }
    }
    
    func getAllImageFromFS(venueID : String , completion : (result : AnyObject! , error : NSError!) -> () ){
        var url = String(format: "https://api.foursquare.com/v2/venues/%@/photos?client_id=%@&client_secret=%@&&v=20130815&limit=200", venueID, CLIENT_ID,CLIENT_SECRET)
        
        Alamofire.request(.GET, url, parameters: nil  ).responseJSON { (request, response, data, error) -> Void in
            println("---------------------")
            println("get all url of image")
            println("---------------------")
            completion(result: data, error: error)
        }
        
    }
    
    func getImage(url : String , completion : (image : UIImage! )->() ){
        ImageLoader.sharedLoader.imageForUrl(url) { (image, url) -> () in
            completion(image: image)
        }
        
    }

}
