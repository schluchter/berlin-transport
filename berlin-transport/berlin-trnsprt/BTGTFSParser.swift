//
//  BTGTFSParser.swift
//  berlin-transport
//
//  Created by Thomas Schluchter on 11/15/14.
//  Copyright (c) 2014 Thomas Schluchter. All rights reserved.
//

import Foundation
import Realm
import CHCSVParser

class GTFSParser: NSObject, CHCSVParserDelegate {
    let formatter = NSNumberFormatter()
    
    func populateStopDatabase() {
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        
//        RLMRealm.setSchemaVersion(1, withMigrationBlock: { (migration: RLMMigration!, oldSchemaVersion: UInt) -> Void in
//            if oldSchemaVersion > 1 {
//                migration.enumerateObjects(GTFSStop.className(), block: { (oldObject: RLMObject!, newObject: RLMObject!) -> Void in
//                    newObject["distanceFromHere"] = (newObject["name"] as String).lengthOfBytesUsingEncoding(NSISOLatin1StringEncoding)
//                })
//            }
//        })
        
        // Create and configure CHCSVParser
        let path = NSBundle.mainBundle().pathForResource("stops", ofType: "txt")!
        let url = NSURL.fileURLWithPath(path)!
        dispatch_async(dispatch_get_main_queue()) {
            let realm = RLMRealm.defaultRealm()
            let stops = NSArray(contentsOfCSVURL: url, options: CHCSVParserOptions.UsesFirstLineAsKeys|CHCSVParserOptions.SanitizesFields) as [NSDictionary]
            
            // Write to Realm DB
            realm.beginWriteTransaction()

            for entry in stops {
                let stop = GTFSStop()
                stop.id = entry["stop_id"] as String
                stop.name = entry["stop_name"] as String
                stop.lat = self.formatter.numberFromString(entry["stop_lat"] as String)!.doubleValue
                stop.long = self.formatter.numberFromString(entry["stop_lon"] as String)!.doubleValue
                realm.addOrUpdateObject(stop)
            }
            realm.commitWriteTransaction()
            println(realm.path)
        }
        
    }
}