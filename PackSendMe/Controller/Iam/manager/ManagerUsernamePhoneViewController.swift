//
//  ManagerUsernamePhoneViewController.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 20/08/2019.
//  Copyright © 2019 Ricardo Marzochi. All rights reserved.
//

import UIKit

class ManagerUsernamePhoneViewController: UIViewController, UITextFieldDelegate  {

    // Edit PhoneNumber
    @IBOutlet weak var newphoneLabel: UILabel!
    @IBOutlet weak var phonenumberTitleLabel: UILabel!
    @IBOutlet weak var codenumberLabel: UILabel!
    @IBOutlet weak var countrycodeBtn: UIButton!
    @IBOutlet weak var phonenumberTextField: UITextField!
    @IBOutlet weak var updatephoneBtn: UIButton!
    @IBOutlet weak var phoneValidateLabel: UILabel!

    var country : CountryVModel? = nil
    var numberphoneOld = String()
    var dateFormat = UtilityHelper()
    var formatPlaceHoldName = UtilityHelper()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        codenumberLabel.text = country?.cod
        newphoneLabel.text = NSLocalizedString("editusername-label-newphone", comment:"")
        phonenumberTitleLabel.text = NSLocalizedString("editusername-label-title", comment:"")
        updatephoneBtn.setTitle(NSLocalizedString("editusername-title-btn", comment:"") , for: .normal)
        phonenumberTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        phoneValidateLabel.text = NSLocalizedString("editusername-label-usernamevalidate", comment:"")
        
        let phonenumberdNewHolder : String = NSLocalizedString("editusername-text-username", comment:"")
        phonenumberTextField.attributedPlaceholder = formatPlaceHoldName.setPlaceholder(nameholder : phonenumberdNewHolder)
        countrycodeBtn.setImage(country?.countryImage, for: .normal)
        phonenumberTextField.becomeFirstResponder()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "ManagerProfileUserToCheckSMSCodeAccountView") {
            let something = segue.destination as! CheckSMSCodeAccountViewController
            something.numberphoneNew = codenumberLabel.text!+phonenumberTextField.text!
            something.metadadosView = URLConstants.IAM.smscode_register
            something.country = country!
        }
        else if (segue.identifier == "ManagerUsernamePhoneViewControllerGoCountryAccount") {
            let something = segue.destination as! CountryAccountViewController
            something.countryDto = country!
            something.operationTypeController = GlobalVariables.sharedManager.OP_CHANGE_COUNTRY_NUMBER
        }
    }

    func changeNumberCodPhone(_ sender: Any) {
        self.performSegue(withIdentifier:"PhoneNumberChangeCountry", sender: nil)
    }
    
    func updatePhoneNumberAction(_ sender: Any) {
        if phonenumberTextField.text!.count >= 5{
            checkPhoneNumber()
        }
        else{
            self.phoneValidateLabel.isHidden = false
        }
    }
    
    func textFieldDidChange(textField: UITextField){
        let text = textField.text
        switch textField{
         case phonenumberTextField:
            if (text?.utf16.count)! >= 11  {
                phonenumberTextField.deleteBackward()
            }
        default:
            break
        }
    }
    
    func checkPhoneNumber() {
        let dateNow = dateFormat.dateConvertToString()
        let paramsDictionary : String = codenumberLabel.text!+phonenumberTextField.text!+"/"+dateNow
        let url = URLConstants.IAM.iamIdentity_http
        
        HttpClientApi.instance().makeAPICall(url: url, params:paramsDictionary, method: .GET, success: { (data, response, error) in
                do{
                    if response?.statusCode == URLConstants.HTTP_STATUS_CODE.OK{
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier:"ManagerProfileUserToCheckSMSCodeAccountView", sender: nil)
                        }
                    }
                    else if response?.statusCode == URLConstants.HTTP_STATUS_CODE.FOUND{
                        self.phoneValidateLabel.text = NSLocalizedString("editusername-label-usernameregistered", comment:"")
                        self.phoneValidateLabel.isHidden = false
                    }
                } catch _ {
                    DispatchQueue.main.async {
                        let ac = UIAlertController(title: NSLocalizedString("error-title-failconnection", comment:""), message: NSLocalizedString("error-body-failconnection", comment:""), preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated:  true)
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
