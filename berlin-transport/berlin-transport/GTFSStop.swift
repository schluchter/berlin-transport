//
//  GTFSStop.swift
//  berlin-transport
//
//  Created by Thomas Schluchter on 11/13/14.
//  Copyright (c) 2014 Thomas Schluchter. All rights reserved.
//

import Foundation
import CoreLocation
import Realm

class GTFSStop: RLMObject {
    dynamic var id: String = ""
    dynamic var code: String = ""
    dynamic var name: String = ""
    dynamic var desc: String = ""
    dynamic var lat: Double = 0.0
    dynamic var long: Double = 0.0
    dynamic var zoneId: String = ""
    dynamic var stopUrl: String = ""
    dynamic var locationType: String = ""
    dynamic var parentStation: String = ""
    dynamic var distanceFromHere: Int = 0
    
    override class func attributesForProperty(propertyName: String) -> RLMPropertyAttributes {
        var attributes = super.attributesForProperty(propertyName)
        if propertyName == "name" {
            attributes |= RLMPropertyAttributes.AttributeIndexed
        }
        return attributes
    }
    
    override class func primaryKey() -> String {
        return "id"
    }
    
    class func updateWithDistanceFromLocation(location: CLLocationCoordinate2D) {
        let queue = dispatch_queue_create("Update queue", nil)
        dispatch_async(queue, { () -> Void in
            RLMRealm.defaultRealm().beginWriteTransaction()
            
            for stop in self.allObjects() {
                let theStop = stop as GTFSStop
                let hereLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
                let stopLocation = CLLocation(latitude: theStop.lat, longitude: theStop.long)
                let distance = stopLocation.distanceFromLocation(hereLocation)
                theStop.distanceFromHere = Int(distance)
                GTFSStop.createOrUpdateInDefaultRealmWithObject(theStop)
            }
            
            RLMRealm.defaultRealm().commitWriteTransaction()
        })
    }
}