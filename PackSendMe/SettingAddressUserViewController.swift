//
//  EditAddressUserViewController.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 16/12/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import GoogleMaps
import GooglePlacesAutocomplete

class SettingAddressUserViewController: UIViewController {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressCurrentView: UIView!
    @IBOutlet weak var searchAddressBar: UISearchBar!
    @IBOutlet weak var newAddressTable: UITableView!

    @IBOutlet weak var addressCurrentLabel: UILabel!
    @IBOutlet weak var streetAddressLabel: UILabel!
    @IBOutlet weak var streetResponseLabel: UILabel!
    @IBOutlet weak var cityAddressLabel: UILabel!
    @IBOutlet weak var cityResponseLabel: UILabel!
    @IBOutlet weak var postalCodeLabel: UILabel!
    @IBOutlet weak var postalcodeResponseLabel: UILabel!
    
    let controller = GooglePlacesSearchController(delegate: self,
                                                  apiKey: GoogleMapsAPIServerKey,
                                                  placeType: .address
        // Optional: coordinate: CLLocationCoordinate2D(latitude: 55.751244, longitude: 37.618423),
        // Optional: radius: 10,
        // Optional: strictBounds: true,
        // Optional: searchBarPlaceholder: "Start typing..."
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        addressLabel.text = NSLocalizedString("address-label-title", comment:"")
        addressCurrentLabel.text = NSLocalizedString("addressCurrent-label-title", comment:"")
        streetAddressLabel.text = NSLocalizedString("streetAddress-label-title", comment:"")
        cityAddressLabel.text = NSLocalizedString("cityAddress-label-title", comment:"")
        postalCodeLabel.text = NSLocalizedString("postalcodeAddress-label-title", comment:"")
    
    }
    



}
