//
//  CheckSMSCodeAccountViewController.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 28/01/2019.
//  Copyright © 2019 Ricardo Marzochi. All rights reserved.
//

import UIKit

class CheckSMSCodeAccountViewController: UIViewController, UITextFieldDelegate {
    
    // New SMS Code - UIVIEM
    
    @IBOutlet weak var titleSMSCodeLabel: UILabel!
    
    // Validate SMS Code - UIVIEM
    @IBOutlet weak var codeSMS1TextField: UITextField!
    @IBOutlet weak var codeSMS2TextField: UITextField!
    @IBOutlet weak var codeSMS3TextField: UITextField!
    @IBOutlet weak var codeSMS4TextField: UITextField!
    @IBOutlet weak var errorValidateLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var confirmeSMSCodeBtn: UIButton!
    @IBOutlet weak var newSMSCodeBtn: UIButton!
    
    var dateFormat = UtilityHelper()
    var country : CountryVModel? = nil
    var numberphoneNew = String()

    var timer = Timer()
    var isTimerRunning = false
    var timeRemaining = 120
    var metadadosView : String = ""
    
    
    
    enum RegisterType:String {
        case smscode_register = "SMSCodeRegister"
        case smscode_new = "SMSCodeNew"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSMSRegister()
    }
    
    func setupSMSRegister(){
         print("CheckSMSCodeAccountViewController: OIIII")
        //self.smscodeContainer.alpha = 0.0
        timerLabel.text = "01:00"
        codeSMS1TextField.delegate = self
        codeSMS2TextField.delegate = self
        codeSMS3TextField.delegate = self
        codeSMS4TextField.delegate = self
        codeSMS1TextField.becomeFirstResponder()
        confirmeSMSCodeBtn.isEnabled = false
        newSMSCodeBtn.isEnabled = false
        //newSMSCodeBtn.isHighlighted = false
        errorValidateLabel.isHidden = true
        runTimer()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 13.4
        let titleLabel = NSLocalizedString("main-title-smscod", comment:"")+"  "+numberphoneNew
        let attrString = NSMutableAttributedString(string: titleLabel)
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        titleSMSCodeLabel.attributedText = attrString
        
        newSMSCodeBtn.setTitle(NSLocalizedString("main-title-receivecode", comment:""), for: .normal)
        
        codeSMS1TextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        codeSMS2TextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        codeSMS3TextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        codeSMS4TextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
    }
    
    @IBAction func closeGeneratorSMSCode(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
    }
    
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(CheckSMSCodeAccountViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    func updateTimer() {
        timeRemaining -= 1     //This will decrement(count down)the seconds.
        
        //   let minutesLeft = Int(timeRemaining) / 60 % 60
        let secondsLeft = Int(timeRemaining) % 60
        
        //  timerLabel.text = "\(minutesLeft):\(secondsLeft)"
        timerLabel.text = "\(00):\(secondsLeft)"
        timerLabel.isHidden = false
        // if minutesLeft == 00 && secondsLeft == 00{
        if secondsLeft == 00{
            timer.invalidate()
            confirmeSMSCodeBtn.isEnabled = false
            newSMSCodeBtn.isEnabled  = true
            newSMSCodeBtn.isHighlighted = false
            timerLabel.isHidden = true
            
            DispatchQueue.main.async {
                let ac = UIAlertController(title: NSLocalizedString(NSLocalizedString("error-title-smsexpired", comment:""), comment:""), message: NSLocalizedString("error-label-smsexpired", comment:""), preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(ac, animated:  true)
            }
        }
    }
    
    
    @IBAction func openScreenSMSCode(_ sender: Any) {
        self.performSegue(withIdentifier:URLConstants.IAM.smscode_new, sender: nil)
    }
    
    func validateSMSCodeAndChangeNumberPhone(){
        let smsCode = codeSMS1TextField.text!+codeSMS2TextField.text!+codeSMS3TextField.text!+codeSMS4TextField.text!
        let dateNow = dateFormat.dateConvertToString()
        let paramsDictionary : String = GlobalVariables.sharedManager.usernameNumberphone+"/"+numberphoneNew+"/"+smsCode+"/"+dateNow
        
        print("PARAMETERS: \(paramsDictionary)")
        
        let url = URLConstants.IAM.iamManager_http+"sms/"
        
        print("PARAMETERS: \(url)")

        
        HttpClientApi.instance().makeAPICall(url: url, params:paramsDictionary, method: .GET, success: { (data, response, error) in
            
            if response?.statusCode == URLConstants.HTTP_STATUS_CODE.OK{
                GlobalVariables.sharedManager.usernameNumberphone = self.numberphoneNew
                GlobalVariables.sharedManager.countryCodInstance = (self.country?.cod)!
                GlobalVariables.sharedManager.countryImageInstance = self.country?.countryImage
                
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier:"CheckSMSCodeToHomePackSend", sender: nil)
                }
            }
        }, failure: { (data, response, error) in
            
                    print("ERROR : \(paramsDictionary)")
            if response?.statusCode == URLConstants.HTTP_STATUS_CODE.NOTFOUND{
                DispatchQueue.main.async {
                    self.errorValidateLabel.isHidden = false
                    self.errorValidateLabel.text = NSLocalizedString("error-label-smsinvalid", comment:"")
                }
            }
            if response?.statusCode == URLConstants.HTTP_STATUS_CODE.FAIL{
                  print("ERROR : \(URLConstants.HTTP_STATUS_CODE.FAIL)")
                DispatchQueue.main.async {
                    let ac = UIAlertController(title: NSLocalizedString(NSLocalizedString("error-title-failconnection", comment:""), comment:""), message: NSLocalizedString("error-msg-failconnection", comment:""), preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated:  true)
                }
            }
        })
    }
    
    func textFieldDidChange(textField: UITextField){
        let text = textField.text
        if metadadosView == RegisterType.smscode_register.rawValue{
            if text?.utf16.count==1{
                switch textField{
                case codeSMS1TextField:
                    codeSMS2TextField.becomeFirstResponder()
                case codeSMS2TextField:
                    codeSMS3TextField.becomeFirstResponder()
                case codeSMS3TextField:
                    codeSMS4TextField.becomeFirstResponder()
                case codeSMS4TextField:
                    confirmeSMSCodeBtn.isEnabled = true
                    validateSMSCodeAndChangeNumberPhone()
                default:
                    break
                }
            }
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
            confirmeSMSCodeBtn.isEnabled = true
            message += NSLocalizedString("error-label-smscode1", comment:"")
            alertWithTitle(title: title, message: message, ViewController: self, toFocus:self.codeSMS1TextField)
        }
        else if codeSMS2TextField.text!.isEmpty
        {
            errors = true
            confirmeSMSCodeBtn.isEnabled = true
            message += NSLocalizedString("error-label-smscode2", comment:"")
            alertWithTitle(title: title, message: message, ViewController: self, toFocus:self.codeSMS2TextField)
        }
        else if codeSMS3TextField.text!.isEmpty
        {
            errors = true
            confirmeSMSCodeBtn.isEnabled = true
            message += NSLocalizedString("error-label-smscode3", comment:"")
            alertWithTitle(title: title, message: message, ViewController: self, toFocus:self.codeSMS3TextField)
        }
        else if codeSMS4TextField.text!.isEmpty
        {
            errors = true
            confirmeSMSCodeBtn.isEnabled = true
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
    
    @IBAction func newSMSCode(_ sender: Any) {
        generatorNewSMSCode()
    }
    
    func generatorNewSMSCode() {
        let dateNow = dateFormat.dateConvertToString()
        let paramsDictionary : String = numberphoneNew+"/"+dateNow
        let url = URLConstants.IAM.iamIdentity_http
        
        HttpClientApi.instance().makeAPICall(url: url, params:paramsDictionary, method: .GET, success: { (data, response, error) in
            if let data = data {
                do{
                    if response?.statusCode == URLConstants.HTTP_STATUS_CODE.OK{
                        DispatchQueue.main.async {
                            self.timeRemaining = 120
                            self.runTimer()
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
    
    
}
