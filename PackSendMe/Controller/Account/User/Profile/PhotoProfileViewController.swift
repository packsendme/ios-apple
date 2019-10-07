//
//  PhotoProfileViewController.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 20/12/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import UIKit
import AVFoundation

class PhotoProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var titleProfilePhotoLabel: UILabel!

    @IBOutlet weak var editBtn: UIBarButtonItem!
    @IBOutlet weak var profileimageImg: UIImageView!
    let imagePicker = UIImagePickerController()
    var profileObj : ProfileBO? = nil
    var boxActivityView = UIView()
    var activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        // Load Image
        if UserDefaults.standard.object(forKey: GlobalVariables.sharedManager.profileImage) as? NSData != nil{
            let dataImage = UserDefaults.standard.object(forKey: GlobalVariables.sharedManager.profileImage) as! NSData
            profileimageImg.image = UIImage(data: dataImage as Data)
        }
        else{
            profileimageImg.image = UIImage(named: GlobalVariables.sharedManager.profileImageDefault)
        }
        editBtn.title = NSLocalizedString("photoprofile-buttontop-edit", comment:"")
        titleProfilePhotoLabel.text = NSLocalizedString("photoprofile-title-home", comment:"")
    }
    
    
    func activityActionStart(title : String) {
        // You only need to adjust this frame to move it anywhere you want
        boxActivityView = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25, width: 180, height: 50))
        boxActivityView.backgroundColor = UIColor.white
        boxActivityView.alpha = 0.8
        boxActivityView.layer.cornerRadius = 10
        
        //Here the spinnier is initialized
        
        activityView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityView.startAnimating()
        
        let textLabel = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
        textLabel.textColor = UIColor.gray
        textLabel.text = title
        
        boxActivityView.addSubview(activityView)
        boxActivityView.addSubview(textLabel)
        
        view.addSubview(boxActivityView)
    }
    
    func activityActionStop() {
        //When button is pressed it removes the boxView from screen
        self.boxActivityView.removeFromSuperview()
        self.activityView.stopAnimating()
    }

    @IBAction func photoProfileAction(_ sender: Any) {
        showScrollOptions()
    }
    
    
    func showScrollOptions() {
        let alert = UIAlertController(title: "", message: NSLocalizedString("photoprofile-title-changephoto", comment:""), preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("photoprofile-buttontool-takephoto", comment:""), style: .default , handler:{ (UIAlertAction)in
            self.activityActionStart(title:NSLocalizedString("photoprofile-activity-save", comment:""))
            
                DispatchQueue.main.async {
                    self.takePhotoCam()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.activityActionStop()
                }
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("photoprofile-buttontool-choosephoto", comment:""), style: .default , handler:{ (UIAlertAction)in
            self.activityActionStart(title:NSLocalizedString("setting-activity-load", comment:""))

            DispatchQueue.main.async {
                   self.photoFromLibrary()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.activityActionStop()
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("photoprofile-buttontool-deletephoto", comment:""), style: .destructive , handler:{ (UIAlertAction)in
            DispatchQueue.main.async {
                self.photoDeleteLibrary()
                
            }
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("photoprofile-buttontool-cancelphoto", comment:""), style: .cancel , handler:{ (UIAlertAction)in
           
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    func takePhotoCam() {
        let cameraMediaType = AVMediaTypeVideo
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: cameraMediaType)
        switch cameraAuthorizationStatus {
            
        case .authorized:
            print(" AVAuthorizationStatus ACCEPT ")
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .camera
            self.imagePicker.cameraCaptureMode = .photo
            self.imagePicker.cameraCaptureMode = .video
            self.imagePicker.modalPresentationStyle = .fullScreen
            self.present(self.imagePicker,animated: true,completion: nil)
            break
            
        case .notDetermined:
             print(" AVAuthorizationStatus notDetermined ")
             AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo) { granted in
                if granted {
                    print("Granted access to \(cameraMediaType)")
                    self.imagePicker.allowsEditing = false
                    self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                    self.imagePicker.cameraCaptureMode = .photo
                    self.imagePicker.modalPresentationStyle = .fullScreen
                    self.present(self.imagePicker,animated: true,completion: nil)
                } else {
                    print("Denied access to \(cameraMediaType)")
                    self.noCamera()
                }
             }
            break
        case .restricted:
            print(" AVAuthorizationStatus restricted ")
            break
            
        case .denied:
            print(" AVAuthorizationStatus denied ")
            break
        }
    }
    
    func saveImageToDocuments(image: UIImage){
        let profileImage = "imageProfile_"+GlobalVariables.sharedManager.usernameNumberphone
        GlobalVariables.sharedManager.profileImage = profileImage
        let imageData:NSData = UIImagePNGRepresentation(image)! as NSData
        UserDefaults.standard.set(imageData, forKey:profileImage)
    }
    
    func photoDeleteLibrary() {
        let idForUserDefaults = GlobalVariables.sharedManager.profileImage
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: idForUserDefaults)
        //userDefaults.synchronize()
        self.profileimageImg.image = UIImage(named: GlobalVariables.sharedManager.profileImageDefault)

    }
    

    
    func photoFromLibrary() {
        self.imagePicker.allowsEditing = false
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let settingProfile = segue.destination as? AUPSettingViewController
        settingProfile!.profileObj = profileObj!
    }
    
    //MARK: - Done image capture here
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        profileimageImg.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        saveImageToDocuments(image: profileimageImg.image!)
    }
    

    @IBAction func backAction(_ sender: Any) {
        self.performSegue(withIdentifier:"PhotoProfileViewControllerBk", sender: nil)
    }
    
    

}
