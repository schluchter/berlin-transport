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
    
    private let parser = BTConResParser(fileName: "apertomove-CONCoordRes")
    private let mapView = MKMapView()

    override func viewDidLoad() {
        super.viewDidLoad()
        let mapFrame = self.view.bounds
        self.mapView.frame = mapFrame
        self.view.addSubview(mapView)
        
        let locMgr = CLLocationManager()
        if !CLLocationManager.locationServicesEnabled() {
            println("No location services enabled")
        } else {
            let firstConnection = parser.getConnections()[0]
            let startCoords = firstConnection.start.coordinate
            let endCoords = firstConnection.end.coordinate
            
            for segment in firstConnection.segments! {
                let startMark = MKPlacemark(coordinate: segment.start.coordinate, addressDictionary: nil)
                let endMark = MKPlacemark(coordinate: segment.end.coordinate, addressDictionary: nil)
                self.mapView.addAnnotation(startMark)
                self.mapView.addAnnotation(endMark)
                
                // Add passList if it's a journey
                if let journey = segment as? BTJourney {
                    for station in journey.passList! {
                        let passMark = MKPlacemark(coordinate: station.coordinate, addressDictionary: nil)
                        self.mapView.addAnnotation(passMark)
                    }
                }
            }
            
            mapView.showAnnotations(mapView.annotations, animated: true)
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

