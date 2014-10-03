//
//  BTConnection.swift
//  berlin-transport
//
//  Created by Thomas Schluchter on 10/1/14.
//  Copyright (c) 2014 Thomas Schluchter. All rights reserved.
//

import Foundation
import CoreFoundation

struct BTConnectionSegment {
    let order: UInt
    let travelTime: UInt
    let getOn: BTStation
    let getOff: BTStation
    let duration: UInt
}

public struct BTConnection {
    var date: NSDate
    var travelTime: CFTimeInterval
    var doesConnect: Bool
    var departureStation: BTStation
    var arrivalStation: BTStation
    var segments: [BTConnectionSegment]?
}