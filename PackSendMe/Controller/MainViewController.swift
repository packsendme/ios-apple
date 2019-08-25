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
    
    var countryResult = CountryVModel()
    var countryObj = CountryService()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        maintitleLabel.text = NSLocalizedString("main-title-welcome", comment:"")
        mobiletitleBtn.setTitle(NSLocalizedString("main-title-mobile", comment:""), for: .normal)
        
        countries = countryHelperOb.createCountries()
        codeCountry = countryHelperOb.getCountryCallingCode()
      //  print("country code is \(codeCountry)")
        
        var countryCurrentObj: CountryModel = countryHelperOb.findCountryCurrent(codeCountry: codeCountry, countriesFull: countries)
        
        GlobalVariables.sharedManager.countryNameInstance = countryCurrentObj.name
        GlobalVariables.sharedManager.countryImageInstance = countryCurrentObj.countryImage
        GlobalVariables.sharedManager.countryCodInstance = countryCurrentObj.cod
        GlobalVariables.sharedManager.countryFormatInstance = countryCurrentObj.format
        
        countrycurrentImage.image = GlobalVariables.sharedManager.countryImageInstance
        codenumberLabel.text = GlobalVariables.sharedManager.countryCodInstance
        
        
        let currentLocale: NSLocale = NSLocale.current as NSLocale
        let countryRegionCode = currentLocale.object(forKey: NSLocale.Key.countryCode) as! String
        self.getCountryDetails(codCountry : countryRegionCode)
    }
    
    
    
    func getCountryDetails(codCountry : String){
            CountryService.instance().findCountryByIDCode(idcountry:codCountry, resultOperation: { (data, response, error) in
    
            if response?.statusCode == URLConstants.HTTP_STATUS_CODE.OK{
                let countrySelect = self.countryResult.parseJsonToCountryModel(json: data!)
                print("country countryRegionCode is \(countrySelect.name)")
            }
            else  if response?.statusCode == URLConstants.HTTP_STATUS_CODE.NOTFOUND{
                DispatchQueue.main.async {
                    let ac = UIAlertController(title: NSLocalizedString("error-title-failconnection", comment:""), message: NSLocalizedString("error-body-failconnection", comment:""), preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated:  true)
                }
            }
            else  if response?.statusCode == URLConstants.HTTP_STATUS_CODE.FAIL{
                DispatchQueue.main.async {
                    let ac = UIAlertController(title: NSLocalizedString("error-title-failconnection", comment:""), message: NSLocalizedString("error-body-failconnection", comment:""), preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated:  true)
                }
            }
        })
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?)
        -> TimeInterval {
            return 0.3
    }


}
