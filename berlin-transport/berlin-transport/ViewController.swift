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
    
    private let mapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setting up the map
        self.mapView.delegate = self
        let mapFrame = self.view.bounds
        self.mapView.frame = mapFrame
        self.view.addSubview(mapView)
        
        // Setting up the data from the server
        let start = (CLLocationCoordinate2DMake(52.482357, 13.349523), "Start")
        let end = (CLLocationCoordinate2DMake(52.515690, 13.335827), "End")
        let req = BTConReq(date: NSDate(), start: start, end: end)
        let reqXml = BTRequestBuilder.conReq(req)
        
        BTHafasAPIClient.send(reqXml)
        
//        let locMgr = CLLocationManager()
//        if !CLLocationManager.locationServicesEnabled() {
//            println("No location services enabled")
//        } else {
//            let firstConnection = parser.getConnections()[0]
//            let startCoords = firstConnection.start.coordinate
//            let endCoords = firstConnection.end.coordinate
//            
//            for segment in firstConnection.segments! {
//                let startMark = MKPlacemark(coordinate: segment.start.coordinate, addressDictionary: nil)
//                let endMark = MKPlacemark(coordinate: segment.end.coordinate, addressDictionary: nil)
//                self.mapView.addAnnotation(startMark)
//                self.mapView.addAnnotation(endMark)
//
//                
//                var points: [CLLocationCoordinate2D] = []
//                // Add passList if it's a journey
//                if let journey = segment as? BTJourney {
//                    for station in journey.passList! {
//                        let passMark = MKPlacemark(coordinate: station.coordinate, addressDictionary: nil)
//                        points.append(passMark.coordinate)
//                        self.mapView.addAnnotation(passMark)
//                    }
//                } else if (segment is BTWalk) || (segment is BTGisRoute) {
//                    points.append(segment.start.coordinate)
//                    points.append(segment.end.coordinate)
//                }
//                let line = MKPolyline(coordinates: &points, count: points.count)
//                self.mapView.addOverlay(line)
//            }
//            self.mapView.showAnnotations(mapView.annotations, animated: true)
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- MKMapViewDelegate methods
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        println(__FUNCTION__)
        mapView.setCenterCoordinate(mapView.userLocation.location.coordinate, animated: true)
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        println(__FUNCTION__)
        var polyLineRenderer = MKPolylineRenderer(overlay: overlay)
        polyLineRenderer.strokeColor = kBTColorU3
        polyLineRenderer.lineWidth = 5.0
        
        return polyLineRenderer
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        println(__FUNCTION__)
        let point = UIImage(named: "BTMapPoint")!.imageWithRenderingMode(.AlwaysTemplate)
        
        let view = MKAnnotationView(annotation: annotation, reuseIdentifier: "BTPoint")
        view.image = point
        view.tintColor = UIColor.whiteColor()
        
        return view
    }
    
    func mapView(mapView: MKMapView!, didAddAnnotationViews views: [AnyObject]!) {
        // Implement later
    }
    
    func mapView(mapView: MKMapView!, didAddOverlayRenderers renderers: [AnyObject]!) {
        // Implement later
    }
}

