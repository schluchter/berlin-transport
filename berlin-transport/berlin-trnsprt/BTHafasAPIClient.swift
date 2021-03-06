//
//  BTHafasRequestHandler.swift
//  berlin-transport
//
//  Created by Thomas Schluchter on 11/5/14.
//  Copyright (c) 2014 Thomas Schluchter. All rights reserved.
//

import Foundation
import AFNetworking
import Ono
import AFOnoResponseSerializer

class BTHafasAPIClient {
    
    class func send(xml: String) {
        let bodyData = xml.dataUsingEncoding(NSISOLatin1StringEncoding, allowLossyConversion: false)!
        let req = NSMutableURLRequest(URL: NSURL(string: kBTHafasServerURL)!)
        req.HTTPMethod = "POST"
        req.setValue("application/xml", forHTTPHeaderField: "Content-Type")
        req.HTTPBody = bodyData
        
        let ops = AFHTTPRequestOperation(request: req)
        
        ops.responseSerializer = AFOnoResponseSerializer.XMLResponseSerializer()
        ops.setCompletionBlockWithSuccess({ (ops: AFHTTPRequestOperation!, res: AnyObject!) -> Void in
            if let connectionXML = res as? ONOXMLDocument {
                NSNotificationCenter.defaultCenter().postNotificationName("BTHafasAPIClientDidReceiveResponse", object: connectionXML)
            }
            },
            failure: { (ops: AFHTTPRequestOperation!, err: NSError!) -> Void in
                NSNotificationCenter.defaultCenter().postNotificationName("BTHafasAPIClientDidNotReceiveValidResponse", object: err)
        })
        ops.start()
    }
}