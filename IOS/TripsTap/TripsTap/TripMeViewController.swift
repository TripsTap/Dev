//
//  TripMeViewController.swift
//  TripsTap
//
//  Created by Piyawut Kamwiset on 3/11/2558 BE.
//  Copyright (c) 2558 Piyawut Kamwiset. All rights reserved.
//

import UIKit


    
class TripMeViewController: UIViewController ,UITableViewDelegate, TripMeCellDelegate  {

    

    
//MARK: -
//MARK: IBOutlet
//MARK: -

    @IBOutlet weak var textLocation: UITextField!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var viewPicker: UIView!
    @IBOutlet weak var viewIndicator: UIView!
    @IBOutlet var segmentType: UISegmentedControl!
    
    @IBOutlet var btnTripMe: UIButton!

//MARK: -
//MARK: variable
//MARK: -
    
    let location : NSArray = NSArray(contentsOfFile: "location.text")!
    

    var connection : Connection!
    var selectCategory : NSMutableArray!
    var category : NSMutableArray! = NSMutableArray()
    var mainViewController: UIViewController!
    var listPlan : NSMutableArray!
    var categorySort: NSArray!
    var cateSelectList : NSMutableArray!
    var pageType : String!
    
//MARK:-
//MARK: cycle
//MARK:-
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.hidden = true
        var storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController : MainViewController = storyBoard.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
        self.mainViewController = UINavigationController(rootViewController: mainViewController)
        
        self.selectCategory = NSMutableArray()
        self.category = NSMutableArray()
        self.listPlan = NSMutableArray()
        
        btnTripMe.enabled = false
        
    }
    
    override func viewWillAppear(animated: Bool) {
        if(pageType == "Menu"){
            pageType = ""
            self.selectCategory.removeAllObjects()
            self.category.removeAllObjects()
            self.listPlan.removeAllObjects()
        }
            table.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
       
    }
    
    
//MARK: -
//MARK: button event
//MARK: -
    
    @IBAction func clickSelectLocation(sender: AnyObject) {
        viewPicker.hidden = false
        
    }
    
    @IBAction func clickDonePicker(sender: AnyObject) {
        selectCategory.removeAllObjects()
        viewPicker.hidden = true
        
        viewIndicator.hidden = false

        // send request
         self.connection = Connection.sharedInstance
        if(textLocation.text == ""){
            textLocation.text = location[0] as! String
        }
        
        
        connection.getCategoryTripsMe(textLocation.text, place: 0) { (result, error) -> () in
            
            self.viewIndicator.hidden = true
            self.category.removeAllObjects()
            self.table.reloadData()
            if(error == nil)
            {
                if(  ((result.objectAtIndex(0) as! NSDictionary)["cats"] as! NSArray).count != 0){
                    
                    self.category = ((result.objectAtIndex(0) as! NSDictionary)["cats"] as! NSMutableArray).mutableCopy() as! NSMutableArray
                    self.table.reloadData()
                }
                else{
                    println("cate == 0")
                }
            }
            else {
                UIAlertView(title: "Error occur!", message: "No request available", delegate: self, cancelButtonTitle: "OK").show()
            }
        }
        
    }
    @IBAction func clickBack(sender: AnyObject) {
        self.selectCategory.removeAllObjects()
        self.category.removeAllObjects()
        self.listPlan.removeAllObjects()
        
        self.navigationController?.popViewControllerAnimated(true)
        self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)
    }
    
    
    @IBAction func clickTripMe(sender: AnyObject) {
        
        self.viewIndicator.hidden = false
        
        cateSelectList = NSMutableArray()
        for (var i = 0 ; i < self.selectCategory.count ;i++){
            cateSelectList.addObject((category.objectAtIndex(self.selectCategory.objectAtIndex(i) as! Int) as! NSDictionary).objectForKey("catName") as! String)
        }
        
        var descriptor: NSSortDescriptor = NSSortDescriptor(key: "", ascending: true)
            categorySort = cateSelectList.sortedArrayUsingDescriptors([descriptor])
        // start with
        if(self.segmentType.selectedSegmentIndex == 0 ){
            connection.getRuleTripsMe(textLocation.text, category: cateSelectList) { (result, error) -> () in
                println("getRuleTripsMe sucess")
                
                self.viewIndicator.hidden = true

                if error == nil {

                    if(result.count == 0 ){
                        
//                        let alertController = UIAlertController(title: nil, message:
//                            "Please select the other category", preferredStyle: UIAlertControllerStyle.Alert)
//                        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
//                        
//                        self.presentViewController(alertController, animated: true, completion: nil)
                        
                        
                         UIAlertView(title: nil, message: "Please select the other category!", delegate: self, cancelButtonTitle: "OK").show()
                    }
                    else{
                        
                        
                        var storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        var mainView : MainViewController = storyBoard.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
                        mainView.pageType = "TripMe"
                        mainView.listPlan = NSMutableArray(array: result as! NSMutableArray)
                        mainView.location = self.textLocation.text
                        self.navigationController?.pushViewController(mainView, animated: true)
                    }
                }
                
                else {
                    UIAlertView(title: "Error occur!", message: "No request available", delegate: self, cancelButtonTitle: "OK").show()
                }
                
            }
        }
            
        // interest in
        else{
            connection.getRuleTripsMe(textLocation.text, category: cateSelectList) { (result, error) -> () in
                println("getRuleTripsMe sucess")
//                self.listPlan = NSMutableArray()
                
                self.viewIndicator.hidden = true
                
                if error == nil {
                    
                    if(result.count == 0 ){
                        let alertController = UIAlertController(title: nil, message:
                            "Please select the other category", preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                    else{
                        
                        var listNewPlan : NSMutableArray = NSMutableArray()
                        
                        for var i = 0 ; i < result.count ; i++ {
                            listNewPlan.addObject(NSMutableDictionary(dictionary: result.objectAtIndex(i) as! NSMutableDictionary))
                        }
                        for var i = 0 ; i < result.count ; i++ {
                            
                            //                        var allCat : NSMutableArray = NSMutableArray()
                            var premises : NSMutableArray = NSMutableArray()
                            var conclusion : NSMutableArray = NSMutableArray()
                            // add category of premiss
                            for var j = 0 ; j < result.objectAtIndex(i).objectForKey("premises")!.count ; j++ {
                                for var k = 0 ; k < self.cateSelectList.count ; k++ {
                                    if (((result.objectAtIndex(i).objectForKey("premises") as! NSArray).objectAtIndex(j) as! NSDictionary).objectForKey("catName") as! String == self.cateSelectList.objectAtIndex(k) as! String)
                                    {
                                        premises.addObject(((result.objectAtIndex(i) as! NSDictionary).objectForKey("premises") as! NSArray).objectAtIndex(j))
                                    }
                                }
                                
                            }
                            
                            // add category of conclusion
                            for var j = 0 ; j < result.objectAtIndex(i).objectForKey("conclusion")!.count ; j++ {
                                
                                for var k = 0 ; k < self.cateSelectList.count ; k++ {
                                    if (((result.objectAtIndex(i).objectForKey("conclusion") as! NSArray).objectAtIndex(j) as! NSDictionary).objectForKey("catName") as! String == self.cateSelectList.objectAtIndex(k) as! String ){
                                        conclusion.addObject(((result.objectAtIndex(i) as! NSDictionary).objectForKey("conclusion") as! NSArray).objectAtIndex(j))
                                    }
                                }
                                
                            }
                            
                            
                            
                            (listNewPlan.objectAtIndex(i) as! NSMutableDictionary).removeObjectForKey("premises")
                            (listNewPlan.objectAtIndex(i) as! NSMutableDictionary).setObject(premises, forKey: "premises")
                            (listNewPlan.objectAtIndex(i) as! NSMutableDictionary).removeObjectForKey("conclusion")
                            (listNewPlan.objectAtIndex(i) as! NSMutableDictionary).setObject(conclusion, forKey: "conclusion")
                        }
                        
                        if(listNewPlan.count != 0 ){
                            var storyBoard = UIStoryboard(name: "Main", bundle: nil)
                            var mainView : MainViewController = storyBoard.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
                            mainView.pageType = "TripMe"
                            mainView.listPlan = listNewPlan as NSMutableArray
                            mainView.location = self.textLocation.text
                            self.navigationController?.pushViewController(mainView, animated: true)
                        }
                    }
                    
                }
                
                else {
                    UIAlertView(title: "Error occur!", message: "No request available", delegate: self, cancelButtonTitle: "OK").show()
                }
            }
        }
    }

    @IBAction func clickDismiss(sender: AnyObject) {
        viewPicker.hidden = true
    }

    


//MARK:-
//MARK:  picker function
//MARK:-
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return location.count
        
    }
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return location[row] as! String
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textLocation.text = location[row] as! String
    }
    
    

//MARK:-
//MARK:  table function
//MARK:-
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.count
//        return 30

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell  = tableView.dequeueReusableCellWithIdentifier("TripMeTableViewCell" ,forIndexPath: indexPath) as! TripMeTableViewCell
        

        //  set information!
        cell.labCategoryName.text = (self.category[indexPath.row] as! NSDictionary) ["catName"] as? String
        cell.delegate = self
        cell.index = indexPath.row
        

        // check select category
        var checkSelect : Bool = false
        for(var i = 0 ; i < self.selectCategory.count ; i++){
            if( (selectCategory.objectAtIndex(i) as! Int) == indexPath.row){
                checkSelect = true
            }
        }
        
        // select already
        if (checkSelect){
            cell.imageSelect.backgroundColor = UIColor.greenColor()
        }
            
        // not select
        else{
            cell.imageSelect.backgroundColor = UIColor.redColor()
        }
        
        return cell
    }

    
    func  tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 60;
    }
    
//MARK:-
//MARK:  cell delegate
//MARK:-
    func clickCell(index: Int) {

        for(var i = 0 ; i < self.selectCategory.count ; i++){
            if( (selectCategory.objectAtIndex(i) as! Int) == index){
                selectCategory.removeObjectAtIndex(i)
                table.reloadData()
                checkEnableTripMeBtn()
                return;
            }
        }
        selectCategory.addObject(index)
        checkEnableTripMeBtn()
        table.reloadData()
    }
    
//MARK:-
//MARK: function
//MARK:-
    func checkEnableTripMeBtn(){
        if(selectCategory.count > 0){
            btnTripMe.enabled = true
        }
        else{
            btnTripMe.enabled = false
        }
    }


    
    func checkMatchCat(cateList : NSArray) -> Bool{
        
        for var i = 0 ; i < cateList.count ; i++ {
            var matchCat : Int = 0
            for var j = 0 ; j < self.cateSelectList.count ; j++ {
                if (self.cateSelectList.objectAtIndex(j) as! NSString == cateList.objectAtIndex(i) as! NSString){
                    matchCat++
                }
            }
            if matchCat == 0 {
                return false
            }
        }
        return true
        
    }
   

// MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    
   
    
}
