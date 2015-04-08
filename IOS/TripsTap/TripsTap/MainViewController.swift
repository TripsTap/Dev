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
            
        }
        
        
//        if(pageType == nil){
//            
//        }
//        else if(pageType == "TripMe" ){
                for(var i = 0 ; i < listPlan?.count  ; i++ ){
                
                var data: NSDictionary = self.listPlan?.objectAtIndex(i) as NSDictionary
                var conclusion : NSArray = data.objectForKey("conclusion") as NSArray
                var premises : NSArray = data.objectForKey("premises") as NSArray
                
                var loadImageCount :Int = 0
                let imageAtIndex : Int = i
                
                for(var j = 0 ; j < conclusion.count && loadImageCount < 3 ; j++  ){
                    loadImageCount++
                    
                    var imageUrlFull : String = (conclusion.objectAtIndex(j).objectForKey("image") as String)
                    var imageUrl : String = getUrlImage(imageUrlFull , index: i)
                    if(imageUrl == ""){
//                        println(conclusion.objectAtIndex(j))
//                        println(imageUrlFull)
                        loadImageCount--
                    }
                        
                    else  {
                        connection.getImage(imageUrl, completion: { (image) -> () in
//                            println("load image complete")
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
                    var imageUrlFull : String = (premises.objectAtIndex(j).objectForKey("image") as String)
                    var imageUrl : String = getUrlImage(imageUrlFull , index : i)
                    if(imageUrl == ""){
//                        println(premises.objectAtIndex(j))
//                        println(imageUrlFull)
                        loadImageCount--
                    }
                    else{
                        connection.getImage(imageUrl, completion: { (image) -> () in
//                            println("load image complete")
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
            
//        }

    }
    
    
    func getUrlImage(urlFull : String , index: Int )->String{
        var imageArray : NSArray = urlFull.componentsSeparatedByString("oooo") as NSArray
        var url : String = ""
        let diceRoll = Int(arc4random_uniform(3))
        
//        println(diceRoll)
        var a : NSArray = ((imageArray.objectAtIndex(diceRoll)as String).componentsSeparatedByString("-") as NSArray)
        
        for(var i = 0 ; i < a.count - 1 ; i++){
            if(i == 0){
                url += a.objectAtIndex(i) as String
            }
            else if i == 1{
                url += String(format: "500x500%@", a.objectAtIndex(i)as String)
            }
            else{
                url += String(format: "-%@", a.objectAtIndex(i)as String)
            }
            
        }
        return url
        
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
       
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
        
        var data: NSDictionary = self.listPlan?.objectAtIndex(indexPath.row) as NSDictionary
        var conclusionCount : Int = (data.objectForKey("conclusion") as NSArray).count
        var premisesCount : Int = (data.objectForKey("premises") as NSArray).count
        
        if (conclusionCount + premisesCount  == 2 ){
            
            var cell : MainTwoTableViewCell = tableView.dequeueReusableCellWithIdentifier("MainTwoTableViewCell") as MainTwoTableViewCell
            var locat : String = String(format: "%d place & Avg rating %.2f",conclusionCount + premisesCount , 2.45 )
            cell.labCountRate.text = locat
            var countIamge = 0
            for (var i = 0 ; i < self.listImage!.count ; i++){
                if(listImage!.objectAtIndex(i).objectForKey("index") as String == String(format: "%d", indexPath.row)){
                    if(countIamge == 0){
                        cell.imageOne.layer.cornerRadius = 10.0
                        cell.imageOne.clipsToBounds = true
                        cell.imageOne.image = listImage!.objectAtIndex(i).objectForKey("image") as? UIImage
                    }
                    else if(countIamge == 1){
                        cell.imageTwo.layer.cornerRadius = 10.0
                        cell.imageOne.clipsToBounds = true
                        cell.imageTwo.image = listImage!.objectAtIndex(i).objectForKey("image") as? UIImage
                    }
                    countIamge++
                }
            }
            
            return cell
    
            
        }
            
        else if (indexPath.row % 2 == 0 )
        {
            var cell : MainOneTableViewCell = tableView.dequeueReusableCellWithIdentifier("MainOneTableViewCell") as MainOneTableViewCell
            
            var locat : String = String(format: "%d place & Avg rating %.2f",conclusionCount + premisesCount , 2.45 )
            cell.labCountRate.text = locat
            
            var countIamge = 0
            for (var i = 0 ; i < self.listImage!.count ; i++){
                if(listImage!.objectAtIndex(i).objectForKey("index") as String == String(format: "%d", indexPath.row)){
                    if(countIamge == 0){
                        cell.imageOne.layer.cornerRadius = 10.0
                        cell.imageOne.clipsToBounds = true
                        cell.imageOne.image = listImage!.objectAtIndex(i).objectForKey("image") as? UIImage
                    }
                    else if(countIamge == 1){
                        cell.imageTwo.layer.cornerRadius = 10.0
                        cell.imageTwo.clipsToBounds = true
                        cell.imageTwo.image = listImage!.objectAtIndex(i).objectForKey("image") as? UIImage
                    }
                    else{
                        cell.imageThree.layer.cornerRadius = 10.0
                        cell.imageThree.clipsToBounds = true
                        cell.imageThree.image = listImage!.objectAtIndex(i).objectForKey("image") as? UIImage
                    }
                    countIamge++
                }
            }
            
            return cell
        }
        
        else{
            var cell : MainThreeTableViewCell = tableView.dequeueReusableCellWithIdentifier("MainThreeTableViewCell") as MainThreeTableViewCell
            
            var locat : String = String(format: "%d place & Avg rating %.2f",conclusionCount + premisesCount , 2.45 )
            cell.labCountRate.text = locat
            
            var countIamge = 0
            for (var i = 0 ; i < self.listImage!.count ; i++){
                if(listImage!.objectAtIndex(i).objectForKey("index") as String == String(format: "%d", indexPath.row)){
                    if(countIamge == 0){
                        cell.imageOne.layer.cornerRadius = 10.0
                        cell.imageOne.clipsToBounds = true
                        cell.imageOne.image = listImage!.objectAtIndex(i).objectForKey("image") as? UIImage
                    }
                    else if(countIamge == 1){
                        cell.imageTwo.layer.cornerRadius = 10.0
                        cell.imageTwo.clipsToBounds = true
                        cell.imageTwo.image = listImage!.objectAtIndex(i).objectForKey("image") as? UIImage
                    }
                    else{
                        cell.imageThree.layer.cornerRadius = 10.0
                        cell.imageThree.clipsToBounds = true
                        cell.imageThree.image = listImage!.objectAtIndex(i).objectForKey("image") as? UIImage
                    }
                    countIamge++
                }
            }
            
            return cell
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
            table.reloadData()
        }
    }
    
    
    
    
    
    
    
    
    
    
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "ListVenue"{
            let listVenue : ListVenueViewController = segue.destinationViewController as ListVenueViewController
            let indexPath = self.table.indexPathForSelectedRow()
            listVenue.dicPlan = self.listPlan?.objectAtIndex(indexPath!.row as Int) as NSDictionary
            listVenue.location = self.location
            if(pageType == nil){
                listVenue.pageType = "Main"
            }
            else{
                listVenue.pageType = self.pageType
            }
            
            
        }
    }


}
