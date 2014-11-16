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
import CoreLocation
import MapKit

class BTConnectionSearch: UIViewController {
    
    func updateTextField(textField: UITextField) {
        let pred = NSPredicate(format: "name CONTAINS[c] %@", textField.text)
        self.stops = GTFSStop.objectsWithPredicate(pred!).sortedResultsUsingProperty("name", ascending: true)
        tableView.reloadData()
    }
    
    @IBOutlet weak var fromField: UITextField!
    @IBOutlet weak var toField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var textfields: [UITextField]!
    
    var stops = GTFSStop.allObjects().sortedResultsUsingProperty("name", ascending: true)
    
    override func viewDidLoad() {
        for field in self.textfields {
            field.clearsOnBeginEditing = true
            field.clearButtonMode = UITextFieldViewMode.Always
            field.addTarget(self, action: "updateTextField:", forControlEvents: UIControlEvents.EditingChanged)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        ()
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
    
    func updateTextField(field: UITextField!) {
        let pred = NSPredicate(format: "name CONTAINS[c] %@", field.text)
        self.stops = GTFSStop.objectsWithPredicate(pred!).sortedResultsUsingProperty("name", ascending: true)
        tableView.reloadData()
    }
}

extension BTConnectionSearch: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        ()
    }
}

extension BTConnectionSearch: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("locSuggestion", forIndexPath: indexPath) as UITableViewCell
        let stop = self.stops.objectAtIndex(UInt(indexPath.row)) as GTFSStop
        cell.textLabel.text = stop.name
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(self.stops.count)
    }
}

extension BTConnectionSearch: UITextFieldDelegate {
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.placeholder = "Schreib ma wat, Keule"
        textField.becomeFirstResponder()
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