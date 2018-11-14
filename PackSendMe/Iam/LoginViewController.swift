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

    func validatePasswordUserAccess(completion: @escaping (Int) -> ()) {
        NSLog("VALIDADO")
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 20.0
        sessionConfig.timeoutIntervalForResource = 60.0
        let session = URLSession(configuration: sessionConfig)
        
        // let session = URLSession.shared
        let parameter : String = GlobalVariables.sharedManager.username+"/"+passwordTextField.text!
        let url_service : String = URLConstants.IAM.iamAccess_http+parameter
        let request = NSMutableURLRequest(url: NSURL(string: url_service)! as URL)
        var statusCode : Int = 0
        
        print ("URL = \(url_service)")
        
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTask(with: request as URLRequest as URLRequest, completionHandler: {(data, response, error) in
            do{
                if let response = response {
                    let nsHTTPResponse = response as! HTTPURLResponse
                    statusCode = nsHTTPResponse.statusCode
                    print ("status code = \(statusCode)")
                    
                    if statusCode == URLConstants.HTTP_STATUS_CODE.NOTFOUND{
                        DispatchQueue.main.async {
                            self.loginerrorLabel.isHidden = false
                            self.loginerrorLabel.text = NSLocalizedString("main-label-error", comment:"")
                        }
                    }
                    else if statusCode == URLConstants.HTTP_STATUS_CODE.FOUND{
                        DispatchQueue.main.async {
                        }
                    }
                    else if statusCode == URLConstants.HTTP_STATUS_CODE.FAIL{
                        DispatchQueue.main.async {
                            let ac = UIAlertController(title: NSLocalizedString("error-title-failconnection", comment:""), message: NSLocalizedString("error-body-failconnection", comment:""), preferredStyle: .alert)
                            ac.addAction(UIAlertAction(title: "OK", style: .default))
                            self.present(ac, animated:  true)
                        }
                    }
                    completion(statusCode) // or return an error cod
                    return
                }
                if let error = error {
                    DispatchQueue.main.async {
                        let ac = UIAlertController(title: NSLocalizedString("error-title-failconnection", comment:""), message: NSLocalizedString("error-body-failconnection", comment:""), preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated:  true)
                    }
                    completion(0) // or return an error code
                    return
                }
            } catch {
                DispatchQueue.main.async {
                    let ac = UIAlertController(title: NSLocalizedString("error-title-failconnection", comment:""), message: NSLocalizedString("error-body-failconnection", comment:""), preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated:  true)
                }
                completion(0) // or return an error code
                return
            }
        })
        task.resume()
    }
    

}
