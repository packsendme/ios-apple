//
//  EditAccountUserViewController.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 16/12/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import UIKit

class ManagerAccesstUserViewController: UIViewController {

    @IBOutlet weak var editAccessInfTitleLabel: UILabel!
    @IBOutlet weak var userprofileImg: UIImageView!
    @IBOutlet weak var accessinfoTable: UITableView!
    
    @IBOutlet weak var nameFieldLabel: UILabel!
    
    
    var accountModelObj : AccountModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func hometoolAction(_ sender: Any) {
        self.performSegue(withIdentifier:URLConstants.ACCOUNT.settingToAccountHome, sender: nil)
    }
    
    @IBAction func menutoolAction(_ sender: Any) {
    }
    
}

extension ManagerAccesstUserViewController : UITableViewDataSource, UITableViewDelegate{
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 5
        }
        
        func imageWithImage(image:UIImage,scaledToSize newSize:CGSize)->UIImage{
            UIGraphicsBeginImageContext( newSize )
            image.draw(in: CGRect(x: 0,y: 0,width: newSize.width,height: newSize.height))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage!.withRenderingMode(.alwaysTemplate)
        }
        
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier:"AccessInfoCell") as? AccessInfViewCell
                else{
                    return UITableViewCell()
            }
            
            if(accountModelObj != nil){
                
                // USER ACCOUNT - NAME
                if(indexPath.row == 0){
                    cell.titleFieldCell.text = NSLocalizedString("editfirstname-text-firstname", comment:"")
                    cell.nameFieldCell.text = accountModelObj?.name
                }
                // USER ACCOUNT - LASTNAME
               if(indexPath.row == 1){
                    cell.titleFieldCell.text = NSLocalizedString("editlastname-text-lastname", comment:"")
                    cell.nameFieldCell.text = accountModelObj?.lastname
                    
                }
                // USER ACCOUNT - EMAIL
               if(indexPath.row == 2){
                    cell.titleFieldCell.text = NSLocalizedString("editemail-text-email", comment:"")
                    cell.nameFieldCell.text = accountModelObj?.email
               }
                // USER ACCOUNT - username (phone)
                if(indexPath.row == 3){
                    cell.titleFieldCell.text = NSLocalizedString("editusername-text-username", comment:"")
                    cell.nameFieldCell.text = accountModelObj?.username
                }
                // USER ACCOUNT - password
                if(indexPath.row == 4){
                    cell.titleFieldCell.text = NSLocalizedString("editpassword-text-password", comment:"")
                    cell.nameFieldCell.text = accountModelObj?.password
                }
            }
            return cell
        }
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 15;
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
        {
            return 100.0;//Choose your custom row height
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            if(indexPath.row == 0){
                self.performSegue(withIdentifier:URLConstants.ACCOUNT.settingViewToManagerAccessView, sender: nil)
            }
            else if(indexPath.row == 1){
                self.performSegue(withIdentifier:URLConstants.ACCOUNT.settingViewToManagerAddressView, sender: nil)
            }
            else if(indexPath.row == 2){
                self.performSegue(withIdentifier:URLConstants.ACCOUNT.settingViewToManagerAddressView, sender: nil)
            }
            else if(indexPath.row == 3){
                self.performSegue(withIdentifier:URLConstants.ACCOUNT.settingViewToManagerPaymentView, sender: nil)
            }
            else if(indexPath.row == 4){
                self.performSegue(withIdentifier:URLConstants.ACCOUNT.settingViewToManagerPaymentView, sender: nil)
            }
        }
}
