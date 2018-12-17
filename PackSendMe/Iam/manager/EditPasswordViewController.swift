//
//  EditPasswordViewController.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 16/12/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import UIKit

class EditPasswordViewController: UIViewController {

    @IBOutlet weak var editPasswordTitleLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var updatePasswordBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        passwordTextField.becomeFirstResponder()
        updatePasswordBtn.isEnabled = false
        editPasswordTitleLabel.text = NSLocalizedString("editpassword-label-title", comment:"")
        updatePasswordBtn.setTitle(NSLocalizedString("editpassword-title-btn", comment:""), for: .normal)

    }
    
    
    @IBAction func updatePasswordAction(_ sender: Any) {
        
    }
    
    @IBAction func goBackAction(_ sender: Any) {
        let transition = CATransition()
        transition.duration = 0.1
        transition.type = kCATransition
        transition.subtype = kCATransitionFromBottom
        dismiss(animated: false, completion: nil)
    }
    
}
