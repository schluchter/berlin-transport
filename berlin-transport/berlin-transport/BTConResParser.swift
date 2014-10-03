//
//  BTConResParser.swift
//  berlin-transport
//
//  Created by Thomas Schluchter on 9/30/14.
//  Copyright (c) 2014 Thomas Schluchter. All rights reserved.
//

import Foundation
import MapKit

public class BTConResParser {
    var hafasRes: ONOXMLDocument
    public var connections: [BTConnection] = []
    
    init(fileURL url: NSURL?) {
        let xmlData = NSData(contentsOfURL: url!, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: nil)
        self.hafasRes = ONOXMLDocument.XMLDocumentWithData(xmlData, error: nil)
    }
    
    convenience init(fileName name: String) {
        let fileURL = NSBundle.mainBundle().URLForResource(name, withExtension: "xml")
        self.init(fileURL: fileURL)
    }
    
    public convenience init() {
        let fileURL = NSBundle.mainBundle().URLForResource("VBB-STD-LUAX-CONRes", withExtension: "xml")
        self.init(fileURL: fileURL)
    }
    
    func getConnections() -> [BTConnection] {
        
        self.hafasRes.enumerateElementsWithXPath("//Connection", usingBlock: { (element, idx, stop) -> Void in
            
            let connDate = NSDate()
            let travelTimeStr = element.firstChildWithXPath("//Duration/Time").stringValue()
            let travelTime = CFTimeInterval.abs(22.0 * 60.0)
            let doesConnect = element.firstChildWithXPath("//Transfers").numberValue().boolValue
            let departureStation: ONOXMLElement = element.firstChildWithXPath("//Departure//Station")
            let arrivalStation: ONOXMLElement = element.firstChildWithXPath("//Arrival//Station")
            
            let connection = BTConnection(
                date: connDate,
                travelTime: travelTime,
                doesConnect: doesConnect,
                departureStation: BTStation(
                    name: departureStation.attributes["name"]! as String,
                    coords: self.coordinatesForStation(departureStation),
                    services: nil),
                arrivalStation: BTStation(
                    name: arrivalStation.attributes["name"]! as String,
                    coords: self.coordinatesForStation(arrivalStation),
                    services: nil),
                segments: nil)
            
            self.connections.append(connection)
        })
        return connections
    }
    
    private func coordinatesForStation(station: ONOXMLElement) -> CLLocationCoordinate2D {
        let lat = Double((station["y"] as String).toInt()!) / kBTCoordinateDegreeDivisor
        let long = Double((station["x"] as String).toInt()!) / kBTCoordinateDegreeDivisor
        
        let coords = CLLocationCoordinate2DMake(lat, long)
        
        return coords
    }
}
