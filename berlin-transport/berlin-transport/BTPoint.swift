//
//  BTPoint.swift
//  berlin-transport
//
//  Created by Thomas Schluchter on 10/9/14.
//  Copyright (c) 2014 Thomas Schluchter. All rights reserved.
//

import Foundation
import CoreLocation

public protocol BTPoint {
    var coordinate: CLLocationCoordinate2D { get }
    var displayName: String { get }
}

struct BTStation: BTPoint {
    let coordinate: CLLocationCoordinate2D
    let displayName: String
    let externalId: String
    let externalStationNr: UInt
    let services: [BTServiceDescription]?
}

struct BTPointOfInterest: BTPoint {
    let coordinate: CLLocationCoordinate2D
    let displayName: String
}

struct BTAddress: BTPoint {
    let coordinate: CLLocationCoordinate2D
    let displayName: String
}
