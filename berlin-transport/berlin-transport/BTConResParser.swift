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
    
    
    public func getConnections() -> [BTConnection] {
        
        self.hafasRes.enumerateElementsWithXPath("//Connection", usingBlock: { (element, idx, stop) -> Void in
            
            let startDate = NSDate() //TODO: Replace with implementation
            let endDate = NSDate() //TODO: Replace with implementation
            let travelTime = self.timeIntervalForElement(element.firstChildWithXPath("//Duration/Time"))
            let transfers = element.firstChildWithXPath("//Transfers").numberValue()
            let departureStation: ONOXMLElement = element.firstChildWithXPath("//Departure//Station")
            let arrivalStation: ONOXMLElement = element.firstChildWithXPath("//Arrival//Station")
            
            let connection = BTConnection(startDate: startDate,
                endDate: endDate,
                travelTime: travelTime,
                numberOfTransfers: transfers,
                start: self.pointFromElement(element)!,
                end: self.pointFromElement(element)!,
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
    
    private func pointFromElement(element: ONOXMLElement) -> BTPoint? {
        let pointType = element.firstChildWithXPath("/BasicStop/Address|Poi|Station")
        var point: BTPoint?
        let coordinate = self.coordinatesForStation(pointType)
        let displayName = pointType["name"].stringValue
        
        switch pointType.tag {
        case "Address":
            point =  BTAddress(coordinate: coordinate,
                displayName: displayName)
        case "Poi":
            point =  BTPointOfInterest(coordinate: coordinate,
                displayName: displayName)
        case "Station":
            point = BTStation(coordinate: coordinate,
                displayName: displayName,
                externalId: pointType["externalId"].stringValue,
                externalStationNr: pointType["externalStationNr"].numberValue(),
                services: nil)
        default: ()
        }
        return point
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
    
    private func segmentsForJourney(journey: ONOXMLElement) -> [BTConnectionSegment] {
        var segments: [BTConnectionSegment] = []
        
        journey.enumerateElementsWithXPath("//ConSection/") { (element, idx, stop) -> Void in
            var segment: BTConnectionSegment
            
            let arrivalEl = element.firstChildWithTag("Arrival")
            let departureEl = element.firstChildWithTag("Departure")
            let segmentTypeEl = element.firstChildWithXPath("Journey|Walk|Transfer|GisRoute")
            
            switch segmentTypeEl.tag {
            case "Journey":
                let startTime = departureEl.firstChildWithXPath("//Time")
                let endTime = arrivalEl.firstChildWithXPath("//Time")
                let duration = self.timeIntervalBetween(startTime, endTime)
                segment = BTConnectionSegment(start: self.pointFromElement(departureEl)!,
                    end: self.pointFromElement(arrivalEl)!,
                    mode: .Journey,
                    duration: 20,
                    distance: nil)
            case "Walk":
                segment = BTConnectionSegment(start: self.pointFromElement(departureEl)!,
                    end: self.pointFromElement(arrivalEl)!,
                    mode: .Journey,
                    duration: 20,
                    distance: nil)
                println("Walk")
            case "Transfer":
                segment = BTConnectionSegment(start: self.pointFromElement(departureEl)!,
                    end: self.pointFromElement(arrivalEl)!,
                    mode: .Journey,
                    duration: 20,
                    distance: nil)
                
                println("Transfer")
            case "GisRoute":
                segment = BTConnectionSegment(start: self.pointFromElement(departureEl)!,
                    end: self.pointFromElement(arrivalEl)!,
                    mode: .Journey,
                    duration: 20,
                    distance: nil)
                
                println("GisRoute")
            default:
                segment = BTConnectionSegment(start: self.pointFromElement(departureEl)!,
                    end: self.pointFromElement(arrivalEl)!,
                    mode: .Journey,
                    duration: 20,
                    distance: nil)
                
                println("Found something else")
            }
            segments.append(segment)
        }
        
        return segments
    }
}
