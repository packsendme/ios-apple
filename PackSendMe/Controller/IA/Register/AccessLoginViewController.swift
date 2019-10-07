//
//  LoginViewController.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 04/11/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import UIKit

class AccessLoginViewController: UIViewController, UITextFieldDelegate{
    
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
    var iamService = IAService()
    var dateFormat = UtilityHelper()
    
    enum ViewType:String {
        case usernameVC = "AccessLoginControllerUsername"
        case passwordVC = "AccessLoginControllerPassword"
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
        if segue.identifier == "AccessLoginControllerPassword" {
            let loginVC = segue.destination as! AccessLoginViewController
            loginVC.metadadosView = segue.identifier!
        }
        else  if segue.identifier == "AccessLoginControllerUsername" {
            let loginVC = segue.destination as! AccessLoginViewController
            loginVC.metadadosView = segue.identifier!
        }
    }
    
    // Screen: LoginViewController - Username (PhoneNumber)
 
    @IBAction func validateAcessAction(_ sender: Any) {
         validateLogin()
    }
    
    // Screen: LoginViewController - Password
    @IBAction func nextAccountAccessAction(_ sender: Any) {
        userAccess()
    }
    
    @IBAction func backLoginUsername(_ sender: Any) {
        self.performSegue(withIdentifier:"AccessLoginControllerUsername", sender: nil)
    }
    
    /* ################################### < HTTP SERVICE >  ############################################### */
    

    func validateLogin() {
        GlobalVariables.sharedManager.usernameNumberphone = usernamecodeLabel.text!+usernameTexField.text!
        iamService.getIdentityAuthentication(){(success, response, error) in
            let responseCode = response
            if success == true{
                if URLConstants.HTTP_STATUS_CODE.OK == responseCode as! Int {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier:"IdentitySMSViewController", sender: nil)
                    }
                }
                else if URLConstants.HTTP_STATUS_CODE.FOUND == responseCode as! Int{
                    DispatchQueue.main.async {
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "AccessLoginControllerPassword", sender: nil)
                        }
                    }
                }
            }
            else if success == false || error != nil {
                DispatchQueue.main.async {
                    let ac = UIAlertController(title: NSLocalizedString("error-title-failconnection", comment:""), message: NSLocalizedString("error-body-failconnection", comment:""), preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated:  true)
                }
            }
        }
    }
    
    func userAccess() {
        iamService.getAccessManager(password: passwordTextField.text!){(success, response, error) in
            if success == true{
                let storyboard: UIStoryboard = UIStoryboard(name: "ACCOUNT", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "AccountView") as! AHMainViewController
                self.show(vc, sender: self)
            }
            else  if success == false && error == nil{
                DispatchQueue.main.async {
                    self.loginerrorLabel.isHidden = false
                    self.loginerrorLabel.text = NSLocalizedString("main-label-error", comment:"")
                }
            }
            else if error != nil{
                DispatchQueue.main.async {
                    let ac = UIAlertController(title: NSLocalizedString("error-title-failconnection", comment:""), message: NSLocalizedString("error-body-failconnection", comment:""), preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated:  true)
                }
            }
        }
    }

}
