//
//  ImageViewController.swift
//  TripsTap
//
//  Created by Piyawut Kamwiset on 4/9/2558 BE.
//  Copyright (c) 2558 Piyawut Kamwiset. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController , UICollectionViewDataSource ,UICollectionViewDelegate {

    //MARK:-
    //MARK: IBoutlet
    //MARK:-
    @IBOutlet var collection: UICollectionView!
    @IBOutlet var viewImage: UIView!
    @IBOutlet var imagePlace: UIImageView!
    
    //MARK:-
    //MARK: Variable
    //MARK:-
    var listUrl : NSMutableArray! // list of url
    var listImage : NSMutableArray! //list of image
    var venueID : String! // venue ud
    var currentIndexImage : Int! = 0 //position of image
    
    //MARK:-
    //MARK: cycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()

        listImage = NSMutableArray()
        var connection : Connection = Connection.sharedInstance
        listUrl = NSMutableArray()
        if venueID != nil {
            connection.getAllImageFromFS(venueID, completion: { (result, error) -> () in
                
                if error == nil {
                    self.listUrl = ((result.objectForKey("response") as! NSDictionary).objectForKey("photos") as! NSDictionary).objectForKey("items") as! NSMutableArray
                    
                    self.loadAllImage()
                }
            })
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:-
    //MARK: Function
    //MARK:-
    func loadAllImage(){
        
        for var i = 0 ; i < listUrl.count ; i++ {
            var prefix : String = listUrl.objectAtIndex(i).objectForKey("prefix") as! String
            var suffix : String = listUrl.objectAtIndex(i).objectForKey("suffix") as! String
            var height : String = String(format: "%d",(listUrl.objectAtIndex(i).objectForKey("height") as! Int))
            var width : String = String(format: "%d",(listUrl.objectAtIndex(i).objectForKey("width") as! Int))
            var urlImage : String = String(format: "%@%@x%@%@", prefix,  height ,width , suffix)
            
            if height < width{
                continue
            }
            var connection : Connection = Connection.sharedInstance
            
            connection.getImage(urlImage, completion: { (image) -> () in
                if(image != nil){
                    self.listImage.addObject(image)
                    self.collection.reloadData()
                }
            })
            
            
        }
        
    }


    //MARK:-
    //MARK: Collection delegate
    //MARK:-
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return listImage.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell : UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! UICollectionViewCell
        
        var imageRecipe : UIImageView = cell.viewWithTag(100) as! UIImageView
        imageRecipe.image = listImage.objectAtIndex(indexPath.row) as? UIImage

        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let picDimension = self.view.frame.size.width / 4
        return CGSizeMake(picDimension, picDimension)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let leftRightInset = self.view.frame.size.width / 14.0
        return UIEdgeInsetsMake(0, leftRightInset, 0, leftRightInset)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        currentIndexImage = indexPath.row
        imagePlace.image = listImage!.objectAtIndex(indexPath.row) as? UIImage
        viewImage.hidden = false
        imagePlace.hidden = false
    }

    
    //MARK:-
    //MARK: event button
    //MARK:-
    @IBAction func clickCloseImage(sender: AnyObject) {
        viewImage.hidden = true
        imagePlace.hidden = true
    }
    
    @IBAction func clickBace(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    /*
    des :   slide right image
    
    */
    @IBAction func swipeRight(sender: AnyObject) {
        if currentIndexImage + 1 < listImage.count {
            currentIndexImage  = currentIndexImage + 1
            
            self.imagePlace.image = self.listImage.objectAtIndex(self.currentIndexImage) as! UIImage
            
        }
    }
    
    /*
    des :   slide left image
    
    */
    @IBAction func swipeLeft(sender: AnyObject) {
        

        if currentIndexImage - 1 >= 0 {
            currentIndexImage = currentIndexImage - 1
             imagePlace.image = listImage.objectAtIndex(currentIndexImage) as! UIImage

        }
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
