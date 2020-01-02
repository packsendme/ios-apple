//
//  MainViewController.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 14/10/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var logopacksendView: UIView!
    @IBOutlet weak var maintitleLabel: UILabel!

    @IBOutlet weak var countryImage: UIImageView!
    @IBOutlet weak var countrycodeLabel: UILabel!
    @IBOutlet weak var accesscountryBtn: UIButton!

    var codeCountry: String = ""
    var countries: [CountryBO] = []
    var countriesData: [CountryBO] = []
    var countryService = CountryService()
    

    @IBOutlet weak var locationView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        maintitleLabel.text = NSLocalizedString("main-title-welcome", comment:"")
        accesscountryBtn.setTitle(NSLocalizedString("main-title-mobile", comment:""), for: .normal)
        
        self.countryImage.image = UIImage(named: "icon-contry-default")
        self.countrycodeLabel.text = "+00"
        
        /*
        countries = countryHelperOb.createCountries()
        codeCountry = countryHelperOb.getCountryCallingCode()
        print("country code is \(codeCountry)")
        
        let countryCurrentObj: CountryModel = countryHelperOb.findCountryCurrent(codeCountry: codeCountry, countriesFull: countries)
        let currentLocale: NSLocale = NSLocale.current as NSLocale
        let countryRegionCode = currentLocale.object(forKey: NSLocale.Key.countryCode) as! String
         */
        let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String
        getCountryDetails(codCountry : countryCode!)
    }
    

 
    func getCountryDetails(codCountry : String){
        countryService.findDetailCountryByID(idcountry: codCountry){(success, response, error) in
            if success{
                let country = response as! CountryBO
                print("country code is \(country.name!)")
                print("country code is \(country.sigla!)")

                GlobalVariables.sharedManager.countryNameInstance = country.name!
                GlobalVariables.sharedManager.countryImageInstance = country.countryImage!
                GlobalVariables.sharedManager.countryCodInstance = country.cod!
                GlobalVariables.sharedManager.countryFormatInstance = country.format!
                GlobalVariables.sharedManager.countrySingla = country.sigla!
                
                self.countryImage.image = GlobalVariables.sharedManager.countryImageInstance
                self.countrycodeLabel.text = GlobalVariables.sharedManager.countryCodInstance
                
                UIView.transition(with: self.countryImage,
                                  duration:0.5,
                                  options: .transitionCrossDissolve,
                                  animations: { self.countryImage.image = GlobalVariables.sharedManager.countryImageInstance },
                                  completion: nil)
            }
            else if error != nil{
                DispatchQueue.main.async {
                    let ac = UIAlertController(title: NSLocalizedString("error-title-failconnection", comment:""), message: NSLocalizedString("error-body-failconnection", comment:""), preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated:  true)
                }
            }
        }
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?)
        -> TimeInterval {
            return 0.3
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "IAUSettingUsername") {
            let loginVC = segue.destination as! IAUSettingViewController
            loginVC.metadadosView = segue.identifier!
        }
    }
  
    @IBAction func nextPhoneNumberAction(_ sender: Any) {
        self.performSegue(withIdentifier:"IAUSettingUsername", sender: nil)
    }

 }
