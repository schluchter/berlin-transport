//
//  BTConnection.swift
//  berlin-transport
//
//  Created by Thomas Schluchter on 10/1/14.
//  Copyright (c) 2014 Thomas Schluchter. All rights reserved.
//

import Foundation
import CoreLocation

protocol BTConnectionSegment {
    var start: BTPoint { get }
    var end: BTPoint { get }
    var duration: NSTimeInterval {get}
}

public struct BTJourney: BTConnectionSegment {
    let start: BTPoint
    let end: BTPoint
    let duration: NSTimeInterval
    let line: BTServiceDescription
    
}

public struct BTWalk: BTConnectionSegment {
    typealias Meters = UInt
    
    let start: BTPoint
    let end: BTPoint
    let duration: NSTimeInterval
    let distance: Meters?
}

public struct BTGisRoute: BTConnectionSegment {
    let start: BTPoint
    let end: BTPoint
    let duration: NSTimeInterval
    let trafficType: IndividualTrafficType
    
    enum IndividualTrafficType {
        case Foot
        case Bike
        case Car
        case Taxi
    }
    
}

public struct BTTransfer: BTConnectionSegment {
    let start: BTPoint
    let end: BTPoint
    let duration: NSTimeInterval
    
}

public struct BTConnection {
    var startDate: NSDate
    var endDate: NSDate
    public var travelTime: NSTimeInterval
    var numberOfTransfers: UInt
    var start: BTPoint
    var end: BTPoint
    var segments: [BTConnectionSegment]?
}