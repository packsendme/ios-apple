//
//  MenuConfigSession.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 09/07/2019.
//  Copyright © 2019 Ricardo Marzochi. All rights reserved.
//

struct MenuConfigSession{
    
    var titleHeader : String
    var menuInformation : [String]
    var typeInformation : String
    

    init(title: String, type: String, objectos:[String]) {
        titleHeader = title
        menuInformation = objectos
        typeInformation = type
    }

}
