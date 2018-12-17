//
//  EditEmailViewController.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 16/12/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import UIKit

class EditEmailViewController: UIViewController {

    
    
    @IBOutlet weak var editEmailTitleLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var updateEmailBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.becomeFirstResponder()
        updateEmailBtn.isEnabled = false
        editEmailTitleLabel.text = NSLocalizedString("editemail-label-title", comment:"")
        updateEmailBtn.setTitle(NSLocalizedString("editemail-title-btn", comment:""), for: .normal)
            
    }
    
    @IBAction func updateEmailAction(_ sender: Any) {
    }
    
    
    @IBAction func goBackAction(_ sender: Any) {
        let transition = CATransition()
        transition.duration = 0.1
        transition.type = kCATransition
        transition.subtype = kCATransitionFromBottom
        dismiss(animated: false, completion: nil)     
    }
    

}
