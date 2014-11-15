//
//  BTGTFSParser.swift
//  berlin-transport
//
//  Created by Thomas Schluchter on 11/15/14.
//  Copyright (c) 2014 Thomas Schluchter. All rights reserved.
//

import Foundation
import Realm

class GTFSParser: NSObject, CHCSVParserDelegate {
    let formatter = NSNumberFormatter()
    
    func populateStopDatabase() {
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        
        // Create and configure CHCSVParser
        let path = NSBundle.mainBundle().pathForResource("stops", ofType: "txt")!
        let url = NSURL.fileURLWithPath(path)!
        dispatch_async(dispatch_get_main_queue()) {
            let realm = RLMRealm.defaultRealm()
            let stops = NSArray(contentsOfCSVURL: url, options: CHCSVParserOptions.UsesFirstLineAsKeys) as [NSDictionary]
            
            realm.beginWriteTransaction()
            realm.deleteAllObjects()
            
            for entry in stops {
                let stop = GTFSStop()
                stop.id = entry["stop_id"] as String
                stop.name = entry["stop_name"] as String
                stop.lat = self.formatter.numberFromString(entry["stop_lat"] as String)!.doubleValue
                stop.long = self.formatter.numberFromString(entry["stop_lon"] as String)!.doubleValue
                realm.addObject(stop)
            }
            realm.commitWriteTransaction()
            println(realm.path)
        }
        
    }
}