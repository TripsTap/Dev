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
   
    override init(){
        println("init conection")
    }
    
    
    
    let baseUrl : String = "http://171.98.210.83:8080/TripTap/rest/service/"
    
    
    func getCategoryTripsMe(location : String ,place : Int   ){
        
        var url = baseUrl + "getCategory"
        
        Alamofire.request(.GET, url, parameters: ["location": "phuket", "place" : 0]  ).responseJSON { (request, response, data, error) -> Void in
            println(request)
            println(response)
            println(error)
            println("---------------------")
            println(data?.description)

        }
    }
    
    func getRuleTripsMe(categories : Int){
        
    }
}
