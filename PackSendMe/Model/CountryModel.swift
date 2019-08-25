//
//  CountryModel.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 10/10/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import UIKit

class CountryModel : NSObject {
    
    @objc var name: String!
    var countryImage: UIImage!
    @objc var cod: String!
    @objc var format: String!
    
    
    override init() {
    }

    init(countryImage:UIImage, name:String, cod:String, format:String) {
        self.countryImage = countryImage
        self.name = name
        self.cod = cod
        self.format = format
    }

}
