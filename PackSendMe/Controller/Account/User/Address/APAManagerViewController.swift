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
import GoogleMaps


class APAManagerViewController: UIViewController {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var amService = AccountService()
    var addressObject = AddressBO()


    var fetcher: GMSAutocompleteFetcher?
    var filtered1 = [String]()
    var boxActivityView = UIView()
    var activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    var typeAddress : String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        let nsBoundsCorner = CLLocationCoordinate2D(latitude: 20.5937, longitude: 78.9629)
        let bounds = GMSCoordinateBounds(coordinate: nsBoundsCorner, coordinate: nsBoundsCorner)
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        fetcher  = GMSAutocompleteFetcher(bounds: bounds, filter: filter)
        fetcher?.delegate = self
        addressLabel.text = NSLocalizedString("address-label-title", comment:"")
    }
    
    func activityActionStart(title : String) {
        // You only need to adjust this frame to move it anywhere you want
        boxActivityView = UIView(frame: CGRect(x: view.frame.midX - 40, y: view.frame.midY - 70, width:50, height: 50))
        boxActivityView.backgroundColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0)
        //UIColor.lightGray
        boxActivityView.alpha = 0.9
        boxActivityView.layer.cornerRadius = 10
        //Here the spinnier is initialized
        activityView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityView.color = UIColor.black
        activityView.startAnimating()
        let textLabel = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
        textLabel.textColor = UIColor.black
        textLabel.text = ""
        boxActivityView.addSubview(activityView)
        boxActivityView.addSubview(textLabel)
        view.addSubview(boxActivityView)
    }
    
    func activityActionStop() {
        //When button is pressed it removes the boxView from screen
        self.boxActivityView.removeFromSuperview()
        self.activityView.stopAnimating()
    }

    @IBAction func returnAction(_ sender: Any) {
        self.performSegue(withIdentifier:"APSearchViewController", sender: nil)
    }
    
    
    //========================= HTTP ====================================================================================//
    
    
    // -------------------------------------------------------------------------------------
    // FUNCTION : UPDATE
    // MICROSERVICE : ACCOUNT
    // ENTITY :  ProfileBO
    // -------------------------------------------------------------------------------------
    func updateAddressAccount(addressDescription:String) {
        activityActionStart(title : NSLocalizedString("a-action-lbl-update", comment:""))
        amService.updateProfileAddress(username:GlobalVariables.sharedManager.usernameNumberphone, location: addressDescription,typeAddress:typeAddress!, priorityAddress: addressObject.addressMain){(success, response, error) in
            if success == true{
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier:"APSearchViewController", sender: nil)
                }
            }
            else{
                self.activityActionStop()
                DispatchQueue.main.async() {
                    let ac = UIAlertController(title: NSLocalizedString("error-title-failconnection", comment:""), message: NSLocalizedString("error-msg-failconnection", comment:""), preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated:  true)
                }
            }
        }
    }
}


extension APAManagerViewController:
UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, GMSAutocompleteFetcherDelegate{
    
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        filtered1.removeAll()
        for prediction in predictions {
            filtered1.append(prediction.attributedFullText.string)
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

