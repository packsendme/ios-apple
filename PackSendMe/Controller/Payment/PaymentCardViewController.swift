//
//  CardPaymentViewController.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 24/06/2019.
//  Copyright © 2019 Ricardo Marzochi. All rights reserved.
//

import Foundation
import UIKit

class PaymentCardViewController: UIViewController {

    @IBOutlet weak var titleCardPayLabel: UILabel!
    
    @IBOutlet weak var cardnameCardPayLabel: UILabel!
    @IBOutlet weak var cardnameCardPayTextField: UITextField!
    @IBOutlet weak var cardnamenotifCardPayLabel: UILabel!
    
    @IBOutlet weak var cardnumberCardPayLabel: UILabel!
    @IBOutlet weak var cardnumberCardPayTextField: UITextField!
    @IBOutlet weak var cardnumbernotifCardPayLabel: UILabel!

    @IBOutlet weak var cardexpdateCardPayLabel: UILabel!
    @IBOutlet weak var cardexpdateCardPayTextField: UITextField!
    @IBOutlet weak var cardexpdatenotifCardPayLabel: UILabel!
    
    @IBOutlet weak var cardcvvCardPayLabel: UILabel!
    @IBOutlet weak var cardcvvCardPayTextField: UITextField!
    @IBOutlet weak var cardcvvnotifCardPayLabel: UILabel!
    @IBOutlet weak var saveupdateBtn: UIButton!
    
    
    
}
