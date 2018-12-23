//
//  EditAccountUserViewController.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 16/12/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import UIKit

class ManagerProfileUserViewController: UIViewController {

    
    @IBOutlet weak var photoprofileBtn: UIButton!
    @IBOutlet weak var editAccessInfTitleLabel: UILabel!
    @IBOutlet weak var useraccountLabel: UILabel!
    @IBOutlet weak var accessuserTable: UITableView!
    
    var accountModel : AccountModel? = nil

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        accessuserTable.dataSource = self
        accessuserTable.delegate = self
        editAccessInfTitleLabel.text = NSLocalizedString("setting-title-home", comment:"")
        accessuserTable.rowHeight = UITableViewAutomaticDimension
        accessuserTable.isScrollEnabled = true
        accessuserTable.translatesAutoresizingMaskIntoConstraints = false
        useraccountLabel.text = accountModel?.name
    }
    
    
    @IBAction func hometoolAction(_ sender: Any) {
        self.performSegue(withIdentifier:URLConstants.ACCOUNT.settingToAccountHome, sender: nil)
    }
    
    @IBAction func menutoolAction(_ sender: Any) {
    }
    
}

extension ManagerProfileUserViewController: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    /*
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let rect = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 180)
        let footerView = UIView(frame:rect)
        footerView.backgroundColor = UIColor.clear
        return footerView
    }*/
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 75.0;//Choose your custom row height
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //var country = countriesData[indexPath.section][indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier:"AccessInfoCell") as? ProfileUserViewCell
            else{
                return UITableViewCell()
        }
       
        if indexPath.row == 0{
            //cell.nameFieldUserLabel.font = UIFont(name:"Avenir", size:19)
            cell.nameFieldUserLabel.text = NSLocalizedString("profileuser-title-name", comment:"")
            cell.itemFieldUserLabel.text = accountModel?.name
        }
       else if indexPath.row == 1{
            //cell.nameFieldUserLabel.font = UIFont(name:"Avenir", size:19)
            cell.nameFieldUserLabel.text = NSLocalizedString("profileuser-title-lastname", comment:"")
            cell.itemFieldUserLabel.text = accountModel?.lastname
        }
        else if indexPath.row == 2{
            cell.nameFieldUserLabel.text = NSLocalizedString("profileuser-title-email", comment:"")
            cell.itemFieldUserLabel.text = accountModel?.email
        }
        else if indexPath.row == 3{
            cell.nameFieldUserLabel.text = NSLocalizedString("profileuser-title-password", comment:"")
            cell.itemFieldUserLabel.text = accountModel?.password
        }
        else if indexPath.row == 4{
            cell.nameFieldUserLabel.text = NSLocalizedString("profileuser-title-numberphone", comment:"")
            cell.itemFieldUserLabel.text = accountModel?.username
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(indexPath.row == 4){
            self.performSegue(withIdentifier:URLConstants.ACCOUNT.account_setting, sender: nil)
        }
    }
}


