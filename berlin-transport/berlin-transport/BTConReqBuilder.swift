//
//  BTConReqBuilder.swift
//  berlin-transport
//
//  Created by Thomas Schluchter on 11/1/14.
//  Copyright (c) 2014 Thomas Schluchter. All rights reserved.
//

import Foundation
import CoreLocation

public struct BTConReq {
    let date: NSDate
    let start: (coordinate: CLLocationCoordinate2D, title: String)
    let end:  (coordinate: CLLocationCoordinate2D, title: String)
}

public class BTRequestBuilder {
    class var apiKey: String? {
        if let path = NSBundle.mainBundle().pathForResource("Keys", ofType: "plist") {
            let keys = NSDictionary(contentsOfFile: path)!
            return keys.valueForKey("VBBTestSystemAccessID") as? String
        }
        return nil
    }
    
    public class func conReq(request: BTConReq) -> String {
        let dayTime = requestDataFromDate(request.date)

        let startX = request.start.coordinate.longitude.toWGS()
        let startY = request.start.coordinate.latitude.toWGS()
        let startTitle = request.start.title

        let endX = request.end.coordinate.longitude.toWGS()
        let endY = request.end.coordinate.latitude.toWGS()
        let endTitle = request.end.title
        
        // TODO: Figure out how to get the date in there
        var req = "<?xml version=\"1.0\" encoding=\"iso-8859-1\"?><ReqC accessId=\"\(apiKey!)\" ver=\"1.1\" requestId=\"\" prod=\"net.schluchter.berlin-transport\" lang=\"DE\"><ConReq><ReqT date=\"\(dayTime.day)\" time=\"\(dayTime.time)\"></ReqT><RFlags b=\"0\" f=\"1\"></RFlags><Start><Coord name=\"\(startTitle)\" x=\"\(startX)\" y=\"\(startY)\" type=\"WGS84\"/><Prod  prod=\"1111000000000000\" direct=\"0\" sleeper=\"0\" couchette=\"0\" bike=\"0\"/></Start><Dest><Coord name=\"\(endTitle)\" x=\"\(endX)\" y=\"\(endY)\" type=\"WGS84\"/></Dest></ConReq></ReqC>"
        println(req)
        return req
    }
        
    public class func requestDataFromDate(date: NSDate) -> (day: String, time: String) {
        let dayFormat = "yyyyMMdd"
        let timeFormat = "HH':'mm':'ss"
        let formatter = NSDateFormatter()
        formatter.calendar = NSCalendar.currentCalendar()

        formatter.dateFormat = dayFormat
        let day: String = formatter.stringFromDate(date)
        
        formatter.dateFormat = timeFormat
        let time: String = formatter.stringFromDate(date)
        
        return(day, time)
    }
}