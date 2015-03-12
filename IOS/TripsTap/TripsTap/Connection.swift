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
    
    let baseUrl : String = "http://171.98.210.83:8080/TripTap/rest/service/"
    
    
//
//===============================================================================
//  function
//===============================================================================
//

    func getCategoryTripsMe(location : String ,place : Int  , completion :((result : NSObject , error : NSError ) ->()) )
    {
        
        var url = baseUrl + "getCategory"
        
        Alamofire.request(.GET, url, parameters: ["location": location , "place" : 0]  ).responseJSON { (request, response, data, error) -> Void in
            println(request)
            println(response)
            println(error)
            println("---------------------")
            println(data?.description)
            
        
            completion(result: response!, error: error!)
        }
        
        

    }
    
    func getRuleTripsMe(categories : Int){
        
    }
}
