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
    
    func setPlaceholder(nameholder : String) -> NSMutableAttributedString{
        var placeHolder = NSMutableAttributedString()
        // Set the Font
        placeHolder = NSMutableAttributedString(string:nameholder, attributes: [NSFontAttributeName:UIFont(name: "Helvetica", size: 20.0)!])
        // Set the color
        placeHolder.addAttribute(NSForegroundColorAttributeName, value: UIColor.gray, range:NSRange(location:0,length:nameholder.characters.count))
        
        return placeHolder
    }
    
    func getFormattedDate(strDate: String , currentFomat:String, expectedFromat: String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = currentFomat
        
        let date : Date = dateFormatterGet.date(from: strDate)!
        
        dateFormatterGet.dateFormat = expectedFromat
        return dateFormatterGet.string(from: date)
    }
    
    
    
}
