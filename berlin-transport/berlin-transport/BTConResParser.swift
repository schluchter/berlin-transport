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
    
    public init(fileURL url: NSURL?) {
        let xmlData = NSData(contentsOfURL: url!, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: nil)
        self.hafasRes = ONOXMLDocument(data: xmlData, error: nil)
    }
    
    public convenience init(fileName name: String) {
        let fileURL = NSBundle.mainBundle().URLForResource(name, withExtension: "xml")
        self.init(fileURL: fileURL)
    }
    
    
    public func getConnections() -> [BTConnection] {
        println(__FUNCTION__)
        self.hafasRes.enumerateElementsWithXPath("//Connection", usingBlock: { (element, idx, stop) -> Void in
            
            let overViewEl = element.firstChildWithTag("Overview")
            let segmentListEl = element.firstChildWithTag("ConSectionList")
            
            let connectionBaseDate = self.dateTimeFromElement(overViewEl.firstChildWithTag("Date"))!
            let startDate = self.dateTimeFromElement(overViewEl.firstChildWithXPath(".//Departure//Time"), baseDate: connectionBaseDate)
            let endDate = self.dateTimeFromElement(overViewEl.firstChildWithXPath(".//Arrival//Time"), baseDate: connectionBaseDate)
            let travelTime = self.timeIntervalForElement(element.firstChildWithXPath(".//Duration/Time"))
            let transfers = element.firstChildWithXPath("//Transfers").numberValue().unsignedLongValue
            let departureStation: ONOXMLElement = overViewEl.firstChildWithXPath(".//Departure//Station")
            let arrivalStation: ONOXMLElement = overViewEl.firstChildWithXPath(".//Arrival//Station")
            
            let connection = BTConnection(startDate: startDate,
                endDate: endDate,
                travelTime: travelTime,
                numberOfTransfers: transfers,
                start: self.pointFromElement(departureStation)!,
                end: self.pointFromElement(arrivalStation)!,
                segments: self.segmentsForJourney(segmentListEl))
            
            self.connections.append(connection)
        })
        return connections
    }
    
    func coordinatesForStation(station: ONOXMLElement) -> CLLocationCoordinate2D? {
        println(__FUNCTION__)
        var lat: Double, long: Double
        
        func numberForAttribute(attr: String, inElement element: ONOXMLElement) -> Double {
            return Double((element[attr] as String).toInt()!) / kBTCoordinateDegreeDivisor
        }
        
        if station.tag != "Station" {
            
            let realStation = station.firstChildWithXPath(".//Station")
            lat = numberForAttribute("y", inElement: realStation)
            long = numberForAttribute("x", inElement: realStation)
        } else {
            lat = numberForAttribute("y", inElement: station)
            long = numberForAttribute("x", inElement: station)
        }
        
        return CLLocationCoordinate2DMake(lat, long)
    }
    
    func pointFromElement(element: ONOXMLElement) -> BTPoint? {
        println(__FUNCTION__)
        var point: BTPoint?
        let displayName: String = element.attributes["name"] as String
        
        if let coordinate = self.coordinatesForStation(element) {
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
                    externalId: element["externalId"] as String,
                    externalStationNr: element["externalStationNr"] as String,
                    services: nil)
            default: ()
            println("Element with tag \(element.tag) is not a recognized point")
            }
            return point
            
        } else {
            println("BTConResParser.pointFromElement isn't producing an element")
            return nil
        }
    }
    
    func timeIntervalForElement(element: ONOXMLElement) -> NSTimeInterval {
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
    
    func dateTimeFromElement(element: ONOXMLElement?) -> NSDate? {
        if let str = element?.stringValue() {
            let year    = str.substringWithRange(Range<String.Index>(start: str.startIndex, end: advance(str.startIndex, 4))).toInt()!
            let month   = str.substringWithRange(Range<String.Index>(start: advance(str.startIndex ,4), end: advance(str.startIndex, 6))).toInt()!
            let day     = str.substringWithRange(Range<String.Index>(start: advance(str.startIndex ,6), end: str.endIndex)).toInt()!
            
            let dc = NSDateComponents()
            dc.day = day
            dc.month = month
            dc.year = year
            
            let cal = NSCalendar(identifier: "gregorian")!
            return cal.dateFromComponents(dc)
        } else {
            return nil
        }
    }
    
    func dateTimeFromElement(element: ONOXMLElement, baseDate: NSDate) -> NSDate {
        let interval = self.timeIntervalForElement(element)
        return baseDate.dateByAddingTimeInterval(interval)
    }
    
    func timeIntervalBetween(earlierDate: ONOXMLElement, _ laterDate: ONOXMLElement) -> NSTimeInterval {
        println(__FUNCTION__)
        let earlierDiff = self.timeIntervalForElement(earlierDate)
        let laterDiff = self.timeIntervalForElement(laterDate)
        return laterDiff - earlierDiff
    }
    
    func serviceDescriptionFromElement(element: ONOXMLElement) -> BTServiceDescription {
        println(__FUNCTION__)
        let terminus = element.firstChildWithXPath(".//Attribute[@type=\"DIRECTION\"]/AttributeVariant[@type=\"NORMAL\"]//Text").stringValue()
        let serviceType = element.firstChildWithXPath(".//Attribute[@type=\"CATEGORY\"]/AttributeVariant[@type=\"NORMAL\"]//Text").stringValue()
        let serviceName = element.firstChildWithXPath(".//Attribute[@type=\"NUMBER\"]/AttributeVariant[@type=\"NORMAL\"]/Text").stringValue()
        return BTServiceDescription(serviceId: (.Bus, name: serviceName), serviceTerminus: terminus)
    }
    
    func segmentsForJourney(el: ONOXMLElement?) -> [BTConnectionSegment]? {
        println(__FUNCTION__)
        var segments: [BTConnectionSegment] = []
        
        if let journey = el {
            journey.enumerateElementsWithXPath(".//ConSection") { (element, idx, stop) -> Void in
                var segment: BTConnectionSegment?
                
                let arrivalEl = element.firstChildWithTag("Arrival")
                let departureEl = element.firstChildWithTag("Departure")
                let segmentTypeEl = element.firstChildWithXPath("Journey|Walk|Transfer|GisRoute")
                
                let startTime = departureEl.firstChildWithXPath(".//Time")
                let endTime = arrivalEl.firstChildWithXPath(".//Time")
                let duration = self.timeIntervalBetween(startTime, endTime)
                
                
                switch segmentTypeEl.tag {
                case "Journey":
                    println("Journey")
                    segment = BTJourney(start: self.pointFromElement(departureEl.firstChildWithXPath(".//Station"))!,
                        end: self.pointFromElement(arrivalEl.firstChildWithXPath(".//Station"))!,
                        duration: duration,
                        line: self.serviceDescriptionFromElement(element.firstChildWithTag("Journey")))
                    
                    
                case "Walk":
                    println("Walk")
                    segment = BTWalk(start: self.pointFromElement(departureEl)!,
                        end: self.pointFromElement(arrivalEl)!,
                        duration: duration,
                        distance: 200)
                    
                    
                case "Transfer":
                    println("Transfer")
                    segment = BTTransfer(start: self.pointFromElement(departureEl)!,
                        end: self.pointFromElement(arrivalEl)!,
                        duration: duration)
                    
                    
                case "GisRoute":
                    println("GisRoute")
                    segment = BTGisRoute(start: self.pointFromElement(departureEl.firstChildWithXPath(".//Station"))!,
                        end: self.pointFromElement(arrivalEl.firstChildWithXPath(".//Station"))!,
                        duration: duration,
                        trafficType: BTGisRoute.IndividualTrafficType.Car)
                    
                    
                default:
                    segment = nil
                    let exception = NSException(name: "BTNoValidSegmentTypeFoundInConnection", reason: nil, userInfo: nil)
                    exception.raise()
                }
                segments.append(segment!)
            }
            return segments

            
        } else {
            return nil
        }
    }
}