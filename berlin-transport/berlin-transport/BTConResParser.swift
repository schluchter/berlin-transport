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
        println(__FUNCTION__)
        self.hafasRes.enumerateElementsWithXPath("//Connection", usingBlock: { (element, idx, stop) -> Void in
            
            let overViewEl = element.firstChildWithTag("Overview")
            let segmentListEl = element.firstChildWithTag("ConSectionList")
            
            let startDate = self.dateTimeFromElement(overViewEl.firstChildWithXPath("/Departure//Time"))
            let endDate = self.dateTimeFromElement(overViewEl.firstChildWithXPath("/Arrival//Time"))
            let travelTime = self.timeIntervalForElement(element.firstChildWithXPath("//Duration/Time"))
            let transfers = element.firstChildWithXPath("//Transfers").numberValue()
            let departureStation: ONOXMLElement = overViewEl.firstChildWithXPath("//Departure//Station")
            let arrivalStation: ONOXMLElement = overViewEl.firstChildWithXPath("//Arrival//Station")
            
            if let point: BTPoint = self.pointFromElement(arrivalStation) {
                println(point)
            } else {
                println("Well shit.")
            }
            
            //            let connection = BTConnection(startDate: startDate,
            //                endDate: endDate,
            //                travelTime: travelTime,
            //                numberOfTransfers: transfers,
            //                start: self.pointFromElement(departureStation)!,
            //                end: self.pointFromElement(arrivalStation)!,
            //                segments: nil)
            //
            //            self.connections.append(connection)
        })
        return connections
    }
    
    private func coordinatesForStation(station: ONOXMLElement) -> CLLocationCoordinate2D {
        println(__FUNCTION__)
        let lat = Double((station["y"] as String).toInt()!) / kBTCoordinateDegreeDivisor
        let long = Double((station["x"] as String).toInt()!) / kBTCoordinateDegreeDivisor
        let coords = CLLocationCoordinate2DMake(lat, long)
        
        return coords
    }
    
    private func pointFromElement(element: ONOXMLElement) -> BTPoint? {
        println(__FUNCTION__)
        var point: BTPoint?
        let coordinate = self.coordinatesForStation(element)
        let displayName: String = toString(element.attributes["name"])
        
        switch element.tag {
        case "Address":
            point = BTAddress(coordinate: coordinate,
                displayName: displayName)
        case "Poi":
            point = BTPointOfInterest(coordinate: coordinate,
                displayName: displayName)
        case "Station":
            point = BTStation(coordinate: coordinate,
                displayName: displayName,
                externalId: toString(element["externalId"]),
                externalStationNr: toString(element["externalStationNr"]),
                services: nil)
        default: ()
        }
        return point
    }
    
    private func timeIntervalForElement(element: ONOXMLElement) -> NSTimeInterval {
        println(__FUNCTION__)
        let timeString = element.stringValue()
        var components = timeString.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "d:"))
        let seconds: Int = (components.removeLast() as String).toInt()!
        let minutes: Int = (components.removeLast() as String).toInt()!
        let hours: Int = (components.removeLast() as String).toInt()!
        if let days: Int = (components.removeLast() as String).toInt()? {
            var total = days*86400 + hours*3600 + minutes*60 + seconds
            return NSTimeInterval(total)
        } else {
            var total = hours*3600 + minutes*60 + seconds
            return NSTimeInterval(total)
        }
    }
    
    private func dateTimeFromElement(element: ONOXMLElement?) -> NSDate {
        println(__FUNCTION__)
        let date: NSDate = NSDate()
        return date
    }
    
    private func timeIntervalBetween(earlierDate: ONOXMLElement, _ laterDate: ONOXMLElement) -> NSTimeInterval {
        println(__FUNCTION__)
        let earlierDiff = self.timeIntervalForElement(earlierDate)
        let laterDiff = self.timeIntervalForElement(laterDate)
        return laterDiff - earlierDiff
    }
    
    private func segmentsForJourney(journey: ONOXMLElement) -> [BTConnectionSegment] {
        println(__FUNCTION__)
        var segments: [BTConnectionSegment] = []
        
        journey.enumerateElementsWithXPath("//ConSection/") { (element, idx, stop) -> Void in
            var segment: BTConnectionSegment?
            
            let arrivalEl = element.firstChildWithTag("Arrival")
            let departureEl = element.firstChildWithTag("Departure")
            let segmentTypeEl = element.firstChildWithXPath("Journey|Walk|Transfer|GisRoute")
            
            let startTime = departureEl.firstChildWithXPath("//Time")
            let endTime = arrivalEl.firstChildWithXPath("//Time")
            let duration = self.timeIntervalBetween(startTime, endTime)
            
            
            switch segmentTypeEl.tag {
            case "Journey":
                segment = BTJourney(start: self.pointFromElement(departureEl)!,
                    end: self.pointFromElement(arrivalEl)!,
                    duration: duration,
                    line: BTServiceDescription(serviceId: (serviceType: ServiceType.UBahn, name: "7"), serviceTerminus: "Krumme Flanke"))
                
            case "Walk":
                segment = BTWalk(start: self.pointFromElement(departureEl)!,
                    end: self.pointFromElement(arrivalEl)!,
                    duration: duration,
                    distance: 200)
                println("Walk")
            case "Transfer":
                segment = BTTransfer(start: self.pointFromElement(departureEl)!,
                    end: self.pointFromElement(arrivalEl)!,
                    duration: duration)
                
                println("Transfer")
            case "GisRoute":
                segment = BTGisRoute(start: self.pointFromElement(departureEl)!,
                    end: self.pointFromElement(arrivalEl)!,
                    duration: duration,
                    trafficType: BTGisRoute.IndividualTrafficType.Car)
                
                println("GisRoute")
            default:
                segment = nil
                let exception = NSException(name: "BTNoValidSegmentTypeFoundInConnection", reason: nil, userInfo: nil)
                exception.raise()
            }
            segments.append(segment!)
        }
        return segments
    }
}