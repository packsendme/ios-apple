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
    
    // New SMS Code - UIVIEM
    
    @IBOutlet weak var sendNewSMSCodeBtn: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var resendSMSTitleLabel: UILabel!
    @IBOutlet weak var usernamecurrentLabel: UILabel!
    @IBOutlet weak var countryselectBtn: UIButton!
    @IBOutlet weak var usernamecodLabel: UILabel!
    @IBOutlet weak var resendSMSBtn: UIButton!
    @IBOutlet weak var cancelSendSMSBtn: UIButton!

    // Validate SMS Code - UIVIEM
    @IBOutlet weak var titleCheckSMSLabel: UILabel!
    @IBOutlet weak var codeSMS1TextField: UITextField!
    @IBOutlet weak var codeSMS2TextField: UITextField!
    @IBOutlet weak var codeSMS3TextField: UITextField!
    @IBOutlet weak var codeSMS4TextField: UITextField!
    @IBOutlet weak var errorValidateLabel: UILabel!
    @IBOutlet weak var changeusernameBtn: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var newSMSCodeBtn: UIButton!
    
    var dateFormat = UtilityHelper()
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
        
        if metadadosView == RegisterType.smscode_register.rawValue{
            setupSMSRegister()
        }
        else if metadadosView == RegisterType.smscode_new.rawValue{
            setupSMSNew()
        }
        
    }
    
    func setupSMSRegister(){
        //self.smscodeContainer.alpha = 0.0
        timerLabel.text = "01:00"
        newSMSCodeBtn.isHidden = true
        codeSMS1TextField.delegate = self
        codeSMS2TextField.delegate = self
        codeSMS3TextField.delegate = self
        codeSMS4TextField.delegate = self
        codeSMS1TextField.becomeFirstResponder()
        nextBtn.isEnabled = false
        newSMSCodeBtn.isEnabled = false
        //newSMSCodeBtn.isHighlighted = false
        errorValidateLabel.isHidden = true
        runTimer()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 13.4
        let titleLabel = NSLocalizedString("main-title-smscod", comment:"")+"  "+GlobalVariables.sharedManager.username
        let attrString = NSMutableAttributedString(string: titleLabel)
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        titleCheckSMSLabel.attributedText = attrString
        
        newSMSCodeBtn.setTitle(NSLocalizedString("main-title-receivecode", comment:""), for: .normal)
        changeusernameBtn.setTitle(NSLocalizedString("main-title-editnumber", comment:""), for: .normal)
        
        codeSMS1TextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        codeSMS2TextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        codeSMS3TextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        codeSMS4TextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
    }

    @IBAction func closeGeneratorSMSCode(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
    }
    
    
    
    func setupSMSNew(){
       
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 13.4
        let titleLabel = NSLocalizedString("main-title-codeforward", comment:"")
        let attrString = NSMutableAttributedString(string: titleLabel)
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        resendSMSTitleLabel.attributedText = attrString

        
        usernameLabel.text = GlobalVariables.sharedManager.username
        usernamecodLabel.text = GlobalVariables.sharedManager.countryCodInstance
        countryselectBtn.setImage(GlobalVariables.sharedManager.countryImageInstance, for: .normal)
        
        usernamecurrentLabel.text = NSLocalizedString("main-label-codeforward", comment:"")
        
        sendNewSMSCodeBtn.setTitle(NSLocalizedString("main-button-codeforward", comment:""), for: .normal)
        cancelSendSMSBtn.setTitle(NSLocalizedString("main-button-cancelcode", comment:""), for: .normal)
    }
    
    
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(CheckSMSCodeViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    func updateTimer() {
        timeRemaining -= 1     //This will decrement(count down)the seconds.
        
     //   let minutesLeft = Int(timeRemaining) / 60 % 60
        let secondsLeft = Int(timeRemaining) % 60

      //  timerLabel.text = "\(minutesLeft):\(secondsLeft)"
        timerLabel.text = "\(00):\(secondsLeft)"
        
       // if minutesLeft == 00 && secondsLeft == 00{
         if secondsLeft == 00{
            timer.invalidate()
            nextBtn.isEnabled = false
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == URLConstants.IAM.emailUI) {
            print("EMAIL")
            let something = segue.destination as! DataRegisterViewController
            something.metadadosView = segue.identifier!
            
        } else if (segue.identifier == URLConstants.IAM.passwordUI) {
            print("PasswordRegisterUI")
            let something = segue.destination as! DataRegisterViewController
            something.metadadosView = segue.identifier!
        }
        else if (segue.identifier == URLConstants.IAM.nameUI) {
            print("NameRegisterUI")
            let something = segue.destination as! DataRegisterViewController
            something.metadadosView = segue.identifier!
        }
        else if (segue.identifier == URLConstants.IAM.smscode_new) {
            let something = segue.destination as! CheckSMSCodeViewController
            something.metadadosView = segue.identifier!
        }
        else if (segue.identifier == URLConstants.IAM.smscode_register) {
            let something = segue.destination as! CheckSMSCodeViewController
            something.metadadosView = segue.identifier!
        }
    }

    @IBAction func validateSMSCodeFirstUserAccess(_ sender: Any) {
        let paramsDictionary : String = GlobalVariables.sharedManager.username+"/"+codeSMS1TextField.text!+codeSMS2TextField.text!+codeSMS3TextField.text!+codeSMS4TextField.text!
               
        let url = URLConstants.IAM.iamIdentity_http+"sms/"
        HttpClientApi.instance().makeAPICall(url: url, params:paramsDictionary, method: .GET, success: { (data, response, error) in

            if response?.statusCode == URLConstants.HTTP_STATUS_CODE.FOUND{
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier:URLConstants.IAM.emailUI, sender: nil)
                }
            }
        }, failure: { (data, response, error) in
            
            if response?.statusCode == URLConstants.HTTP_STATUS_CODE.NOTFOUND{
                DispatchQueue.main.async {
                    self.errorValidateLabel.isHidden = false
                    self.errorValidateLabel.text = NSLocalizedString("error-label-smsinvalid", comment:"")
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
                    nextBtn.isEnabled = true
                    validateSMSCodeFirstUserAccess(){
                        code in print(code)
                    }
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
    
    
    @IBAction func generatorNewSMSCode(_ sender: Any) {
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
