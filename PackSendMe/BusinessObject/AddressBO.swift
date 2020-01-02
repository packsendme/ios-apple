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
    var dateOperation : String?
    
    public var addressMain: String = "main"
    public var addressSecond: String = "second"
    public var addressTypeJob: String = "addressJob"
    public var addressTypeHome: String = "addressHome"
    
    init(){
    }
    
    init(address:String, city:String, country:String, type:String, main:String, dateOperation:String) {
        self.address = address
        self.city = city
        self.country = country
        self.type = type
        self.main = main
        self.dateOperation = dateOperation
    }

    func createAddressArray(jsonAddress : [String: Any]) -> [AddressBO]{
        var addressCollection = [AddressBO]()
        var addressNamesL : [String] = [""]
        let addressArray = jsonAddress["address"] as? [[String:Any]]
        var addressObj = AddressBO()
        if addressArray != nil {
            for address in addressArray! {
                if address["main"] as! String == addressMain {
                    //let nameDescription = address["address"] as? String
                    //addressNamesL = addressParser(addressParser: nameDescription!)
                    addressObj.address = address["address"] as? String
                    addressObj.city = address["city"] as? String
                    addressObj.country = address["country"] as? String
                    addressObj.type = address["type"] as? String
                    addressObj.main = address["main"] as? String
                    addressCollection.append(addressObj)
                }
            }
        }
        return addressCollection
    }
    
    func addressParser(addressParser : String) -> [String] {
        let delimiter = ","
        var token = addressParser.components(separatedBy: delimiter)
        print("A", token[0])
        print("B", token[1])
        print("C", token[2])
        return token
    }
    
    func addressObjectToArray(address:String, type:String, main:String, dateUpdate:String) -> Dictionary<String, Any> {
        var addressL = [String:Any]()
        let addressNamesL = addressParser(addressParser: address)
        addressL["address"] = addressNamesL[0]
        addressL["city"] = addressNamesL[1]
        addressL["country"] = addressNamesL[2]
        addressL["type"] = type
        addressL["main"] = main
         addressL["dateOperation"] = dateUpdate
        return addressL
    }

}
