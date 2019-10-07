//
//  AddressDto.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 10/07/2019.
//  Copyright © 2019 Ricardo Marzochi. All rights reserved.
//

import Foundation
 
public struct AddressBO: Codable {
    var address: String?
    var city: String?
    var country: String?
    var type: String?
    var main: String?
    
    
    func createAddressArray(jsonAddress : [String: Any]) -> [AddressBO]{
        var addressCollection = [AddressBO]()
        var addressNamesL : [String] = [""]
        let addressParser = ParserHelper()
        let addressArray = jsonAddress["address"] as? [[String:Any]]

        if addressArray != nil {
            for address in addressArray! {
                if address["main"] as! String == GlobalVariables.sharedManager.addressMain {
                    let nameDescription = address["address"] as? String
                    addressNamesL = addressParser.addressParser(addressParser: nameDescription!)
                    let addressObj = AddressBO(
                        address: addressNamesL[0],
                        city: addressNamesL[1],
                        country: addressNamesL[2],
                        type: address["type"] as? String,
                        main: address["main"] as? String)
                    addressCollection.append(addressObj)
                }
            }
        }
        return addressCollection
    }
}
