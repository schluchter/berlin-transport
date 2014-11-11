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
        
        // Listen for completion notification from API client
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleBTHafasAPIClientResponse:", name: "BTHafasAPIClientDidReceiveResponse", object: nil)
        
        // Setting up the map
        let locMgr = CLLocationManager()
        locMgr.requestAlwaysAuthorization()
        self.mapView.delegate = self
        self.mapView.showsPointsOfInterest = false
        self.mapView.showsUserLocation = true
        let mapFrame = self.view.bounds
        self.mapView.frame = mapFrame
        self.view.addSubview(mapView)
        
        // Setting up the data from the server
        let start = (CLLocationCoordinate2DMake(52.5491666,13.4317231), "Start")
        let end = (CLLocationCoordinate2DMake(52.500052,13.443949), "End")
        let req = BTConReq(date: NSDate(), start: start, end: end)
        let reqXml = BTRequestBuilder.conReq(req)
        
        BTHafasAPIClient.send(reqXml)
        
    }
    
    func handleBTHafasAPIClientResponse(notification: NSNotification) {
        let xml = notification.object as ONOXMLDocument
        let parser = BTConResParser(xml)
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
                
                
                var points: [CLLocationCoordinate2D] = []
                // Add passList if it's a journey
                if let journey = segment as? BTJourney {
                    for station in journey.passList! {
                        let passMark = MKPlacemark(coordinate: station.coordinate, addressDictionary: nil)
                        points.append(passMark.coordinate)
                        self.mapView.addAnnotation(passMark)
                    }
                } else if (segment is BTWalk) || (segment is BTGisRoute) {
                    points.append(segment.start.coordinate)
                    points.append(segment.end.coordinate)
                }
                let line = BTConnectionPolyLine(coordinates: &points, count: points.count)
                line.connectionData = segment
                self.mapView.addOverlay(line)
            }
            self.mapView.showAnnotations(mapView.annotations, animated: true)
        }
        
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
        let polyLineRenderer = MKPolylineRenderer(overlay: overlay)
        polyLineRenderer.lineWidth = 3.5
        
        let polyLine = overlay as BTConnectionPolyLine
        let data = polyLine.connectionData!
        switch data {
        case let journey as BTJourney:
            polyLineRenderer.strokeColor = self.lineColorForService(journey.line)
        case let walk as BTWalk:
            polyLineRenderer.strokeColor = kBTColorPrimaryBg
            polyLineRenderer.lineWidth = 2.5
            polyLineRenderer.lineDashPattern = [0,4]
        case let gisRoute as BTGisRoute:
            polyLineRenderer.strokeColor = kBTColorPrimaryBg
            polyLineRenderer.lineWidth = 2.5
            polyLineRenderer.lineDashPattern = [0,4]
        case let transfer as BTTransfer:
            polyLineRenderer.strokeColor = kBTColorIconUBahn
        default:
            ()
        }
        
        return polyLineRenderer
    }
    
    func lineColorForService(service: BTServiceDescription) -> UIColor {
        switch service.serviceId.serviceType {
        case .Bus:
            return kBTColorIconBus
        case .MetroBus, .MetroTram:
            return kBTColorIconMetro
        case .UBahn:
            switch service.serviceId.name {
            case "1", "15":
                return kbTColorU1_15
            case "2":
                return kBTColorU2
            case "3":
                return kBTColorU3
            case "4":
                return kBTColorU4
            case "5", "55":
                return kBTColorU5_55
            case "6":
                return kBTColorU6
            case "7":
                return kBTColorU7
            case "8":
                return kBTColorU8
            case "9":
                return kBTColorU9
            default:
                return UIColor.blackColor()
            }
        case .SBahn:
            switch service.serviceId.name {
            case "S1":
                return kBTColorS1
            case "S2", "S25":
                return kBTColorS2_25
            case "S3":
                return kBTColorS3
            case "S41":
                return kBTColorS41
            case "S42":
                return kBTColorS42
                case "S45", "S46", "S47":
                return kBTColorS45_47
            case "S5":
                return kBTColorS5
            case "S7", "S75":
                return kBTColorS7_75
            case "S8", "S85":
                return kBTColorS8_85
            case "S9":
                return kBTColorS9
            default:
                return kBTColorPrimaryBg
            }
        default:
            return kBTColorIconTram
        }
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        println(__FUNCTION__)
        let point = UIImage(named: "BTMapPoint")!.imageWithRenderingMode(.AlwaysTemplate)
        
        let view = MKAnnotationView(annotation: annotation, reuseIdentifier: "BTPoint")
        view.image = point
        
        return view
    }
    
    func mapView(mapView: MKMapView!, didAddAnnotationViews views: [AnyObject]!) {
        // TODO: Implement later
    }
    
    func mapView(mapView: MKMapView!, didAddOverlayRenderers renderers: [AnyObject]!) {
        // TODO: Implement later
    }
}