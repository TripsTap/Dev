//
//  TripForYouViewController.swift
//  TripsTap
//
//  Created by Piyawut Kamwiset on 4/10/2558 BE.
//  Copyright (c) 2558 Piyawut Kamwiset. All rights reserved.
//

import UIKit

class TripForYouViewController: UIViewController {

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
    
    let location : Array<String> = ["Uthai Thani","Phuket","Trat","Krung Thep Mahanakhon","Chainat" ,"Nakhon Sawan" ,"Nonthaburi" ,"Pathum Thani" ,"Ayutthaya","Lopburi","Samut Songkhram","Samut Prakan","Samut Sakhon","Saraburi","Singburi","Ang Thong","Kanchanaburi",    "Nakhon Pathom",    "Prachuap Khiri Khan",    "Phetchaburi",    "Ratchaburi",    "Suphanburi",    "Chanthaburi",    "Chachoengsao",    "Chonburi",        "Nakhon Nayok",    "Prachinburi",    "Rayong",    "Sa Kaeo",    "Kalasin",    "Khon Kaen",    "Chaiyaphum",    "Nakhon Phanom",    "Nakhon Ratchasima",    "Buriram",    "Maha Sarakham",    "Mukdahan",    "Yasothon",    "Roi Et",    "Loei",    "Si Sa Ket",    "Sakon Nakhon",    "Surin",    "Nong Khai",    "Nong Bua Lamphu",    "Amnat Charoen",    "Udon Thani",    "Ubon Ratchathani",    "Krabi",    "Chumphon",    "Trang",    "Nakhon Si Thammarat",    "Narathiwat",    "Pattani",    "Phangnga",    "Phatthalung",        "Yala",    "Ranong",    "Songkhla",    "Satun",    "Surat Thani",    "Kamphaeng Phet",    "Chiang Rai",    "Chiang Mai",    "Tak",    "Nan",    "Phayao",    "Phichit",    "Phitsanulok",    "Phetchabun",    "Phrae",    "Mae Hong Son",    "Lampang",    "Lamphun",    "Sukhothai",    "Uttaradit"]
    
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

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    //MARK:-
    //MARK:  table function
    //MARK:-
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return category.count
                return 30
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
//        var cell  = tableView.dequeueReusableCellWithIdentifier("TripMeTableViewCell" ,forIndexPath: indexPath) as TripMeTableViewCell
        
        
//        //  set information
//        cell.labCategoryName.text = (self.category[indexPath.row] as NSDictionary) ["catName"] as String
//        cell.delegate = self
//        cell.index = indexPath.row
//        
//        
//        // check select category
//        var checkSelect : Bool = false
//        for(var i = 0 ; i < self.selectCategory.count ; i++){
//            if( (selectCategory.objectAtIndex(i) as Int) == indexPath.row){
//                checkSelect = true
//            }
//        }
//        
//        // select already
//        if (checkSelect){
//            cell.imageSelect.backgroundColor = UIColor.greenColor()
//        }
//            
//            // not select
//        else{
//            cell.imageSelect.backgroundColor = UIColor.redColor()
//        }
//        
        return UITableViewCell()
    }
    
    
    func  tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 80;
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
