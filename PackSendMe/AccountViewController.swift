//
//  AccountViewController.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 14/11/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps


class AccountViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    //@IBOutlet weak var mapView: GMSMapView!
    let locationManager:CLLocationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        mapView.settings.myLocationButton = true
        let locationObj = locationManager.location
        
        let lattitude = locationObj!.coordinate.latitude
        let longitude = locationObj!.coordinate.longitude
        print(" lat in  updating \(lattitude) ")
        print(" long in  updating \(longitude)")
         
        let center = CLLocationCoordinate2D(latitude: locationObj!.coordinate.latitude, longitude: locationObj!.coordinate.longitude)
        let marker = GMSMarker()
        marker.position = center
        marker.title = "current location"
        marker.map = mapView
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: lattitude, longitude: longitude, zoom: 18.0)
        self.mapView.animate(to: camera)
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        mapView.settings.zoomGestures = true

    }
    
    
    @IBAction func menuAction(_ sender: Any) {
        
    }
    
    func showMenu(){
        
    }
    
    func closeMenu(){
        
    }
    
}


    


