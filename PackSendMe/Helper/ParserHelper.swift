//
//  ParserHelper.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 13/06/2019.
//  Copyright © 2019 Ricardo Marzochi. All rights reserved.
//

import Foundation
import UIKit

class ParserHelper : NSObject{
    
    func addressParser(addressParser : String) -> [String] {
        var delimiter = ","
        var token = addressParser.components(separatedBy: delimiter)
        print("A", token[0])
        print("B", token[1])
        print("C", token[2])
        return token
    }
    
}
