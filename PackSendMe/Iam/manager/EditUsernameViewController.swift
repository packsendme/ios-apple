//
//  EditUsernameViewController.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 16/12/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import UIKit

class EditUsernameViewController: UIViewController {

    
    @IBOutlet weak var editUsernameTitleLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var updateUsernameBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.becomeFirstResponder()
        updateUsernameBtn.isEnabled = false
        editUsernameTitleLabel.text = NSLocalizedString("editusername-label-title", comment:"")
        updateUsernameBtn.setTitle(NSLocalizedString("editusername-title-btn", comment:""), for: .normal)


    }
    
    @IBAction func updateUsernameAction(_ sender: Any) {
    }
    
    
    @IBAction func goBackAction(_ sender: Any) {
        let transition = CATransition()
        transition.duration = 0.1
        transition.type = kCATransition
        transition.subtype = kCATransitionFromBottom
        dismiss(animated: false, completion: nil)
    }
}
