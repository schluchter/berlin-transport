//
//  BTConnectionPolyLine.swift
//  berlin-transport
//
//  Created by Thomas Schluchter on 11/5/14.
//  Copyright (c) 2014 Thomas Schluchter. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class BTConnectionPolyLine : MKPolyline {
    let connectionData: BTConnectionSegment
    
    init(connectionData: BTConnectionSegment) {
        self.connectionData = connectionData
        var coordinateList: [CLLocationCoordinate2D] = []
        if let journey = connectionData as? BTJourney {
            for point in journey.passList! {
                coordinateList.append(point.coordinate)
            }
        } else if let walk = connectionData as? BTWalk {
            coordinateList.append(walk.start.coordinate)
            coordinateList.append(walk.end.coordinate)
        } else if let gisRoute = connectionData as? BTGisRoute {
            coordinateList.append(gisRoute.start.coordinate)
            coordinateList.append(gisRoute.end.coordinate)
        }
    }
}