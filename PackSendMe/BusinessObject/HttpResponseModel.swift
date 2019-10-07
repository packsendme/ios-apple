//
//  HttpResponseModel.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 24/10/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import Foundation


class HttpResponseModel{
    
    var status: String?
    var message: String?
    var code: Int?
    
    init(code:Int, status:String) {
        self.code = code
        self.status = status
    }
    
    init() {
    }

    
}
