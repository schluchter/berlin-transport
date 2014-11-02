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
public let kBTHafasServerURL: String = "http://demo.hafas.de/bin/pub/vbb/extxml.exe"

// Date and Time-related constants
public let kBTHoursPerDay = 24
public let kBTMinutesPerHour = 60
public let kBTSecondsPerMinute = 60

public let kBTSecondsPerHour = kBTMinutesPerHour * kBTSecondsPerMinute
public let kBTSecondsPerDay = kBTHoursPerDay * kBTMinutesPerHour * kBTSecondsPerMinute

// Color constants
public let kBTPrimaryBgColor = UIColor(hue: 190, saturation: 30, brightness: 22, alpha: 100)