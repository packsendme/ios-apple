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
    
    var countriesData: [CountryBO] = []
    var countryObj = CountryBO()
    
    static func instance() ->  CountryService{
        return CountryService()
    }
    
    func findDetailCountryByID(idcountry : String, completion: @escaping (Bool, Any?, Error?) -> Void){
        let country_url = URLConstants.COUNTRY.country_http
        let paramsDictionary : String = idcountry
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1){
            HttpService.instance().makeAPICall(url: country_url, params:paramsDictionary, method: .GET, success: { (data, response, error) in
                if let data = data {
                    do{
                        if response?.statusCode == URLConstants.HTTP_STATUS_CODE.OK{
                            let jsonCountry = try! JSONSerialization.jsonObject(with: data, options: []) as? [String:  Any]
                            let countriesData = self.countryObj.getCountryFromJson(json: jsonCountry!)
                            DispatchQueue.main.async {
                                completion(true,countriesData,nil)
                            }
                        }
                    } catch _ {
                        DispatchQueue.main.async {
                            completion(false,nil,error)
                        }
                    }
                }
            }, failure: {  (data, response, error) in
                DispatchQueue.main.async {
                    completion(false,nil,error)
                }
            })
        }
    }
    
    func findCountryAll(completion: @escaping (Bool, Any?, Error?) -> Void){
         DispatchQueue.global().asyncAfter(deadline: .now() + 2	){
            print(" Dispatch Finalizado")
            var countriesData: [CountryBO] = []
            let country_url = URLConstants.COUNTRY.country_http
        
            HttpService.instance().makeAPICall(url: country_url, params:nil, method: .GET, success: { (data, response, error) in
                if let data = data {
                    do{
                        if response?.statusCode == URLConstants.HTTP_STATUS_CODE.OK{
                            let jsonCountry = try! JSONSerialization.jsonObject(with: data, options: []) as? [String:  Any]
                            countriesData = self.countryObj.getCountriesFromJson(countriesJson: jsonCountry!)
                            print("CODE before \(countriesData.count)")
                            
                            DispatchQueue.main.async {
                                completion(true,countriesData,nil)
                            }
                        }
                    } catch _ {
                        DispatchQueue.main.async {
                            completion(false,nil,error)
                        }
                    }
                }
            }, failure: {  (data, response, error) in
                DispatchQueue.main.async {
                    completion(false,nil,error)
                }
            })
        }
    }
}
