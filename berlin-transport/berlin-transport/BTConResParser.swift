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
    
    public init(fileURL url: NSURL?) {
        let error = NSErrorPointer()
        let xmlData = NSData(contentsOfURL: url!, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: nil)
        
        self.hafasRes = ONOXMLDocument(data: xmlData, error: error)
        
        // Configure date formatter
        self.hafasRes.dateFormatter.dateFormat = "yyyyMMdd"
        self.hafasRes.dateFormatter.calendar = NSCalendar.currentCalendar()
        self.hafasRes.dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
    }
    
    public convenience init(fileName name: String) {
        let fileURL = NSBundle.mainBundle().URLForResource(name, withExtension: "xml")
        self.init(fileURL: fileURL)
    }
    
    
    public func getConnections() -> [BTConnection] {
        self.hafasRes.enumerateElementsWithXPath("//Connection", usingBlock: { (element, idx, stop) -> Void in
            
            let overViewEl = element.firstChildWithTag("Overview")
            let segmentListEl = element.firstChildWithTag("ConSectionList")
            
            let connectionBaseDate = overViewEl.firstChildWithTag("Date").dateValue()
            let startDate = self.dateTimeFromElement(overViewEl.firstChildWithXPath(".//Departure//Time"), baseDate: connectionBaseDate)
            let endDate = self.dateTimeFromElement(overViewEl.firstChildWithXPath(".//Arrival//Time"), baseDate: connectionBaseDate)
            let travelTime = self.timeIntervalForElement(element.firstChildWithXPath(".//Duration/Time"))
            let transfers = element.firstChildWithXPath("//Transfers").numberValue().unsignedLongValue
            let departurePoint: ONOXMLElement = overViewEl.firstChildWithXPath(".//Departure")
            let arrivalPoint: ONOXMLElement = overViewEl.firstChildWithXPath(".//Arrival")
            
            let connection = BTConnection(startDate: startDate,
                endDate: endDate,
                travelTime: travelTime,
                numberOfTransfers: transfers,
                start: self.pointFromElement(departurePoint)!,
                end: self.pointFromElement(arrivalPoint)!,
                segments: self.segmentsForJourney(segmentListEl))
            
            self.connections.append(connection)
        })
        return connections
    }
    
    func coordinatesForPoint(var point: ONOXMLElement) -> CLLocationCoordinate2D? {
        println(__FUNCTION__)
        var lat: Double, long: Double
        
        func numberForAttribute(attr: String, inElement element: ONOXMLElement) -> CLLocationDegrees {
            return CLLocationDegrees((element[attr] as String).toInt()!) / kBTCoordinateDegreeDivisor
        }
        
        switch point.tag {
        case "Station", "Point", "Address":
            ()
            
        default:
            point = point.firstChildWithXPath("Station|Address|Poi|.//Station|.//Address|.//Poi")
        }
        
        lat = numberForAttribute("y", inElement: point)
        long = numberForAttribute("x", inElement: point)
        return CLLocationCoordinate2DMake(lat, long)
    }
    
    func pointFromElement(var element: ONOXMLElement) -> BTPoint? {
        println(__FUNCTION__)
        var point: BTPoint?
        element = element.firstChildWithXPath("Station|Address|Poi|.//Station|.//Address|.//Poi")
        let displayName = element["name"] as String
        
        if let coordinate = self.coordinatesForPoint(element) {
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
    
    func dateTimeFromElement(element: ONOXMLElement, baseDate: NSDate) -> NSDate {
        let interval = self.timeIntervalForElement(element)
        return baseDate.dateByAddingTimeInterval(interval)
    }
    
    func timeIntervalBetween(earlierDate: ONOXMLElement, _ laterDate: ONOXMLElement) -> NSTimeInterval {
        println(__FUNCTION__)
        let earlierDiff = self.timeIntervalForElement(earlierDate)
        let laterDiff = self.timeIntervalForElement(laterDate)
        return abs(laterDiff - earlierDiff)
    }
    
    func timeIntervalForElement(element: ONOXMLElement) -> NSTimeInterval {
        println(__FUNCTION__)
        let timeString = element.stringValue()
        var total = 0
        var components = timeString.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "d:"))
        
        let seconds: Int = (components.removeLast() as String).toInt()!
        let minutes: Int = (components.removeLast() as String).toInt()!
        let hours: Int = (components.removeLast() as String).toInt()!
        
        total = hours * kBTSecondsPerHour + minutes * kBTSecondsPerMinute + seconds
        
        if let days: Int = (components.removeLast() as String).toInt()? {
            total += days * kBTSecondsPerDay
        }
        return NSTimeInterval(total)
    }
    
    func serviceDescriptionFromElement(element: ONOXMLElement) -> BTServiceDescription {
        println(__FUNCTION__)
        let terminus = element.firstChildWithXPath(".//Attribute[@type=\"DIRECTION\"]/AttributeVariant[@type=\"NORMAL\"]//Text").stringValue()
        let serviceType = element.firstChildWithXPath(".//Attribute[@type=\"CATEGORY\"]/AttributeVariant[@type=\"NORMAL\"]//Text").stringValue()
        let serviceName = element.firstChildWithXPath(".//Attribute[@type=\"NUMBER\"]/AttributeVariant[@type=\"NORMAL\"]/Text").stringValue()
        return BTServiceDescription(serviceId: (self.serviceTypeFromCategoryDescriptor(serviceType), name: serviceName), serviceTerminus: terminus)
    }
    
    func trafficTypeFromGisRoute(gisRouteEl: ONOXMLElement) -> BTGisRoute.IndividualTrafficType {
        let type = gisRouteEl["type"] as String
        switch type {
        case "BIKE":
            return .Bike
        case "FOOT":
            return .Foot
        case "CAR":
            return .Car
        case "TAXI":
            return .Taxi
        default:
            return .Car
            
        }
    }
    
    func serviceTypeFromCategoryDescriptor(var desc: String) -> BTServiceDescription.ServiceType {
        desc = desc.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        switch desc {
        case "U-Bahn", "U":
            return .UBahn
        case "S-Bahn", "S":
            return .SBahn
        case "MetroTram", "M":
            return .MetroTram
        case "X", "ExpressBus":
            return .ExpressBus
        case "Bus":
            return .Bus
        case "MetroBus", "Metrobus", "M":
            return .MetroBus
        default:
            return .Unknown
        }
    }
    
    func distanceFromElement(element: ONOXMLElement) -> Meters? {
        if let distance = element.firstChildWithXPath(".//Distance").numberValue() as? Meters {
            return distance
        } else {
            return nil
        }
    }
    
    func passListFromElement(element: ONOXMLElement?) -> [BTStation]? {
        if element != nil {
            var passList: [BTStation] = []
            element!.enumerateElementsWithXPath(".//BasicStop", usingBlock: { (el, idx, stop) -> Void in
                let station = self.pointFromElement(el) as BTStation
                passList.append(station)
            })
            return passList
        } else {
            return nil
        }
    }
    
    func segmentsForJourney(el: ONOXMLElement?) -> [BTConnectionSegment]? {
        println(__FUNCTION__)
        var segments: [BTConnectionSegment] = []
        
        if let conSectionList = el {
            conSectionList.enumerateElementsWithXPath("ConSection") { (element, idx, stop) -> Void in
                var segment: BTConnectionSegment?
                
                let arrivalEl = element.firstChildWithTag("Arrival")
                let segmentTypeEl = element.firstChildWithXPath(".//Journey|.//Walk|.//Transfer|.//GisRoute")
                let departureEl = element.firstChildWithTag("Departure")
                
                let startTime = departureEl.firstChildWithXPath(".//Time")
                let endTime = arrivalEl.firstChildWithXPath(".//Time")
                let duration = self.timeIntervalBetween(startTime, endTime)
                
                switch segmentTypeEl.tag {
                case "Journey":
                    println("Journey")
                    let passList = segmentTypeEl.firstChildWithXPath(".//PassList")
                    segment = BTJourney(start: self.pointFromElement(departureEl)!,
                        end: self.pointFromElement(arrivalEl)!,
                        duration: duration,
                        line: self.serviceDescriptionFromElement(element.firstChildWithTag("Journey")),
                        passList: self.passListFromElement(passList))

                case "Walk":
                    println("Walk")
                    segment = BTWalk(start: self.pointFromElement(departureEl)!,
                        end: self.pointFromElement(arrivalEl)!,
                        duration: duration,
                        distance: self.distanceFromElement(segmentTypeEl))
                    
                case "Transfer":
                    println("Transfer")
                    segment = BTTransfer(start: self.pointFromElement(departureEl)!,
                        end: self.pointFromElement(arrivalEl)!,
                        duration: duration)
                    
                    
                case "GisRoute":
                    segment = BTGisRoute(start: self.pointFromElement(departureEl)!,
                        end: self.pointFromElement(arrivalEl)!,
                        duration: duration,
                        distance: nil,
                        trafficType: self.trafficTypeFromGisRoute(segmentTypeEl))
                    
                    
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