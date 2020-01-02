//
//  CheckSMSCodeAccountViewController.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 28/01/2019.
//  Copyright © 2019 Ricardo Marzochi. All rights reserved.
//

import UIKit

class APSCheckViewController: UIViewController, UITextFieldDelegate {
    
    // New SMS Code - UIVIEM
    
    @IBOutlet weak var titleSMSCodeLabel: UILabel!
    
    // Validate SMS Code - UIVIEM
    @IBOutlet weak var codeSMS1TextField: UITextField!
    @IBOutlet weak var codeSMS2TextField: UITextField!
    @IBOutlet weak var codeSMS3TextField: UITextField!
    @IBOutlet weak var codeSMS4TextField: UITextField!
    @IBOutlet weak var errorValidateLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var newSMSCodeBtn: UIButton!
    
    var boxActivityView = UIView()
    var activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    var iamService = IdentityService()
    var dateFormat = UtilityHelper()
    var country : CountryBO? = nil
    var numberphoneNew = String()
    var smsService = SMSCodeService()

    var timer = Timer()
    var isTimerRunning = false
    var timeRemaining = 120
    var metadadosView : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSMS()
    }
    
    func setupSMS(){
        //self.smscodeContainer.alpha = 0.0
        timerLabel.text = "01:00"
        codeSMS1TextField.delegate = self
        codeSMS2TextField.delegate = self
        codeSMS3TextField.delegate = self
        codeSMS4TextField.delegate = self
        codeSMS1TextField.becomeFirstResponder()
        newSMSCodeBtn.isEnabled = false
        newSMSCodeBtn.isHighlighted = false
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
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(APSCheckViewController.updateTimer)), userInfo: nil, repeats: true)
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
            newSMSCodeBtn.isEnabled  = true
          //  newSMSCodeBtn.isHighlighted = true
            newSMSCodeBtn.backgroundColor = UIColor(red:0.00, green:0.64, blue:1.00, alpha:1.0)

            timerLabel.isHidden = true
            
            DispatchQueue.main.async {
                let ac = UIAlertController(title: NSLocalizedString(NSLocalizedString("error-title-smsexpired", comment:""), comment:""), message: NSLocalizedString("error-label-smsexpired", comment:""), preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(ac, animated:  true)
            }
        }
    }
    
    
    @IBAction func openScreenSMSCode(_ sender: Any) {
        self.performSegue(withIdentifier:"AAA", sender: nil)
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        
        if textField == codeSMS1TextField{
            if codeSMS1TextField.text!.count == 1{
                codeSMS1TextField.backgroundColor = UIColor(red:0.89, green:0.79, blue:0.79, alpha:1.0)
                codeSMS2TextField.becomeFirstResponder()
            }
            else{
                codeSMS1TextField.backgroundColor = UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0)
            }
        }
        else  if textField == codeSMS2TextField{
            if codeSMS2TextField.text!.count == 1{
                codeSMS2TextField.backgroundColor = UIColor(red:0.89, green:0.79, blue:0.79, alpha:1.0)
                codeSMS3TextField.becomeFirstResponder()
            }
            else{
                codeSMS2TextField.backgroundColor = UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0)
            }
        }
        else  if textField == codeSMS3TextField{
            if codeSMS3TextField.text!.count == 1{
                codeSMS3TextField.backgroundColor = UIColor(red:0.89, green:0.79, blue:0.79, alpha:1.0)
                codeSMS4TextField.becomeFirstResponder()
            }
            else{
                codeSMS3TextField.backgroundColor = UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0)
            }
        }
        else  if textField == codeSMS4TextField{
            if codeSMS4TextField.text!.count == 1{
                codeSMS4TextField.backgroundColor = UIColor(red:0.89, green:0.79, blue:0.79, alpha:1.0)
                validateSMSAndUpdateUsername()
            }
            else{
                codeSMS4TextField.backgroundColor = UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0)
            }
        }
    }

    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    func checkForErrors() -> Bool
    {
        var errors = false
        let title = "Error"
        var message = ""
        
        if codeSMS1TextField.text!.isEmpty {
            errors = true
            message += NSLocalizedString("error-label-smscode1", comment:"")
            alertWithTitle(title: title, message: message, ViewController: self, toFocus:self.codeSMS1TextField)
        }
        else if codeSMS2TextField.text!.isEmpty
        {
            errors = true
            message += NSLocalizedString("error-label-smscode2", comment:"")
            alertWithTitle(title: title, message: message, ViewController: self, toFocus:self.codeSMS2TextField)
        }
        else if codeSMS3TextField.text!.isEmpty
        {
            errors = true
            message += NSLocalizedString("error-label-smscode3", comment:"")
            alertWithTitle(title: title, message: message, ViewController: self, toFocus:self.codeSMS3TextField)
        }
        else if codeSMS4TextField.text!.isEmpty
        {
            errors = true
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
    
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 1
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if (textField == codeSMS1TextField) {
            codeSMS2TextField.becomeFirstResponder()
        }
        else if (textField == codeSMS2TextField) {
            codeSMS3TextField.becomeFirstResponder()
            
        } else if (textField == codeSMS3TextField) {
            codeSMS4TextField.becomeFirstResponder()
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
    
    @IBAction func newSMSCode(_ sender: Any) {
        newSMSCodeBtn.isEnabled = false
        newSMSCodeBtn.isHighlighted = false
        resignFirstResponder()
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.view.tintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        //to change font of title and message.
        let messageFont = [kCTFontAttributeName: UIFont(name: "Avenir-Roman", size: 18.0)!]
        
        
        let messageAttrString = NSMutableAttributedString(string: NSLocalizedString("main-title-numbercorrect", comment:""), attributes: messageFont as [NSAttributedStringKey : Any] as [String : Any])
        
        alertController.setValue(messageAttrString, forKey: "attributedMessage")
        
        let numberLabel = UILabel(frame: CGRect(x: 100, y: 20, width: 1000, height: 65))
        numberLabel.text = numberphoneNew
        numberLabel.textColor = UIColor.red
        numberLabel.font = UIFont(name: "HelveticaNeue", size: CGFloat(18.0))
        
        let sendsmsAction = UIAlertAction(title: NSLocalizedString("main-button-codeforward", comment:""), style: UIAlertActionStyle.default, handler: { alert -> Void in
            self.generatorNewSMSCode()
        })
        let changePhoneAction = UIAlertAction(title: NSLocalizedString("main-button-cancelcode", comment:""), style: UIAlertActionStyle.default, handler: {
            alert -> Void in
            self.dismiss(animated: true, completion: nil)
        })
        alertController.view.addSubview(numberLabel)
        alertController.addAction(sendsmsAction)
        alertController.addAction(changePhoneAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setTitleNewSMSCode(){
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 13.4
        let titleLabel = NSLocalizedString("main-title-newsmscode", comment:"")+"  "+numberphoneNew
        let attrString = NSMutableAttributedString(string: titleLabel)
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        titleSMSCodeLabel.attributedText = attrString
    }
    
    
    func activityActionStart(title : String) {
        // You only need to adjust this frame to move it anywhere you want
        boxActivityView = UIView(frame: CGRect(x: view.frame.midX - 45, y: view.frame.midY - 40, width:50, height: 50))
        boxActivityView.backgroundColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0)
        //UIColor.lightGray
        boxActivityView.alpha = 0.9
        boxActivityView.layer.cornerRadius = 10
        //Here the spinnier is initialized
        activityView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityView.color = UIColor.black
        activityView.startAnimating()
        let textLabel = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
        textLabel.textColor = UIColor.black
        textLabel.text = ""
        boxActivityView.addSubview(activityView)
        boxActivityView.addSubview(textLabel)
        view.addSubview(boxActivityView)
    }
    
    func activityActionStop() {
        //When button is pressed it removes the boxView from screen
        self.boxActivityView.removeFromSuperview()
        self.activityView.stopAnimating()
    }

    
// ################################# HTTP #################################################################//
    
    
    // -------------------------------------------------------------------------------------
    // FUNCTION : Generar New SMS Code
    // MICROSERVICE : sms
    // ENTITY :
    // -------------------------------------------------------------------------------------
    func generatorNewSMSCode() {
        activityActionStart(title : NSLocalizedString("main-status-newsms", comment:""))
        smsService.getNewSMS(username : numberphoneNew){(success, response, error) in
        
        if success == true{
                    DispatchQueue.main.async {
                        UIView.transition(with: self.view,
                                          duration:0.1,
                                          options: .transitionCrossDissolve,
                                          animations: {
                                            self.activityActionStop()
                                            self.setTitleNewSMSCode()
                                            self.runTimer()},
                                          completion: nil)
                    }
            }
            else{
                DispatchQueue.main.async {
                    self.activityActionStop()
                    let ac = UIAlertController(title: NSLocalizedString("error-title-failconnection", comment:""), message: NSLocalizedString("error-body-failconnection", comment:""), preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated:  true)
                }
            }
        }
    }

    
    func validateSMSAndUpdateUsername(){
        let smsCode = codeSMS1TextField.text!+codeSMS2TextField.text!+codeSMS3TextField.text!+codeSMS4TextField.text!
        activityActionStart(title : NSLocalizedString("a-action-lbl-validationcode", comment:""))
        iamService.putUsernamePhone(usernameNew: numberphoneNew, codeSMS: smsCode){
            (success, response, error) in
            if success == true{
                DispatchQueue.main.async {
                    GlobalVariables.sharedManager.usernameNumberphone = self.numberphoneNew
                    GlobalVariables.sharedManager.countryCodInstance = (self.country?.cod)!
                    GlobalVariables.sharedManager.countryImageInstance = self.country?.countryImage
                    self.performSegue(withIdentifier:"AHMainViewController", sender: nil)
                }
            }
            if success == false && response as! Int == URLConstants.HTTP_STATUS_CODE.NOTFOUND {
                DispatchQueue.main.async {
                    self.activityActionStop()
                    self.errorValidateLabel.isHidden = false
                    self.errorValidateLabel.text = NSLocalizedString("error-label-smsinvalid", comment:"")
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
