//
//  FirstNameEditViewController.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 16/12/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import UIKit



class FirstNameEditViewController: UIViewController {

    @IBOutlet weak var editFirstnameTitleLabel: UILabel!
    @IBOutlet weak var firstnameLabel: UILabel!
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var updateFirstnameBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstnameTextField.becomeFirstResponder()
        updateFirstnameBtn.isEnabled = false
        editFirstnameTitleLabel.text = NSLocalizedString("editfirstname-label-title", comment:"")
        updateFirstnameBtn.setTitle(NSLocalizedString("editfirstname-title-btn", comment:""), for: .normal)

        
    }
    
    
 
    @IBAction func updateFirstnameAction(_ sender: Any) {
    }
    
    
    @IBAction func goBackAction(_ sender: Any) {
        let transition = CATransition()
        transition.duration = 0.1
        transition.type = kCATransition
        transition.subtype = kCATransitionFromBottom
        dismiss(animated: false, completion: nil)
    }
    
}
