//
//  MainViewController.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 14/10/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    
    @IBOutlet weak var maintitleLabel: UILabel!
    @IBOutlet weak var mobiletitleBtn: UIButton!
    @IBOutlet weak var codenumberLabel: UILabel!

    @IBOutlet weak var countrycurrentImage: UIImageView!
    
    var countryHelperOb = CountryHelper()
    var countries: [CountryModel] = []
    var codeCountry: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        maintitleLabel.text = NSLocalizedString("main-title-welcome", comment:"")
        mobiletitleBtn.setTitle(NSLocalizedString("main-title-mobile", comment:""), for: .normal)
        
        countries = countryHelperOb.createCountries()
        codeCountry = countryHelperOb.getCountryCallingCode()
        print("country code is \(codeCountry)")
        
        var countryCurrentObj: CountryModel = countryHelperOb.findCountryCurrent(codeCountry: codeCountry, countriesFull: countries)
        
        GlobalVariables.sharedManager.countryNameInstance = countryCurrentObj.name
        GlobalVariables.sharedManager.countryImageInstance = countryCurrentObj.countryImage
        GlobalVariables.sharedManager.countryCodInstance = countryCurrentObj.cod
        GlobalVariables.sharedManager.countryFormatInstance = countryCurrentObj.format
        
        countrycurrentImage.image = GlobalVariables.sharedManager.countryImageInstance
        codenumberLabel.text = GlobalVariables.sharedManager.countryCodInstance
    }
    
        
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?)
        -> TimeInterval {
            return 0.3
    }


}
