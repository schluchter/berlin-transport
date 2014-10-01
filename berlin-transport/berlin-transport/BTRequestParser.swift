//
//  BTRequestParser.swift
//  berlin-transport
//
//  Created by Thomas Schluchter on 9/30/14.
//  Copyright (c) 2014 Thomas Schluchter. All rights reserved.
//

import Foundation

class BTRequestParser {
    init() {
        let xmlPath = NSBundle.mainBundle().URLForResource("VBB-STD-LUAX-CONRes", withExtension: "xml")
        let xmlData = NSData(contentsOfURL: xmlPath!, options: nil, error: nil)
        
        let err = NSError(domain: "XML couldn't be parsed", code: 1, userInfo: nil)
        
        if (xmlData != nil) {
            let hafasRes = ONOXMLDocument(data: xmlData, error: nil)
            hafasRes.rootElement.enumerateElementsWithXPath("//Connection", usingBlock: { (element, idx, done) -> Void in
                println("For tag \(element.tag)[\(idx)], the number of attributes is \(element.attributes.count)")
            })
        }
    }
}