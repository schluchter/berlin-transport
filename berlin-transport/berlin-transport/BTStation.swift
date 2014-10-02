//
//  BTStation.swift
//  berlin-transport
//
//  Created by Thomas Schluchter on 10/1/14.
//  Copyright (c) 2014 Thomas Schluchter. All rights reserved.
//

import Foundation
import CoreLocation

struct BTStation {
    let name: String
    let coords: CLLocationCoordinate2D?
    let services: [BTServiceDescription]?
}