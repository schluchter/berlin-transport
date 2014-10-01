//
//  BTRequestParser.swift
//  berlin-transport
//
//  Created by Thomas Schluchter on 9/30/14.
//  Copyright (c) 2014 Thomas Schluchter. All rights reserved.
//

import Foundation

class BTResponseParser {
    let xmlPath: NSURL?
    let xmlData: NSData?
    let parserError: NSError?
    let onoError: NSError?
    
    init() {
        parserError = NSError(domain: "XML couldn't be parsed", code: 1, userInfo: nil)
        onoError = NSError(domain: "ONO error", code: 2, userInfo: nil)
        
        xmlPath = NSBundle.mainBundle().URLForResource("VBB-STD-LUAX-CONRes", withExtension: "xml")
        xmlData = NSData(contentsOfURL: xmlPath!, options: nil, error: &parserError)
        
        
        if (xmlData != nil) {
            let hafasRes = ONOXMLDocument(data: xmlData, error: &onoError)
            hafasRes.rootElement.enumerateElementsWithXPath("//Connection", usingBlock: { (element, idx, done) -> Void in
                
            })
        }
    }
}