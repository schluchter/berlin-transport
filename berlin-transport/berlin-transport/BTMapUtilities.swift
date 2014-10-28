//
//  BTMapUtilities.swift
//  berlin-transport
//
//  Created by Thomas Schluchter on 10/27/14.
//  Copyright (c) 2014 Thomas Schluchter. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

public class BTMapUtils {
    public class func centerBetweenPoints(one: CLLocationCoordinate2D, _ two: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        
        func addDeltaToSmallerValue(delta: CLLocationDegrees, one: CLLocationDegrees, two: CLLocationDegrees) -> CLLocationDegrees {
            if one < two {
                return one + delta
            } else {
                return two + delta
            }
        }
        
        func positiveDelta(one: CLLocationDegrees, two: CLLocationDegrees) -> CLLocationDegrees {
            if one > two {
                return (one - two) / 2.0
            } else {
                return (two - one) / 2.0
            }
        }

        let latitudeDelta = positiveDelta(one.latitude, two.latitude)
        let longitudeDelta = positiveDelta(one.longitude, two.longitude)
        
        let latNew = addDeltaToSmallerValue(latitudeDelta, one.latitude, two.latitude)
        let longNew = addDeltaToSmallerValue(longitudeDelta, one.longitude, two.longitude)
        
        return CLLocationCoordinate2DMake(latNew, longNew)
    }
}
