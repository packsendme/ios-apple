//
//  MenuViewController.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 02/12/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    let cellSpacingHeight: CGFloat = 200
    @IBOutlet weak var nameprofileLabel: UILabel!
    @IBOutlet weak var menuTable: UITableView!
    var menuData: [String] = []
    
    @IBOutlet weak var useraccountImg: UIImageView!
    @IBOutlet weak var learnmoreBtn: UIButton!
    @IBOutlet weak var makemoneyBtn: UIButton!
    @IBOutlet weak var menuTitleLabel: UILabel!
    var account_vc = AccountViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.isOpaque = false
        view.backgroundColor = .clear
        
        menuTable.rowHeight = UITableViewAutomaticDimension
        menuTable.isScrollEnabled = true
        menuTable.translatesAutoresizingMaskIntoConstraints = false
        menuTable.delegate = self
        menuTable.dataSource = self
        
        useraccountImg.layer.borderWidth = 1
        useraccountImg.layer.masksToBounds = false
        useraccountImg.layer.borderColor = UIColor.black.cgColor
        useraccountImg.layer.cornerRadius = useraccountImg.frame.height/2
        useraccountImg.clipsToBounds = true
        
        GlobalVariables.sharedManager.nameFirst = "Ricardo"
        GlobalVariables.sharedManager.nameLast = "Marzochi"
        nameprofileLabel.text = GlobalVariables.sharedManager.nameFirst+" "+GlobalVariables.sharedManager.nameLast
        
        learnmoreBtn.setTitle(NSLocalizedString("menu-btn-learnmore", comment:""), for: .normal)
        makemoneyBtn.setTitle(NSLocalizedString("menu-btn-makemoney", comment:""), for: .normal)

        
        menuData = [NSLocalizedString("menu-title-shipping", comment:""),
                NSLocalizedString("menu-title-payment", comment:""),
                NSLocalizedString("menu-title-voucherfree", comment:""),
                NSLocalizedString("menu-title-help", comment:""),
                NSLocalizedString("menu-title-settings", comment:""),
                NSLocalizedString("menu-title-legal", comment:"")]
        
    }
    
    
    @IBAction func menuAction(_ sender: Any) {
        let transition = CATransition()
        transition.duration = 0.1
        transition.type = kCATransition
        transition.subtype = kCATransitionFromBottom
        dismiss(animated: false, completion: nil)

    }
    
    
}

extension MenuViewController: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuData.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let rect = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 180)
        let footerView = UIView(frame:rect)
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60.0;//Choose your custom row height
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return menuData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //var country = countriesData[indexPath.section][indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier:"MenuCell") as? MenuViewCell
            else{
                return UITableViewCell()
        }
        
        if indexPath.row == 5{
            cell.menuTitleLabel.font = UIFont(name:"Avenir", size:19)
            cell.menuTitleLabel.text = menuData[indexPath.row]
        
        } else {
            cell.menuTitleLabel.text  = menuData[indexPath.row]
        }
        return cell
    }
    

    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if(indexPath.row == 4){
            // Setting
          //  let menu_vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as! SettingDataViewController
          //  self.navigationController?.present(menu_vc, animated: true, completion: nil)
            self.performSegue(withIdentifier:URLConstants.ACCOUNT.account_setting, sender: nil)
        }
        
    }
    
    

    
    
}


