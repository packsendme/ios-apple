//
//  EditAddressUserViewController.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 16/12/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData
import GooglePlaces
//import GooglePlacesAutocomplete
import GoogleMaps


class SettingAddressUserViewController: UIViewController {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    var fetcher: GMSAutocompleteFetcher?
    var searchActive : Bool = false
    var filtered1 = [String]()
  
  //  var accountModel : AccountModel? = nil
    var addressUserArray : [String:Any]? = nil
    var addressChangeModel = AddressModel()
    var typeAddressChange : String? = nil
    
    var searchResults: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // locationTable.delegate = self
      //  locationTable.dataSource = self
        searchBar.delegate = self
        let nsBoundsCorner = CLLocationCoordinate2D(latitude: 20.5937, longitude: 78.9629)
        let bounds = GMSCoordinateBounds(coordinate: nsBoundsCorner, coordinate: nsBoundsCorner)

        let filter = GMSAutocompleteFilter()
        filter.type = .address
        fetcher  = GMSAutocompleteFetcher(bounds: bounds, filter: filter)
        fetcher?.delegate = self
        addressLabel.text = NSLocalizedString("address-label-title", comment:"")
    }
    
    
    func updateAddressAccount(addressDescription:String) {
        let accountHelper = AccountHelper()
        let utilityHelper = UtilityHelper()
        let dateUpdate = utilityHelper.dateConvertToString()
        
        var paramsDictionary = [String:Any]()
        
        paramsDictionary = accountHelper.addressObjectToArray(username:(GlobalVariables.sharedManager.username), address:(addressDescription), type:(typeAddressChange)!, main:(GlobalVariables.sharedManager.addressMain), dateUpdate: (dateUpdate))
        
        let account = URLConstants.ACCOUNT.account_http+"/address"
        
        HttpClientApi.instance().makeAPIBodyCall(url: account, params:paramsDictionary, method: .PUT, success: { (data, response, error) in
            
            if response?.statusCode == URLConstants.HTTP_STATUS_CODE.OK{
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier:"SettingAddressUserViewToSettingDataAccountView", sender: nil)
                }
            }
        }, failure: { (data, response, error) in
            DispatchQueue.main.async {
                let ac = UIAlertController(title: NSLocalizedString(NSLocalizedString("error-title-failconnection", comment:""), comment:""), message: NSLocalizedString("error-msg-failconnection", comment:""), preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(ac, animated:  true)
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let setupPhotoProfile = segue.destination as? SettingDataViewController
       // setupPhotoProfile?.accountModel = accountModel!
    }
    
}


extension SettingAddressUserViewController:
UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, GMSAutocompleteFetcherDelegate{
    
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        filtered1.removeAll()
        for prediction in predictions {
            filtered1.append(prediction.attributedFullText.string)
         //   print(" FullText : \n",prediction.attributedFullText.string)
         //   print(" PrimaryText :  \n",prediction.attributedPrimaryText.string)
        //    print(" PLACE : \n",prediction.placeID)
        //    print("\n********")
        }
        tableView.reloadData()
    }
    
    func didFailAutocompleteWithError(_ error: Error) {
         print(error.localizedDescription)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:"Cell")
            else{
                return UITableViewCell()
        }
        if (filtered1.count >= 1){
            cell.textLabel?.text =  filtered1[indexPath.row];
        }
        
	   return cell;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        fetcher?.sourceTextHasChanged(searchText)
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return filtered1.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //getting the index path of selected row
        let indexPath = tableView.indexPathForSelectedRow
        //getting the current cell from the index path
        let currentCell = tableView.cellForRow(at: indexPath!)! as UITableViewCell
        let currentItem = currentCell.textLabel!.text

        updateAddressAccount(addressDescription: currentItem!)
    }

}

