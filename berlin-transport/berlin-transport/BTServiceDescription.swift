//
//  BTServiceDescription.swift
//  berlin-transport
//
//  Created by Thomas Schluchter on 10/1/14.
//  Copyright (c) 2014 Thomas Schluchter. All rights reserved.
//

import Foundation

public struct BTServiceDescription {
    public let serviceId: (serviceType: ServiceType, name: String)
    public let serviceTerminus: String?
    
    public enum ServiceType {
        case Bus
        case MetroBus
        case ExpressBus
        case Tram
        case MetroTram
        case UBahn
        case SBahn
        case Unknown
    }
}