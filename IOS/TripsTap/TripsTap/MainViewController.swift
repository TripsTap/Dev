//
//  MainViewController.swift
//  TripsTap
//
//  Created by Piyawut Kamwiset on 3/10/2558 BE.
//  Copyright (c) 2558 Piyawut Kamwiset. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {


    
    var pageID : String?
    var listPlan : NSMutableArray?
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(listPlan : NSMutableArray , pageID : String){
        super.init()
        self.listPlan = listPlan;
        self.pageID = pageID;
    }

  

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.hidden = true
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func clickMenu(sender: AnyObject) {
        
        self.slideMenuController()?.openLeft()
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
