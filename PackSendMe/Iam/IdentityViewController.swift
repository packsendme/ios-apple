//
//  IdentityViewController.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 24/09/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import Foundation
import UIKit


class IdentityViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var mobiletitleLabel: UILabel!
    @IBOutlet weak var countryselectBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var usernamecodeLabel: UILabel!
    @IBOutlet weak var usernameTexField: UITextField!
    // #C1E3F8
    var dateFormat = UtilityHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTexField.delegate = self
        usernameTexField.becomeFirstResponder()
        nextBtn.isEnabled = false
        usernameTexField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        mobiletitleLabel.text = NSLocalizedString("main-title-mobile", comment:"")
        usernameTexField.placeholder = GlobalVariables.sharedManager.countryFormatInstance
        usernamecodeLabel.text = GlobalVariables.sharedManager.countryCodInstance
        countryselectBtn.setImage(GlobalVariables.sharedManager.countryImageInstance, for: .normal)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= 13
    }
    
    
    @IBAction func validateFirstUserAccess(_ sender: Any) {
        let dateNow = dateFormat.dateConvertToString()
        let paramsDictionary : String = usernamecodeLabel.text!+usernameTexField.text!+"/"+dateNow
        let usernameP = usernamecodeLabel.text!+usernameTexField.text!
        let url = URLConstants.IAM.iamIdentity_http
        
        print (" URL NOW = \(url)")
        
        HttpClientApi.instance().makeAPICall(url: url, params:paramsDictionary, method: .GET, success: { (data, response, error) in
           //print (" URL statusCode = \(response?.statusCode)")
            if let data = data {
                do{
                    GlobalVariables.sharedManager.username = usernameP
                    if response?.statusCode == URLConstants.HTTP_STATUS_CODE.OK{
                        DispatchQueue.main.async {
                           self.performSegue(withIdentifier:URLConstants.IAM.smscode_register, sender: nil)
                        }
                    }
                    else if response?.statusCode == URLConstants.HTTP_STATUS_CODE.FOUND{
                        DispatchQueue.main.async {
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "LoginViewController", sender: nil)
                            }
                        }
                    }
                } catch _ {
                    DispatchQueue.main.async {
                        let ac = UIAlertController(title: NSLocalizedString("error-title-failconnection", comment:""), message: NSLocalizedString("error-body-failconnection", comment:""), preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated:  true)
                    }
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
        if (segue.identifier == URLConstants.IAM.smscode_register) {
            let something = segue.destination as! CheckSMSCodeViewController
            something.metadadosView = URLConstants.IAM.smscode_register
        }
        else if (segue.identifier == URLConstants.IAM.country_identity) {
            self.shouldPerformSegue(withIdentifier:URLConstants.IAM.country_identity, sender: nil)
        }
     }
    

    func textFieldDidChange(textField: UITextField){
        let text = textField.text
        if (text?.utf16.count)! >= 5{
            switch textField{
            case usernameTexField:
                nextBtn.isEnabled = true
            default:
                break
            }
        }else{
            nextBtn.isEnabled = false
        }
    }

    /*
    func callCheckSMSCode() {
       self.performSegue(withIdentifier:URLConstants.IAM.smscode_register, sender: nil)
        /*let checkSMSView = storyboard?.instantiateViewController (withIdentifier: "CheckSMSCodeViewController") as! CheckSMSCodeViewController
        self.present(checkSMSView, animated: true, completion: nil) */
    }*/
    
       
}
