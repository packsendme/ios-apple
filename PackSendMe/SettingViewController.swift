//
//  SettingTableViewController.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 09/12/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import UIKit

class SettingViewController: UITableViewController {

    
     // @IBOutlet weak var settingTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
   //     settingTable.delegate = self
    //    settingTable.dataSource = self
       // loadAccount()
    }
    
    func loadAccount(){
        GlobalVariables.sharedManager.username = "+5596064241"
        let paramsDictionary : String = GlobalVariables.sharedManager.username+URLConstants.ACCOUNT.account_load
        let url = URLConstants.ACCOUNT.account_http
        
        print (" URL NOW = \(url)")
        
        HttpClientApi.instance().makeAPICall(url: url, params:paramsDictionary, method: .GET, success: { (data, response, error) in
            //print (" URL statusCode = \(response?.statusCode)")
            if let data = data {
                do{
                    if response?.statusCode == URLConstants.HTTP_STATUS_CODE.OK{
                        let json = data as? [String: Any]
                        self.parseHTTPDataToAccountModel(jsonResponse: json!)
                    }
                    else if response?.statusCode == URLConstants.HTTP_STATUS_CODE.FOUND{
                        let ac = UIAlertController(title: NSLocalizedString("error-title-failconnection", comment:""), message: NSLocalizedString("error-body-failconnection", comment:""), preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated:  true)
                    }
                } catch _ {
                    DispatchQueue.main.async {
                        let ac = UIAlertController(title: NSLocalizedString("error-title-failconnection", comment:""), message: NSLocalizedString("error-body-failconnection", comment:""), preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated:  true)
                    }
                }
            }
        }, failure: { (data, response, error) in
            DispatchQueue.main.async {
                let ac = UIAlertController(title: NSLocalizedString(NSLocalizedString("error-title-failconnection", comment:""), comment:""), message: NSLocalizedString("error-msg-failconnection", comment:""), preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(ac, animated:  true)
            }
        })

    }
    
    func parseHTTPDataToAccountModel(jsonResponse : [String: Any]){
                print (" URL email = \(jsonResponse["email"])")
        
    }

    // MARK: - Table view data source
/*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
*/
  
}
