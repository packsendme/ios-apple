//
//  LoginViewController.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 04/11/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate{
    
    
    @IBOutlet weak var loginTitleLabel: UILabel!

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var loginerrorLabel: UILabel!
    @IBOutlet weak var forgotpasswordBtn: UIButton!
    @IBOutlet weak var accountBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

    func textFieldDidChange(textField: UITextField){
        let text = textField.text
        if (text?.utf16.count)! >= 8{
            switch textField{
            case passwordTextField:
                nextBtn.isEnabled = true
            default:
                break
            }
        }else{
            nextBtn.isEnabled = false
        }
    }

    
    @IBAction func loginPackSendMe(_ sender: Any) {
        let paramsDictionary : String = GlobalVariables.sharedManager.username+"/"+passwordTextField.text!
        
        let account = URLConstants.IAM.iamAccess_http
        HttpClientApi.instance().makeAPICall(url: account, params:paramsDictionary, method: .GET, success: { (data, response, error) in
            
        if response?.statusCode == URLConstants.HTTP_STATUS_CODE.FOUND{
               DispatchQueue.main.async {
                    let storyboard: UIStoryboard = UIStoryboard(name: "ACCOUNT", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "AccountView") as! AccountViewController
                    self.show(vc, sender: self)
                 }
            }
        }, failure: { (data, response, error) in
            
            if response?.statusCode == URLConstants.HTTP_STATUS_CODE.NOTFOUND{
                DispatchQueue.main.async {
                    self.loginerrorLabel.isHidden = false
                    self.loginerrorLabel.text = NSLocalizedString("main-label-error", comment:"")
                }
            }
            if response?.statusCode == URLConstants.HTTP_STATUS_CODE.FAIL{
                DispatchQueue.main.async {
                   let ac = UIAlertController(title: NSLocalizedString(NSLocalizedString("error-title-failconnection", comment:""), comment:""), message: NSLocalizedString("error-msg-failconnection", comment:""), preferredStyle: .alert)
                       ac.addAction(UIAlertAction(title: "OK", style: .default))
                       self.present(ac, animated:  true)
                   }
            }
        })
        
    }
    

}
