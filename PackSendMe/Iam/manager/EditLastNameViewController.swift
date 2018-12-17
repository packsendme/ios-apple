//
//  EditLastNameViewController.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 16/12/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import UIKit

class EditLastNameViewController: UIViewController {
    
    
    @IBOutlet weak var editLastnameTitleLabel: UILabel!
    @IBOutlet weak var lastnameLabel: UILabel!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var updatelastnameBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lastnameTextField.becomeFirstResponder()
        updatelastnameBtn.isEnabled = false
        editLastnameTitleLabel.text = NSLocalizedString("editlastname-label-title", comment:"")
        updatelastnameBtn.setTitle(NSLocalizedString("editlastname-title-btn", comment:""), for: .normal)

    }
    
    @IBAction func goBackAction(_ sender: Any) {
        let transition = CATransition()
        transition.duration = 0.1
        transition.type = kCATransition
        transition.subtype = kCATransitionFromBottom
        dismiss(animated: false, completion: nil)     
    }
    
    
    @IBAction func updateLastNameAction(_ sender: Any) {
   
    }
    

}
