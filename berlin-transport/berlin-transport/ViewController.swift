//
//  ViewController.swift
//  berlin-transport
//
//  Created by Thomas Schluchter on 9/15/14.
//  Copyright (c) 2014 Thomas Schluchter. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        let mapFrame = self.view.bounds
        let mapView = MKMapView(frame: mapFrame)
        self.view.addSubview(mapView)
        
        let locMgr = CLLocationManager()
        if !CLLocationManager.locationServicesEnabled() {
            println("No location services enabled")
        } else {
            println(CLLocationManager.authorizationStatus())
            locMgr.startUpdatingLocation()
            let coord = CLLocationCoordinate2D(latitude: 52.518338, longitude: 13.401026)
            mapView.setRegion(MKCoordinateRegion(center: coord, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        println(__FUNCTION__)
        mapView.setCenterCoordinate(mapView.userLocation.location.coordinate, animated: true)
    }


}

