//
//  ManagerProfileUserViewController.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 27/12/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import UIKit

class ManagerProfileUserViewController: UIViewController {
    
    // Edit Name
    @IBOutlet weak var nameTitleLabel: UILabel!
    @IBOutlet weak var firstnameFieldLabel: UILabel!
    @IBOutlet weak var lastnameFieldLabel: UILabel!
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lasnameTextField: UITextField!
    @IBOutlet weak var updatenameBtn: UIButton!
  
    // Edit EMAIL
    @IBOutlet weak var emailTitleLabel: UILabel!
    @IBOutlet weak var emailFieldLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var updateemailBtn: UIButton!

    
    // Edit Password
    @IBOutlet weak var passwordTitleLabel: UILabel!
    @IBOutlet weak var passwordnewView: UIView!
    @IBOutlet weak var passwordFieldLabel: UILabel!
    @IBOutlet weak var passwordnewTextField: UITextField!
    @IBOutlet weak var passwordnewBtn: UIButton!
    
    @IBOutlet weak var passwordcurrentView: UIView!
    @IBOutlet weak var passwordcurrentLabel: UILabel!
    @IBOutlet weak var passwordcurrentTextField: UITextField!
    @IBOutlet weak var passwordverifyBtn: UIButton!
    
    // Edit PhoneNumber
    @IBOutlet weak var phonenumberTitleLabel: UILabel!
    @IBOutlet weak var phonenumberFieldLabel: UILabel!
    @IBOutlet weak var phonenumberTextField: UITextField!
    @IBOutlet weak var updatephoneBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setupName(){
        
    }
    
    func setupEmail(){
        
    }
    
    func setupPassword(){
        
    }

    func setupPhoneNumber(){
        
    }
    
    @IBAction func updateNameAction(_ sender: Any) {
    }
    
    @IBAction func updateEmailAction(_ sender: Any) {
    }
    
    @IBAction func updatePasswordAction(_ sender: Any) {
    }
    
    @IBAction func passwordVerify(_ sender: Any) {
    }
    
    @IBAction func updatePhoneNumberAction(_ sender: Any) {
    }
}
