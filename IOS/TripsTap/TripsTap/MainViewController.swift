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
    //MARK: variable
    //MARK:-
    var connection : Connection = Connection.sharedInstance
    var pageType : String?
    var listPlan : NSMutableArray?
    var listImage : NSMutableArray?
    var location : String?
    var planFile : PlanFile?
    var mainViewController: UIViewController!
    var storyboards = UIStoryboard(name: "Main", bundle: nil)
    var stopLoad : Int?
    
    //MARK:-
    //MARK: IBOutlet
    //MARK:-
    @IBOutlet var table: UITableView!
    @IBOutlet var btnBackAndMenu: UIButton!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.hidden = true
        
        planFile = PlanFile.sharedInstance
        
            self.listImage = NSMutableArray()
        if(pageType != "TripMe"){
            listPlan = NSMutableArray(array: planFile!.listPlan)
        }
        else{
            btnBackAndMenu.setTitle("Back", forState: UIControlState.Normal)
            // sort by rateing
            for(var i = 0 ; i < listPlan?.count  ; i++ ){
                var rate : String? = getRating(listPlan?.objectAtIndex(i) as! NSMutableDictionary)
                var newPlan : NSMutableDictionary = NSMutableDictionary(dictionary: listPlan?.objectAtIndex(i) as! NSMutableDictionary)
                newPlan.setObject(rate!, forKey: "rate")
                listPlan?.removeObjectAtIndex(i)
                listPlan?.insertObject(newPlan, atIndex: i)
            }
            // update listPlan
            var planForSort : NSArray = NSArray(array: listPlan!)
            var descriptor: NSSortDescriptor = NSSortDescriptor(key: "rate", ascending: false)
            var listPlanSort : NSArray = planForSort.sortedArrayUsingDescriptors([descriptor])
            listPlan?.removeAllObjects()
            listPlan = NSMutableArray(array: listPlanSort )
            deleteSameCat()
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
    
    
    
    func deleteSameCat(){
        
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
        
        return String(format: "%.2f",rateAvg)
        
    }
    
    func getUrlImage(urlFull : String , index: Int )->String{
        var imageArray : NSArray = urlFull.componentsSeparatedByString("oooo") as NSArray
        var url : String = ""
        let diceRoll = Int(arc4random_uniform(3))
        
//        println(diceRoll)
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
    
    
    
    override func viewWillAppear(animated: Bool) {
       table.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func clickMenu(sender: AnyObject) {
        if(pageType == "TripMe"){
            self.navigationController?.popViewControllerAnimated(true)
        }
        else{
            self.slideMenuController()?.openLeft()
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.listPlan!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if self.listPlan?.objectAtIndex(indexPath.row).objectForKey("type") as? String == "TripForYou" {
         
            var data: NSDictionary = self.listPlan?.objectAtIndex(indexPath.row) as! NSDictionary
            var user_checkin : NSMutableArray = self.listPlan?.objectAtIndex(indexPath.row).objectForKey("user_checkin") as! NSMutableArray
            var rate : String! = "2.4"
//            data.objectForKey("rate") as! String
            
            if user_checkin.count == 2 {
                
                var cell : MainTwoTableViewCell = tableView.dequeueReusableCellWithIdentifier("MainTwoTableViewCell") as! MainTwoTableViewCell
                var locat : String = String(format: "%d place & Avg rating %@",user_checkin.count , rate )
                cell.labCountRate.text = locat
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
            else if (indexPath.row % 2 == 0 )
            {
                var cell : MainOneTableViewCell = tableView.dequeueReusableCellWithIdentifier("MainOneTableViewCell") as! MainOneTableViewCell
                
                var locat : String = String(format: "%d place & Avg rating %@",user_checkin.count , rate )
                cell.labCountRate.text = locat
                
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
            else{
                var cell : MainThreeTableViewCell = tableView.dequeueReusableCellWithIdentifier("MainThreeTableViewCell") as! MainThreeTableViewCell
                
                var locat : String = String(format: "%d place & Avg rating %@",user_checkin.count , rate )
                cell.labCountRate.text = locat
                
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
        
        else
        {
            var data: NSDictionary = self.listPlan?.objectAtIndex(indexPath.row) as! NSDictionary
            var conclusionCount : Int = (data.objectForKey("conclusion") as! NSArray).count
            var premisesCount : Int = (data.objectForKey("premises") as! NSArray).count
            
            var rate : String! = data.objectForKey("rate") as! String
            if (conclusionCount + premisesCount  == 2 ){
                
                var cell : MainTwoTableViewCell = tableView.dequeueReusableCellWithIdentifier("MainTwoTableViewCell") as! MainTwoTableViewCell
                var locat : String = String(format: "%d place & Avg rating %@",conclusionCount + premisesCount , rate )
                cell.labCountRate.text = locat
                var countIamge = 0
                for (var i = 0 ; i < self.listImage!.count ; i++){
                    if(listImage!.objectAtIndex(i).objectForKey("index") as! String == String(format: "%d", indexPath.row)){
                        if(countIamge == 0){
                            //                        cell.imageOne.layer.cornerRadius = 10.0
                            //                        cell.imageOne.clipsToBounds = true
                            cell.imageOne.image = listImage!.objectAtIndex(i).objectForKey("image") as? UIImage
                        }
                        else if(countIamge == 1){
                            //                        cell.imageTwo.layer.cornerRadius = 10.0
                            //                        cell.imageOne.clipsToBounds = true
                            cell.imageTwo.image = listImage!.objectAtIndex(i).objectForKey("image") as? UIImage
                        }
                        countIamge++
                    }
                }
                
                return cell
                
                
            }
                
            else if (indexPath.row % 2 == 0 )
            {
                var cell : MainOneTableViewCell = tableView.dequeueReusableCellWithIdentifier("MainOneTableViewCell") as! MainOneTableViewCell
                
                var locat : String = String(format: "%d place & Avg rating %@",conclusionCount + premisesCount , rate )
                cell.labCountRate.text = locat
                
                var countIamge = 0
                for (var i = 0 ; i < self.listImage!.count ; i++){
                    if(listImage!.objectAtIndex(i).objectForKey("index") as! String == String(format: "%d", indexPath.row)){
                        if(countIamge == 0){
                            //                        cell.imageOne.layer.cornerRadius = 10.0
                            //                        cell.imageOne.clipsToBounds = true
                            cell.imageOne.image = listImage!.objectAtIndex(i).objectForKey("image") as? UIImage
                        }
                        else if(countIamge == 1){
                            //                        cell.imageTwo.layer.cornerRadius = 10.0
                            //                        cell.imageTwo.clipsToBounds = true
                            cell.imageTwo.image = listImage!.objectAtIndex(i).objectForKey("image") as? UIImage
                        }
                        else{
                            //                        cell.imageThree.layer.cornerRadius = 10.0
                            //                        cell.imageThree.clipsToBounds = true
                            cell.imageThree.image = listImage!.objectAtIndex(i).objectForKey("image") as? UIImage
                        }
                        countIamge++
                    }
                }
                
                return cell
            }
                
            else{
                var cell : MainThreeTableViewCell = tableView.dequeueReusableCellWithIdentifier("MainThreeTableViewCell") as! MainThreeTableViewCell
                
                var locat : String = String(format: "%d place & Avg rating %@",conclusionCount + premisesCount , rate )
                cell.labCountRate.text = locat
                
                var countIamge = 0
                for (var i = 0 ; i < self.listImage!.count ; i++){
                    if(listImage!.objectAtIndex(i).objectForKey("index") as! String == String(format: "%d", indexPath.row)){
                        if(countIamge == 0){
                            //                        cell.imageOne.layer.cornerRadius = 10.0
                            //                        cell.imageOne.clipsToBounds = true
                            cell.imageOne.image = listImage!.objectAtIndex(i).objectForKey("image") as? UIImage
                        }
                        else if(countIamge == 1){
                            //                        cell.imageTwo.layer.cornerRadius = 10.0
                            //                        cell.imageTwo.clipsToBounds = true
                            cell.imageTwo.image = listImage!.objectAtIndex(i).objectForKey("image") as? UIImage
                        }
                        else{
                            //                        cell.imageThree.layer.cornerRadius = 10.0
                            //                        cell.imageThree.clipsToBounds = true
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
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "ListVenue"{
            let listVenue : ListVenueViewController = segue.destinationViewController as! ListVenueViewController
            let indexPath = self.table.indexPathForSelectedRow()
            listVenue.dicPlan = self.listPlan?.objectAtIndex(indexPath!.row) as! NSMutableDictionary
//            listVenue.location = self.location
            if(pageType == nil){
                listVenue.pageType = "Main"
            }
            else{
                listVenue.pageType = self.pageType
            }
            
            
        }
    }


}
