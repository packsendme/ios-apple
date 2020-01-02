//
//  PhotoProfileViewController.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 20/12/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import UIKit
import AVFoundation

class APPPhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var titleProfilePhotoLabel: UILabel!
    @IBOutlet weak var editBtn: UIBarButtonItem!
    @IBOutlet weak var profileimageImg: UIImageView!
    let imagePicker = UIImagePickerController()
    var boxActivityView = UIView()
    var activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    var profileImageDefault: String = "icon-user-photo"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        // Load Image
        if UserDefaults.standard.object(forKey: GlobalVariables.sharedManager.profileImage) as? NSData != nil{
            let dataImage = UserDefaults.standard.object(forKey: GlobalVariables.sharedManager.profileImage) as! NSData
            profileimageImg.image = UIImage(data: dataImage as Data)
        }
        else{
            profileimageImg.image = UIImage(named: profileImageDefault)
        }
        editBtn.title = NSLocalizedString("photoprofile-buttontop-edit", comment:"")
        titleProfilePhotoLabel.text = NSLocalizedString("photoprofile-title-home", comment:"")
    }
    
    override func didReceiveMemoryWarning() {
        print(" DEALOCK MEMORY")
        super.didReceiveMemoryWarning()
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
        let scaledImage = UIImage.scaleImageWithDivisor(img: image, divisor: 3)
        let imageData:NSData = UIImagePNGRepresentation(scaledImage)! as NSData
        UserDefaults.standard.set(imageData, forKey:profileImage)
        GlobalVariables.sharedManager.profileImage = profileImage
    }
    
    func photoDeleteLibrary() {
        activityActionStart(title:"");
        let idForUserDefaults = GlobalVariables.sharedManager.profileImage
        let userDefaults = UserDefaults.standard

        UIView.transition(with: self.view,
            duration:0.5,
            options: .transitionCrossDissolve,
            animations: {
                userDefaults.removeObject(forKey: idForUserDefaults)
                //userDefaults.synchronize()
                self.profileimageImg.image = UIImage(named: self.profileImageDefault)
                self.activityActionStop()
            },
            completion: nil)
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
    
    //MARK: - Done image capture here
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        profileimageImg.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        saveImageToDocuments(image: profileimageImg.image!)
    }
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let homeObj = segue.destination as? AHMainViewController
        homeObj?.didReceiveMemoryWarning()
    }
     */
    
    /*
    @IBAction func ampPhotoGoBackAction(_ sender: Any) {
        self.performSegue(withIdentifier:"AHMainViewController", sender: nil)
    }
    */
    
    
}

extension UIImage {
    class func scaleImageWithDivisor(img: UIImage, divisor: CGFloat) -> UIImage {
        let size = CGSize(width: img.size.width/divisor, height: img.size.height/divisor)
        UIGraphicsBeginImageContext(size)
        img.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }
}
