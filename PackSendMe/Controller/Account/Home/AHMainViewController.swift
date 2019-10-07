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


class AHMainViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var homeToolBtn: UIBarButtonItem!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var menuView: UIView!
    //@IBOutlet weak var mapView: GMSMapView!
    let locationManager:CLLocationManager = CLLocationManager()
    //var menuBtn : UIButton = UIButton()
 
    var menu_vc : AHMenuViewController!
    var amService = AccountService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        UIView.transition(with: self.view,
                          duration:0.1,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.loadNamesAccount()},
                          completion: nil)
       
        
        print(" NAME \(GlobalVariables.sharedManager.nameLastMenu) ")
        print(" NAME \(GlobalVariables.sharedManager.nameFirstMenu)")
        GlobalVariables.sharedManager.profileImage = "imageProfile_"+GlobalVariables.sharedManager.usernameNumberphone
        homeToolBtn.isEnabled = false
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
       // self.mapView.addSubview(button)
   
        /*menuBtn.setTitle("Button", for: .normal)
        menuBtn.setTitleColor(.red, for: .normal)
        menuBtn.addTarget(self, action: #selector(menuActionView), for: .touchUpInside)
        self.view.addSubview(menuBtn)*/
        
        mapView.reloadInputViews()
        menu_vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! AHMenuViewController
        present(menu_vc!, animated: true)

    }

    func loadNamesAccount() {
        amService.getLoadNamesAccount(){(success, response, error) in
            if success == true{
                DispatchQueue.main.async {
                    let profileObj = response as! ProfileBO
                    GlobalVariables.sharedManager.nameFirstMenu  = profileObj.name!
                    GlobalVariables.sharedManager.nameLastMenu = profileObj.lastName!
                }
            }
            else if success == false{
                DispatchQueue.main.async {
                    let ac = UIAlertController(title: NSLocalizedString("error-title-failconnection", comment:""), message: NSLocalizedString("error-body-failconnection", comment:""), preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated:  true)
                    
                }
            }
        }
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        mapView.settings.myLocationButton = true
        let locationObj = locationManager.location
        
        let lattitude = locationObj!.coordinate.latitude
        let longitude = locationObj!.coordinate.longitude

         
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
        transition.duration = 0.25
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromTop
        
       // present(menu_vc!, animated: true)
        show(menu_vc, sender: true)

       //self.performSegue(withIdentifier:"AHMenuViewController", sender: nil)

       /* let storyboard = UIStoryboard(name: "ACCOUNT", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MenuViewController")
        self.present(controller, animated: false, completion: nil)*/
    }
    

    @IBAction func actionMenu(_ sender: Any) {
        showMenu()
    }
    
    @IBAction func unwindToOne(_ sender: UIStoryboardSegue) {
        
    
    }
    
    
}


    

