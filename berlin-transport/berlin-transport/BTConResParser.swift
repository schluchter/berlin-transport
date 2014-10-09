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
    var connections: [BTConnection] = []
    
    init(fileURL url: NSURL?) {
        let xmlData = NSData(contentsOfURL: url!, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: nil)
        self.hafasRes = ONOXMLDocument.XMLDocumentWithData(xmlData, error: nil)
    }
    
    convenience init(fileName name: String) {
        let fileURL = NSBundle.mainBundle().URLForResource(name, withExtension: "xml")
        self.init(fileURL: fileURL)
    }
    
    public convenience init() {
        let fileURL = NSBundle.mainBundle().URLForResource("Antwort_ID_ASCI", withExtension: "xml")
        self.init(fileURL: fileURL)
    }
    
    public func getConnections() -> [BTConnection] {
        
        self.hafasRes.enumerateElementsWithXPath("//Connection", usingBlock: { (element, idx, stop) -> Void in
            
            let connDate = NSDate()
            let travelTime = self.timeIntervalForElement(element.firstChildWithXPath("//Duration/Time"))
            let transfers = element.firstChildWithXPath("//Transfers").numberValue()
            let departureStation: ONOXMLElement = element.firstChildWithXPath("//Departure//Station")
            let arrivalStation: ONOXMLElement = element.firstChildWithXPath("//Arrival//Station")
            
            let connection = BTConnection(
                date: connDate,
                travelTime: travelTime,
                numberOfTransfers: transfers,
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
    
    private func timeIntervalForElement(element: ONOXMLElement) -> NSTimeInterval {
        let timeString = element.stringValue()
        var components = timeString.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "d:"))
        let seconds: Int = (components.removeLast() as String).toInt()!
        let minutes: Int = (components.removeLast() as String).toInt()!
        let hours: Int = (components.removeLast() as String).toInt()!
        
        return Double(seconds + minutes*60 + hours*3600)
    }
}
