//
//  BTConnection.swift
//  berlin-transport
//
//  Created by Thomas Schluchter on 10/1/14.
//  Copyright (c) 2014 Thomas Schluchter. All rights reserved.
//

import Foundation
import CoreLocation

struct BTConnectionSegment {
    typealias Meters = UInt
    
    let start: BTPoint
    let end: BTPoint
    let mode: Mode

    let duration: NSTimeInterval?
    let distance: Meters?
    
    enum Mode {
        case Journey
        case Walk
        case Transfer
        case GisRoute    
    }
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