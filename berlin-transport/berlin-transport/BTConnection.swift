//
//  BTConnection.swift
//  berlin-transport
//
//  Created by Thomas Schluchter on 10/1/14.
//  Copyright (c) 2014 Thomas Schluchter. All rights reserved.
//

import Foundation
import CoreLocation

public typealias Meters = UInt

public protocol BTConnectionSegment {
    var start: BTPoint { get }
    var end: BTPoint { get }
    var duration: NSTimeInterval? {get}
}

public struct BTJourney: BTConnectionSegment {
    public let start: BTPoint
    public let end: BTPoint
    public let duration: NSTimeInterval?
    public let line: BTServiceDescription
    public let passList: [BTStation]?
    
}

public struct BTWalk: BTConnectionSegment {
    public let start: BTPoint
    public let end: BTPoint
    public let duration: NSTimeInterval?
    public let distance: Meters?
}

public struct BTGisRoute: BTConnectionSegment {
    public let start: BTPoint
    public let end: BTPoint
    public let duration: NSTimeInterval?
    public let distance: Meters?
    public let trafficType: IndividualTrafficType
    
    public enum IndividualTrafficType {
        case Foot
        case Bike
        case Car
        case Taxi
    }
}

public struct BTTransfer: BTConnectionSegment {
    public let start: BTPoint
    public let end: BTPoint
    public let duration: NSTimeInterval?
    
}

public struct BTConnection {
    public var startDate: NSDate
    public var endDate: NSDate
    public var travelTime: NSTimeInterval
    public var numberOfTransfers: UInt
    public var start: BTPoint
    public var end: BTPoint
    public var segments: [BTConnectionSegment]?
}