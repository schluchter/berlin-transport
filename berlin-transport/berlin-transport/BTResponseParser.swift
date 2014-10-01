//
//  BTResponseParser.swift
//  berlin-transport
//
//  Created by Thomas Schluchter on 9/30/14.
//  Copyright (c) 2014 Thomas Schluchter. All rights reserved.
//

import Foundation

class BTResponseParser {
    var hafasRes: ONOXMLDocument
    
    init() {
        var parserError = NSError(domain: "XML couldn't be parsed", code: 1, userInfo: nil)
        var onoError = NSError(domain: "ONO error", code: 2, userInfo: nil)
        
        let xmlPath = NSBundle.mainBundle().URLForResource("VBB-STD-LUAX-CONRes", withExtension: "xml")
        let xmlData = NSData(contentsOfURL: xmlPath!, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: nil)
        
        self.hafasRes = ONOXMLDocument(data: xmlData, error: nil)
    }
}
