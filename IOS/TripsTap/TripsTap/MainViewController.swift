//
//  MainViewController.swift
//  TripsTap
//
//  Created by Piyawut Kamwiset on 3/10/2558 BE.
//  Copyright (c) 2558 Piyawut Kamwiset. All rights reserved.
//

import UIKit

class MainViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {


    var connection : Connection = Connection.sharedInstance
    
    var pageType : String?
    var listPlan : NSMutableArray?
    var listImage : NSMutableArray?
    var location : String?
    
    @IBOutlet var table: UITableView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(listPlan : NSMutableArray , pageID : String){
        super.init()
        self.listPlan = listPlan;
        self.pageType = pageID;

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.hidden = true
        
        self.listImage = NSMutableArray()
        if(self.listPlan == nil){
            self.listPlan = NSMutableArray()
        }
    }
    
    
    func getUrlImage(urlFull : String)->String{
        var imageArray : NSArray = urlFull.componentsSeparatedByString("oooo") as NSArray
        var url : String!
        for (var i = 0 ; i < imageArray.count ; i++){
            if(((imageArray.objectAtIndex(i)as String).componentsSeparatedByString("-") as NSArray).count == 3)
            {
                
                url = String(format: "%@500x500%@", ((imageArray.objectAtIndex(i)as String).componentsSeparatedByString("-") as NSArray).objectAtIndex(0)as String ,((imageArray.objectAtIndex(i)as String).componentsSeparatedByString("-") as NSArray).objectAtIndex(1) as String)
                return url
            }
        }
        return ""
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        if(pageType == nil){
            
        }
        else if(pageType == "TripMe" ){
            for(var i = 0 ; i < listPlan?.count  ; i++ ){
                
                var data: NSDictionary = self.listPlan?.objectAtIndex(i) as NSDictionary
                var conclusion : NSArray = data.objectForKey("conclusion") as NSArray
                var premises : NSArray = data.objectForKey("premises") as NSArray
                
                var loadImageCount :Int = 0
                let imageAtIndex : Int = i
                
                
                for(var j = 0 ; j < premises.count && loadImageCount < 3 ; j++){
                    loadImageCount++
                    var imageUrlFull : String = (premises.objectAtIndex(j).objectForKey("image") as String)
                    var imageUrl : String = getUrlImage(imageUrlFull)
                    if(imageUrl == ""){
                        println(conclusion.objectAtIndex(j))
                        println(imageUrlFull)
                        loadImageCount--
                    }
                    else{
                        connection.getImage(imageUrl, completion: { (image) -> () in
                            println("load image complete")
                            var imageDic : NSMutableDictionary = NSMutableDictionary()
                            imageDic.setObject(String(format: "%d", imageAtIndex), forKey: "index")
                            imageDic.setObject(image as UIImage, forKey: "image")
                            self.listImage?.addObject(imageDic)
                            
                            self.table.reloadData()
                        })
                    }
                    
//                    var imageArray : NSArray = ((imageString.componentsSeparatedByString("oooo") as NSArray).objectAtIndex(0)as String).componentsSeparatedByString("-") as NSArray
                    

                    
//                    if (imageArray.count != 3)
//                    {
//                        loadImageCount--
//                        continue;
//                    }
//                    var url : String = String(format: "%@500x500%@", imageArray.objectAtIndex(0)as String ,imageArray.objectAtIndex(1) as String)
                    
                    
                    
                }

                
                for(var j = 0 ; j < conclusion.count && loadImageCount < 3 ; j++  ){
                    loadImageCount++

                    var imageUrlFull : String = (conclusion.objectAtIndex(j).objectForKey("image") as String)
                    var imageUrl : String = getUrlImage(imageUrlFull)
                    if(imageUrl == ""){
                        println(conclusion.objectAtIndex(j))
                        println(imageUrlFull)
                        loadImageCount--
                    }

                    else  {
                        connection.getImage(imageUrl, completion: { (image) -> () in
                            println("load image complete")
                            var imageDic : NSMutableDictionary = NSMutableDictionary()
                            imageDic.setObject(String(format: "%d", imageAtIndex), forKey: "index")
                            imageDic.setObject(image as UIImage, forKey: "image")
                            self.listImage?.addObject(imageDic)
                            self.table.reloadData()
                        })
                    }
//                    var imageArray : NSArray = ((imageString.componentsSeparatedByString("oooo") as NSArray).objectAtIndex(0)as String).componentsSeparatedByString("-") as NSArray
//                    
//                    if (imageArray.count != 3){
//                        loadImageCount--
//                        continue;
//                    }
//                    var url : String = String(format: "%@500x500%@", imageArray.objectAtIndex(0)as String ,imageArray.objectAtIndex(1) as String)


                   
                    
                }
                
                
                
                
                
                
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func clickMenu(sender: AnyObject) {
        self.slideMenuController()?.openLeft()
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
            
        else
        {
            var cell : MainOneTableViewCell = tableView.dequeueReusableCellWithIdentifier("MainOneTableViewCell") as MainOneTableViewCell
            
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    
    
    
    
    
    
    
    
    
    
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "ListVenue"{
            let listVenue : ListVenueViewController = segue.destinationViewController as ListVenueViewController
            let indexPath = self.table.indexPathForSelectedRow()
            listVenue.listPlan = self.listPlan?.objectAtIndex(indexPath!.row as Int) as NSDictionary
            listVenue.location = self.location
            
        }
    }


}
