//
//  CountryService.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 23/08/2019.
//  Copyright © 2019 Ricardo Marzochi. All rights reserved.
//

import Foundation
import UIKit

class CountryService: NSObject {
    
    static func instance() ->  CountryService{
        return CountryService()
    }
    
    func findCountryByIDCode(idcountry : String,
        resultOperation:@escaping ( [String:  Any]?,HTTPURLResponse?, NSError? ) -> Void) {
        
        let country_url = URLConstants.COUNTRY.country_http
        let paramsDictionary : String = idcountry
        
        HttpClientApi.instance().makeAPICall(url: country_url, params:paramsDictionary, method: .GET, success: { (data, response, error) in
            
            if response?.statusCode == URLConstants.HTTP_STATUS_CODE.OK{
                let jsonAccount = try! JSONSerialization.jsonObject(with: data!, options: []) as? [String:  Any]
                let data = jsonAccount
                resultOperation(data , response , error as NSError?)
            }
        }, failure: { (data, response, error) in
            resultOperation(nil , response , error as NSError?)
        })
    }
            
            /*
            if response?.statusCode == URLConstants.HTTP_STATUS_CODE.OK{
                resultOperation(data , response , error as NSError?)
            }
            else if response?.statusCode == URLConstants.HTTP_STATUS_CODE.NOTFOUND{
                resultOperation(data , response , error as NSError?)
            }
            else{
                resultOperation(data , response , error as NSError?)
            }
        }, failure: <#(Data?, HTTPURLResponse?, NSError?) -> Void#>); in
            resultOperation(data , response as? HTTPURLResponse, error as NSError?)
    }
  */
}
