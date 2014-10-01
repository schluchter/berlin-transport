//
//  BTConnection.swift
//  berlin-transport
//
//  Created by Thomas Schluchter on 10/1/14.
//  Copyright (c) 2014 Thomas Schluchter. All rights reserved.
//

import Foundation

struct BTConnectionSegment {
    let order: UInt
    let travelTime: UInt
    let getOn: BTStation
    let getOff: BTStation
    let duration: UInt
}

struct BTConnection {
    let date: NSDate
    let travelTime: UInt
    let doesConnect: Bool
    let departureStation: BTStation
    let arrivalStation: BTStation
    let segments: [BTConnectionSegment]
}