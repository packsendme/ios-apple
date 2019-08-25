//
//  CountryVModel.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 23/08/2019.
//  Copyright © 2019 Ricardo Marzochi. All rights reserved.
//

import UIKit

struct CountryVModel {

    var name: String?
    var countryImage: UIImage?
    var cod: String?
    var format: String?
    
    init() {

    }
    
    
    init(countryImage:UIImage, name:String, cod:String, format:String) {
        self.countryImage = countryImage
        self.name = name
        self.cod = cod
        self.format = format
    }
    
    func parseJsonToCountryModel(json : [String:  Any]) -> CountryVModel{
        let countryJson = json["body"] as! [String:Any]
        
        let countryS = countryJson["nameimagecountry"] as! String
        let countryImage = UIImage(named:countryS)
        
        let country = CountryVModel (countryImage: countryImage!, name: countryJson["namecountry"] as! String, cod: countryJson["codcountry"] as! String, format: countryJson["formatnumbercountry"] as! String)
        return country
    }
}

extension String {
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
}
