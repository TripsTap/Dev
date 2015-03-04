//
//  ViewController.swift
//  TripsTap
//
//  Created by Piyawut Kamwiset on 3/4/2558 BE.
//  Copyright (c) 2558 Piyawut Kamwiset. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var camera = GMSCameraPosition.cameraWithLatitude(0, longitude:-165, zoom:2)
        var mapView = GMSMapView.mapWithFrame(CGRectZero, camera:camera)
        
        var path = GMSMutablePath()
        path.addLatitude(-33.866, longitude:151.195) // Sydney
        path.addLatitude(-18.142, longitude:178.431) // Fiji
        path.addLatitude(21.291, longitude:-157.821) // Hawaii
        path.addLatitude(37.423, longitude:-122.091) // Mountain View
        
        var polyline = GMSPolyline(path: path)
        polyline.strokeColor = UIColor.blueColor()
        polyline.strokeWidth = 1.0
        polyline.map = mapView
        
        self.view = mapView

}
}

