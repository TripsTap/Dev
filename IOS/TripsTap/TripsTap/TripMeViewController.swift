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
    

//MARK: -
//MARK: variable
//MARK: -
    
    let location : Array<String> = ["Uthai Thani","Phuket","Trat","Krung Thep Mahanakhon","Chainat" ,"Nakhon Sawan" ,"Nonthaburi" ,"Pathum Thani" ,"Ayutthaya","Lopburi","Samut Songkhram","Samut Prakan","Samut Sakhon","Saraburi","Singburi","Ang Thong","Kanchanaburi",    "Nakhon Pathom",    "Prachuap Khiri Khan",    "Phetchaburi",    "Ratchaburi",    "Suphanburi",    "Chanthaburi",    "Chachoengsao",    "Chonburi",        "Nakhon Nayok",    "Prachinburi",    "Rayong",    "Sa Kaeo",    "Kalasin",    "Khon Kaen",    "Chaiyaphum",    "Nakhon Phanom",    "Nakhon Ratchasima",    "Buriram",    "Maha Sarakham",    "Mukdahan",    "Yasothon",    "Roi Et",    "Loei",    "Si Sa Ket",    "Sakon Nakhon",    "Surin",    "Nong Khai",    "Nong Bua Lamphu",    "Amnat Charoen",    "Udon Thani",    "Ubon Ratchathani",    "Krabi",    "Chumphon",    "Trang",    "Nakhon Si Thammarat",    "Narathiwat",    "Pattani",    "Phangnga",    "Phatthalung",        "Yala",    "Ranong",    "Songkhla",    "Satun",    "Surat Thani",    "Kamphaeng Phet",    "Chiang Rai",    "Chiang Mai",    "Tak",    "Nan",    "Phayao",    "Phichit",    "Phitsanulok",    "Phetchabun",    "Phrae",    "Mae Hong Son",    "Lampang",    "Lamphun",    "Sukhothai",    "Uttaradit"]
    

    var connection : Connection!
    var selectCategory : NSMutableArray!
    var category : NSMutableArray! = NSMutableArray()
    var mainViewController: UIViewController!
    var listPlan : NSMutableArray!

    
//MARK:-
//MARK: cycle
//MARK:-
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.hidden = true
        var storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController : MainViewController = storyBoard.instantiateViewControllerWithIdentifier("MainViewController") as MainViewController
        self.mainViewController = UINavigationController(rootViewController: mainViewController)
        
        self.selectCategory = NSMutableArray()
        self.category = NSMutableArray()
        self.listPlan = NSMutableArray()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        table.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.selectCategory.removeAllObjects()
        self.category.removeAllObjects()
        self.listPlan.removeAllObjects()
    }
    
    
//MARK: -
//MARK: button event
//MARK: -
    
    @IBAction func clickSelectLocation(sender: AnyObject) {
        viewPicker.hidden = false
        
    }
    
    @IBAction func clickDonePicker(sender: AnyObject) {
        viewPicker.hidden = true
        
        viewIndicator.hidden = false

        // send request
         self.connection = Connection.sharedInstance
        
        connection.getCategoryTripsMe(textLocation.text, place: 0) { (result, error) -> () in
            
            self.viewIndicator.hidden = true
            self.category.removeAllObjects()
            self.table.reloadData()
            if(error == nil){
                if(  ((result.objectAtIndex(0) as NSDictionary)["cats"] as NSArray).count != 0){
                    
                    self.category = ((result.objectAtIndex(0) as NSDictionary)["cats"] as NSMutableArray).mutableCopy() as NSMutableArray
                    self.table.reloadData()
                }
                else{
                    println("cate == 0")
                }
                
            }
        }
        
    }
    @IBAction func clickBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
        self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)
    }
    
    
    @IBAction func clickTripMe(sender: AnyObject) {
        
        self.viewIndicator.hidden = false
        
        var cateSelectList : NSMutableArray = NSMutableArray()
        for (var i = 0 ; i < self.selectCategory.count ;i++){
            cateSelectList.addObject((category.objectAtIndex(self.selectCategory.objectAtIndex(i) as Int) as NSDictionary).objectForKey("catName") as String)
        }
        
        if(self.segmentType.selectedSegmentIndex == 0 ){
            connection.getRuleTripsMe(textLocation.text, category: cateSelectList) { (result, error) -> () in
                println("getRuleTripsMe sucess")
                self.listPlan = NSMutableArray()
                
                self.viewIndicator.hidden = true
                
                if(result.count == 0 ){
                    
                }
                else{
                    var storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    var mainView : MainViewController = storyBoard.instantiateViewControllerWithIdentifier("MainViewController") as MainViewController
                    mainView.pageType = "TripME"
                    mainView.listPlan = result as NSMutableArray
                    mainView.location = self.textLocation.text
                    mainView.pageType = "TripMe"
                    self.navigationController?.pushViewController(mainView, animated: true)
                }
                
            }
        }
        
        else{
            
            
        }
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
        return location[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textLocation.text = location[row]
    }
    
    

//MARK:-
//MARK:  table function
//MARK:-
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.count
//        return 30

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell  = tableView.dequeueReusableCellWithIdentifier("TripMeTableViewCell" ,forIndexPath: indexPath) as TripMeTableViewCell
        

        //  set information
        cell.labCategoryName.text = (self.category[indexPath.row] as NSDictionary) ["catName"] as String
        cell.delegate = self
        cell.index = indexPath.row
        

        // check select category
        var checkSelect : Bool = false
        for(var i = 0 ; i < self.selectCategory.count ; i++){
            if( (selectCategory.objectAtIndex(i) as Int) == indexPath.row){
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
    }
    
    func  tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 80;
    }
    
//MARK:-
//MARK:  cell delegate
//MARK:-
    func clickCell(index: Int) {
        
        for(var i = 0 ; i < self.selectCategory.count ; i++){
            if( (selectCategory.objectAtIndex(i) as Int) == index){
                selectCategory.removeObjectAtIndex(i)
                table.reloadData()
                return;
            }
        }
        selectCategory.addObject(index)
        table.reloadData()
    }

    

// MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    
   
    
}
