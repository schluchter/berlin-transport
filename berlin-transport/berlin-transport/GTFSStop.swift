//
//  GTFSStop.swift
//  berlin-transport
//
//  Created by Thomas Schluchter on 11/13/14.
//  Copyright (c) 2014 Thomas Schluchter. All rights reserved.
//

import Foundation
import Realm

class GTFSStop: RLMObject {
    dynamic var id: String = ""
    dynamic var code: String = ""
    dynamic var name: String = ""
    dynamic var desc: String = ""
    dynamic var lat: Float = 0.0
    dynamic var long: Float = 0.0
    dynamic var zoneId: String = ""
    dynamic var stopUrl: String = ""
    dynamic var locationType: String = ""
    dynamic var parentStation: String = ""
        
    override class func attributesForProperty(propertyName: String) -> RLMPropertyAttributes {
        var attributes = super.attributesForProperty("name")
        attributes |= RLMPropertyAttributes.AttributeIndexed
        return attributes
    }   
}