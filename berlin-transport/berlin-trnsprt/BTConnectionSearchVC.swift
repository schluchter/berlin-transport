//
//  BTConnectionSearchVC.swift
//  berlin-transport
//
//  Created by Thomas Schluchter on 11/15/14.
//  Copyright (c) 2014 Thomas Schluchter. All rights reserved.
//

import Foundation
import UIKit
import Realm
import Ono
import CoreLocation
import MapKit

class BTConnectionSearchVC: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var fromField: UITextField!
    @IBOutlet weak var toField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var textfields: [UITextField]!
    

    @IBAction func requestConnections(sender: UIBarButtonItem) {
        self.requestConnectionBetween(self.departureCoord!, arrival: self.arrivalCoord!)
    }
    
    var stops = GTFSStop.allObjects().sortedResultsUsingProperty("distanceFromHere", ascending: true)
    var departureCoord: CLLocationCoordinate2D?
    var arrivalCoord: CLLocationCoordinate2D?
    var currentTextField: UITextField?
    var connectionResults: [BTConnection]?
    
    override func viewDidLoad() {
        let locMgr = CLLocationManager()
        locMgr.delegate = self
        println(CLLocationManager.authorizationStatus().rawValue)
        locMgr.requestAlwaysAuthorization()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleBTHafasAPIClientResponse:", name: "BTHafasAPIClientDidReceiveResponse", object: nil)
        
        for field in self.textfields {
            field.clearsOnBeginEditing = true
            field.clearButtonMode = UITextFieldViewMode.Always
            field.addTarget(self, action: "updateTextField:", forControlEvents: UIControlEvents.EditingChanged)
            
            self.view.backgroundColor = kBTColorPrimaryBg
        }
    }
    
    override func viewWillAppear(animated: Bool) {
    }
    
    override func viewDidAppear(animated: Bool) {
        ()
    }
    
    override func viewWillDisappear(animated: Bool) {
        ()
    }
    
    override func viewDidDisappear(animated: Bool) {
        ()
    }
    
    func requestConnectionBetween(departure: CLLocationCoordinate2D, arrival: CLLocationCoordinate2D) {
        // Setting up the data from the server
        let req = BTConReq(date: NSDate(), start: (departure, ""), end: (arrival, ""))
        let reqXml = BTRequestBuilder.conReq(req)
        BTHafasAPIClient.send(reqXml)
    }
    
    func handleBTHafasAPIClientResponse(notification: NSNotification) {
        println(__FUNCTION__)
        print(NSDate())
        let xml = notification.object as ONOXMLDocument
        println(xml)
        let parser = BTConResParser(xml)
        self.connectionResults = parser.getConnections()
        self.performSegueWithIdentifier("displayConnections", sender: self)
    }
    
    func updateTextField(field: UITextField!) {
        let pred = NSPredicate(format: "name CONTAINS[c] %@", field.text)
        self.stops = GTFSStop.objectsWithPredicate(pred!).sortedResultsUsingProperty("distanceFromHere", ascending: true)
        tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "displayConnections" {
            let connectionListVC = segue.destinationViewController as BTConnectionResultListViewController
            connectionListVC.connections = self.connectionResults
        }
    }
}

extension BTConnectionSearchVC: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let stop = self.stops[UInt(indexPath.row)] as GTFSStop
        if self.currentTextField == nil {
            self.currentTextField = self.textfields.first!
        }
        self.currentTextField!.text = stop.name
        switch currentTextField!.tag {
        case 1:
            self.departureCoord = CLLocationCoordinate2D(latitude: stop.lat, longitude: stop.long)
        case 2:
            self.arrivalCoord = CLLocationCoordinate2D(latitude: stop.lat, longitude: stop.long)
        default:
            ()
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        for textfield in self.textfields {
            textfield.resignFirstResponder()
        }
    }
}

extension BTConnectionSearchVC: UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("locSuggestion", forIndexPath: indexPath) as UITableViewCell
        let stop = self.stops.objectAtIndex(UInt(indexPath.row)) as GTFSStop
        cell.textLabel!.text = stop.name
        cell.detailTextLabel!.text = "\(BTMapUtils.formatDistance(stop.distanceFromHere))"
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(self.stops.count)
    }
}

extension BTConnectionSearchVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.becomeFirstResponder()
        self.currentTextField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.placeholder = ""
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}