//
//  CountryAccountViewController.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 28/01/2019.
//  Copyright © 2019 Ricardo Marzochi. All rights reserved.
//

import UIKit
import CoreData

class APCSearchViewController: UIViewController{
    
    @IBOutlet weak var headView: UIView!
    var countries: [CountryBO] = []
    var countriesData: [CountryBO] = []
    var countryService = CountryService()
    var countryObj = CountryBO()
    var cardpaySelect = PaymentAccountBO()
    
    // Type the Controller call (1) CardPaymentViewController  (2)ManagerUsernamePhoneViewController
    var operationTypeController: String = ""
    var refreshControl = UIRefreshControl()


    //var accountObj : AccountBO? = nil
    var cardpayDto = PaymentAccountBO()
    var countryDto = CountryBO()
    
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
        refreshControl.addTarget(self, action: #selector(handleRefresh(sender:)),for: .valueChanged)
        
        //refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
        countriesTableView.refreshControl = refreshControl
        refreshControl.beginRefreshing()

        //Perform some task and update UI immediately.
        countryService.findCountryAll{(success, response, error) in
            if success{
                print("GET BLOCK")
                guard let countriesArray = response as? [CountryBO] else { return }
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
        
        if operationTypeController == GAViewController.APPayCard.rawValue{
            countrytitleLabel.text = NSLocalizedString("country-card-title", comment:"")
        }
        else if operationTypeController == GAViewController.APPManagerUsername.rawValue{
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
        if segue.identifier == "APPayCardViewController"{
            let something = segue.destination as! APPayCardViewController
            something.cardpaySelect = cardpayDto
            something.countryDto = self.countryDto
            something.cardpaySelect = self.cardpaySelect
        }
            // ManagerProfileUserViewController
        else if segue.identifier == "APPManagerUsername"{
            let usernameManager = segue.destination as! APPManagerViewController
            usernameManager.metadadosView = GAConstants.username.rawValue
            usernameManager.countryObj = self.countryDto
        }
    }
    
    @IBAction func closeActionB(_ sender: Any) {
        if operationTypeController == GAViewController.APPManagerUsername.rawValue{
            self.performSegue(withIdentifier:"APPManagerUsername", sender: self)
        }
        else if operationTypeController == GAViewController.APPayCard.rawValue{
            self.performSegue(withIdentifier:"APPayCardViewController", sender: self)
        }
    }
}

extension APCSearchViewController: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countriesData.count
    }
  
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return countriesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:"CountryCell") as? CountryViewCell
            else{
                return UITableViewCell()
        }
        let country = countriesData[indexPath.row]
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
        countriesData = countries.filter({(country : CountryBO ) -> Bool in
            return country.name!.lowercased().contains(searchText.lowercased())
        })
        self.countriesTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CountryViewCell
        let countrySelect = countriesData[indexPath.row]
        
        countryDto = CountryBO(countryImage: countrySelect.countryImage!, name: countrySelect.name!, cod: countrySelect.cod!, format: countrySelect.format!,sigla: countrySelect.sigla!)
        countryselectLabel.text = cell.namecountryLabel.text
        countryselectImage.image =  cell.countryImageView.image
        
        if operationTypeController == GAViewController.APPayCard.rawValue{
            self.performSegue(withIdentifier: "APPayCardViewController", sender: self)
        }
        else if operationTypeController == GAViewController.APPManagerUsername.rawValue{
            self.performSegue(withIdentifier: "APPManagerUsername", sender: self)
        }
    }
}
