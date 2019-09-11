//
//  CardPaymentViewController.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 19/08/2019.
//  Copyright © 2019 Ricardo Marzochi. All rights reserved.
//

import UIKit

class CardPaymentViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var cardtitleLabel: UILabel!

    @IBOutlet weak var countrycardLabel: UILabel!
    @IBOutlet weak var numbercardLabel: UILabel!
    @IBOutlet weak var numbercardFieldText: UITextField!
    @IBOutlet weak var datecardLabel: UILabel!
    @IBOutlet weak var datecardFieldText: UITextField!
    @IBOutlet weak var cvvcardLabel: UILabel!
    @IBOutlet weak var cvvcardFieldText: UITextField!
    @IBOutlet weak var savepayBtn: UIButton!
    @IBOutlet weak var countrycardBtn: UIButton!
    @IBOutlet weak var entitycardImage: UIImageView!
    @IBOutlet weak var countrycardImage: UIImageView!
    
    @IBOutlet weak var menuslideBtn: UIButton!
    
    
    var cardpaySelect = PaymentAccountDto()
    var cardpayDto = PaymentAccountDto()

    var utilityObj = UtilityHelper()
    var paymentService = PaymentService()
    var countryService = CountryService()
    
    var boxActivityView = UIView()
    var activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    var countryDto : CountryVModel? = nil
    var countryObj = CountryVModel()
    var utilDateObj = UtilityHelper()
    var operationType : String = ""

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        savepayBtn.isHidden = true
        cardtitleLabel.text = NSLocalizedString("payment-title-card", comment:"")
        self.numbercardFieldText.addTarget(self, action: #selector(didChangeText(textField:)), for: .editingChanged)
        
        // SELECT AUTO COUNTRY
        self.countrycardImage.image = UIImage(named: "icon-countrydefault")
        self.countrycardBtn.setTitle(NSLocalizedString("card-title-countrycard", comment:""), for: .normal)

        // Operation Type : ADD NEW CARD PAY
        if cardpaySelect.payCodenum == nil{
            cardPaySettingFieldNewCard()
            menuslideBtn.isHidden = true
        }
        // Operation Type : EDIT CARD PAY
        else if cardpaySelect.payCodenum != nil{
            cardPaySettingFieldEditCard()
             menuslideBtn.isHidden = false
        }
    }
    
    func cardPaySettingFieldNewCard(){
        savepayBtn.isHidden = false
        entitycardImage.image = UIImage(named: "icon-card-standard")
        cvvcardFieldText.placeholder = "123"
        datecardFieldText.attributedPlaceholder = NSAttributedString(string: "MM/YY",attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        
        numbercardFieldText.attributedPlaceholder = NSAttributedString(string: "•••• •••• •••• ••••",attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
            numbercardFieldText.placeholder = "•••• •••• •••• ••••"
            numbercardFieldText.becomeFirstResponder()
        
        // Operation: Return Change Country Card
        if countryDto != nil{
            countrycardImage.image = countryDto?.countryImage
            countrycardBtn.setTitle(countryDto?.name, for: .normal)
        }
        else{
            countrycardImage.image = GlobalVariables.sharedManager.countryImageInstance
            countrycardBtn.setTitle(GlobalVariables.sharedManager.countryNameInstance, for: .normal)
            // Set Object ComntryDto to Save
            countryDto = CountryVModel.init(
                countryImage: GlobalVariables.sharedManager.countryImageInstance!,
                name: GlobalVariables.sharedManager.countryNameInstance,
                cod: GlobalVariables.sharedManager.countryCodInstance,
                format: GlobalVariables.sharedManager.countryFormatInstance,
                sigla:GlobalVariables.sharedManager.countrySingla)
        }
    }
        
    
    func cardPaySettingFieldEditCard(){
        
        if cardpaySelect.payExpiry != nil{
            datecardFieldText.text = cardpaySelect.payExpiry
        }
        if cardpaySelect.payCodenum != nil{
            numbercardFieldText.isEnabled = false
            let mySubstring = "•••• •••• •••• "+cardpaySelect.payCodenum!.prefix(12) //suffix(3)
            numbercardFieldText.text = String(mySubstring) as String
        }
        switch cardpaySelect.payEntity {
        case "VisaCard":
            entitycardImage.image =  UIImage(named: "icon-card-visa")
        case "MasterCard":
            entitycardImage.image = UIImage(named: "icon-card-master")
        case "DiscoverCard":
            entitycardImage.image = UIImage(named: "icon-card-discover")
        case "DinersCard":
            entitycardImage.image = UIImage(named: "icon-card-diners")
        case "AmericanCard":
            entitycardImage.image = UIImage(named: "icon-card-american")
        case "Aura":
            entitycardImage.image = UIImage(named: "icon-card-aura")
        case "Elo":
            entitycardImage.image = UIImage(named: "icon-card-elo")
        case "Hipercard":
            entitycardImage.image = UIImage(named: "icon-card-hipercard")
        default:
            entitycardImage.image = UIImage(named: "icon-card-standard")
        }
        
        // Operation: Return Change Country Card
        if countryDto != nil{
            countrycardImage.image = countryDto?.countryImage
            countrycardBtn.setTitle(countryDto?.name, for: .normal)
        }
        // Operation: Change Card
        else if cardpaySelect.payCountry != nil{
            getCountryDetails(codCountry : cardpaySelect.payCountry!)
        }
    }

    
    override func didReceiveMemoryWarning() {
       super.didReceiveMemoryWarning()
    }
   
    @objc func didChangeText(textField:UITextField) {
        if numbercardFieldText.text!.count == 19 {
            let codeCardNum = numbercardFieldText.text
            let strcodeCardNum = String(codeCardNum!.filter {![" ", "\t", "\n"].contains($0)})
                   print(" strcodeCardNum \(strcodeCardNum)")
            let cardType = paymentService.validateCardType(testCard: strcodeCardNum)
            changeImageCard(cardType : cardType)
            cardpaySelect.payCodenum = strcodeCardNum
            cardpaySelect.payEntity = cardType
            datecardFieldText.becomeFirstResponder()
        }
        else {
            numbercardFieldText.text = self.modifyCreditCardString(creditCardString: numbercardFieldText.text!)
        }
    }
    
    func modifyCreditCardString(creditCardString : String) -> String {
        let trimmedString = creditCardString.components(separatedBy: .whitespaces).joined()
        
        let arrOfCharacters = Array(trimmedString)
        var modifiedCreditCardString = ""
        
        if(arrOfCharacters.count > 0) {
            for i in 0...arrOfCharacters.count-1 {
                modifiedCreditCardString.append(arrOfCharacters[i])
                if((i+1) % 4 == 0 && i+1 != arrOfCharacters.count){
                    modifiedCreditCardString.append(" ")
                }
            }
        }
        return modifiedCreditCardString
    }
    
    @IBAction func expdataTextFieldChange(_ sender: Any) {
        if datecardFieldText.text!.count == 2 {
            datecardFieldText.text = "\(datecardFieldText.text!) / "
        }
        if datecardFieldText.text!.count == 7 {
            cardpaySelect.payExpiry = datecardFieldText.text
            cvvcardFieldText.becomeFirstResponder()
        }
    }
    
    
    func changeImageCard(cardType : String){
        print(" cardType \(cardType)")

        switch cardType {
        case "VisaCard":
            entitycardImage.image =  UIImage(named: "icon-card-visa")
        case "MasterCard":
            entitycardImage.image = UIImage(named: "icon-card-master")
        case "DiscoverCard":
            entitycardImage.image = UIImage(named: "icon-card-discover")
        case "DinersCard":
            entitycardImage.image = UIImage(named: "icon-card-diners")
        case "AmericanCard":
            entitycardImage.image = UIImage(named: "icon-card-american")
        case "Aura":
            entitycardImage.image = UIImage(named: "icon-card-aura")
        case "Elo":
            entitycardImage.image = UIImage(named: "icon-card-elo")
        case "Hipercard":
            entitycardImage.image = UIImage(named: "icon-card-hipercard")
        default:
            entitycardImage.image = UIImage(named: "icon-card-standard")
        }
    }
    
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var maxLength : Int = 0
        if textField == cvvcardFieldText{
            maxLength = 3
        }
        else  if textField == datecardFieldText{
            maxLength = 7
        }
        else  if textField == numbercardFieldText{
            maxLength = 19
        }
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
 
    
    @IBAction func menuslide(_ sender: Any) {
        self.showMenuScrollOptions()
    }
    
    func editCard(){
        numbercardFieldText.becomeFirstResponder()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CountryAccountViewController"{
            let something = segue.destination as! CountryAccountViewController
            something.countryDto = self.countryDto!
            something.operationTypeController = GlobalVariables.sharedManager.OP_CHANGE_COUNTRY_CARDPAY
            something.cardpaySelect = self.cardpaySelect
        }
     }
    
    
    func validateFieldAndSettingPayDto() -> Bool{
        var result : Bool = true
        let errorColor = UIColor.red
        let correctColor = UIColor.white
        cardpayDto.payCountry = countryDto?.sigla
        cardpayDto.dateOperation = utilDateObj.dateConvertToString()
        cardpayDto.payType = GlobalVariables.sharedManager.cardPay
        
        if numbercardFieldText.text!.isEmpty{
            result = false
            numbercardFieldText.layer.borderColor = errorColor.cgColor
        }
        else{
            result = true
            numbercardFieldText.layer.borderColor = correctColor.cgColor
            let strcodeCardNum = String(numbercardFieldText.text!.filter {![" ", "\t", "\n"].contains($0)})
            cardpayDto.payCodenum = strcodeCardNum
        }
        
        if datecardFieldText.text!.isEmpty{
            result = false
            datecardFieldText.layer.borderColor = errorColor.cgColor
        }
        else{
            result = true
            datecardFieldText.layer.borderColor = correctColor.cgColor
            let dateStr = datecardFieldText.text!
            let firstChars = String(dateStr.prefix(2))
            let lastChars = String(dateStr.suffix(2))
            cardpayDto.payExpiry = firstChars+lastChars
        }
        
        if cvvcardFieldText.text!.isEmpty{
            result = false
            cvvcardFieldText.layer.borderColor = errorColor.cgColor
        }
        else{
            result = true
            cvvcardFieldText.layer.borderColor = correctColor.cgColor
            cardpayDto.payValue = cvvcardFieldText.text
        }

        if cardpaySelect.payEntity!.isEmpty {
            result = false
            cvvcardFieldText.layer.borderColor = errorColor.cgColor
        }
        else{
            result = true
            numbercardFieldText.layer.borderColor = correctColor.cgColor
            cardpayDto.payEntity = cardpaySelect.payEntity
        }
        return result
    }
    
    func validateCreditCard(){
        if validateFieldAndSettingPayDto() == true{
            
            paymentService.getValidateCreditCard(paymentDto: cardpayDto){(success, response, error) in
                if success{
                    print("GET BLOCK")
                   self.cardpayDto.payStatus = GlobalVariables.sharedManager.validateCard
                    DispatchQueue.main.async {
                        self.saveCardPay()
                    }
                }
                else if error != nil{
                    DispatchQueue.main.async {
                        let ac = UIAlertController(title: NSLocalizedString("error-title-failconnection", comment:""), message: NSLocalizedString("error-body-failconnection", comment:""), preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated:  true)
                    }
                }
            }
        }
    }
    
    
    func saveCardPay(){
          paymentService.postPaymentMethod(paymentDto: cardpayDto){(success, response, error) in
            if success{
                print("GET BLOCK")
                self.performSegue(withIdentifier:"CardPaymentGoSettingPaymentUser", sender: self)
            }
            else if error != nil{
                DispatchQueue.main.async {
                    let ac = UIAlertController(title: NSLocalizedString("error-title-failconnection", comment:""), message: NSLocalizedString("error-body-failconnection", comment:""), preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated:  true)
                }
            }
        }
    }
    
    func getCountryDetails(codCountry : String){
        countryService.findDetailCountryByID(idcountry: codCountry){(success, response, error) in
            if success{
                print("GET BLOCK")
                let country = response as! CountryVModel
                self.countryDto = country
                self.countrycardImage.image = country.countryImage
                self.countrycardBtn.setTitle(country.name, for: .normal)
            }
            else if error != nil{
                DispatchQueue.main.async {
                    let ac = UIAlertController(title: NSLocalizedString("error-title-failconnection", comment:""), message: NSLocalizedString("error-body-failconnection", comment:""), preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated:  true)
                }
            }
        }
    }
    
    
    @IBAction func savePaymentMethod(_ sender: Any) {
            print("GET savePaymentMethod")
        validateCreditCard()
    }

}


