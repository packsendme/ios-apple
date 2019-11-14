//
//  AMPOperationEnum.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 27/10/2019.
//  Copyright © 2019 Ricardo Marzochi. All rights reserved.
//

import UIKit

enum amUpdateProfile:String {
    case name = "names"
    case email = "email"
    case password = "password"
    case username = "username" // phonumber
}

enum amCountryViewReturn:String {
    case ampSettingViewController = "AMPSettingViewController"
    case amPaymentCard = "CardPaymentViewController"
}
