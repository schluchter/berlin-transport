//
//  BTResponseParser.swift
//  berlin-transport
//
//  Created by Thomas Schluchter on 9/30/14.
//  Copyright (c) 2014 Thomas Schluchter. All rights reserved.
//

import Foundation
import MapKit

public class BTResponseParser {
    var hafasRes: ONOXMLDocument
    
    init() {
        var parserError = NSError(domain: "XML couldn't be parsed", code: 1, userInfo: nil)
        var onoError = NSError(domain: "ONO error", code: 2, userInfo: nil)
        
        let xmlPath = NSBundle.mainBundle().URLForResource("VBB-STD-LUAX-CONRes", withExtension: "xml")
        let xmlData = NSData(contentsOfURL: xmlPath!, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: nil)
        
        self.hafasRes = ONOXMLDocument(data: xmlData, error: nil)
    }
    
    func getConnections() -> [BTConnection] {
        println(__FUNCTION__)
        var connections: [BTConnection] = []
    
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
                departureStation: BTStation(name: departureStation.attributes["name"]! as String, coords: self.coordinatesForStation(departureStation), services: nil),
                arrivalStation: BTStation(name: arrivalStation.attributes["name"]! as String, coords: self.coordinatesForStation(arrivalStation), services: nil),
                segments: nil)
            
            connections.append(connection)
        })
        return connections
    }
    
    private func coordinatesForStation(station: ONOXMLElement) -> CLLocationCoordinate2D {
        let x = Double((station["x"] as String).toInt()!) / 1000000
        let y = Double((station["y"] as String).toInt()!) / 1000000
        
        let coords = CLLocationCoordinate2DMake(x, y)
        
        return coords
    }
}
