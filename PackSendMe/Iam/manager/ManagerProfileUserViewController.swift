//
//  ManagerProfileUserViewController.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 27/12/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import UIKit

class ManagerProfileUserViewController: UIViewController {
    
    // Edit Name
    @IBOutlet weak var nameTitleLabel: UILabel!
    @IBOutlet weak var firstnameFieldLabel: UILabel!
    @IBOutlet weak var lastnameFieldLabel: UILabel!
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var updatenameBtn: UIButton!
  
    // Edit EMAIL
    @IBOutlet weak var emailTitleLabel: UILabel!
    @IBOutlet weak var emailFieldLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var updateemailBtn: UIButton!
    @IBOutlet weak var emailValidateErrorLabel: UILabel!
    
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
    
    // Edit PhoneNumber
    @IBOutlet weak var phonenumberTitleLabel: UILabel!
    @IBOutlet weak var codenumberLabel: UILabel!
    @IBOutlet weak var countrycodeBtn: UIButton!
    @IBOutlet weak var phonenumberTextField: UITextField!
    @IBOutlet weak var updatephoneBtn: UIButton!
    
    var metadadosView : String = ""
    var accountModel : AccountModel? = nil
    
    enum RegisterType:String {
        case name = "NameUI"
        case email = "EmailUI"
        case password = "PasswordUI"
        case username = "UsernameUI"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if metadadosView == RegisterType.name.rawValue{
            setupName()
        }
        else if metadadosView == RegisterType.email.rawValue{
            setupEmail()
        }
        else if metadadosView == RegisterType.password.rawValue{
            setupPassword()
        }
        else if metadadosView == RegisterType.username.rawValue{
            setupPhoneNumber()
        }
        
    }
    
    func setupName(){
        self.nameTitleLabel.text  = NSLocalizedString("editfirstname-label-title", comment:"")
        self.firstnameFieldLabel.text  = NSLocalizedString("editfirstname-text-firstname", comment:"")
        self.lastnameFieldLabel.text  = NSLocalizedString("editlastname-text-lastname", comment:"")
        self.firstnameTextField.text  = accountModel?.name
        self.lastnameTextField.text  = accountModel?.lastname
        self.updatenameBtn.setTitle(NSLocalizedString("editfirstname-title-btn", comment:"") , for: .normal)
    }
    
    func setupEmail(){
        emailValidateErrorLabel.text = NSLocalizedString("main-msg-email", comment:"")
        emailValidateErrorLabel.isHidden = true
        self.emailTitleLabel.text  = NSLocalizedString("editemail-label-title", comment:"")
        self.emailFieldLabel.text  = NSLocalizedString("editemail-text-email", comment:"")
        self.emailTextField.text  = accountModel?.email
        self.updateemailBtn.setTitle(NSLocalizedString("editemail-title-btn", comment:"") , for: .normal)
    }
    
    func setupPassword(){
        self.passwordTitleLabel.text = NSLocalizedString("editpassword-label-title", comment:"")
        // Current Password
        self.passwordcurrentView.isHidden = false
        self.passwordcurrentLabel.text = NSLocalizedString("editpasswordcurrent-text-password", comment:"")
        self.passwordcurrentdetailLabel.text = NSLocalizedString("editpasswordcurrent-text-detail", comment:"")
        self.passwordverifyBtn.setTitle(NSLocalizedString("editpasswordcurrent-title-btn", comment:"") , for: .normal)
        // New Password
        self.passwordnewView.isHidden = true
        self.passwordFieldLabel.text = NSLocalizedString("editpassword-text-password", comment:"")
        self.passwordnewBtn.setTitle(NSLocalizedString("editpassword-title-btn", comment:"") , for: .normal)

    }

    func setupPhoneNumber(){
        self.phonenumberTitleLabel.text = NSLocalizedString("editusername-label-title", comment:"")
        self.codenumberLabel.text = accountModel?.username
        self.phonenumberTextField.text = accountModel?.username
        self.updatephoneBtn.setTitle(NSLocalizedString("editusername-title-btn", comment:"") , for: .normal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let something = segue.destination as! SettingProfileUserViewController
            something.accountModel = self.accountModel
    }
    
    //Validad Field
    func textFieldDidChange(textField: UITextField){
        let text = textField.text
        switch textField{
            
        case firstnameTextField:
            if (text?.utf16.count)! >= 3 && (text?.utf16.count)! <= 13 && (lastnameTextField.text?.count)! >= 3{
                updatenameBtn.isEnabled = true
            }
            else if (text?.utf16.count)! >= 3 && (text?.utf16.count)! <= 13  {
                accountModel?.name = firstnameTextField.text!
            }
            else  if (text?.utf16.count)! < 3 {
                updatenameBtn.isEnabled = false
                accountModel?.name = firstnameTextField.text
            }
            else if (text?.utf16.count)! >= 14  {
                firstnameTextField.deleteBackward()
            }
            
        case lastnameTextField:
            if (text?.utf16.count)! >= 3 && (text?.utf16.count)! <= 13 && (lastnameTextField.text?.count)! >= 3{
                updatenameBtn.isEnabled = true
                accountModel?.lastname = lastnameTextField.text!
            }
            else if (text?.utf16.count)! >= 14  {
                lastnameTextField.deleteBackward()
            }
            else  if (text?.utf16.count)! < 3 {
                updatenameBtn.isEnabled = false
                accountModel?.lastname = lastnameTextField.text!
            }
        case passwordnewTextField:
            if (text?.utf16.count)! >= 6{
                passwordnewBtn.isEnabled = true
            }
            else{
                passwordnewBtn.isEnabled = false
            }
        case emailTextField:
            if (text?.utf16.count)! >= 10 && (text?.utf16.count)! <= 254  {
                updateemailBtn.isEnabled = true
            }
            else if (text?.utf16.count)! >= 254  {
                emailTextField.deleteBackward()
            }
            if (text?.utf16.count)! < 10 {
                updateemailBtn.isEnabled = false
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
    

    
    @IBAction func updateNameAction(_ sender: Any) {
        updateAccount()
    }
    
    @IBAction func updateEmailAction(_ sender: Any) {
        if isValidEmail(testStr: emailTextField.text!) == false{
            emailValidateErrorLabel.isHidden = false
        }else{


        }
    }
    
    // OPERATION - UPDATE
    @IBAction func updatePasswordAction(_ sender: Any) {
    }
    
    @IBAction func passwordVerify(_ sender: Any) {
    }
    
    @IBAction func updatePhoneNumberAction(_ sender: Any) {
    }
    
    // Call Country View
    @IBAction func changeCountryNumberAction(_ sender: Any) {
    }
    
    func updateAccount() {
        let accountHelper = AccountHelper()
        let utilityHelper = UtilityHelper()
        let dtNowS = utilityHelper.dateConvertToString()
        
        var paramsDictionary = [String:Any]()
        paramsDictionary = accountHelper.transformObjectToArray(username:(accountModel?.username)!, email:(accountModel?.email)!, password:(accountModel?.password)!, name:(accountModel?.name)!, lastname:(accountModel?.lastname)!, address:(accountModel?.address!)!, dtCreation:(accountModel?.dateCreation)!, dtChange: dtNowS)
        
        let account = URLConstants.ACCOUNT.account_http
        
        HttpClientApi.instance().makeAPIBodyCall(url: account, params:paramsDictionary, method: .PUT, success: { (data, response, error) in
            
            if response?.statusCode == URLConstants.HTTP_STATUS_CODE.ACCEPT{
                DispatchQueue.main.async {
                    let storyboard: UIStoryboard = UIStoryboard(name: "ACCOUNT", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "SettingProfileUserView") as! SettingProfileUserViewController
                    self.show(vc, sender: self)
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
