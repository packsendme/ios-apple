//
//  ManagerProfileUserViewController.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 27/12/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import UIKit

class AUPManagerViewController: UIViewController, UITextFieldDelegate {
    
    // Edit Name
    @IBOutlet weak var nameTitleLabel: UILabel!
    @IBOutlet weak var firstnameFieldLabel: UILabel!
    @IBOutlet weak var lastnameFieldLabel: UILabel!
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var updatenameBtn: UIButton!
    @IBOutlet weak var firstnameValidateLabel: UILabel!
    @IBOutlet weak var lastnameValidateLabel: UILabel!
    
    // Edit EMAIL
    @IBOutlet weak var emailTitleLabel: UILabel!
    @IBOutlet weak var emailFieldLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var updateemailBtn: UIButton!
    @IBOutlet weak var emailErrorDescriptionLabel: UILabel!
    
    // Edit Password
    @IBOutlet weak var passwordTitleLabel: UILabel!
    @IBOutlet weak var passwordnewView: UIView!
    @IBOutlet weak var passwordFieldLabel: UILabel!
    @IBOutlet weak var passwordnewTextField: UITextField!
    @IBOutlet weak var passwordnewBtn: UIButton!
    @IBOutlet weak var passwordcurrentView: UIView!
    @IBOutlet weak var passwordcurrentLabel: UILabel!
    @IBOutlet weak var passwordcurrentTextField: UITextField!
    @IBOutlet weak var passwordverifyBtn: UIButton!
    @IBOutlet weak var passwordcurrentdetailLabel: UILabel!
    @IBOutlet weak var passwordValidateLabel: UILabel!
    
    
    var metadadosView : String = ""
    var profileObj : ProfileBO? = nil
    var formatPlaceHoldName = UtilityHelper()
    var refreshControl = UIRefreshControl()
    var usernameNumber: String = ""
    var country : CountryVModel? = nil
    
    var amService = AccountService()
    var iamService = IAService()
    
    
    enum ViewType:String {
        case name = "names"
        case email = "email"
        case password = "password"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if metadadosView == ViewType.name.rawValue{
            setupName()
        }
        else if metadadosView == ViewType.email.rawValue{
            setupEmail()
        }
        else if metadadosView == ViewType.password.rawValue{
            setupPassword()
        }
        
    }
    
    func textFieldDidChange(textField: UITextField){
        let text = textField.text
        switch textField{
            
        case firstnameTextField:
            if (text?.utf16.count)! >= 10  {
                 lastnameTextField.deleteBackward()
            }
            
        case lastnameTextField:
            if (text?.utf16.count)! >= 10  {
                lastnameTextField.deleteBackward()
            }

        case passwordnewTextField:
            if (text?.utf16.count)! >= 10{
                passwordnewTextField.deleteBackward()
            }
        case emailTextField:
            if (text?.utf16.count)! >= 254  {
                emailTextField.deleteBackward()
            }
         default:
            break
        }
    }
    
    func setupName(){
        self.nameTitleLabel.text  = NSLocalizedString("editfirstname-label-title", comment:"")
        self.firstnameFieldLabel.text  = NSLocalizedString("editfirstname-text-firstname", comment:"")
        self.lastnameFieldLabel.text  = NSLocalizedString("editlastname-text-lastname", comment:"")
        self.firstnameTextField.text  = profileObj?.name
        self.lastnameTextField.text  = profileObj?.lastName
        
        firstnameTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        lastnameTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)

        self.updatenameBtn.setTitle(NSLocalizedString("editfirstname-title-btn", comment:"") , for: .normal)
    }
    
    func setupEmail(){
        emailErrorDescriptionLabel.text = NSLocalizedString("main-msg-email", comment:"")
        emailErrorDescriptionLabel.isHidden = true
        self.emailTitleLabel.text  = NSLocalizedString("editemail-label-title", comment:"")
        self.emailFieldLabel.text  = NSLocalizedString("editemail-text-email", comment:"")
        self.emailTextField.text  = profileObj?.email
        emailTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        self.updateemailBtn.setTitle(NSLocalizedString("editemail-title-btn", comment:"") , for: .normal)
    }
    
    func setupPassword(){
        self.passwordTitleLabel.text = NSLocalizedString("editpassword-label-title", comment:"")
        // Current Password
        self.passwordcurrentView.isHidden = false
        self.passwordcurrentLabel.text = NSLocalizedString("editpasswordcurrent-text-passwordVerifiy", comment:"")
        self.passwordcurrentdetailLabel.text = NSLocalizedString("editpasswordcurrent-text-detail", comment:"")
        self.passwordverifyBtn.setTitle(NSLocalizedString("editpasswordcurrent-title-btn", comment:"") , for: .normal)
        passwordcurrentTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
       
        // New Password
        self.passwordnewView.isHidden = true
        self.passwordFieldLabel.text = NSLocalizedString("editpassword-text-passwordNew", comment:"")
        self.passwordnewBtn.setTitle(NSLocalizedString("editpassword-title-btn", comment:"") , for: .normal)
        passwordnewTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        self.passwordValidateLabel.text = NSLocalizedString("editpassword-label-passwordvalidate", comment:"")
        
        /*
        let passwordNameHolder : String = NSLocalizedString("editpassword-text-password", comment:"")
        self.passwordcurrentTextField.attributedPlaceholder = formatPlaceHoldName.setPlaceholder(nameholder : passwordNameHolder)
 
        let passwordNewHolder : String = NSLocalizedString("editpassword-text-password", comment:"")
        self.passwordnewTextField.attributedPlaceholder = formatPlaceHoldName.setPlaceholder(nameholder : passwordNewHolder)
       */
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "AUPSettingViewController") {
            let something = segue.destination as! AUPSettingViewController
            something.profileObj = self.profileObj!
        }
        else if (segue.identifier == "PhoneNumberAccountChangeCountry") {
            let something = segue.destination as! CountryAccountViewController
            //something.profileObj = self.profileObj
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    // OPERATION - UPDATE
    @IBAction func updateNameAction(_ sender: Any) {
        profileObj?.name = firstnameTextField.text!
        profileObj?.lastName = lastnameTextField.text!
        
        if (firstnameTextField.text!.count) >= 3 && (firstnameTextField.text!.count) <= 13 && (lastnameTextField.text!.count) >= 3{
            updateProfile()
        }
        else if firstnameTextField.text!.count < 3 && lastnameTextField.text!.count < 3{
            self.firstnameValidateLabel.text = NSLocalizedString("editfirstname-label-firstnamevalidate", comment:"")
            self.firstnameValidateLabel.isHidden = false
            self.lastnameValidateLabel.text = NSLocalizedString("editlastname-label-lastnamevalidate", comment:"")
            self.lastnameValidateLabel.isHidden = false

        }
        else if firstnameTextField.text!.count < 3{
            self.firstnameValidateLabel.text = NSLocalizedString("editfirstname-label-firstnamevalidate", comment:"")
            self.lastnameValidateLabel.isHidden = true
            self.firstnameValidateLabel.isHidden = false
        }
        else if lastnameTextField.text!.count < 3{
            self.lastnameValidateLabel.text = NSLocalizedString("editlastname-label-lastnamevalidate", comment:"")
            self.firstnameValidateLabel.isHidden = true
            self.lastnameValidateLabel.isHidden = false
        }
    }
    
    @IBAction func updateEmailAction(_ sender: Any) {
        if isValidEmail(testStr: emailTextField.text!) == false{
            emailErrorDescriptionLabel.isHidden = false
        }else{
            profileObj?.email = emailTextField.text!
            updateProfile()
        }
    }
    

    @IBAction func updatePasswordAction(_ sender: Any) {
        updatePasswordAccount()
    }
    
    @IBAction func passwordVerify(_ sender: Any) {
        if passwordcurrentTextField.text!.count >= 6{
            let passwordTrim = passwordcurrentTextField.text
            let formattedPassword = passwordTrim!.replacingOccurrences(of: " ", with: "")
            checkPasswordCurrent(password: formattedPassword)
        }
        else{
            self.passwordcurrentdetailLabel.text = NSLocalizedString("editpassword-label-passwordvalidate", comment:"")
            self.passwordcurrentdetailLabel.font = UIFont(name:"Helvetica", size:15)
            self.passwordcurrentdetailLabel.textColor = UIColor.red
        }
    }
    
    
 

    // -------------------------------------------------------------------------------------
    // FUNCTION : UPDATE
    // MICROSERVICE : ACCOUNT
    // ENTITY :  ProfileBO
    // -------------------------------------------------------------------------------------
    func updateProfile() {
        amService.updateUserProfile(profile:profileObj!){(success, response, error) in
            if success == true{
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier:"AUPSettingViewController", sender: nil)
                }
            }
            else{
                DispatchQueue.main.async() {
                    let ac = UIAlertController(title: NSLocalizedString("error-title-failconnection", comment:""), message: NSLocalizedString("error-msg-failconnection", comment:""), preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated:  true)
                }
            }
        }
    }
    
    
    // -------------------------------------------------------------------------------------
    // FUNCTION : Check Password Current
    // MICROSERVICE : IAM
    // ENTITY :  String Password
    // -------------------------------------------------------------------------------------
    func checkPasswordCurrent(password : String) {
        iamService.getPasswordCurrent(password:passwordcurrentTextField.text!){(success, response, error) in
            if success == true{
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.5) { [unowned self] in
                        self.passwordnewView.isHidden = false
                        self.passwordcurrentView.alpha = 0
                    }
                }
            }
            else if success == false && error == nil{
                DispatchQueue.main.async() {
                    self.passwordcurrentdetailLabel.text = NSLocalizedString("main-label-error", comment:"")
                    self.passwordcurrentdetailLabel.font = UIFont(name:"Avenir", size:20)
                    self.passwordcurrentdetailLabel.textColor = UIColor.red
                }
            }
            else{
                DispatchQueue.main.async() {
                    let ac = UIAlertController(title: NSLocalizedString("error-title-failconnection", comment:""), message: NSLocalizedString("error-msg-failconnection", comment:""), preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated:  true)
                }
            }
        }
    }
    
    
    // -------------------------------------------------------------------------------------
    // FUNCTION : UPDATE
    // MICROSERVICE : IAM
    // ENTITY :  ProfileBO
    // -------------------------------------------------------------------------------------
    func updatePasswordAccount() {
        let utilityHelper = UtilityHelper()
        let dateUpdate = utilityHelper.dateConvertToString()
        
        let paramsDictionary : String = GlobalVariables.sharedManager.usernameNumberphone+"/"+passwordnewTextField.text!+"/"+dateUpdate
        let iamURL = URLConstants.IAM.iamManager_http
        
        
        HttpService.instance().makeAPICall(url: iamURL, params:paramsDictionary, method: .PUT, success: { (data, response, error) in
            
            if response?.statusCode == URLConstants.HTTP_STATUS_CODE.OK{
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier:"ManagerProfileUserToSettingProfileUser", sender: nil)
                }
            }
        }, failure: { (data, response, error) in
            DispatchQueue.main.async {
                let ac = UIAlertController(title: NSLocalizedString(NSLocalizedString("error-title-failconnection", comment:""), comment:""), message: NSLocalizedString("error-msg-failconnection", comment:""), preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(ac, animated:  true)
            }
        })
    }

    
    
}
