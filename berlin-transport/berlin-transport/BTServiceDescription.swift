//
//  BTServiceDescription.swift
//  berlin-transport
//
//  Created by Thomas Schluchter on 10/1/14.
//  Copyright (c) 2014 Thomas Schluchter. All rights reserved.
//

import Foundation

enum ServiceType {
    case Bus
    case MetroBus
    case ExpressBus
    case Tram
    case MetroTram
    case UBahn
    case SBahn
}

struct BTServiceDescription {
    let serviceType: (serviceType: ServiceType, name: String)
    let serviceTerminus: String
}