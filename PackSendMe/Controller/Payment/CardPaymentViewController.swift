//
//  CardPaymentViewController.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 19/08/2019.
//  Copyright © 2019 Ricardo Marzochi. All rights reserved.
//

import UIKit

class CardPaymentViewController: UIViewController {

    @IBOutlet weak var cardtitleLabel: UILabel!
    
    @IBOutlet weak var namecardLabel: UILabel!
    @IBOutlet weak var namecardFieldText: UITextField!
    
    @IBOutlet weak var numbercardLabel: UILabel!
    @IBOutlet weak var numbercardFieldText: UITextField!
    
    @IBOutlet weak var datecardLabel: UILabel!
    @IBOutlet weak var datecardFieldText: UITextField!

    
    @IBOutlet weak var cvvcardLabel: UILabel!
    @IBOutlet weak var cvvcardFieldText: UITextField!
    
    @IBOutlet weak var savepayBtn: UIButton!
    @IBOutlet weak var countrycard: UIButton!
    
    var countryModel : CountryModel? = nil
    
    var boxActivityView = UIView()
    var activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    var cardpaySelect = PaymentMethodAccountDto()
    @IBOutlet weak var countryImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        savepayBtn.isHidden = true
        cardtitleLabel.text = NSLocalizedString("payment-title-card", comment:"")
        
        
        if cardpaySelect != nil{
            namecardFieldText.text = cardpaySelect.payName
            numbercardFieldText.text = cardpaySelect.payCodenum
            datecardFieldText.text = cardpaySelect.payCodenum
            cvvcardFieldText.text = cardpaySelect.payValue
            //countrycard.value(cardpaySelect.payCountry)
        }
    }
    
    @IBAction func menuslide(_ sender: Any) {
        self.showMenuScrollOptions()
    }
    
    func editCard(){
        namecardFieldText.becomeFirstResponder()
        savepayBtn.isHidden = false
    }
    
    
    func deleteCard(){
        savepayBtn.isHidden = true
    }
    
    func showMenuScrollOptions() {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.view.tintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        //to change font of title and message.
        let messageFont = [kCTFontAttributeName: UIFont(name: "Avenir-Roman", size: 18.0)!]
        let messageAttrString = NSMutableAttributedString(string: NSLocalizedString("payment-title-changecard", comment:""), attributes: messageFont as [NSAttributedStringKey : Any] as [String : Any])
        
        alert.setValue(messageAttrString, forKey: "attributedMessage")
        alert.addAction(UIAlertAction(title: NSLocalizedString("payment-title-editcard", comment:""), style: .default , handler:{ (UIAlertAction)in
           // self.activityActionStart(title:NSLocalizedString("payment-title-editcard", comment:""))
            
            DispatchQueue.main.async {
                self.editCard()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.activityActionStop()
            }
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("payment-title-deletecard", comment:""), style: .default , handler:{ (UIAlertAction)in
            //self.activityActionStart(title:NSLocalizedString("payment-title-deletecard", comment:""))
            
            DispatchQueue.main.async {
                self.deleteCard()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.activityActionStop()
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("photoprofile-buttontool-cancelphoto", comment:""), style: .cancel , handler:{ (UIAlertAction)in
            
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    func activityActionStop() {
        //When button is pressed it removes the boxView from screen
        self.boxActivityView.removeFromSuperview()
        self.activityView.stopAnimating()
    }
    
    func activityActionStart(title : String) {
        // You only need to adjust this frame to move it anywhere you want
        boxActivityView = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25, width: 180, height: 50))
        boxActivityView.backgroundColor = UIColor.white
        boxActivityView.alpha = 0.8
        boxActivityView.layer.cornerRadius = 10
        
        //Here the spinnier is initialized
        
        activityView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityView.startAnimating()
        
        let textLabel = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
        textLabel.textColor = UIColor.gray
        textLabel.text = title
        
        boxActivityView.addSubview(activityView)
        boxActivityView.addSubview(textLabel)
        
        view.addSubview(boxActivityView)
    }
    
}
