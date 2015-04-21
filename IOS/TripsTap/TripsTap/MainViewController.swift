//
//  MainViewController.swift
//  TripsTap
//
//  Created by Piyawut Kamwiset on 3/10/2558 BE.
//  Copyright (c) 2558 Piyawut Kamwiset. All rights reserved.
//

import UIKit

class MainViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    //MARK:-
    //MARK: IBOutlet
    //MARK:-
    @IBOutlet var table: UITableView!
    @IBOutlet var btnBackAndMenu: UIButton!
    
    
    //MARK:-
    //MARK: variable
    //MARK:-
    var connection : Connection = Connection.sharedInstance
    var planFile : PlanFile?
    var pageType : String? // type of page before
    var listPlan : NSMutableArray? // list plan
    var listImage : NSMutableArray? // list image
    var location : String? // location that user select
    var mainViewController: UIViewController! // main apge
    var storyboards = UIStoryboard(name: "Main", bundle: nil)


    //MARK:-
    //MARK: cycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.hidden = true
        
        planFile = PlanFile.sharedInstance
        
        self.listImage = NSMutableArray()
        
        //start with main
        if(pageType != "TripMe"){
            listPlan = NSMutableArray(array: planFile!.listPlan)
        }
            
        // push from another page
        else{
            btnBackAndMenu.setTitle("Back", forState: UIControlState.Normal)
            // find rateing of each plan
            for(var i = 0 ; i < listPlan?.count  ; i++ ){
                var rate : String? = getRating(listPlan?.objectAtIndex(i) as! NSMutableDictionary)
                var newPlan : NSMutableDictionary = NSMutableDictionary(dictionary: listPlan?.objectAtIndex(i) as! NSMutableDictionary)
                newPlan.setObject(rate!, forKey: "rate")
                listPlan?.removeObjectAtIndex(i)
                listPlan?.insertObject(newPlan, atIndex: i)
            }
            // sort plan by rating
            var planForSort : NSArray = NSArray(array: listPlan!)
            var descriptor: NSSortDescriptor = NSSortDescriptor(key: "rate", ascending: false)
            var listPlanSort : NSArray = planForSort.sortedArrayUsingDescriptors([descriptor])
            listPlan?.removeAllObjects()
            listPlan = NSMutableArray(array: listPlanSort )
            
            // delete same plan
            deleteSamePlan()
        }
        
        
        for(var i = 0 ; i < listPlan?.count  ; i++ ){
            if pageType == "TripMe" {
                setViewMain(i)
            }
            
            else{
                if self.listPlan?.objectAtIndex(i).objectForKey("type") as! String == "TripForYou" {
                    
                    var loadImageCount :Int = 0
                    let imageAtIndex : Int = i
                    // load image of each place
                    for(var j = 0 ; j < self.listPlan?.objectAtIndex(i).objectForKey("user_checkin")?.count && loadImageCount < 3 ; j++  ){
                        
                        loadImageCount++
                        
                        var imageUrlFull : String = self.listPlan?.objectAtIndex(i).objectForKey("user_checkin")?.objectAtIndex(j).objectForKey("PHOTO")! as! String
                        var imageUrl : String = getUrlImage(imageUrlFull , index: i)
                        if(imageUrl == ""){
                            loadImageCount--
                        }
                            
                        else  {
                            connection.getImage(imageUrl, completion: { (image) -> () in
                                if(image != nil){
                                    var imageDic : NSMutableDictionary = NSMutableDictionary()
                                    imageDic.setObject(String(format: "%d", imageAtIndex), forKey: "index")
                                    imageDic.setObject(image as UIImage, forKey: "image")
                                    self.listImage?.addObject(imageDic)
                                    self.table.reloadData()
                                }
                            })
                        }
                        
                    }
                    
                }
                    
                else {
                    setViewMain(i)
                }
            }
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        table.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:-
    //MARK: Function
    //MARK:-
    
    /*
        des : setup view when page start
        
        para :
            i : index of cell
    */
    func setViewMain(i : Int){
        var data: NSDictionary = self.listPlan?.objectAtIndex(i) as! NSDictionary
        var conclusion : NSArray = data.objectForKey("conclusion") as! NSArray
        var premises : NSArray = data.objectForKey("premises") as! NSArray
        
        var loadImageCount :Int = 0
        let imageAtIndex : Int = i
        // load image of each place
        for(var j = 0 ; j < conclusion.count && loadImageCount < 3 ; j++  ){
            
            loadImageCount++
            
            var imageUrlFull : String = (conclusion.objectAtIndex(j).objectForKey("image") as! String)
            var imageUrl : String = getUrlImage(imageUrlFull , index: i)
            if(imageUrl == ""){
                loadImageCount--
            }
                
            else  {
                connection.getImage(imageUrl, completion: { (image) -> () in
                    if(image != nil){
                        var imageDic : NSMutableDictionary = NSMutableDictionary()
                        imageDic.setObject(String(format: "%d", imageAtIndex), forKey: "index")
                        imageDic.setObject(image as UIImage, forKey: "image")
                        self.listImage?.addObject(imageDic)
                        self.table.reloadData()
                    }
                })
            }
            
        }
        
        for(var j = 0 ; j < premises.count && loadImageCount < 3 ; j++){
            loadImageCount++
            var imageUrlFull : String = (premises.objectAtIndex(j).objectForKey("image") as! String)
            var imageUrl : String = getUrlImage(imageUrlFull , index : i)
            if(imageUrl == ""){
                loadImageCount--
            }
            else{
                connection.getImage(imageUrl, completion: { (image) -> () in
                    if(image != nil){
                        var imageDic : NSMutableDictionary = NSMutableDictionary()
                        imageDic.setObject(String(format: "%d", imageAtIndex), forKey: "index")
                        imageDic.setObject(image as UIImage, forKey: "image")
                        self.listImage?.addObject(imageDic)
                        
                        self.table.reloadData()
                    }
                })
            }
            
        }
    }
    
    /*
    des : delete same plan
    
    para :

    */
    func deleteSamePlan(){
        
        for var i = 0 ; i < self.listPlan?.count ; i++ {
            
            for var j = i + 1 ; j < self.listPlan?.count ; j++ {
                var countI : Int = (listPlan?.objectAtIndex(i).objectForKey("premises") as! NSArray).count as Int + (listPlan?.objectAtIndex(i).objectForKey("conclusion") as! NSArray).count as Int
                var countJ : Int = (listPlan?.objectAtIndex(j).objectForKey("premises") as! NSArray).count as! Int + (listPlan?.objectAtIndex(j).objectForKey("conclusion") as! NSArray).count as! Int
                
                var rateI : String = listPlan?.objectAtIndex(i).objectForKey("rate") as! String
                var rateJ : String = listPlan?.objectAtIndex(j).objectForKey("rate") as! String
                if i !=  j && countI == countJ && rateI == rateJ {
                    listPlan?.removeObjectAtIndex(j)
                    j--
                }
            }
        }
        
    }
    
    /*
    des : get rating of each plan
    
    para :
            plan : plan
    */
    func getRating(plan : NSMutableDictionary) -> String{
        var sumRate : Double = 0.0
        
        for var i = 0 ; i < (plan.objectForKey("premises")as! NSArray).count ; i++ {
            sumRate += (plan.objectForKey("premises")as! NSArray).objectAtIndex(i).objectForKey("rate")!.doubleValue
            
        }
        
        for var i = 0 ; i < (plan.objectForKey("conclusion")as! NSArray).count ; i++ {
            sumRate += (plan.objectForKey("conclusion")as! NSArray).objectAtIndex(i).objectForKey("rate")!.doubleValue
        }
        
        var countPremiese : Int = (plan.objectForKey("premises")as! NSArray).count as Int
        var countConclusion : Int = (plan.objectForKey("conclusion")as! NSArray).count as Int
        var rateAvg : Double = sumRate / (Double(countConclusion) + Double(countPremiese))
        
        return String(format: "%.1f",rateAvg)
        
    }
    
    /*
    des : get real url image frim full string
    
    para :
    urlFull :   3 image url (.../oooo/...)
    index   :   image index
    */
    func getUrlImage(urlFull : String , index: Int )->String{
        var imageArray : NSArray = urlFull.componentsSeparatedByString("oooo") as NSArray
        var url : String = ""
        let diceRoll = Int(arc4random_uniform(3))
        
        var a : NSArray = ((imageArray.objectAtIndex(diceRoll)as! String).componentsSeparatedByString("-") as NSArray)
        
        for(var i = 0 ; i < a.count - 1 ; i++){
            if(i == 0){
                url += a.objectAtIndex(i) as! String
            }
            else if i == 1{
                url += String(format: "500x500%@", a.objectAtIndex(i)as! String)
            }
            else{
                url += String(format: "-%@", a.objectAtIndex(i)as! String)
            }
            
        }
        return url
        
    }
    
    //MARK:-
    //MARK: button event
    //MARK:-
    @IBAction func clickMenu(sender: AnyObject) {
        if(pageType == "TripMe"){
            self.navigationController?.popViewControllerAnimated(true)
        }
        else{
            self.slideMenuController()?.openLeft()
        }
    }
    
    @IBAction func longPressEditCell(sender: AnyObject) {
        if (pageType == nil && (sender as! UILongPressGestureRecognizer).state == UIGestureRecognizerState.Began){
            self.table.setEditing(!self.table.editing, animated: true)
        }
    }
    
    
    //MARK:-
    //MARK:Table delegate
    //MArk:-
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.listPlan!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //
        // Trip for U form
        //
        if self.listPlan?.objectAtIndex(indexPath.row).objectForKey("type") as? String == "TripForYou" {
            
            var data: NSDictionary = self.listPlan?.objectAtIndex(indexPath.row) as! NSDictionary
            var user_checkin : NSMutableArray = self.listPlan?.objectAtIndex(indexPath.row).objectForKey("user_checkin") as! NSMutableArray
            var rate : String! = String(format: "Rating %@",data.objectForKey("rate") as! String)
            var tripName : String!
            
            // set trip name
            if data.objectForKey("tripname") == nil {
                tripName = ""
            }
            else {
                tripName = data.objectForKey("tripname") as! String
            }
            
            
            // For one place in plan
            if user_checkin.count == 1{

                var cell : MainFourTableViewCellTableViewCell = tableView.dequeueReusableCellWithIdentifier("MainFourTableViewCellTableViewCell") as! MainFourTableViewCellTableViewCell
                var locat : String = String(format: "%@ %d place ",tripName,user_checkin.count  )
                
                
                cell.labName.text = locat
                cell.labRate.text = rate
                
                var countIamge = 0
                for (var i = 0 ; i < self.listImage!.count && countIamge < 1; i++){
                    
                    if(listImage!.objectAtIndex(i).objectForKey("index") as! String == String(format: "%d", indexPath.row)){
                        if(countIamge == 0){
                            cell.imageOne.image = listImage!.objectAtIndex(i).objectForKey("image") as? UIImage
                        }
                        
                        countIamge++
                    }
                }
                
                return cell
            }
            
            // For two place in plan
            else if user_checkin.count == 2 {
                
                var cell : MainTwoTableViewCell = tableView.dequeueReusableCellWithIdentifier("MainTwoTableViewCell") as! MainTwoTableViewCell
                var locat : String = String(format: "%@ %d place",tripName,user_checkin.count )
                cell.labCountRate.text = locat
                                cell.labRate.text = rate
                var countIamge = 0
                for (var i = 0 ; i < self.listImage!.count ; i++){
                    if(listImage!.objectAtIndex(i).objectForKey("index") as! String == String(format: "%d", indexPath.row)){
                        if(countIamge == 0){
                            cell.imageOne.image = listImage!.objectAtIndex(i).objectForKey("image") as? UIImage
                        }
                        else if(countIamge == 1){
                            cell.imageTwo.image = listImage!.objectAtIndex(i).objectForKey("image") as? UIImage
                        }
                        countIamge++
                    }
                }
                
                return cell
                
            }
                
            //For 3 image
            else if (indexPath.row % 2 == 0 )
            {
                var cell : MainOneTableViewCell = tableView.dequeueReusableCellWithIdentifier("MainOneTableViewCell") as! MainOneTableViewCell
                
                var locat : String = String(format: "%@ %d place ",tripName,user_checkin.count  )
                cell.labCountRate.text = locat
                                cell.labRate.text = rate
                
                var countIamge = 0
                for (var i = 0 ; i < self.listImage!.count ; i++){
                    if(listImage!.objectAtIndex(i).objectForKey("index") as! String == String(format: "%d", indexPath.row)){
                        if(countIamge == 0){
                            cell.imageOne.image = listImage!.objectAtIndex(i).objectForKey("image") as? UIImage
                        }
                        else if(countIamge == 1){
                            cell.imageTwo.image = listImage!.objectAtIndex(i).objectForKey("image") as? UIImage
                        }
                        else{
                            cell.imageThree.image = listImage!.objectAtIndex(i).objectForKey("image") as? UIImage
                        }
                        countIamge++
                    }
                }
                
             return cell
            }
                
            //For 3 image
            else{
                var cell : MainThreeTableViewCell = tableView.dequeueReusableCellWithIdentifier("MainThreeTableViewCell") as! MainThreeTableViewCell
                
                var locat : String = String(format: "%@ %d place",tripName ,user_checkin.count  )
                cell.labCountRate.text = locat
                cell.labRate.text = rate
                
                var countIamge = 0
                for (var i = 0 ; i < self.listImage!.count ; i++){
                    if(listImage!.objectAtIndex(i).objectForKey("index") as! String == String(format: "%d", indexPath.row)){
                        if(countIamge == 0){
                            cell.imageOne.image = listImage!.objectAtIndex(i).objectForKey("image") as? UIImage
                        }
                        else if(countIamge == 1){
                            cell.imageTwo.image = listImage!.objectAtIndex(i).objectForKey("image") as? UIImage
                        }
                        else{
                            cell.imageThree.image = listImage!.objectAtIndex(i).objectForKey("image") as? UIImage
                        }
                        countIamge++
                    }
                }
                
                return cell
            }
            
            
            
        }
            
        //
        // Trip Me form
        //
        else
        {
            var data: NSDictionary = self.listPlan?.objectAtIndex(indexPath.row) as! NSDictionary
            var conclusionCount : Int = (data.objectForKey("conclusion") as! NSArray).count
            var premisesCount : Int = (data.objectForKey("premises") as! NSArray).count
            var rate : String! = String(format: "Rating %@",data.objectForKey("rate") as! String)
            var tripName : String!
            
            //set trip name
            if data.objectForKey("tripname") == nil {
                tripName = ""
            }
            else {
                tripName = data.objectForKey("tripname") as! String
            }
            
            // For one place in trip
            if conclusionCount + premisesCount == 1{
                
                var cell : MainFourTableViewCellTableViewCell = tableView.dequeueReusableCellWithIdentifier("MainFourTableViewCellTableViewCell") as! MainFourTableViewCellTableViewCell
                var locat : String = String(format: "%@ %d place ",tripName, conclusionCount + premisesCount  )
                
                cell.labName.text = locat
                cell.labRate.text = rate
                
                var countIamge = 0
                for (var i = 0 ; i < self.listImage!.count && countIamge < 1; i++){
                    
                    if(listImage!.objectAtIndex(i).objectForKey("index") as! String == String(format: "%d", indexPath.row)){
                        if(countIamge == 0){
                            cell.imageOne.image = listImage!.objectAtIndex(i).objectForKey("image") as? UIImage
                        }
                        
                        countIamge++
                    }
                }
                
                return cell
            }
            
            // For two place in trip
            else if (conclusionCount + premisesCount  == 2 ){
                
                var cell : MainTwoTableViewCell = tableView.dequeueReusableCellWithIdentifier("MainTwoTableViewCell") as! MainTwoTableViewCell
                var locat : String = String(format: "%@ %d place",tripName , conclusionCount + premisesCount )
                cell.labCountRate.text = locat
                cell.labRate.text = rate
                var countIamge = 0
                for (var i = 0 ; i < self.listImage!.count ; i++){
                    if(listImage!.objectAtIndex(i).objectForKey("index") as! String == String(format: "%d", indexPath.row)){
                        if(countIamge == 0){
                            cell.imageOne.image = listImage!.objectAtIndex(i).objectForKey("image") as? UIImage
                        }
                        else if(countIamge == 1){
                            cell.imageTwo.image = listImage!.objectAtIndex(i).objectForKey("image") as? UIImage
                        }
                        countIamge++
                    }
                }
                
                return cell
                
                
            }
            
            // For 3 image
            else if (indexPath.row % 2 == 0 )
            {
                var cell : MainOneTableViewCell = tableView.dequeueReusableCellWithIdentifier("MainOneTableViewCell") as! MainOneTableViewCell
                
                var locat : String = String(format: "%@ %d place ",tripName , conclusionCount + premisesCount  )
                cell.labCountRate.text = locat
                cell.labRate.text = rate
                var countIamge = 0
                for (var i = 0 ; i < self.listImage!.count ; i++){
                    if(listImage!.objectAtIndex(i).objectForKey("index") as! String == String(format: "%d", indexPath.row)){
                        if(countIamge == 0){
                            cell.imageOne.image = listImage!.objectAtIndex(i).objectForKey("image") as? UIImage
                        }
                        else if(countIamge == 1){
                            cell.imageTwo.image = listImage!.objectAtIndex(i).objectForKey("image") as? UIImage
                        }
                        else{
                            cell.imageThree.image = listImage!.objectAtIndex(i).objectForKey("image") as? UIImage
                        }
                        countIamge++
                    }
                }
                
                return cell
            }
            
            // For 3 image
            else{
                var cell : MainThreeTableViewCell = tableView.dequeueReusableCellWithIdentifier("MainThreeTableViewCell") as! MainThreeTableViewCell
                
                var locat : String = String(format: "%@ %d place ",tripName , conclusionCount + premisesCount )
                cell.labCountRate.text = locat
                cell.labRate.text = rate
                var countIamge = 0
                for (var i = 0 ; i < self.listImage!.count ; i++){
                    if(listImage!.objectAtIndex(i).objectForKey("index") as! String == String(format: "%d", indexPath.row)){
                        if(countIamge == 0){
                            cell.imageOne.image = listImage!.objectAtIndex(i).objectForKey("image") as? UIImage
                        }
                        else if(countIamge == 1){
                            cell.imageTwo.image = listImage!.objectAtIndex(i).objectForKey("image") as? UIImage
                        }
                        else{
                            cell.imageThree.image = listImage!.objectAtIndex(i).objectForKey("image") as? UIImage
                        }
                        countIamge++
                    }
                }
                
                return cell
            }
        }
        

    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 240
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if pageType != "TripMe"{
            return true
        }
        return false
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete{
            planFile?.listPlan.removeObjectAtIndex(indexPath.row)
            planFile?.saveFile()
            self.listPlan = planFile?.listPlan
            
            
            for var i = 0 ; i < listImage?.count ; i++ {
                if((listImage?.objectAtIndex(i).objectForKey("index") as! String).toInt() > indexPath.row){
                    var indexImage : Int = (listImage?.objectAtIndex(i).objectForKey("index") as! String).toInt()!
                    indexImage--
                    listImage?.objectAtIndex(i).removeObjectForKey("index")
                    listImage?.objectAtIndex(i).setObject(String(format: "%d", indexImage), forKey: "index")
                }
                else if((listImage?.objectAtIndex(i).objectForKey("index") as! String).toInt() == indexPath.row){
                    listImage?.removeObjectAtIndex(i)
                    i--
                }
            }
            
            table.reloadData()
        }
    }
    
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {

        if self.table.editing {
            return UITableViewCellEditingStyle.None
        }
        return UITableViewCellEditingStyle.Delete
        
    }
    
    func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        if pageType  == nil {
            
            return true
        }
        else{
            return false
        }
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
        if sourceIndexPath.row as Int == destinationIndexPath.row as Int {
            return
        }
        
        listPlan!.exchangeObjectAtIndex(sourceIndexPath.row, withObjectAtIndex: destinationIndexPath.row)
        
    
        PlanFile.sharedInstance.listPlan = listPlan
        PlanFile.sharedInstance.saveFile()
        
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "ListVenue"{
            let listVenue : ListVenueViewController = segue.destinationViewController as! ListVenueViewController
            let indexPath = self.table.indexPathForSelectedRow()
            listVenue.dicPlan = self.listPlan?.objectAtIndex(indexPath!.row) as! NSMutableDictionary
            listVenue.indexPlan = indexPath!.row
            if(pageType == nil){
                listVenue.pageType = "Main"
            }
            else{
                listVenue.pageType = self.pageType
            }
            
            
        }
    }


}
