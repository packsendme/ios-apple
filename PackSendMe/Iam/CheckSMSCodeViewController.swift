//
//  CheckSMSCodeViewController.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 21/10/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//
import Foundation
import UIKit

class CheckSMSCodeViewController: UIViewController, UITextFieldDelegate {
    
    

    @IBOutlet weak var titleCheckSMSLabel: UILabel!
    @IBOutlet weak var codeSMS1TextField: UITextField!
    @IBOutlet weak var codeSMS2TextField: UITextField!
    @IBOutlet weak var codeSMS3TextField: UITextField!
    @IBOutlet weak var codeSMS4TextField: UITextField!
    @IBOutlet weak var errorValidateLabel: UILabel!
    @IBOutlet weak var changeusernameBtn: UIButton!
    @IBOutlet weak var receivecodeBtn: UIButton!

    var dateFormat = UtilityHelper()

    
    @IBOutlet weak var nextBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        codeSMS1TextField.delegate = self
        codeSMS2TextField.delegate = self
        codeSMS3TextField.delegate = self
        codeSMS4TextField.delegate = self
        codeSMS1TextField.becomeFirstResponder()
        nextBtn.isEnabled = false
        errorValidateLabel.isHidden = true
        
        let titleLabel = NSLocalizedString("main-title-smscod", comment:"")+"  "+GlobalVariables.sharedManager.username
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 13.4
        let attrString = NSMutableAttributedString(string: titleLabel)
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        titleCheckSMSLabel.attributedText = attrString
        
        receivecodeBtn.setTitle(NSLocalizedString("main-title-receivecode", comment:""), for: .normal)
        changeusernameBtn.setTitle(NSLocalizedString("main-title-editnumber", comment:""), for: .normal)
        
        codeSMS1TextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        codeSMS2TextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        codeSMS3TextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        codeSMS4TextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == URLConstants.IAM.email_register) {
            print("EMAIL")
            let something = segue.destination as! DataRegisterViewController
            something.metadadosView = segue.identifier!
            
        } else if (segue.identifier == URLConstants.IAM.password_register) {
            print("PasswordRegisterUI")
            let something = segue.destination as! DataRegisterViewController
            something.metadadosView = segue.identifier!
        }
        else if (segue.identifier == URLConstants.IAM.name_register) {
            print("NameRegisterUI")
            let something = segue.destination as! DataRegisterViewController
            something.metadadosView = segue.identifier!
        }
    }


    @IBAction func nextBtn(_ sender: Any) {
        validateSMSCodeFirstUserAccess(){
            code in print(code)
        }
    }
    
    func validateSMSCodeFirstUserAccess(completion: @escaping (Int) -> ()) {
        NSLog("VALIDADO")
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 20.0
        sessionConfig.timeoutIntervalForResource = 60.0
        let session = URLSession(configuration: sessionConfig)
        
       // let session = URLSession.shared
        let dateNow = dateFormat.dateConvertToString()
        let parameter : String = GlobalVariables.sharedManager.username+"/"+codeSMS1TextField.text!+codeSMS2TextField.text!+codeSMS3TextField.text!+codeSMS4TextField.text!
        let url_service : String = URLConstants.IAM.iamIdentity_http+parameter
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
                            self.errorValidateLabel.isHidden = false
                            self.errorValidateLabel.text = NSLocalizedString("error-label-smsinvalid", comment:"")
                        }
                    }
                    else if statusCode == URLConstants.HTTP_STATUS_CODE.FOUND{
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier:URLConstants.IAM.email_register, sender: nil)
                        }
                        completion(statusCode)
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
    
    func textFieldDidChange(textField: UITextField){
        
        let text = textField.text
        if text?.utf16.count==1{
            switch textField{
            case codeSMS1TextField:
                codeSMS2TextField.becomeFirstResponder()
            case codeSMS2TextField:
                codeSMS3TextField.becomeFirstResponder()
            case codeSMS3TextField:
                codeSMS4TextField.becomeFirstResponder()
            case codeSMS4TextField:
                nextBtn.isEnabled = true
                validateSMSCodeFirstUserAccess(){
                    code in print(code)
                }
            default:
                break
            }
        }else{
            
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 1
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if (textField == self.codeSMS1TextField) {
            self.codeSMS2TextField.becomeFirstResponder()
        }
        else if (textField == self.codeSMS2TextField) {
            self.codeSMS3TextField.becomeFirstResponder()
            
        } else if (textField == self.codeSMS3TextField) {
            self.codeSMS4TextField.becomeFirstResponder()
        }
        else{
            let thereWereErrors = checkForErrors()
            if !thereWereErrors
            {
                //conditionally segue to next screen
            }
        }
        return true
    }
    
    func checkForErrors() -> Bool
    {
        var errors = false
        let title = "Error"
        var message = ""
        
        if codeSMS1TextField.text!.isEmpty {
            errors = true
            nextBtn.isEnabled = true
            message += NSLocalizedString("error-label-smscode1", comment:"")
            alertWithTitle(title: title, message: message, ViewController: self, toFocus:self.codeSMS1TextField)
        }
        else if codeSMS2TextField.text!.isEmpty
        {
            errors = true
            nextBtn.isEnabled = true
            message += NSLocalizedString("error-label-smscode2", comment:"")
            alertWithTitle(title: title, message: message, ViewController: self, toFocus:self.codeSMS2TextField)
        }
        else if codeSMS3TextField.text!.isEmpty
        {
            errors = true
            nextBtn.isEnabled = true
            message += NSLocalizedString("error-label-smscode3", comment:"")
            alertWithTitle(title: title, message: message, ViewController: self, toFocus:self.codeSMS3TextField)
        }
        else if codeSMS4TextField.text!.isEmpty
        {
            errors = true
            nextBtn.isEnabled = true
            message += NSLocalizedString("error-label-smscode4", comment:"")
            alertWithTitle(title: title, message: message, ViewController: self, toFocus:self.codeSMS4TextField)
        }
        return errors
    }

    func alertWithTitle(title: String!, message: String, ViewController: UIViewController, toFocus:UITextField) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel,handler: {_ in
            toFocus.becomeFirstResponder()
        });
        alert.addAction(action)
        ViewController.present(alert, animated: true, completion:nil)
    }
    
    /*
     
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
