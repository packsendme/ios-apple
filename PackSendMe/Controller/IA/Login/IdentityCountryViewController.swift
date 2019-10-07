//
//  CountryViewController.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 27/09/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import UIKit
import CoreData


class IdentityCountryViewController: UIViewController{

    
    var countries: [CountryModel] = []
    var countryHelperOb = CountryHelper()
    var countriesData: [CountryModel] = []
    var optionViewController: String = ""

    @IBOutlet weak var countrycurrent: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var countriesTableView: UITableView!
    @IBOutlet weak var countryselectImage: UIImageView!
    @IBOutlet weak var countryselectLabel: UILabel!
    @IBOutlet weak var countrytitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countries = countryHelperOb.createCountries()
        countriesData = countries
        
        countriesTableView.delegate = self
        countriesTableView.dataSource = self
        searchBar.delegate = self
        
        countrytitleLabel.text = NSLocalizedString("country-label-title", comment:"")
        searchBar.placeholder = NSLocalizedString("country-label-searchcountry", comment:"")

        // Current Location (title + countryLabel + image)
        countrycurrent.text = NSLocalizedString("country-label-currentcountry", comment:"")
        countryselectLabel.text = GlobalVariables.sharedManager.countryNameInstance
        countryselectImage.image = GlobalVariables.sharedManager.countryImageInstance
    }
    
}

extension IdentityCountryViewController: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
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
        countriesData = countries.filter({(country : CountryModel ) -> Bool in
            return country.name.lowercased().contains(searchText.lowercased())
            })
        self.countriesTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CountryViewCell
        let countrySelect = countriesData[indexPath.row]
        countryselectLabel.text = cell.namecountryLabel.text
        countryselectImage.image =  cell.countryImageView.image
        GlobalVariables.sharedManager.countryNameInstance = countrySelect.name
        GlobalVariables.sharedManager.countryImageInstance = countrySelect.countryImage
        GlobalVariables.sharedManager.countryCodInstance = countrySelect.cod
        GlobalVariables.sharedManager.countryFormatInstance = countrySelect.format
    }
    
}
	
