//
//  CountryVModel.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 23/08/2019.
//  Copyright © 2019 Ricardo Marzochi. All rights reserved.
//

import UIKit
import Foundation

public struct CountryBO {

    var name: String?
    var countryImage: UIImage?
    var cod: String?
    var format: String?
    var sigla: String?
    
    init() {

    }
    
    
    init(countryImage:UIImage, name:String, cod:String, format:String, sigla:String) {
        self.countryImage = countryImage
        self.name = name
        self.cod = cod
        self.format = format
        self.sigla = sigla
    }
    
    func getCountryFromJson(json : [String:  Any]) -> CountryBO{
        let countryJson = json["body"] as! [String:Any]
        let countryS = countryJson["nameimagecountry"] as! String
        let countryImage = UIImage(named:countryS)
        let country = CountryBO (countryImage: countryImage!, name: countryJson["namecountry"] as! String, cod: countryJson["codcountry"] as! String, format: countryJson["formatnumbercountry"] as! String,
            sigla: countryJson["idcountry"] as! String)
        return country
    }
    
    func getCountriesFromJson(countriesJson:[String:  Any]) -> [CountryBO]{
        var countries = [CountryBO]()
        let countryJson = countriesJson["body"] as! [String:Any]
        let countriesArray = countryJson["countries"] as? [[String:Any]]
        
        for country in countriesArray! {
            let countryS = country["nameimagecountry"] as! String
            let countryImg = UIImage(named:countryS)
            print(" IMAGE ES \(countryS)")
            
            let countryCurrent = CountryBO(
                countryImage: countryImg!,
                name: (country["namecountry"] as? String)!,
                cod: (country["codcountry"] as? String)!,
                format: (country["formatnumbercountry"] as? String)!,
                sigla: (country["idcountry"] as? String)!)
            countries.append(countryCurrent)
        }
        return countries
    }
}
