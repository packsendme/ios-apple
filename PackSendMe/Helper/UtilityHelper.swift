//
//  UtilityHelper.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 09/11/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import UIKit

class UtilityHelper: NSObject {
    
    func dateConvertToString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        let stringDate: String = formatter.string(from: NSDate() as Date)
        print(stringDate)
        return stringDate
    }

}
