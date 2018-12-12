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
    
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    var menu_vc : MenuViewController!
    
    @IBOutlet weak var menuView: UIView!
    //@IBOutlet weak var mapView: GMSMapView!
    let locationManager:CLLocationManager = CLLocationManager()
    //var menuBtn : UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
       // self.mapView.addSubview(button)
        menuBtn.setTitle("Button", for: .normal)
        menuBtn.setTitleColor(.red, for: .normal)
        menuBtn.addTarget(self, action: #selector(menuActionView), for: .touchUpInside)
        self.view.addSubview(menuBtn)
        
        mapView.reloadInputViews()
        
        menu_vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
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
    
    @IBAction func menuActionView(_ sender: UIButton) {
         showMenu()
    }
    
    func showMenu(){
        let transition:CATransition = CATransition()
        transition.duration = 0.7
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromTop
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        //view.window!.layer.add(transition, forKey: kCATransition)
        self.navigationController?.present(menu_vc, animated: true, completion: nil)
        //menu_vc.modalPresentationStyle = .overCurrentContext
        //present(menu_vc!, animated: true)
        
        
        //AppDelegate.menu_bool = false
    }
    

    @IBAction func actionMenu(_ sender: Any) {
        showMenu()
    }
    
    
}


    


