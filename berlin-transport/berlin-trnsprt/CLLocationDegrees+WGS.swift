//
//  CLLocationDegrees+WGS.swift
//  berlin-transport
//
//  Created by Thomas Schluchter on 11/5/14.
//  Copyright (c) 2014 Thomas Schluchter. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocationDegrees {
    public func toWGS() -> String {
        let degInt = NSNumber(double: self * kBTCoordinateDegreeDivisor).integerValue
        return toString(degInt)
    }
}