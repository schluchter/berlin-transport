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
        let start = (CLLocationCoordinate2DMake(52.4091540,13.5344170), "Start")
        let end = (CLLocationCoordinate2DMake(52.5522550, 13.3818370), "End")
        let req = BTConReq(date: NSDate(), start: start, end: end)
        let reqXml = BTRequestBuilder.conReq(req)
        
        BTHafasAPIClient.send(reqXml)
    }
    
    func handleBTHafasAPIClientResponse(notification: NSNotification) {
        let xml = notification.object as ONOXMLDocument
        let parser = BTConResParser(xml)
        
        let firstConnection = parser.getConnections()[0]
        let startCoords = firstConnection.start.coordinate
        let endCoords = firstConnection.end.coordinate
        
        for segment in firstConnection.segments! {
            let startMark = MKPlacemark(coordinate: segment.start.coordinate, addressDictionary: nil)
            let endMark = MKPlacemark(coordinate: segment.end.coordinate, addressDictionary: nil)
            var points: [CLLocationCoordinate2D] = []
            
            self.mapView.addAnnotation(startMark)
            self.mapView.addAnnotation(endMark)
            
            switch segment {
            case let journey as BTJourney:

                for station in journey.passList! {
                    let passMark = MKPlacemark(coordinate: station.coordinate, addressDictionary: nil)
                    points.append(passMark.coordinate)
                    self.mapView.addAnnotation(passMark)
                
                }
                let line = BTConnectionPolyLine(coordinates: &points, count: points.count)
                line.connectionData = segment
                
                points.append(journey.end.coordinate)
                self.mapView.addOverlay(line)
                
            case let walk as BTWalk:
                let dirReq = MKDirectionsRequest()
                dirReq.transportType = .Walking
                dirReq.setSource(MKMapItem(placemark: startMark))
                dirReq.setDestination(MKMapItem(placemark: endMark))
                
                let direction = MKDirections(request: dirReq)
                direction.calculateDirectionsWithCompletionHandler() { (res: MKDirectionsResponse!, err: NSError!) -> Void in
                    if let route = res.routes.first as? MKRoute {
                        let line = route.polyline as BTConnectionPolyLine
                        line.connectionData = segment
                        self.mapView.addOverlay(line)
                    }
                }
                
            case let route as BTGisRoute:
                let dirReq = MKDirectionsRequest()
                dirReq.transportType = .Walking
                dirReq.setSource(MKMapItem(placemark: startMark))
                dirReq.setDestination(MKMapItem(placemark: endMark))
                
                let direction = MKDirections(request: dirReq)
                
                direction.calculateDirectionsWithCompletionHandler() { (res: MKDirectionsResponse!, err: NSError!) -> Void in
                    if let route = res.routes.first as? MKRoute {
                        self.mapView.addOverlay(route.polyline)
                    }
                }
                
            default:
                ()
            }
        }
        
        self.mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- MKMapViewDelegate methods
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        mapView.setCenterCoordinate(mapView.userLocation.location.coordinate, animated: true)
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        let polyLineRenderer = MKPolylineRenderer(overlay: overlay)
        polyLineRenderer.lineWidth = 3.5
        
        if let polyLine = overlay as? BTConnectionPolyLine {
            let data = polyLine.connectionData!
            switch data {
            case let journey as BTJourney:
                polyLineRenderer.strokeColor = self.lineColorForService(journey.line)
            case let transfer as BTTransfer:
                polyLineRenderer.strokeColor = kBTColorIconUBahn
            default:
                ()
            }
        } else {
            polyLineRenderer.strokeColor = kBTColorPrimaryBg
            polyLineRenderer.lineWidth = 2.5
            polyLineRenderer.lineDashPattern = [0,5]
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
                return UIColor.purpleColor()
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
        let view = MKAnnotationView(annotation: annotation, reuseIdentifier: "BTPoint")
        view.backgroundColor = UIColor.whiteColor()
        view.frame = CGRectMake(-4, -4, 8, 8)
        view.layer.cornerRadius = 4
        view.layer.shadowOffset = CGSizeMake(1, 1)
        view.layer.shadowOpacity = 0.08
        
        return view
    }
    
    func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool) {
        // TODO: Implement later
    }
    
    func mapView(mapView: MKMapView!, didAddAnnotationViews views: [AnyObject]!) {
        // TODO: Implement later
    }
    
    func mapView(mapView: MKMapView!, didAddOverlayRenderers renderers: [AnyObject]!) {
        // TODO: Implement later
    }
    
    //- MARK: Internal methods
    func routeBetweenPoints(start: MKMapPoint!, end: MKMapPoint!) {
        
    }
}