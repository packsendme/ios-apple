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
    
    
    @IBAction func nextBtn(_ sender: Any) {
        validateUsernameFirstUserAccess(){
            code in print(code)
        }
    }
    
    func validateUsernameFirstUserAccess(completion: @escaping (Int) -> ()) {
        NSLog("VALIDADO USERNAME")
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 20.0
        sessionConfig.timeoutIntervalForResource = 60.0
        let session = URLSession(configuration: sessionConfig)
        
        // let session = URLSession.shared
        let dateNow = dateFormat.dateConvertToString()
        print (" DATA NOW = \(dateNow)")
        
        let parameter = usernamecodeLabel.text!+usernameTexField.text!+"/"+dateNow
        let urlparameter : String = URLConstants.IAM.iamIdentity_http+parameter
        print (" URL NOW = \(urlparameter)")
        
        let request = NSMutableURLRequest(url: NSURL(string: urlparameter)! as URL)
        var statusCode : Int = 0
        var user = UserModel()
        
        
        
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTask(with: request as URLRequest as URLRequest, completionHandler: {(data, response, error) in
            do{

                if let response = response {
                    let nsHTTPResponse = response as! HTTPURLResponse
                    statusCode = nsHTTPResponse.statusCode
                    print (" RESPONSE  code = \(statusCode)")
                }
                if let error = error {
                    DispatchQueue.main.async {
                        let ac = UIAlertController(title: NSLocalizedString("error-title-failconnection", comment:""), message: NSLocalizedString("error-body-failconnection", comment:""), preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated:  true)
                    }
                    completion(statusCode) // or return an error cod
                    return
                }
                if let data = data {
                     print ("DATA code = \(statusCode)")
                    do{
                        let jsonResponse = try JSONSerialization.jsonObject(with: data,options: []) as! [String: AnyObject]
                        
                        
                        if statusCode == URLConstants.HTTP_STATUS_CODE.FAIL{
                            DispatchQueue.main.async {
                                let ac = UIAlertController(title: NSLocalizedString("error-title-failconnection", comment:""), message: NSLocalizedString("error-body-failconnection", comment:""), preferredStyle: .alert)
                                ac.addAction(UIAlertAction(title: "OK", style: .default))
                                self.present(ac, animated:  true)
                            }
                        }
                        else if statusCode == URLConstants.HTTP_STATUS_CODE.FOUND{
                            print("USERNAME - FOUND")
                            GlobalVariables.sharedManager.username = parameter
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "LoginViewController", sender: nil)
                            }
                            completion(statusCode) // or return an error cod
                            return
                         }
                        
                        else if statusCode == URLConstants.HTTP_STATUS_CODE.ACCEPT{
                            print("USERNAME - REGISTER")
                            let dictionary = jsonResponse["body"] as! [String: AnyObject]
                            user = UserModel(json: dictionary as [String : Any])
                            GlobalVariables.sharedManager.username = user.username!
                            GlobalVariables.sharedManager.activationKey = user.activationKey!
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "CheckSMSCodeViewController", sender: nil)
                            }
                            completion(statusCode) // or return an error cod
                            return
                        }
                        
                    }catch _ {
                        DispatchQueue.main.async {
                            let ac = UIAlertController(title: NSLocalizedString("error-title-failconnection", comment:""), message: NSLocalizedString("error-body-failconnection", comment:""), preferredStyle: .alert)
                            ac.addAction(UIAlertAction(title: "OK", style: .default))
                            self.present(ac, animated:  true)
                        }
                        completion(statusCode) // or return an error cod
                        return
                    }
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
        if (text?.utf16.count)! >= 4{
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

    
    func callCheckSMSCode() {
        let checkSMSView = storyboard?.instantiateViewController (withIdentifier: "CheckSMSCodeViewController") as! CheckSMSCodeViewController
        self.present(checkSMSView, animated: true, completion: nil)
    }
    
    
    
    /*
     @IBAction func btn_validateUsername(_ sender: Any) {
     let session = URLSession.shared
     let request = NSMutableURLRequest(url: NSURL(string: URLConstants.IAM.usernameFirstUserAccess)! as URL)
     request.httpMethod = "POST"
     request.addValue("application/json", forHTTPHeaderField: "Content-Type")
     let username : String = codenumberLabel.text!+numberphoneTextField.text!
     let params : [String] = [username]
     print ("status code = \(params)")
     
     do{
     request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions())
     let task = session.dataTask(with: request as URLRequest as URLRequest, completionHandler: {(data, response, error) in
     if let response = response {
     let nsHTTPResponse = response as! HTTPURLResponse
     let statusCode = nsHTTPResponse.statusCode
     print ("status code = \(statusCode)")
     }
     if let error = error {
     print ("\(error)")
     }
     if let data = data {
     do{
     let jsonResponse = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
     print ("data = \(jsonResponse)")
     }catch _ {
     print ("OOps not good JSON formatted response")
     }
     }
     })
     task.resume()
     }catch _ {
     print ("Oops something happened buddy")
     }
     
     
     }
     
 */
   
}
