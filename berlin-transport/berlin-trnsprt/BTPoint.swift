//
//  BTPoint.swift
//  berlin-transport
//
//  Created by Thomas Schluchter on 10/9/14.
//  Copyright (c) 2014 Thomas Schluchter. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

public protocol BTPoint: MKAnnotation {
    var coordinate: CLLocationCoordinate2D { get }
    var title: String { get }
}

public class BTStation: NSObject, BTPoint {
    public let coordinate: CLLocationCoordinate2D
    public let title: String
    public let externalId: String
    public let externalStationNr: String
    public let services: [BTServiceDescription]?
    
    public init(coordinate: CLLocationCoordinate2D, title: String, externalId: String, externalStationNr: String, services: [BTServiceDescription]?) {
        self.coordinate = coordinate
        self.title = title
        self.externalId = externalId
        self.externalStationNr = externalStationNr
        self.services = services
    }
}

public class BTPointOfInterest: NSObject, BTPoint {
    public let coordinate: CLLocationCoordinate2D
    public let title: String
    
    public init(coordinate: CLLocationCoordinate2D, title: String) {
        self.coordinate = coordinate
        self.title = title
    }
}

public class BTAddress: NSObject, BTPoint {
    public let coordinate: CLLocationCoordinate2D
    public let title: String
    
    public init(coordinate: CLLocationCoordinate2D, title: String) {
        self.coordinate = coordinate
        self.title = title
    }
}
