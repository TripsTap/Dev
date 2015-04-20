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
    
    let location : NSArray = ["Uthai Thani","Phuket","Trat","Krung Thep Mahanakhon","Chainat" ,"Nakhon Sawan" ,"Nonthaburi" ,"Pathum Thani" ,"Ayutthaya","Lopburi","Samut Songkhram","Samut Prakan","Samut Sakhon","Saraburi","Singburi","Ang Thong","Kanchanaburi",    "Nakhon Pathom",    "Prachuap Khiri Khan",    "Phetchaburi",    "Ratchaburi",    "Suphanburi",    "Chanthaburi",    "Chachoengsao",    "Chonburi",        "Nakhon Nayok",    "Prachinburi",    "Rayong",    "Sa Kaeo",    "Kalasin",    "Khon Kaen",    "Chaiyaphum",    "Nakhon Phanom",    "Nakhon Ratchasima",    "Buriram",    "Maha Sarakham",    "Mukdahan",    "Yasothon",    "Roi Et",    "Loei",    "Si Sa Ket",    "Sakon Nakhon",    "Surin",    "Nong Khai",    "Nong Bua Lamphu",    "Amnat Charoen",    "Udon Thani",    "Ubon Ratchathani",    "Krabi",    "Chumphon",    "Trang",    "Nakhon Si Thammarat",    "Narathiwat",    "Pattani",    "Phangnga",    "Phatthalung",        "Yala",    "Ranong",    "Songkhla",    "Satun",    "Surat Thani",    "Kamphaeng Phet",    "Chiang Rai",    "Chiang Mai",    "Tak",    "Nan",    "Phayao",    "Phichit",    "Phitsanulok",    "Phetchabun",    "Phrae",    "Mae Hong Son",    "Lampang",    "Lamphun",    "Sukhothai",    "Uttaradit"]
    
    var mainViewController: UIViewController!
    
    var connection : Connection! //HTTP request
    var selectCategory : NSMutableArray! //
    var category : NSMutableArray! = NSMutableArray() //cate of  location that selected
    var listPlan : NSMutableArray! // Plan from server response
    var categorySort: NSArray!  // sort category from that user select
    var cateSelectList : NSMutableArray! // user select category
    var pageType : String! // indentifile page
    
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
    
    
    // click button for select location
    @IBAction func clickSelectLocation(sender: AnyObject) {
        viewPicker.hidden = false
        
    }
    
    /*
    des : select location from picker
    
    */
    @IBAction func clickDonePicker(sender: AnyObject) {

        selectCategory.removeAllObjects()
        viewPicker.hidden = true
        viewIndicator.hidden = false
        
        // dont slide picker
        if(textLocation.text == ""){
            textLocation.text = location[0] as! String
        }

        
        // send request get category
         self.connection = Connection.sharedInstance
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
                    UIAlertView(title: "Don't have Category!", message: "Please select other location", delegate: self, cancelButtonTitle: "OK").show()
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
    
    // Get plan
    @IBAction func clickTripMe(sender: AnyObject) {
        
        // show loading
        self.viewIndicator.hidden = false
        
        // sort category that user select
        cateSelectList = NSMutableArray()
        for (var i = 0 ; i < self.selectCategory.count ;i++){
            cateSelectList.addObject((category.objectAtIndex(self.selectCategory.objectAtIndex(i) as! Int) as! NSDictionary).objectForKey("catName") as! String)
        }
        var descriptor: NSSortDescriptor = NSSortDescriptor(key: "", ascending: true)
        categorySort = cateSelectList.sortedArrayUsingDescriptors([descriptor])
        
        
        // start with function
        if(self.segmentType.selectedSegmentIndex == 0 ){
            connection.getRuleTripsMe(textLocation.text, category: cateSelectList) { (result, error) -> () in
                println("getRuleTripsMe sucess (start with)")
                
                self.viewIndicator.hidden = true

                if error == nil {

                    if(result.count == 0 ){
                        
                         UIAlertView(title: "Don't have trip!", message: "Please select the other category", delegate: self, cancelButtonTitle: "OK").show()
                        
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
            
        // interest in Function
        else{
            connection.getRuleTripsMe(textLocation.text, category: cateSelectList) { (result, error) -> () in
                println("getRuleTripsMe sucess  (interest in)")
                self.viewIndicator.hidden = true
                
                if error == nil {
                    
                    if(result.count == 0 ){
                        
                        UIAlertView(title: "Don't have trip!", message: "Please select the other category", delegate: self, cancelButtonTitle: "OK").show()
                        
                    }
                    else{
                        
                        // add new list for delete place that dont use
                        var listNewPlan : NSMutableArray = NSMutableArray()
                        for var i = 0 ; i < result.count ; i++ {
                            listNewPlan.addObject(NSMutableDictionary(dictionary: result.objectAtIndex(i) as! NSMutableDictionary))
                        }
                        
                        // funcrtion for check save category that selected
                        for var i = 0 ; i < result.count ; i++ {
                            
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
                        
                        // check have plan
                        if(listNewPlan.count != 0 ){
                            var storyBoard = UIStoryboard(name: "Main", bundle: nil)
                            var mainView : MainViewController = storyBoard.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
                            mainView.pageType = "TripMe"
                            mainView.listPlan = listNewPlan as NSMutableArray
                            mainView.location = self.textLocation.text
                            self.navigationController?.pushViewController(mainView, animated: true)
                        }
                        else{
                            
                            UIAlertView(title: "Don't have trip!", message: "Please select the other category", delegate: self, cancelButtonTitle: "OK").show()
                            
                        }
                    }
                    
                }
                
                else {
                    UIAlertView(title: "Error occur!", message: "No request available", delegate: self, cancelButtonTitle: "OK").show()
                }
            }
        }
    }

    // dismiss picker
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
        
        // set image select already
        if (checkSelect){
            cell.imageSelect.backgroundColor = UIColor.greenColor()
        }
            
        // set image not select
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
    
    // select or dont select category when user click in cell
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
    
    // enable get trip btn
    func checkEnableTripMeBtn(){
        if(selectCategory.count > 0){
            btnTripMe.enabled = true
        }
        else{
            btnTripMe.enabled = false
        }
    }


    /*
    
    des : check that category of place in pkan are same with category that user select
    
    para :
            cateList : list of categorf of plan
    */
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
   
    
   
    
}
