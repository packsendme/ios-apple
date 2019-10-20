//
//  CountryViewController.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 27/09/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import UIKit
import CoreData


class IACSettingViewController: UIViewController{

    var countryService = CountryService()
    var countries: [CountryBO] = []
    var countriesData: [CountryBO] = []
    var optionViewController: String = ""

    @IBOutlet weak var countrycurrent: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var countriesTableView: UITableView!
    @IBOutlet weak var countryselectImage: UIImageView!
    @IBOutlet weak var countryselectLabel: UILabel!
    @IBOutlet weak var countrytitleLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countriesTableView.delegate = self
        countriesTableView.dataSource = self
        searchBar.delegate = self

        getCountryAll()
        countrytitleLabel.text = NSLocalizedString("country-label-title", comment:"")
        searchBar.placeholder = NSLocalizedString("country-label-searchcountry", comment:"")

        // Current Location (title + countryLabel + image)
        countrycurrent.text = NSLocalizedString("country-label-currentcountry", comment:"")
        countryselectLabel.text = GlobalVariables.sharedManager.countryNameInstance
        countryselectImage.image = GlobalVariables.sharedManager.countryImageInstance
    }
    
    
    func getCountryAll(){
        countryService.findCountryAll(){(success, response, error) in
            if success{
                DispatchQueue.main.async {
                    self.countriesData = response as! [CountryBO]
                    self.countries = self.countriesData
                    
                    UIView.transition(with: self.countriesTableView,
                                      duration:0.5,
                                      options: .transitionCrossDissolve,
                                      animations: { self.countriesTableView.reloadData() },
                                      completion: nil)
                    
                }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is IAUSettingViewController
        {
            let iauParameter = segue.destination as? IAUSettingViewController
            iauParameter!.metadadosView = segue.identifier!
        }
     }
    
    @IBAction func closeView(_ sender: Any) {
        self.performSegue(withIdentifier:"IAUSettingUsername", sender: nil)
    }
    
}

extension IACSettingViewController: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countriesData.count
   }

   func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return countriesData.count
   }
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       //var country = countriesData[indexPath.section][indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier:"CountryCell") as? CountryViewCell
            else{
                return UITableViewCell()
        }
        let country = countriesData[indexPath.row]
        cell.namecountryLabel.text = country.name
        cell.countryImageView.image = country.countryImage
        return cell
   }

    // Search Bar
   func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        guard !searchText.isEmpty else{
            countriesData = countries
            self.countriesTableView.reloadData()
            return
        }
        countriesData = countries.filter({(country : CountryBO ) -> Bool in
            return country.name!.lowercased().contains(searchText.lowercased())
            })
        self.countriesTableView.reloadData()
   }
    
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CountryViewCell
        let countrySelect = countriesData[indexPath.row]
        countryselectLabel.text = cell.namecountryLabel.text
        countryselectImage.image =  cell.countryImageView.image
        GlobalVariables.sharedManager.countryNameInstance = countrySelect.name!
        GlobalVariables.sharedManager.countryImageInstance = countrySelect.countryImage!
        GlobalVariables.sharedManager.countryCodInstance = countrySelect.cod!
        GlobalVariables.sharedManager.countryFormatInstance = countrySelect.format!
   }
    
}
