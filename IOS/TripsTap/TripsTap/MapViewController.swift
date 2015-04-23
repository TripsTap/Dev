//
//  MapViewController.swift
//  TripsTap
//
//  Created by Piyawut Kamwiset on 4/1/2558 BE.
//  Copyright (c) 2558 Piyawut Kamwiset. All rights reserved.
//

import UIKit
import MapKit
class MapViewController: UIViewController , GMSMapViewDelegate {

    //MARK:-
    //MARK: IBOutlet
    //MARK:-
    @IBOutlet var viewMap: UIView!
    @IBOutlet var viewLoader: UIView!
    
    
    //MARK:-
    //MARK: varialbe
    //MARK:-
    var dicPlan : NSMutableDictionary! // info of plan
    var listInfo : NSMutableArray!  // list of place
    var pageType : String? // type of page before
    var countLoadSeccess : Int! = 0 // load success
    var mainViewController: UIViewController!
    var indexSelectMarker : Int = 0
    
    //MARK:-
    //MARK: cycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.hidden = true
        
        
        if pageType == nil{
            setView()
        }
        
        else {
            
            self.navigationController?.navigationBar.hidden = true
            var storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let mainViewController : MainViewController = storyBoard.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
            self.mainViewController = UINavigationController(rootViewController: mainViewController)
            
            viewLoader.hidden = false
            listInfo = NSMutableArray()
            dicPlan = PlanFile.sharedInstance.listPlan.objectAtIndex(0) as! NSMutableDictionary
            
            if(pageType == "TripForYou" || dicPlan.objectForKey("type") as? String == "TripForYou"){
                
                allocArray((dicPlan.objectForKey("user_checkin") as! NSArray).count)
                
                for(var i = 0 ; i < (dicPlan.objectForKey("user_checkin") as! NSArray).count ; i++){
                    // load info
                    var venueID : String = (dicPlan.objectForKey("user_checkin") as! NSArray).objectAtIndex(i).objectForKey("VENUE_ID") as! String
                    getInfoVenue(venueID , index: i)
                    
                }
                
                
            }
                
            else{
                
                var countPlan : Int = (dicPlan.objectForKey("premises") as! NSArray).count + (dicPlan.objectForKey("conclusion") as! NSArray).count
                
                allocArray(countPlan)
                
                for(var i = 0 ; i < (dicPlan.objectForKey("premises") as! NSArray).count ; i++){
                    // load info
                    var venueID : String = (dicPlan.objectForKey("premises") as! NSArray).objectAtIndex(i).objectForKey("venueId") as! String
                    getInfoVenue(venueID , index: i)
                    
                }
                
                
                for(var i = 0 ; i < (dicPlan.objectForKey("conclusion") as! NSArray).count ; i++){
                    
                    let imageAtIndex : Int = i + (dicPlan.objectForKey("premises") as! NSArray).count
                    // load info of eact place
                    var venueID : String = (dicPlan.objectForKey("conclusion") as! NSArray).objectAtIndex(i).objectForKey("venueId") as! String
                    getInfoVenue(venueID, index: imageAtIndex)
                    
                }
            }
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:-
    //MARK: Function
    //MARK:-
    
    /*
    des : ser up view when pafe start
    
    */
    func setView(){
        
        viewLoader.hidden = true
        var locationFrist : NSDictionary = self.listInfo.objectAtIndex(0).objectForKey("location") as! NSDictionary
        var latFrist : Double = locationFrist.objectForKey("lat") as! Double
        var lngFrist : Double = locationFrist.objectForKey("lng") as! Double
        
        
        var camera = GMSCameraPosition.cameraWithLatitude( latFrist , longitude: lngFrist   , zoom:15)
        var mapView = GMSMapView.mapWithFrame(self.view.bounds, camera:camera)
        mapView.myLocationEnabled = true
        mapView.delegate = self
        var path = GMSMutablePath()
        
        
        for(var i = 0 ; i < self.listInfo!.count ; i++ ){
            
            var location : NSDictionary = self.listInfo!.objectAtIndex(i).objectForKey("location") as! NSDictionary
            
            var lat : Double = location.objectForKey("lat") as! Double
            var lng : Double = location.objectForKey("lng") as! Double
            
            
            path.addLatitude(lat, longitude:lng)
            //
            
            var position : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            var marker = GMSMarker()
            marker.position = position
            marker.snippet = String(format: "%d %@", i+1 , self.listInfo!.objectAtIndex(i).objectForKey("name") as! String)
            marker.appearAnimation = kGMSMarkerAnimationPop
            marker.map = mapView
            
            
        }
        
        var polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 2.0
        polyline.geodesic = true
        polyline.map = mapView
        
        self.viewMap.addSubview(mapView)

    }
    
    
    /*
    des : get info if this page not receive data
    
    para:
        venueID : veune id of FS
        index : position of this veune
    */
    func getInfoVenue(venueID : String , index : Int) -> (){
        
        if pageType == "TripForYou" || dicPlan.objectForKey("type") as? String == "TripForYou"{
            
            Connection.sharedInstance.getInfoFromFoursquare(venueID , completion: { (result, error) -> () in
                
                if error == nil {
                    
                    self.listInfo.replaceObjectAtIndex(index, withObject: (result.objectForKey("response") as! NSDictionary).objectForKey("venue") as! NSDictionary)
                    self.countLoadSeccess!++
                    
                    if(self.countLoadSeccess == (self.dicPlan.objectForKey("user_checkin") as! NSArray).count ){
                        
                        self.setView()
                        
                    }
                }
                
            })
        }
            
        else
        {
            Connection.sharedInstance.getInfoFromFoursquare(venueID , completion: { (result, error) -> () in
                if error == nil {
                    
                    self.listInfo.replaceObjectAtIndex(index, withObject: (result.objectForKey("response") as! NSDictionary).objectForKey("venue") as! NSDictionary)
                    
                    self.countLoadSeccess!++
                    if(self.countLoadSeccess == (self.dicPlan.objectForKey("premises") as! NSArray).count + (self.dicPlan.objectForKey("conclusion") as! NSArray).count){
                        
                        self.setView()
                    }
                }
            })
        }
    }
    
    
    func allocArray(countOfArray : Int){
        for var i = 0 ; i < countOfArray ; i++ {
            listInfo.addObject("")
        }
    }

    
    //MARK:-
    //MARK: event button
    //MARK:-
    @IBAction func clickBack(sender: AnyObject) {
        if pageType == nil {
            self.navigationController?.popViewControllerAnimated(true)
        }
            
        else{
            self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)
        }
    }
    
    @IBAction func clickDirect(sender: AnyObject) {
        openMapForPlace()
    }
    
    func openMapForPlace() {
        
        var latitute:CLLocationDegrees =  (self.listInfo.objectAtIndex(indexSelectMarker).objectForKey("location") as! NSDictionary).objectForKey("lat") as! Double
        var longitute:CLLocationDegrees =  (self.listInfo.objectAtIndex(indexSelectMarker).objectForKey("location") as! NSDictionary).objectForKey("lng") as! Double
        
        let regionDistance:CLLocationDistance = 10000
        var coordinates = CLLocationCoordinate2DMake(latitute, longitute)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        var options = [
            MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
        ]
        var placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        var mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.listInfo!.objectAtIndex(indexSelectMarker).objectForKey("name")  as! String
        mapItem.openInMapsWithLaunchOptions(options)
        
    }
    
    
    func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
        var firsrChar = Array(marker.snippet)[0]

        indexSelectMarker = String(firsrChar).toInt()!-1
        
        return false
    }

}
