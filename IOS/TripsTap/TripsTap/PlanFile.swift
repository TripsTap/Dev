//
//  PlanFile.swift
//  TripsTap
//
//  Created by Piyawut Kamwiset on 4/6/2558 BE.
//  Copyright (c) 2558 Piyawut Kamwiset. All rights reserved.
//

import UIKit

class PlanFile: NSObject {
   
    var listPlan : NSMutableArray!
    var fileName : String = "plan.peach"
    var fileBehaviour : String = "behaviour.peach"
    var behaviour : NSMutableDictionary!
    
    class var sharedInstance: PlanFile {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: PlanFile? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = PlanFile()
        }
        return Static.instance!
    }

    override init()  {

        super.init()
        
        println("init planfile class")
        var realPath : String = applicationDocumentsDirectory(fileName)
        
        if(NSFileManager.defaultManager().fileExistsAtPath(realPath)){
            listPlan = NSMutableArray(contentsOfFile: realPath)

            
        }
        else{
            listPlan = NSMutableArray()
            saveFile()
        }
        
        
        realPath = applicationDocumentsDirectory(fileBehaviour)
        if(NSFileManager.defaultManager().fileExistsAtPath(realPath)){
            behaviour = NSMutableDictionary(contentsOfFile: realPath)
            
            
        }
        else{
            behaviour = NSMutableDictionary()
            saveFile()
        }
        
        
    }
    
    
    
    func saveFile(){
        var realPath = applicationDocumentsDirectory(fileName)
        listPlan.writeToFile(realPath, atomically: true)
    }
    
    func deletePlanWithIndex(index : Int ){
        listPlan.removeObjectAtIndex(index)
        saveFile()
    }
    
    
    func applicationDocumentsDirectory(fileName : String) -> String{
        let dirs: [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String]
        let directories:[String] = dirs!
        var realPath = String(format: "%@%@", directories[0] , fileName)
        return realPath
        
    }
    
    
//    behaviour
    func saveBehaviour(){
        var realPath = applicationDocumentsDirectory(fileBehaviour)
        self.behaviour.writeToFile(realPath, atomically: true)
    }
    func getBehaviour() -> NSDictionary?{
        var realPath : String = applicationDocumentsDirectory(fileBehaviour)
        return NSDictionary(contentsOfFile: realPath)
    }
    
    func deleteBehaviour(){
        var behaviour : NSDictionary = NSDictionary()
        var realPath = applicationDocumentsDirectory(fileBehaviour)
        behaviour.writeToFile(realPath, atomically: true)
    }

    
    
    
    
    
    
    
}
