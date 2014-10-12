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
    var connections: [BTConnection<BTPoint>] = []
    
    
    public convenience init() {
        let fileURL = NSBundle.mainBundle().URLForResource("Antwort_ID_ASCI", withExtension: "xml")
        self.init(fileURL: fileURL)
    }
    
    init(fileURL url: NSURL?) {
        let xmlData = NSData(contentsOfURL: url!, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: nil)
        self.hafasRes = ONOXMLDocument.XMLDocumentWithData(xmlData, error: nil)
    }
    
    convenience init(fileName name: String) {
        let fileURL = NSBundle.mainBundle().URLForResource(name, withExtension: "xml")
        self.init(fileURL: fileURL)
    }


    public func getConnections() -> [BTConnection<BTPoint>] {
        
        self.hafasRes.enumerateElementsWithXPath("//Connection", usingBlock: { (element, idx, stop) -> Void in
            
            let startDate = NSDate() //TODO: Replace with implementation
            let endDate = NSDate() //TODO: Replace with implementation
            let travelTime = self.timeIntervalForElement(element.firstChildWithXPath("//Duration/Time"))
            let transfers = element.firstChildWithXPath("//Transfers").numberValue()
            let departureStation: ONOXMLElement = element.firstChildWithXPath("//Departure//Station")
            let arrivalStation: ONOXMLElement = element.firstChildWithXPath("//Arrival//Station")
            
            let connection = BTConnection<BTPoint>(startDate: startDate,
                endDate: endDate,
                travelTime: travelTime,
                numberOfTransfers: transfers,
                start: self.pointFromElement(element),
                end: self.pointFromElement(element),
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
    
    private func pointFromElement(_: ONOXMLElement) -> BTPoint {
        return BTStation(coordinate: CLLocationCoordinate2DMake(10, 10),
            displayName: "S Scheisshaufen",
            services: nil)
    }
    
    private func timeIntervalForElement(element: ONOXMLElement) -> NSTimeInterval {
        let timeString = element.stringValue()
        var components = timeString.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "d:"))
        let seconds: Int = (components.removeLast() as String).toInt()!
        let minutes: Int = (components.removeLast() as String).toInt()!
        let hours: Int = (components.removeLast() as String).toInt()!
        
        return Double(seconds + minutes*60 + hours*3600)
    }
    
    private func dateTimeFromElement(element: ONOXMLElement) -> NSDate {
        return NSDate()
    }
    
    private func timeIntervalBetween(earlierDate: ONOXMLElement, _ laterDate: ONOXMLElement) -> NSTimeInterval {
        let earlierDiff = self.timeIntervalForElement(earlierDate)
        let laterDiff = self.timeIntervalForElement(laterDate)
        return laterDiff - earlierDiff
    }
    
    private func segmentsForJourney(journey: ONOXMLElement) -> [BTConnectionSegment<BTPoint>] {
        var segments: [BTConnectionSegment<BTPoint>] = []
        
        journey.enumerateElementsWithXPath("//ConSection/") { (element, idx, stop) -> Void in
            var segment: BTConnectionSegment<BTPoint>
            
            let arrivalEl = element.firstChildWithTag("Arrival")
            let departureEl = element.firstChildWithTag("Departure")
            let segmentTypeEl = element.firstChildWithXPath("Journey|Walk|Transfer|GisRoute")

            switch segmentTypeEl.tag {
            case "Journey":
                let startTime = departureEl.firstChildWithXPath("//Time")
                let endTime = arrivalEl.firstChildWithXPath("//Time")
                let duration = self.timeIntervalBetween(startTime, endTime)
            case "Walk":
                println("Walk")
            case "Transfer":
                println("Transfer")
            case "GisRoute":
                println("GisRoute")
            default:
                println("Found something else")
            }
            //            segments.append(segment)
        }
        
        return segments
    }
}
