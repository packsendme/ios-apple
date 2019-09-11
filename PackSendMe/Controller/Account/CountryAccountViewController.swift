//
//  CountryAccountViewController.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 28/01/2019.
//  Copyright © 2019 Ricardo Marzochi. All rights reserved.
//

import UIKit
import CoreData

class CountryAccountViewController: UIViewController{
    
    @IBOutlet weak var headView: UIView!
    var countries: [CountryVModel] = []
    var countryHelperOb = CountryHelper()
    var countriesData: [CountryVModel] = []
    var countryService = CountryService()
    var countryObj = CountryVModel()
    var cardpaySelect = PaymentAccountDto()
    
    // Type the Controller call (1) CardPaymentViewController  (2)ManagerUsernamePhoneViewController
    var operationTypeController: String = ""
    var refreshControl = UIRefreshControl()


    var accountModel : AccountDto? = nil
    var cardpayDto = PaymentAccountDto()
    var countryDto = CountryVModel()
    
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
        
        let title = NSLocalizedString("PullToRefresh", comment: "Load Counrty")
        refreshControl.backgroundColor = UIColor.lightGray
        refreshControl.tintColor = UIColor.red
        refreshControl.attributedTitle = NSAttributedString(string: title)
        refreshControl.addTarget(self,
                                 action: #selector(handleRefresh(sender:)),
                                 for: .valueChanged)
        
        //refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
        countriesTableView.refreshControl = refreshControl
        refreshControl.beginRefreshing()

        //Perform some task and update UI immediately.
        countryService.findCountryAll{(success, response, error) in
            if success{
                print("GET BLOCK")
                guard let countriesArray = response as? [CountryVModel] else { return }
                self.countries = countriesArray
                self.countriesData = self.countries
                //self.countriesTableView.reloadData()
                self.refreshTable()
                self.refreshControl.endRefreshing()
            }
            else if let error = error{
                print(error)
            }
        }
        
        if operationTypeController == GlobalVariables.sharedManager.OP_CHANGE_COUNTRY_CARDPAY{
            countrytitleLabel.text = NSLocalizedString("country-card-title", comment:"")
        }
        else if operationTypeController == GlobalVariables.sharedManager.OP_CHANGE_COUNTRY_NUMBER{
            countrytitleLabel.text = NSLocalizedString("country-number-title", comment:"")
        }
        
        searchBar.placeholder = NSLocalizedString("country-label-searchcountry", comment:"")
        countrycurrent.text = NSLocalizedString("country-label-currentcountry", comment:"")
        countryselectLabel.text = countryDto.name
        countryselectImage.image = countryDto.countryImage
     }
    
    
    @objc func handleRefresh(sender: UIRefreshControl) {
         refreshControl.endRefreshing()
    }
    
    func refreshTable() {
       DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                self.countriesTableView.reloadSections([0], with: UITableViewRowAnimation.fade)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CardPaymentViewController"{
            let something = segue.destination as! CardPaymentViewController
            something.cardpaySelect = cardpayDto
            something.countryDto = self.countryDto
            something.cardpaySelect = self.cardpaySelect
        }
            // ManagerProfileUserViewController
        else if segue.identifier == "CountryAccountViewControllerGoManagerUsernamePhone"{
            let something = segue.destination as! ManagerUsernamePhoneViewController
            something.country = self.countryDto
        }
    }
    
    @IBAction func closeActionB(_ sender: Any) {
        if operationTypeController == GlobalVariables.sharedManager.OP_CHANGE_COUNTRY_CARDPAY{
            self.performSegue(withIdentifier: "CardPaymentViewController", sender: self)
        }
        else if operationTypeController == GlobalVariables.sharedManager.OP_CHANGE_COUNTRY_NUMBER{
            self.performSegue(withIdentifier: "CountryAccountViewControllerGoManagerUsernamePhone", sender: self)
        }
    }

}

extension CountryAccountViewController: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countriesData.count
    }
  
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return countriesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //var country = countriesData[indexPath.section][indexPath.row]
        print(" cellForRowAt ")

        
        guard let cell = tableView.dequeueReusableCell(withIdentifier:"CountryCell") as? CountryViewCell
            else{
                return UITableViewCell()
        }
        let country = countriesData[indexPath.row]
        print(" Country: \(country.name) ")
        cell.namecountryLabel.text =  country.name
        cell.countryImageView.image = country.countryImage
        //self.view.layoutIfNeeded()

        return cell
    }
    
    // Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        guard !searchText.isEmpty else{
            countriesData = countries
            self.countriesTableView.reloadData()
            return
        }
        print("TESTE:  \(searchText.prefix(1))")
        countriesData = countries.filter({(country : CountryVModel ) -> Bool in
            return country.name!.lowercased().contains(searchText.lowercased())
        })
        self.countriesTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CountryViewCell
        let countrySelect = countriesData[indexPath.row]
        
        countryDto = CountryVModel(countryImage: countrySelect.countryImage!, name: countrySelect.name!, cod: countrySelect.cod!, format: countrySelect.format!,sigla: countrySelect.sigla!)
        countryselectLabel.text = cell.namecountryLabel.text
        countryselectImage.image =  cell.countryImageView.image
        
        if operationTypeController == GlobalVariables.sharedManager.OP_CHANGE_COUNTRY_CARDPAY{
            self.performSegue(withIdentifier: "CardPaymentViewController", sender: self)
        }
        else if operationTypeController == GlobalVariables.sharedManager.OP_CHANGE_COUNTRY_NUMBER{
            self.performSegue(withIdentifier: "CountryAccountViewControllerGoManagerUsernamePhone", sender: self)
        }
    }
}
