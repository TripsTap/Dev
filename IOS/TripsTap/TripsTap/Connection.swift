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

//
//===============================================================================
//  singleton
//===============================================================================
//
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
//===============================================================================
//  variable
//===============================================================================
//
    
    let baseUrl : String = "https://api.mongolab.com/api/1/databases/triptap_location_category/collections/"
    let apiKey : String = "pssG0fVnXU2G1hV3eI9_SuidpTGqSi4N"
    
    
    let CLIENT_ID = "VQFA1NFZFVHNCSQL1GTBVAOWBDQOHSQEHOW5YZKU1IS1JRFO"
    let CLIENT_SECRET = "KMIYI5FXHQFHCQYKRE35EKX125UEH4AQERSJRXMAZXDRFLDF"
//
//===============================================================================
//  function
//===============================================================================
//

    func getCategoryTripsMe(location : String ,place : Int  , completion :((result : AnyObject! , error : NSError! ) ->()) )
    {
        
        var url = baseUrl + "category"

        var parameter : NSMutableDictionary! = NSMutableDictionary()
        parameter.setObject(location, forKey: "nameEng")
        
        
        Alamofire.request(.GET, url, parameters: ["q": parameter , "apiKey" : apiKey ]  ).responseJSON { (request, response, data, error) -> Void in
            
            println("---------------------")
            println("get category")
            println(data)
            completion(result: data, error: error)
            println("---------------------")
        }
        
        

    }
    
    func getRuleTripsMe(location: String , completion :((result : AnyObject! , error : NSError! ) ->())){
        var url = "https://api.mongolab.com/api/1/databases/triptap_tripme_rules/collections/rules"
        
        var parameter : NSMutableDictionary! = NSMutableDictionary()
        parameter.setObject(location, forKey: "state_init")

        
        Alamofire.request(.GET, url, parameters: ["q":parameter , "apiKey" : apiKey]  ).responseJSON { (request, response, data, error) -> Void in
            
            println("---------------------")
            println("getRuleTripsMe")
            println(data)
            completion(result: data, error: error)
        }
    }
    
    
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
    
    func getInfoRestaAndHotel(idString : String, completion : (result : AnyObject! , error : NSError!) ->() ){
        
        var url = "https://api.foursquare.com/v2/venues/"+idString+"?&client_id="+(self.CLIENT_ID as String)+"&client_secret="+(self.CLIENT_SECRET as String)+"&v=20130815"
        
        Alamofire.request(.GET, url, parameters: nil  ).responseJSON { (request, response, data, error) -> Void in
            println("---------------------")
            println("get info resraurant and hotel")
            println(data)
            completion(result: data, error: error)
        }
    }
    
    func getImage(url : String , completion : (result : AnyObject! , error : NSError!)->() ){
        
        
    }

}
