//
//  BTConstants.swift
//  berlin-transport
//
//  Created by Thomas Schluchter on 10/2/14.
//  Copyright (c) 2014 Thomas Schluchter. All rights reserved.
//

import Foundation
import UIKit

public let kBTCoordinateDegreeDivisor: Double = 1000000.0
//public let kBTHafasServerURL: String = "http://demo.hafas.de/bin/pub/vbb/extxml.exe"
public let kBTHafasServerURL: String = "http://demo.hafas.de/bin/pub/vbb/541/extxml.exe"

// Date and Time-related constants
public let kBTHoursPerDay = 24
public let kBTMinutesPerHour = 60
public let kBTSecondsPerMinute = 60

public let kBTSecondsPerHour = kBTMinutesPerHour * kBTSecondsPerMinute
public let kBTSecondsPerDay = kBTHoursPerDay * kBTMinutesPerHour * kBTSecondsPerMinute

// Color constants
public let kBTColorPrimaryBg = UIColor(rgba: "#546381")
public let kbTColorU1_15 =  UIColor(rgba: "#7DAD4C")
public let kBTColorU2 =     UIColor(rgba: "#DA421E")
public let kBTColorU3 =     UIColor(rgba: "#007A5B")
public let kBTColorU4 =     UIColor(rgba: "#F0D722")
public let kBTColorU5_55 =  UIColor(rgba: "#7E5330")
public let kBTColorU6 =     UIColor(rgba: "#8C6DAB")
public let kBTColorU7 =     UIColor(rgba: "#528DBA")
public let kBTColorU8 =     UIColor(rgba: "#224F86")
public let kBTColorU9 =     UIColor(rgba: "#F3791D")
public let kBTColorS1 =     UIColor(rgba: "#DE4DA4")
public let kBTColorS2_25 =  UIColor(rgba: "#005F27")
public let kBTColorS3 =     UIColor(rgba: "#0A4C99")
public let kBTColorS5 =     UIColor(rgba: "#FF5900")
public let kBTColorS7_75 =  UIColor(rgba: "#6F4E9C")
public let kBTColorS8_85 =  UIColor(rgba: "#55A822")
public let kBTColorS9 =     UIColor(rgba: "#8A0E30")
public let kBTColorS41 =    UIColor(rgba: "#A23B1E")
public let kBTColorS42 =    UIColor(rgba: "#C26A36")
public let kBTColorS45_47 = UIColor(rgba: "#C38737")

public let kBTColorIconUBahn =  UIColor(rgba: "#115D91")
public let kBTColorIconMetro =  UIColor(rgba: "#F3791D")
public let kBTColorIconBus =    UIColor(rgba: "#95276E")
public let kBTColorIconTram =   UIColor(rgba: "#BE1414")