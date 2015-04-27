//
//  PlanFile.swift
//  TripsTap
//
//  Created by Piyawut Kamwiset on 4/6/2558 BE.
//  Copyright (c) 2558 Piyawut Kamwiset. All rights reserved.
//

import UIKit

class PlanFile: NSObject {

    
    //MARK:-
    //MARK: variable
    //MARK:-
    
    var listPlan : NSMutableArray!  // plan that user save already
    var fileName : String = "plan.peach"  // path of file
    var fileBehaviour : String = "behaviour.peach"  // path of file
    var fileFristOpen : String = "fristopne.peach"
    var behaviour : NSMutableDictionary!  // behaviour of user (receive from fackbook)
    var fristOpenApp : NSMutableDictionary!
    
    
    //MARK:-
    //MARK:  init
    //MARK:-
    
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
        

        var realPathPlan : String = applicationDocumentsDirectory(fileName)
        
        if(NSFileManager.defaultManager().fileExistsAtPath(realPathPlan)){
            listPlan = NSMutableArray(contentsOfFile: realPathPlan)
        }
        else{
            listPlan = NSMutableArray()
            saveFile()
        }
        
        var realPathBehaviour : String = applicationDocumentsDirectory(fileBehaviour)
        if(NSFileManager.defaultManager().fileExistsAtPath(realPathBehaviour)){
            behaviour = NSMutableDictionary(contentsOfFile: realPathBehaviour)
        }
        else{
            behaviour = NSMutableDictionary()
            saveFile()
        }
        
        var realPathFristOpen : String = applicationDocumentsDirectory(fileFristOpen)
        if(NSFileManager.defaultManager().fileExistsAtPath(realPathFristOpen)){
            fristOpenApp = NSMutableDictionary(contentsOfFile: realPathFristOpen)
        }
        else{
            fristOpenApp = NSMutableDictionary()
            fristOpenApp.setObject("0", forKey: "fristopen")
            saveFile()
        }

        
        
    }
    
    /*
    des : get root path of file 
    
    para : 
            fileName : file name that will save data
    
    */
    func applicationDocumentsDirectory(fileName : String) -> String{
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! String
        let path = documentsDirectory.stringByAppendingPathComponent(fileName)
        return path
        
    }
    
    //MARK:-
    //MARK: Plan
    //MARK:-
    
    func saveFile(){
        var realPath = applicationDocumentsDirectory(fileName)
        listPlan.writeToFile(realPath, atomically: true)
        
    }
    
    func deletePlanWithIndex(index : Int ){
        listPlan.removeObjectAtIndex(index)
        saveFile()
    }
    
    
    //MARK:-
    //MARK: Behaviour
    //MARK:-
    
    func saveBehaviour(){
        var realPath = applicationDocumentsDirectory(fileBehaviour)
        self.behaviour.writeToFile(realPath, atomically: true)
    }
    func getBehaviour() -> NSDictionary?{
        var realPath : String = applicationDocumentsDirectory(fileBehaviour)
        return NSDictionary(contentsOfFile: realPath)
    }
    
    
    //MARK:-
    //MARK:check open frist time
    //MARK:-
    func saveFristTimeOpen(){
        var realPath = applicationDocumentsDirectory(fileFristOpen)
        self.fristOpenApp.writeToFile(realPath, atomically: true)
    }
    
    
}
