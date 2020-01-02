//
//  EditAccountUserViewController.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 16/12/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import UIKit

class APPSearchViewController: UIViewController {

    @IBOutlet weak var ampScreenTitleLabel: UILabel!
    @IBOutlet weak var userprofileTable: UITableView!
    @IBOutlet weak var photoprofileBtn: UIButton!
    @IBOutlet weak var useraccountLabel: UILabel!

    var profileObj = ProfileBO()
    var countryObj : CountryBO? = nil
    var profileImageDefault: String = "icon-user-photo"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        ampScreenTitleLabel.text = NSLocalizedString("aup-setting-title", comment:"")
        countryObj = CountryBO(countryImage: GlobalVariables.sharedManager.countryImageInstance!, name: GlobalVariables.sharedManager.countryNameInstance, cod: GlobalVariables.sharedManager.countryCodInstance, format: GlobalVariables.sharedManager.countryFormatInstance,sigla:"" )

       // ampTitleSettingLbl.text = NSLocalizedString("aup-setting-title", comment:"")
        userprofileTable.rowHeight = UITableViewAutomaticDimension
        userprofileTable.isScrollEnabled = true
        userprofileTable.translatesAutoresizingMaskIntoConstraints = false
        useraccountLabel.text = profileObj.name
        
     //   photoprofileBtn.frame = CGRect(x: 160, y: 100, width: 50, height: 50)
        photoprofileBtn.layer.cornerRadius = 0.5 * photoprofileBtn.bounds.size.width
        photoprofileBtn.clipsToBounds = true
       // photoprofileBtn.addTarget(self, action: #selector(thumbsUpButtonPressed), for: .touchUpInside)
        
        // Load Image Profile
        if UserDefaults.standard.object(forKey: GlobalVariables.sharedManager.profileImage) as? NSData != nil{
            let dataImage = UserDefaults.standard.object(forKey: GlobalVariables.sharedManager.profileImage) as! NSData
            let profileImage = UIImage(data: dataImage as Data)
            photoprofileBtn.setImage(profileImage, for: .normal)
        }
        else{
            let dataImage = UIImage(named: profileImageDefault)
            photoprofileBtn.setImage(dataImage, for: .normal)
        }
        userprofileTable.delegate = self
        userprofileTable.dataSource = self
    }
    
    @IBAction func photoProfileAction(_ sender: Any){
        self.performSegue(withIdentifier:"APPPhoto", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "APPManagerNames"{
            let setupNames = segue.destination as? APPManagerViewController
            setupNames?.profileObj = profileObj
            setupNames?.metadadosView = GAConstants.name.rawValue
        }
        if segue.identifier == "APPManagerEmail"{
            let setupEmail = segue.destination as? APPManagerViewController
            setupEmail?.profileObj = profileObj
            setupEmail?.metadadosView = GAConstants.email.rawValue
        }
        if segue.identifier == "APPManagerPassword"{
            let setupPassword = segue.destination as? APPManagerViewController
            setupPassword?.profileObj = profileObj
            setupPassword?.metadadosView = GAConstants.password.rawValue
        }
        if segue.identifier == "APPManagerUsername"{
            let setupUsername = segue.destination as? APPManagerViewController
            setupUsername?.countryObj = countryObj
            setupUsername?.profileObj = profileObj
            setupUsername?.metadadosView = GAConstants.username.rawValue
        }
    }
    
    @IBAction func photoReturn(_ sender: Any) {
        
    }
    
}

extension APPSearchViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 75.0;//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //var countryObj = countriesData[indexPath.section][indexPath.row]
        
       guard let cell = tableView.dequeueReusableCell(withIdentifier:"AccessInfoCell") as? ProfileUserViewCell
            else{
                return UITableViewCell()
       }
       
       if indexPath.row == 0{
            //cell.nameFieldUserLabel.font = UIFont(name:"Avenir", size:19)
            cell.nameFieldUserLabel.text = NSLocalizedString("profileuser-title-name", comment:"")
        cell.itemFieldUserLabel.text = profileObj.name
       }
       else if indexPath.row == 1{
            //cell.nameFieldUserLabel.font = UIFont(name:"Avenir", size:19)
            cell.nameFieldUserLabel.text = NSLocalizedString("profileuser-title-lastname", comment:"")
        cell.itemFieldUserLabel.text = profileObj.lastName
       }
       else if indexPath.row == 2{
            cell.nameFieldUserLabel.text = NSLocalizedString("profileuser-title-email", comment:"")
        cell.itemFieldUserLabel.text = profileObj.email
       }
       else if indexPath.row == 3{
            cell.nameFieldUserLabel.text = NSLocalizedString("profileuser-title-password", comment:"")
            cell.itemFieldUserLabel.text =  String("123456781234567812345678".characters.map { _ in return "•" })
            //cell.itemFieldUserLabel.text = profileObj?.password
        
       }
       else if indexPath.row == 4{
            cell.nameFieldUserLabel.text = NSLocalizedString("profileuser-title-numberphone", comment:"")
        cell.itemFieldUserLabel.text = profileObj.username
       }
       return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       if indexPath.row == 0{
           self.performSegue(withIdentifier:"APPManagerNames", sender: nil)
       }
       else if indexPath.row == 1{
           self.performSegue(withIdentifier:"APPManagerNames", sender: nil)
       }
       else if indexPath.row == 2{
            self.performSegue(withIdentifier:"APPManagerEmail", sender: nil)
       }
       else if indexPath.row == 3{
            self.performSegue(withIdentifier:"APPManagerPassword", sender: nil)
       }
       else if indexPath.row == 4{
            self.performSegue(withIdentifier:"APPManagerUsername", sender: nil)
       }
    }
    
    
    
}


