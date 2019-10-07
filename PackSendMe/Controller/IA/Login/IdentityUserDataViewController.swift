//
//  EmailRegisterViewController.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 07/11/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import UIKit

class IdentityUserDataViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nextEmailBtn: UIButton!
    @IBOutlet weak var nextPasswordBtn: UIButton!
    @IBOutlet weak var nextNameBtn: UIButton!
    
    @IBOutlet weak var emailTitleLabel: UILabel!
    @IBOutlet weak var passwordTitleLabel: UILabel!
    @IBOutlet weak var nameTitleLabel: UILabel!
    @IBOutlet weak var emailValidateErrorLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!

    var iamService = IAService()
    var metadadosView : String = ""
    var profileObj = ProfileBO()
    var dateFormat = UtilityHelper()
    var formatPlaceHoldName = UtilityHelper()
    
    enum ViewType:String {
        case email = "IdentityUserDataEmail"
        case password = "IdentityUserDataPassword"
        case name = "IdentityUserDataNames"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        if metadadosView == ViewType.email.rawValue{
            setupEmail()
        }
        else if metadadosView == ViewType.password.rawValue{
            setupPassword()
        }
        else if metadadosView == ViewType.name.rawValue{
            setupNameUser()
        }
    }

    
    @IBAction func nextEmailBtn(_ sender: Any) {
        if isValidEmail(testStr: emailTextField.text!) == false{
            emailValidateErrorLabel.isHidden = false
        }else{
            profileObj.email = emailTextField.text!
            self.performSegue(withIdentifier:"IdentityUserDataPassword", sender: nil)
        }
    }
    
    @IBAction func nextPasswordBtn(_ sender: Any) {
        profileObj.password = passwordTextField.text!
        self.performSegue(withIdentifier:"IdentityUserDataNames", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "IdentityUserDataEmail") {
            let emailVC = segue.destination as! IdentityUserDataViewController
            emailVC.metadadosView = segue.identifier!
            emailVC.profileObj = profileObj

        } else if (segue.identifier == "IdentityUserDataPassword") {
            let passwordVC = segue.destination as! IdentityUserDataViewController
            passwordVC.metadadosView = segue.identifier!
            passwordVC.profileObj = profileObj
        }
        else if (segue.identifier == "IdentityUserDataNames") {
            let names = segue.destination as! IdentityUserDataViewController
            names.metadadosView = segue.identifier!
            names.profileObj = profileObj
        }
        else if (segue.identifier == "AccessLoginControllerUsername") {
            let loginVC = segue.destination as! AccessLoginViewController
            loginVC.metadadosView = segue.identifier!
        }
    }
    
    
    
    func setupEmail(){
        emailTitleLabel.text = NSLocalizedString("main-title-email", comment:"")
        emailTextField.delegate = self
        emailTextField.becomeFirstResponder()
        emailTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        emailValidateErrorLabel.text = NSLocalizedString("main-msg-email", comment:"")
        emailValidateErrorLabel.isHidden = true
        let emailNameHolder : String = NSLocalizedString("main-text-email", comment:"")
        emailTextField.attributedPlaceholder = formatPlaceHoldName.setPlaceholder(nameholder : emailNameHolder)
        
        if profileObj.email != nil{
            if profileObj.email!.count >= 10 && profileObj.email!.count <= 254{
               emailTextField.text = profileObj.email
               nextEmailBtn.isEnabled = true
            }
            else{
                emailTextField.text = profileObj.email
                nextEmailBtn.isEnabled = false
            }
        }
    }
    
    func setupPassword(){
        passwordTitleLabel.text = NSLocalizedString("main-title-password", comment:"")
        nextPasswordBtn.isEnabled = false
        passwordTextField.delegate = self
        passwordTextField.becomeFirstResponder()
        passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        let passwordNameHolder : String = NSLocalizedString("main-text-password", comment:"")
        passwordTextField.attributedPlaceholder = formatPlaceHoldName.setPlaceholder(nameholder : passwordNameHolder)
        
        if profileObj.password != nil{
            if profileObj.password!.count > 6{
                passwordTextField.text = profileObj.password
                nextPasswordBtn.isEnabled = true
            }
            else{
                passwordTextField.text = profileObj.password
                nextPasswordBtn.isEnabled = false
            }
        }
    }
    
    func setupNameUser(){
        nameTitleLabel.text = NSLocalizedString("main-title-name", comment:"")
        nextNameBtn.isEnabled = false
        nameTextField.delegate = self
        lastnameTextField.delegate = self
        nameTextField.becomeFirstResponder()
        nameTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        lastnameTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        
        var nameHolder : String = NSLocalizedString("main-text-name", comment:"")
        nameTextField.attributedPlaceholder = formatPlaceHoldName.setPlaceholder(nameholder : nameHolder)
        var lastnameHolder : String = NSLocalizedString("main-text-lastname", comment:"")
        lastnameTextField.attributedPlaceholder = formatPlaceHoldName.setPlaceholder(nameholder : lastnameHolder)

        if profileObj.name != nil && profileObj.lastName != nil {
            if profileObj.name!.count > 1 && profileObj.lastName!.count > 1{
                nameTextField.text = profileObj.name
                lastnameTextField.text = profileObj.lastName

                if profileObj.name!.count >= 3 && profileObj.name!.count <= 13 &&
                    profileObj.lastName!.count >= 3 && profileObj.lastName!.count <= 13{
                        nextNameBtn.isEnabled = true
                    }
            }
        }
        else{
            nextNameBtn.isEnabled = false
        }
    }
    
    func textFieldDidChange(textField: UITextField){
        let text = textField.text
        switch textField{
                
        case nameTextField:
            if (text?.utf16.count)! >= 3 && (text?.utf16.count)! <= 13 && (lastnameTextField.text?.count)! >= 3{
                profileObj.name = nameTextField.text!
                nextNameBtn.isEnabled = true
            }
            else{
                nextNameBtn.isEnabled = false
            }
            
            if (text?.utf16.count)! >= 3 && (text?.utf16.count)! <= 13{
                profileObj.name = nameTextField.text!
            }
            
            if (text?.utf16.count)! >= 13  {
                nameTextField.deleteBackward()
            }
            
            if (text?.utf16.count)! == 13  {
                lastnameTextField.becomeFirstResponder()
            }
                
        case lastnameTextField:
            if (text?.utf16.count)! >= 3 && (text?.utf16.count)! <= 13 && (nameTextField.text?.count)! >= 3{
                nextNameBtn.isEnabled = true
            }
            if (text?.utf16.count)! >= 13  {
                lastnameTextField.deleteBackward()
            }
            if (text?.utf16.count)! >= 3 && (text?.utf16.count)! <= 13 {
                profileObj.lastName = lastnameTextField.text!
            }
  
        case passwordTextField:
            if (text?.utf16.count)! >= 6{
                nextPasswordBtn.isEnabled = true
                profileObj.password = passwordTextField.text!
            }
            else{
                nextPasswordBtn.isEnabled = false
            }
            
            if (text?.utf16.count)! >= 11  {
                passwordTextField.deleteBackward()
            }
            
            
        case emailTextField:
            if (text?.utf16.count)! >= 10 && (text?.utf16.count)! <= 254  {
                profileObj.email = emailTextField.text!
                nextEmailBtn.isEnabled = true
            }
            else{
                nextEmailBtn.isEnabled = false
            }
            
            if (text?.utf16.count)! >= 254  {
                emailTextField.deleteBackward()
            }
            default:
            break
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    @IBAction func createAccountAction(_ sender: Any) {
        let dateNow = dateFormat.dateConvertToString()
        profileObj.country = GlobalVariables.sharedManager.countryCodInstance
        profileObj.dateOperation = dateNow
        profileObj.username = GlobalVariables.sharedManager.usernameNumberphone
        registerAccount()
    }
    
    @IBAction func returnEmailAction(_ sender: Any) {
        self.performSegue(withIdentifier:"AccessLoginControllerUsername", sender: nil)
    }
    
    @IBAction func returnPasswordAction(_ sender: Any) {
        self.performSegue(withIdentifier:"IdentityUserDataEmail", sender: nil)
    }
    
    @IBAction func returnNamesAction(_ sender: Any) {
        self.performSegue(withIdentifier:"IdentityUserDataPassword", sender: nil)
    }
    
    /* ###################################################################################################
     ################################### < HTTP SERVICE >  ############################################### */
    
    func registerAccount() {
        iamService.postCreateAccount(account: profileObj){(success, response, error) in
            if success == true{
                DispatchQueue.main.async {
                    let storyboard: UIStoryboard = UIStoryboard(name: "ACCOUNT", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "AccountView") as! AHMainViewController
                    self.show(vc, sender: self)
                }
            }
            else if success == false{
                DispatchQueue.main.async {
                    let ac = UIAlertController(title: NSLocalizedString("error-title-failconnection", comment:""), message: NSLocalizedString("error-msg-failconnection", comment:""), preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated:  true)
                }
            }
        }
    }
    
}
