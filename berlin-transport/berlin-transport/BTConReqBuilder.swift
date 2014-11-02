//
//  BTConReqBuilder.swift
//  berlin-transport
//
//  Created by Thomas Schluchter on 11/1/14.
//  Copyright (c) 2014 Thomas Schluchter. All rights reserved.
//

import Foundation

public class BTConReqBuilder {
    
    public class func requestDataFromDate(date: NSDate) -> (String, String) {
        let dayFormat = "yyyyMMdd"
        let timeFormat = "HH':'mm"
        let formatter = NSDateFormatter()
        formatter.calendar = NSCalendar.currentCalendar()

        formatter.dateFormat = dayFormat
        let day: String = formatter.stringFromDate(date)
        
        formatter.dateFormat = timeFormat
        let time: String = formatter.stringFromDate(date)
        
        return(day, time)
    }
}