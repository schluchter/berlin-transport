//
//  BTHafasRequestHandler.swift
//  berlin-transport
//
//  Created by Thomas Schluchter on 11/5/14.
//  Copyright (c) 2014 Thomas Schluchter. All rights reserved.
//

import Foundation

var url = NSURL(string: kBTHafasServerURL)
var request = NSURLRequest(URL: url!)

let manager = AFHTTPRequestOperationManager()