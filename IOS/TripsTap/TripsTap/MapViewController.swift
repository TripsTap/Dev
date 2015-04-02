//
//  MapViewController.swift
//  TripsTap
//
//  Created by Piyawut Kamwiset on 4/1/2558 BE.
//  Copyright (c) 2558 Piyawut Kamwiset. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {

    @IBOutlet var viewMap: UIView!
    
    var listInfo : NSArray!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        var locationFrist : NSDictionary = ((self.listInfo!.objectAtIndex(0).objectForKey("venues") as NSArray).objectAtIndex(0) as NSDictionary).objectForKey("location") as NSDictionary
        var latFrist : Double = locationFrist.objectForKey("lat") as Double
        var lngFrist : Double = locationFrist.objectForKey("lng") as Double
        
        
        var camera = GMSCameraPosition.cameraWithLatitude( latFrist , longitude: lngFrist   , zoom:15)
        var mapView = GMSMapView.mapWithFrame(self.view.bounds, camera:camera)
        mapView.myLocationEnabled = false
        // Do any additional setup after loading the view.
        
        
        
        for(var i = 0 ; i < self.listInfo!.count ; i++ ){
            
            var location : NSDictionary = ((self.listInfo!.objectAtIndex(i).objectForKey("venues") as NSArray).objectAtIndex(0) as NSDictionary).objectForKey("location") as NSDictionary
            
            var lat : Double = location.objectForKey("lat") as Double
            var lng : Double = location.objectForKey("lng") as Double
            
//            
            
            var position : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            var marker = GMSMarker()
            marker.position = position
            marker.snippet = ((self.listInfo!.objectAtIndex(i).objectForKey("venues") as NSArray).objectAtIndex(0) as NSDictionary).objectForKey("venueName") as String
            marker.appearAnimation = kGMSMarkerAnimationPop
            marker.map = mapView
            

        }
        self.viewMap.addSubview(mapView)
        
        
        
    }

    @IBAction func clickBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
