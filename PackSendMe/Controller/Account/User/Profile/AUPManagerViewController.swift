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
    var boxActivityView = UIView()
    var activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
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
            if (text?.utf16.count)! >= 3 && (text?.utf16.count)! <= 13 && (lastnameTextField.text?.count)! >= 3{
                profileObj!.name = firstnameTextField.text!
                updatenameBtn.isEnabled = true
               // updatenameBtn.isHighlighted = false
                updatenameBtn.backgroundColor = UIColor(red:0.38, green:0.35, blue:0.35, alpha:1.0)
            }
            else{
                updatenameBtn.isEnabled = false
               // updatenameBtn.isHighlighted = false
                updatenameBtn.backgroundColor = UIColor(red:0.58, green:0.58, blue:0.58, alpha:1.0)
            }

            if (text?.utf16.count)! >= 3 && (text?.utf16.count)! <= 12{
                profileObj!.name = firstnameTextField.text!
            }
            
            if (text?.utf16.count)! >= 13  {
                firstnameTextField.deleteBackward()
            }
            
            if (text?.utf16.count)! == 13  {
                lastnameTextField.becomeFirstResponder()
            }
            
        case lastnameTextField:
            if (text?.utf16.count)! >= 3 && (text?.utf16.count)! <= 13 && (firstnameTextField.text?.count)! >= 3{
                updatenameBtn.isEnabled = true
                //updatenameBtn.isHighlighted = true
                updatenameBtn.backgroundColor = UIColor(red:0.38, green:0.35, blue:0.35, alpha:1.0)
            }
            else{
                updatenameBtn.isEnabled = false
                updatenameBtn.isHighlighted = false
                updatenameBtn.backgroundColor = UIColor(red:0.58, green:0.58, blue:0.58, alpha:1.0)
            }
            
            if (text?.utf16.count)! >= 13  {
                lastnameTextField.deleteBackward()
            }
            if (text?.utf16.count)! >= 3 && (text?.utf16.count)! <= 13 {
                profileObj!.lastName = lastnameTextField.text!
            }
            
        case passwordcurrentTextField:
            if (text?.utf16.count)! >= 6{
                passwordverifyBtn.isEnabled = true
                passwordverifyBtn.isHighlighted = false
                passwordverifyBtn.backgroundColor = UIColor(red:0.38, green:0.35, blue:0.35, alpha:1.0)
            }
            else{
                passwordverifyBtn.isEnabled = false
                passwordverifyBtn.isHighlighted = false
                passwordverifyBtn.backgroundColor = UIColor(red:0.58, green:0.58, blue:0.58, alpha:1.0)
            }
            
            if (text?.utf16.count)! >= 12  {
                passwordcurrentTextField.deleteBackward()
            }
        
        case passwordnewTextField:
            if (text?.utf16.count)! >= 6{
                passwordnewBtn.isEnabled = true
                passwordnewBtn.isHighlighted = false
                passwordnewBtn.backgroundColor = UIColor(red:0.38, green:0.35, blue:0.35, alpha:1.0)
            }
            else{
                passwordnewBtn.isEnabled = false
                passwordnewBtn.isHighlighted = false
                passwordnewBtn.backgroundColor = UIColor(red:0.58, green:0.58, blue:0.58, alpha:1.0)
            }
            
            if (text?.utf16.count)! >= 11  {
                passwordnewTextField.deleteBackward()
            }

        case emailTextField:
            if (text?.utf16.count)! >= 10 && (text?.utf16.count)! <= 254  {
                profileObj!.email = emailTextField.text!
                updateemailBtn.isEnabled = true
                updateemailBtn.isHighlighted = false
                updateemailBtn.backgroundColor = UIColor(red:0.38, green:0.35, blue:0.35, alpha:1.0)
            }
            else{
                updateemailBtn.isEnabled = false
                updateemailBtn.isHighlighted = false
                updateemailBtn.backgroundColor = UIColor(red:0.58, green:0.58, blue:0.58, alpha:1.0)
            }
            
            if (text?.utf16.count)! >= 254  {
                emailTextField.deleteBackward()
            }
        default:
            break
        }
    }
    
    func setupName(){
        self.nameTitleLabel.text  = NSLocalizedString("aup-manager-lbl-nametitle", comment:"")
        self.firstnameFieldLabel.text  = NSLocalizedString("aup-manager-txt-firstname", comment:"")
        self.lastnameFieldLabel.text  = NSLocalizedString("aup-manager-txt-lastname", comment:"")
        self.firstnameTextField.text  = profileObj?.name
        self.lastnameTextField.text  = profileObj?.lastName
        
        firstnameTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        lastnameTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        updatenameBtn.isEnabled = false
        updatenameBtn.isHighlighted = false
        updatenameBtn.backgroundColor = UIColor(red:0.66, green:0.66, blue:0.66, alpha:1.0)
        self.updatenameBtn.setTitle(NSLocalizedString("aup-manager-btn-update", comment:"") , for: .normal)
    }
    
    func setupEmail(){
        emailErrorDescriptionLabel.text = NSLocalizedString("aup-manager-lbl-emailvalidate", comment:"")
        emailErrorDescriptionLabel.isHidden = true
        self.emailTitleLabel.text  = NSLocalizedString("aup-manager-lbl-emailtitle", comment:"")
        self.emailFieldLabel.text  = NSLocalizedString("aup-manager-txt-email", comment:"")
        self.emailTextField.text  = profileObj?.email
        emailTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        updateemailBtn.isEnabled = false
        updateemailBtn.backgroundColor = UIColor(red:0.66, green:0.66, blue:0.66, alpha:1.0)
        self.updateemailBtn.setTitle(NSLocalizedString("aup-manager-btn-update", comment:"") , for: .normal)
    }
    
    func setupPassword(){
        self.passwordTitleLabel.text = NSLocalizedString("aup-manager-lbl-passwordtitle", comment:"")
        // Current Password
        self.passwordcurrentView.isHidden = false
        self.passwordcurrentLabel.text = NSLocalizedString("aup-manager-lbl-passwordCurrent", comment:"")
        self.passwordcurrentdetailLabel.text = NSLocalizedString("aup-manager-lbl-passwordvalidate", comment:"")
        self.passwordverifyBtn.setTitle(NSLocalizedString("aup-manager-btn-passwordvalidate", comment:"") , for: .normal)
        passwordcurrentTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        passwordverifyBtn.isEnabled = false
        // New Password
        self.passwordnewView.isHidden = true
        self.passwordFieldLabel.text = NSLocalizedString("aup-manager-txt-passwordNew", comment:"")
        passwordnewTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        self.passwordValidateLabel.text = NSLocalizedString("aup-manager-btn-passwordvalidate", comment:"")
        self.passwordnewBtn.setTitle(NSLocalizedString("aup-manager-btn-update", comment:"") , for: .normal)
        passwordnewBtn.isEnabled = false
        passwordverifyBtn.backgroundColor = UIColor(red:0.66, green:0.66, blue:0.66, alpha:1.0)
        passwordnewBtn.backgroundColor = UIColor(red:0.66, green:0.66, blue:0.66, alpha:1.0)
        let holder = settingHolder(field: "aup-manager-txt-passwordinput") as! NSMutableAttributedString
        self.self.passwordcurrentTextField.attributedPlaceholder = holder
        self.passwordnewTextField.attributedPlaceholder = holder
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
    
    func activityActionStop() {
        //When button is pressed it removes the boxView from screen
        self.boxActivityView.removeFromSuperview()
        self.activityView.stopAnimating()
    }
    
    func activityActionStart(title : String) {
        // You only need to adjust this frame to move it anywhere you want
        boxActivityView = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 150, width: 180, height: 50))
        boxActivityView.backgroundColor = UIColor.lightGray
        boxActivityView.alpha = 0.9
        boxActivityView.layer.cornerRadius = 10
        
        //Here the spinnier is initialized
        
        activityView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityView.color = UIColor.black
        
        activityView.startAnimating()
        
        let textLabel = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
        textLabel.textColor = UIColor.white
        textLabel.text = title
        
        boxActivityView.addSubview(activityView)
        boxActivityView.addSubview(textLabel)
        
        view.addSubview(boxActivityView)
    }
    
    func settingHolder(field : String) -> NSMutableAttributedString{
        var placeHolder = NSMutableAttributedString()
        let name  = NSLocalizedString(field, comment:"")
        
        // Set the Font
        placeHolder = NSMutableAttributedString(string:name, attributes: [NSFontAttributeName:UIFont(name: "Helvetica", size: 20.0)!])
        
        // Set the color
        let color = UIColor(red:0.76, green:0.75, blue:0.75, alpha:1.0)

        placeHolder.addAttribute(NSForegroundColorAttributeName, value: color, range:NSRange(location:0,length:name.count))
        
        // Add attribute
       return placeHolder
    }
    
    
 // =================================================================================================================================//


    // -------------------------------------------------------------------------------------
    // FUNCTION : UPDATE
    // MICROSERVICE : ACCOUNT
    // ENTITY :  ProfileBO
    // -------------------------------------------------------------------------------------
    func updateProfile() {
        activityActionStart(title : NSLocalizedString("main-title-loading", comment:""))
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
        iamService.updatePassword(password: passwordcurrentTextField.text!){(success, response, error) in
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

}
