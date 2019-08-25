//
//  EmailRegisterViewController.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 07/11/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import UIKit

class DataRegisterViewController: UIViewController, UITextFieldDelegate {

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

    var metadadosView : String = ""
    var account : AccountModel? = nil
    var formatPlaceHoldName = UtilityHelper()
    
    var emailP : String = ""
    var passwordP : String = ""
    var nameFirstP : String = ""
    var nameLastP : String = ""
    

   
    enum RegisterType:String {
        case email = "EmailUI"
        case password = "PasswordUI"
        case name = "NameUI"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        if metadadosView == RegisterType.email.rawValue{
            setupEmail()
        }
        else if metadadosView == RegisterType.password.rawValue{
            setupPassword()
        }
        else if metadadosView == RegisterType.name.rawValue{
            setupNameUser()
        }
    }

    
    @IBAction func nextEmailBtn(_ sender: Any) {
        if isValidEmail(testStr: emailTextField.text!) == false{
            emailValidateErrorLabel.isHidden = false
        }else{
            emailP = emailTextField.text!
            self.performSegue(withIdentifier:URLConstants.IAM.passwordUI, sender: nil)
        }
    }
    
    @IBAction func nextPasswordBtn(_ sender: Any) {
        passwordP = passwordTextField.text!
        self.performSegue(withIdentifier:URLConstants.IAM.nameUI, sender: nil)
    }
    
    
    @IBAction func registerAccount(_ sender: Any) {
        let accountVO = AccountDto()
        let utilityHelper = UtilityHelper()
        let dateCreationS = utilityHelper.dateConvertToString()
        
        var paramsDictionary = [String:Any]()
        
        paramsDictionary = accountVO.createAccountDictionary(username:GlobalVariables.sharedManager.usernameNumberphone, email:emailP, password:passwordP, name:nameTextField.text!, lastName:lastnameTextField.text!, codcountry: GlobalVariables.sharedManager.countryCodInstance,dateCreation:dateCreationS, dateUpdate:dateCreationS)
        
        let account = URLConstants.ACCOUNT.account_http
        HttpClientApi.instance().makeAPIBodyCall(url: account, params:paramsDictionary, method: .POST, success: { (data, response, error) in
            
            if response?.statusCode == URLConstants.HTTP_STATUS_CODE.ACCEPT{
                DispatchQueue.main.async {
                    let storyboard: UIStoryboard = UIStoryboard(name: "ACCOUNT", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "AccountView") as! AccountViewController
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == URLConstants.IAM.emailUI) {
            let something = segue.destination as! DataRegisterViewController
            something.metadadosView = segue.identifier!
            something.emailP = emailP
            something.passwordP = passwordP
            something.nameFirstP = nameFirstP
            something.nameLastP = nameLastP
            print("email_register")

        } else if (segue.identifier == URLConstants.IAM.passwordUI) {
            let something = segue.destination as! DataRegisterViewController
            something.metadadosView = segue.identifier!
            something.emailP = emailP //emailTextField.text!
            something.nameFirstP = nameFirstP
            something.nameLastP = nameLastP

            print("password_register")
        }
        else if (segue.identifier == URLConstants.IAM.nameUI) {
            let something = segue.destination as! DataRegisterViewController
            something.metadadosView = segue.identifier!
            print("password_register =\(passwordP)")
            something.passwordP = passwordP
            something.emailP = emailP
            something.nameFirstP = nameFirstP
            something.nameLastP = nameLastP
            print("name_register")
        }
        else if (segue.identifier == URLConstants.IAM.smscode_register) {
            let something = segue.destination as! CheckSMSCodeViewController
            something.metadadosView = URLConstants.IAM.smscode_register
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
        emailTextField.text = emailP

        if((emailTextField.text?.count)!) > 1{
            nextEmailBtn.isEnabled = true
        }
        else{
            nextEmailBtn.isEnabled = false
        }

    }
    
    func setupPassword(){
        passwordTitleLabel.text = NSLocalizedString("main-title-password", comment:"")
        nextPasswordBtn.isEnabled = false
        passwordTextField.delegate = self
        passwordTextField.becomeFirstResponder()
        passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        var passwordNameHolder : String = NSLocalizedString("main-text-password", comment:"")
        passwordTextField.attributedPlaceholder = formatPlaceHoldName.setPlaceholder(nameholder : passwordNameHolder)
            passwordTextField.text = passwordP
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
        nameTextField.text = nameFirstP
        lastnameTextField.text = nameLastP
        
        if((nameTextField.text?.count)!) > 1 && ((lastnameTextField.text?.count)!) > 1 {
            nextNameBtn.isEnabled = true
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
                    nextNameBtn.isEnabled = true
                    nameFirstP = nameTextField.text!
            }
            else if (text?.utf16.count)! >= 3 && (text?.utf16.count)! <= 13  {
                nameFirstP = nameTextField.text!
            }
            else  if (text?.utf16.count)! < 3 {
                nextNameBtn.isEnabled = false
                nameFirstP = nameTextField.text!
            }
            else if (text?.utf16.count)! >= 14  {
                nameTextField.deleteBackward()
            }
                
           case lastnameTextField:
            if (text?.utf16.count)! >= 3 && (text?.utf16.count)! <= 13 && (nameTextField.text?.count)! >= 3{
                nextNameBtn.isEnabled = true
                nameLastP = lastnameTextField.text!
            }
            else if (text?.utf16.count)! >= 14  {
                lastnameTextField.deleteBackward()
            }
            else  if (text?.utf16.count)! < 3 {
                nextNameBtn.isEnabled = false
                nameLastP = lastnameTextField.text!
            }
            case passwordTextField:
            if (text?.utf16.count)! >= 6{
                nextPasswordBtn.isEnabled = true
            }
            else{
                nextPasswordBtn.isEnabled = false
            }
            case emailTextField:
            if (text?.utf16.count)! >= 10 && (text?.utf16.count)! <= 254  {
                nextEmailBtn.isEnabled = true
            }
            else if (text?.utf16.count)! >= 254  {
                emailTextField.deleteBackward()
            }
            if (text?.utf16.count)! < 10 {
                nextEmailBtn.isEnabled = false
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
    
    
    @IBAction func returnSMSNewValidate(_ sender: Any) {
        let code: Int = SMSCodeGeneratorHttp().generatorSMSCode()
        
        if  code == URLConstants.HTTP_STATUS_CODE.OK{
            DispatchQueue.main.async {
                self.performSegue(withIdentifier:URLConstants.IAM.smscode_register, sender: nil)
            }
        } else{
            DispatchQueue.main.async {
                let ac = UIAlertController(title: NSLocalizedString(NSLocalizedString("error-title-failconnection", comment:""), comment:""), message: NSLocalizedString("error-msg-failconnection", comment:""), preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(ac, animated:  true)
            }
        }
    }
    
    

    
    
}
