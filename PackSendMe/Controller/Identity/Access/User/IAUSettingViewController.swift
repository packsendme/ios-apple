//
//  LoginViewController.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 04/11/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import UIKit

class IAUSettingViewController: UIViewController, UITextFieldDelegate{
    
    // Password - Login
    @IBOutlet weak var loginTitleLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var loginerrorLabel: UILabel!
    @IBOutlet weak var forgotpasswordBtn: UIButton!
    @IBOutlet weak var accountBtn: UIButton!
    
    // Username - Login
    @IBOutlet weak var phonetitleLabel: UILabel!
    @IBOutlet weak var countryselectBtn: UIButton!
    @IBOutlet weak var usernamecodeLabel: UILabel!
    @IBOutlet weak var usernameTexField: UITextField!
    @IBOutlet weak var phoneNextBtn: UIButton!
    
    var metadadosView : String = ""
    var iamService = IdentityService()
    var dateFormat = UtilityHelper()
    var usernamephone : String = ""
    var boxActivityView = UIView()
    var activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)

    
    enum ViewType:String {
        case usernameVC = "IAUSettingUsername"
        case passwordVC = "IAUSettingPassword"
    }
    
    override func viewDidLoad() {
       super.viewDidLoad()

        // Screen: LoginController - Username
         if metadadosView == ViewType.usernameVC.rawValue{
            usernameTexField.delegate = self
            usernameTexField.becomeFirstResponder()
            phoneNextBtn.isEnabled = false
            usernameTexField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
            phonetitleLabel.text = NSLocalizedString("main-title-mobile", comment:"")
            usernameTexField.placeholder = GlobalVariables.sharedManager.countryFormatInstance
            usernamecodeLabel.text = GlobalVariables.sharedManager.countryCodInstance
            countryselectBtn.setImage(GlobalVariables.sharedManager.countryImageInstance, for: .normal)
        }
        // Screen: LoginController - Password
         else if metadadosView == ViewType.passwordVC.rawValue{
            accountBtn.isEnabled = false
            passwordTextField.delegate = self
            passwordTextField.becomeFirstResponder()
            nextBtn.isEnabled = false
            loginerrorLabel.isHidden = true
            
            passwordTextField.placeholder = NSLocalizedString("main-label-password", comment:"")
            forgotpasswordBtn.setTitle(NSLocalizedString("main-button-forgotpassword", comment:""), for: .normal)
            accountBtn.setTitle(NSLocalizedString("main-button-account", comment:""), for: .normal)
            loginerrorLabel.text = NSLocalizedString("main-label-error", comment:"")
            
            passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
            
            let titleLabel = NSLocalizedString("main-title-login", comment:"")
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 13.4
            let attrString = NSMutableAttributedString(string: titleLabel)
            attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
            loginTitleLabel.attributedText = attrString
        }
    }

    func textFieldDidChange(textField: UITextField){
        let text = textField.text
        if textField == passwordTextField{
            if (text?.utf16.count)! >= 5{
                nextBtn.isEnabled = true
            }else{
                nextBtn.isEnabled = false
            }
        }
        else  if textField == usernameTexField{
            if (text?.utf16.count)! >= 8{
                phoneNextBtn.isEnabled = true
            }else{
                phoneNextBtn.isEnabled = false
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "IAUSettingPassword" {
            let loginVC = segue.destination as! IAUSettingViewController
            loginVC.usernamephone = usernamecodeLabel.text!+usernameTexField.text!
            loginVC.metadadosView = segue.identifier!
        }
        else  if segue.identifier == "IAUSettingUsername" {
            let loginVC = segue.destination as! IAUSettingViewController
            loginVC.metadadosView = segue.identifier!
        }
        else  if segue.identifier == "IRSSettingViewController" {
            let smsVC = segue.destination as! IRSSettingViewController
            smsVC.numberphoneNew = usernamecodeLabel.text!+usernameTexField.text!
        }
    }
    
    // Screen: LoginViewController - Username (PhoneNumber)
    @IBAction func validateAcessAction(_ sender: Any) {
         validateUsernameLogin()
    }
    
    // Screen: LoginViewController - Password
    @IBAction func nextAccountAccessAction(_ sender: Any) {
        userAccess()
    }
    
    @IBAction func backLoginUsername(_ sender: Any) {
        self.performSegue(withIdentifier:"IAUSettingUsername", sender: nil)
    }
    
    func activityActionStop() {
        //When button is pressed it removes the boxView from screen
        self.boxActivityView.removeFromSuperview()
        self.activityView.stopAnimating()
    }
    
    func activityActionStart(title : String) {
        // You only need to adjust this frame to move it anywhere you want
        boxActivityView = UIView(frame: CGRect(x: view.frame.midX - 40, y: view.frame.midY - 95, width:50, height: 50))
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
    
    /* ################################### < HTTP SERVICE >  ############################################### */
    

    func validateUsernameLogin() {
        activityActionStart(title : NSLocalizedString("a-action-lbl-validation", comment:""))
        let phone = usernamecodeLabel.text!+usernameTexField.text!
        iamService.getIdentityAuthentication(username : phone){(success, response, error) in
            let responseCode = response
            if success == true{
                if URLConstants.HTTP_STATUS_CODE.OK == responseCode as! Int {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier:"IRSSettingViewController", sender: nil)
                    }
                }
                else if URLConstants.HTTP_STATUS_CODE.FOUND == responseCode as! Int{
                    DispatchQueue.main.async {
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "IAUSettingPassword", sender: nil)
                        }
                    }
                }
            }
            else if success == false || error != nil {
                DispatchQueue.main.async {
                    self.activityActionStop()
                    let ac = UIAlertController(title: NSLocalizedString("error-title-failconnection", comment:""), message: NSLocalizedString("error-body-failconnection", comment:""), preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated:  true)
                }
            }
        }
    }
    
    func userAccess() {
        activityActionStart(title : NSLocalizedString("a-action-lbl-validation", comment:""))
        iamService.getAccessManager(username:usernamephone ,password: passwordTextField.text!){(success, response, error) in
            if success == true{
                let userObj = response as! UserBO
                GlobalVariables.sharedManager.nameFirst = userObj.firstname!
                GlobalVariables.sharedManager.nameLast = userObj.lastname!
                GlobalVariables.sharedManager.usernameNumberphone = self.usernamephone
                GlobalVariables.sharedManager.profileImage = "imageProfile_"+self.usernamephone

                let storyboard: UIStoryboard = UIStoryboard(name: "ACCOUNT", bundle: nil)
                let mainHomePSM = storyboard.instantiateViewController(withIdentifier: "AccountView") as! AHMainViewController
                self.show(mainHomePSM, sender: self)
            }
            else  if success == false && error == nil{
                DispatchQueue.main.async {
                    self.activityActionStop()
                    self.loginerrorLabel.isHidden = false
                    self.loginerrorLabel.text = NSLocalizedString("main-label-error", comment:"")
                }
            }
            else if error != nil{
                DispatchQueue.main.async {
                    self.activityActionStop()
                    let ac = UIAlertController(title: NSLocalizedString("error-title-failconnection", comment:""), message: NSLocalizedString("error-body-failconnection", comment:""), preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated:  true)
                }
            }
        }
    }

}
