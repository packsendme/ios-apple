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
    
    var emailP : String = ""
    var passwordP : String = ""
    
    
    enum RegisterType:String {
        case email = "EmailRegisterUI"
        case password = "PasswordRegisterUI"
        case name = "NameRegisterUI"
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
            self.performSegue(withIdentifier:URLConstants.IAM.password_register, sender: nil)
        }
    }
    
    @IBAction func nextPasswordBtn(_ sender: Any) {
        passwordP = passwordTextField.text!
        self.performSegue(withIdentifier:URLConstants.IAM.name_register, sender: nil)
    }
    
    
    @IBAction func registerAccount(_ sender: Any) {
        let accountHelper = ObjectTransformHelper()
        let utilityHelper = UtilityHelper()
        let dtNowS = utilityHelper.dateConvertToString()
        
        var paramsDictionary = [String:Any]()
        paramsDictionary = accountHelper.accountTransformObject(username:GlobalVariables.sharedManager.username, email:emailP, password:passwordP, name:nameTextField.text!, lastname:lastnameTextField.text!, address:[], dtAction:dtNowS)
        
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
        if (segue.identifier == URLConstants.IAM.email_register) {
            let something = segue.destination as! DataRegisterViewController
            something.metadadosView = segue.identifier!
            something.emailP = emailTextField.text!
            print("email_register")
            
        } else if (segue.identifier == URLConstants.IAM.password_register) {
            let something = segue.destination as! DataRegisterViewController
            something.metadadosView = segue.identifier!
            something.emailP = emailTextField.text!
            print("password_register")
        }
        else if (segue.identifier == URLConstants.IAM.name_register) {
            let something = segue.destination as! DataRegisterViewController
            something.metadadosView = segue.identifier!
            something.passwordP = passwordTextField.text!
            something.emailP = emailP
            print("name_register")
        }
    }
    
    
    
    func setupEmail(){
        emailTitleLabel.text = NSLocalizedString("main-title-email", comment:"")
        nextEmailBtn.isEnabled = false
        emailTextField.delegate = self
        emailTextField.becomeFirstResponder()
        emailTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        emailValidateErrorLabel.text = NSLocalizedString("main-msg-email", comment:"")
        emailValidateErrorLabel.isHidden = true
        emailTextField.placeholder = NSLocalizedString("main-text-email", comment:"")

    }
    
    func setupPassword(){
        passwordTitleLabel.text = NSLocalizedString("main-title-password", comment:"")
        nextPasswordBtn.isEnabled = false
        passwordTextField.delegate = self
        passwordTextField.becomeFirstResponder()
        passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
         passwordTextField.placeholder = NSLocalizedString("main-text-password", comment:"")
    }
    
    func setupNameUser(){
        nameTitleLabel.text = NSLocalizedString("main-title-name", comment:"")
        nextNameBtn.isEnabled = false
        nameTextField.delegate = self
        lastnameTextField.delegate = self
        nameTextField.becomeFirstResponder()
        nameTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        lastnameTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        nameTextField.placeholder = NSLocalizedString("main-text-name", comment:"")
        lastnameTextField.placeholder = NSLocalizedString("main-text-lastname", comment:"")
    }
    
    func textFieldDidChange(textField: UITextField){
        let text = textField.text
            switch textField{
            case nameTextField:
                if (text?.utf16.count)! >= 3{
                    nextNameBtn.isEnabled = true
                }
            case lastnameTextField:
                if (text?.utf16.count)! >= 4{
                    nextNameBtn.isEnabled = true
                }
            case passwordTextField:
                if (text?.utf16.count)! >= 6{
                   nextPasswordBtn.isEnabled = true
                }
            case emailTextField:
                if (text?.utf16.count)! >= 10{
                    nextEmailBtn.isEnabled = true
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
    
    
    
    

}
