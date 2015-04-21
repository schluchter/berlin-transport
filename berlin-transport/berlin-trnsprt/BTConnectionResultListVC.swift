//
//  BTConnectionResultListVC.swift
//  berlin-transport
//
//  Created by Thomas Schluchter on 11/17/14.
//  Copyright (c) 2014 Thomas Schluchter. All rights reserved.
//

import Foundation
import UIKit

class BTConnectionResultListViewController: UITableViewController {
    var connections: [BTConnection]?
    var selectedConnection: BTConnection!
    
    override func viewDidLoad() {
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showConnectionMap" {
            let destVC = segue.destinationViewController as! BTConnectionMapVC
            destVC.connection = self.selectedConnection
        }
    }
}

extension BTConnectionResultListViewController: UITableViewDelegate {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let connections = self.connections {
            self.selectedConnection = connections[indexPath.row] as BTConnection
            self.performSegueWithIdentifier("showConnectionMap", sender: self)
        } else {
            NSException(name: "No connections found", reason: nil, userInfo: nil).raise()
        }
    }
}

extension BTConnectionResultListViewController: UITableViewDataSource {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return connections!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("IndividualConnection", forIndexPath: indexPath) as! UITableViewCell
        let connection = connections![indexPath.row]
        
        cell.textLabel?.text = "\(connection.startDate)"
        cell.detailTextLabel?.text = "\(connection.travelTime)s"
        return cell
    }
}