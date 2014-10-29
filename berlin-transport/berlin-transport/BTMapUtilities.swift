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
        
        let latitudeDelta = abs(one.latitude - two.latitude) / 2.0
        let longitudeDelta = abs(one.longitude - two.longitude) / 2.0
        
        let latNew = latitudeDelta + min(one.latitude, two.latitude)
        let longNew = longitudeDelta + min(one.longitude, two.longitude)
        
        return CLLocationCoordinate2DMake(latNew, longNew)
    }
}
