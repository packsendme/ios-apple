//
//  CountryViewCell.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 27/09/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import UIKit

class CountryViewCell: UITableViewCell {

  
    @IBOutlet weak var countryImageView: UIImageView!
    @IBOutlet weak var namecountryLabel: UILabel!
    var sigla: String!
    /*
    func setCountry(country: CountryBO){
        countryImageView.image = country.countryImage
        namecountryLabel.text = country.name
        sigla = country.sigla
    }*/
}
