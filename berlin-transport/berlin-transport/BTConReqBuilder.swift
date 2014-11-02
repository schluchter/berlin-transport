//
//  BTConReqBuilder.swift
//  berlin-transport
//
//  Created by Thomas Schluchter on 11/1/14.
//  Copyright (c) 2014 Thomas Schluchter. All rights reserved.
//

import Foundation

public class BTConReqBuilder {
    class func requestDataFromDate(date: NSDate) -> (String, String) {
        
        let dayFormat = NSDateFormatter.dateFormatFromTemplate("yMd", options: 0, locale: nil)
        let timeFormate = NSDateFormatter.dateFormatFromTemplate("HH:mm", options: 0, locale: nil)
        let formatter = NSDateFormatter()
        formatter.calendar = NSCalendar.currentCalendar()

        formatter.dateFormat = dayFormat
        let day: String = formatter.stringFromDate(date)
        
        formatter.dateFormat = timeFormate
        let time: String = formatter.stringFromDate(date)
        
        return(day, time)
    }
}