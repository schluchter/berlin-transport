//
//  BTConnection.swift
//  berlin-transport
//
//  Created by Thomas Schluchter on 10/1/14.
//  Copyright (c) 2014 Thomas Schluchter. All rights reserved.
//

import Foundation
import CoreLocation

struct BTConnectionSegment<T: BTPoint> {
    let duration: NSTimeInterval
    let start: T
    let end: T
//    let mode: Mode
//    
//    enum Mode {
//        case Journey(BTJourney)
//        case Walk(BTWalk)
//        case Transfer
//        case GisRoute
//        
//        struct BTJourney {
//            let service: BTServiceDescription
//            let passList: [BTStation]?
//        }
//        
//        struct BTWalk {
//            let length: NSTimeInterval
//        }
//    }
}

public struct BTConnection<T: BTPoint> {
    var startDate: NSDate
    var endDate: NSDate
    public var travelTime: NSTimeInterval
    var numberOfTransfers: UInt
    var start: T
    var end: T
    var segments: [BTConnectionSegment<T>]?
}