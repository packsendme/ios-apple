//
//  CardPaymentViewController.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 19/08/2019.
//  Copyright © 2019 Ricardo Marzochi. All rights reserved.
//

import UIKit

class APPayCardViewController: UIViewController, UITextFieldDelegate {

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
    @IBOutlet weak var numcarderrorLabel: UILabel!
    @IBOutlet weak var countrydataView: UIView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    var cardpaySelect = PaymentAccountBO()
    
    var utilityObj = UtilityHelper()
    var paymentService = PaymentService()
    var countryService = CountryService()
    var cardValObj = CardValidation()
    var dateFormat = UtilityHelper()
    var boxActivityView = UIView()
    var activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)

    var countryDto : CountryBO? = nil
    var countryObj = CountryBO()
    var utilDateObj = UtilityHelper()
    var operationType : String = ""
    var statusEdit : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardtitleLabel.text = NSLocalizedString("payment-title-card", comment:"")
        numcarderrorLabel.isHidden = true
        
        let numbercardIndentView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 20))
        numbercardFieldText.leftView = numbercardIndentView
        numbercardFieldText.leftViewMode = .always
        
        let datecardcardIndentView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        datecardFieldText.leftView = datecardcardIndentView
        datecardFieldText.leftViewMode = .always

        let cvvccardIndentView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        cvvcardFieldText.leftView = cvvccardIndentView
        cvvcardFieldText.leftViewMode = .always
        
        self.numbercardFieldText.addTarget(self, action: #selector(didChangeText(textField:)), for: .editingChanged)
        self.datecardFieldText.addTarget(self, action: #selector(didChangeText(textField:)), for: .editingChanged)
        self.cvvcardFieldText.addTarget(self, action: #selector(didChangeText(textField:)), for: .editingChanged)

        // SELECT AUTO COUNTRY
        self.countrycardImage.image = UIImage(named: "icon-countrydefault")
        self.countrycardBtn.setTitle(NSLocalizedString("card-title-countrycard", comment:""), for: .normal)
        
        // Operation Type : ADD NEW CARD PAY
        if cardpaySelect.operationTransaction == GPConstants.op_save.rawValue{
            cardPaySettingFieldCard()
            self.savepayBtn.setTitle(NSLocalizedString("payment-title-addcard", comment:""), for: .normal)
            menuslideBtn.isHidden = true
        }
        // Operation Type : EDIT CARD PAY
        else if cardpaySelect.operationTransaction == GPConstants.op_edit.rawValue{
            cardPaySettingFieldCard()
            self.savepayBtn.setTitle(NSLocalizedString("payment-title-editcard", comment:""), for: .normal)
            menuslideBtn.isHidden = false
            if countryDto == nil{
                statusEdit = false
            }
            else{
                statusEdit = true
            }
            fieldColorEdit()
        }
    }
    
    func cardPaySettingFieldCard(){
        
        if cardpaySelect.payCodenum != nil &&  cardpaySelect.operationTransaction == GPConstants.op_edit.rawValue{
            numbercardFieldText.isEnabled = true
            let numcodFourLast = cardpaySelect.payCodenum!.suffix(4)
            print("LAST CODE \(numcodFourLast)")
            let mySubstring = "•••• •••• •••• "+numcodFourLast
            numbercardFieldText.text = String(mySubstring) as String
        }
        else if cardpaySelect.payCodenum == nil &&  cardpaySelect.operationTransaction == GPConstants.op_save.rawValue{
            numbercardFieldText.placeholder = "•••• •••• •••• ••••"
            numbercardFieldText.becomeFirstResponder()
        }
        else if cardpaySelect.payCodenum != nil &&  cardpaySelect.operationTransaction == GPConstants.op_save.rawValue{
            numbercardFieldText.text = self.modifyCreditCardString(creditCardString: cardpaySelect.payCodenum!)
        }
        
        if cardpaySelect.payExpiry != nil{
            let dateS = cardpaySelect.payExpiry
            let first = String(dateS!.prefix(2))
            let secund = String(dateS!.suffix(2))
            let dateTotal = first+"/"+secund
            datecardFieldText.text = dateTotal
        }
        else{
          datecardFieldText.attributedPlaceholder = NSAttributedString(string: "MM/YY",attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        }
        
        if cardpaySelect.payValue != nil &&  cardpaySelect.operationTransaction == GPConstants.op_save.rawValue{
            cvvcardFieldText.text = cardpaySelect.payValue
        }
        else{
            cardpaySelect.payValue = nil
            cvvcardFieldText.text = nil
            cvvcardFieldText.placeholder = "123"
        }

        if cardpaySelect.payEntity != nil {
            changeImageCard(cardType : cardpaySelect.payEntity!)
        }
        else{
           entitycardImage.image = UIImage(named: "icon-card-standard")
        }
        
        // Operation: Return Change Country Card
        if countryDto != nil{
            countrycardImage.image = countryDto?.countryImage
            countrycardBtn.setTitle(countryDto?.name, for: .normal)
            cardpaySelect.payCountry = countryDto?.sigla
        }
        // Operation: Change Card
        else if cardpaySelect.payCountry != nil{
            getCountryDetails(codCountry : cardpaySelect.payCountry!)
        }
       // Operation: Add Card
        else if cardpaySelect.payCountry == nil{
            countrycardImage.image = GlobalVariables.sharedManager.countryImageInstance
            countrycardBtn.setTitle(GlobalVariables.sharedManager.countryNameInstance, for: .normal)
            // Set Object ComntryDto to Save
            countryDto = CountryBO.init(
                countryImage: GlobalVariables.sharedManager.countryImageInstance!,
                name: GlobalVariables.sharedManager.countryNameInstance,
                cod: GlobalVariables.sharedManager.countryCodInstance,
                format: GlobalVariables.sharedManager.countryFormatInstance,
                sigla:GlobalVariables.sharedManager.countrySingla)
            cardpaySelect.payCountry = GlobalVariables.sharedManager.countrySingla
        }
        // Activa or Inative Button Save
        activaButtonSave()
    }
    
    func fieldColorEdit(){
        if statusEdit == false{
            numbercardFieldText.isEnabled = false
            datecardFieldText.isEnabled = false
            cvvcardFieldText.isEnabled = false
            countrycardBtn.isEnabled = false
            numbercardFieldText.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
            datecardFieldText.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
            cvvcardFieldText.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
            countrycardBtn.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
            countrydataView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
        }
        else{
            let color =  UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 0.69)
            datecardFieldText.isEnabled = true
            cvvcardFieldText.isEnabled = true
            countrycardBtn.isEnabled = true
            datecardFieldText.backgroundColor = color
            cvvcardFieldText.backgroundColor = color
            countrycardBtn.backgroundColor = color
            countrydataView.backgroundColor = color
            datecardFieldText.becomeFirstResponder()
        }
    }
    
    func changeImageCard(cardType : String){
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
        case "EloCard":
            entitycardImage.image = UIImage(named: "icon-card-elo")
        case "JBSCard":
            entitycardImage.image = UIImage(named: "icon-card-jcb")
        case "HiperCard":
            entitycardImage.image = UIImage(named: "icon-card-hipercard")
        case "UnionPayCard":
            entitycardImage.image = UIImage(named: "icon-card-union")
        default:
            entitycardImage.image = UIImage(named: "icon-card-standard")
        }
    }

    override func didReceiveMemoryWarning() {
       super.didReceiveMemoryWarning()
    }
   
    @objc func didChangeText(textField:UITextField) {
        
        if textField == numbercardFieldText{
            let typeCard = cardValObj.typeCreditCard(numcard: numbercardFieldText.text!)
            changeImageCard(cardType : typeCard.rawValue)
            let strcodeCardNum = String(textField.text!.filter {![" ", "\t", "\n"].contains($0)})
            if numbercardFieldText.text!.count == 19 {
               let (type, valid) = cardValObj.validateCreditCardFormat(numcard: strcodeCardNum)
               if valid == true{
                    numcarderrorLabel.isHidden = true
                    numbercardFieldText.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
                    cardpaySelect.payCodenum = strcodeCardNum
                    cardpaySelect.payEntity = type.rawValue
                    datecardFieldText.becomeFirstResponder()
               }
               else{
                    cardpaySelect.payEntity = ""
                    cardpaySelect.payCodenum = ""
                    numcarderrorLabel.text = NSLocalizedString("carpay-validation-error", comment:"")
                    numcarderrorLabel.isHidden = false
                    numbercardFieldText.backgroundColor = UIColor(red: 0.957, green: 0.216, blue: 0.216, alpha: 0.1)
               }
            }
            else {
                numbercardFieldText.text = self.modifyCreditCardString(creditCardString: numbercardFieldText.text!)
            }
            cardpaySelect.payCodenum = strcodeCardNum
        }
            
        else if textField == datecardFieldText{
            let inputDateCardS = datecardFieldText.text!
            let strcodeCardNum =  inputDateCardS.replacingOccurrences(of: "/", with: "")
            let inputDateCardI = Int(strcodeCardNum)
            
            if strcodeCardNum.count == 1{
                if inputDateCardI! >= 2 && inputDateCardI! <= 9 {
                    datecardFieldText.text = "0"+strcodeCardNum
                }
            }
            else if strcodeCardNum.count == 4{
                cvvcardFieldText.becomeFirstResponder()
            }
            else if strcodeCardNum.count == 2{
                if inputDateCardI! > 12 {
                    datecardFieldText.text = "1"
                }
            }
            cardpaySelect.payExpiry = strcodeCardNum
        }
        else if textField == cvvcardFieldText{
                cardpaySelect.payValue = cvvcardFieldText.text
        }
       
       activaButtonSave()
    }
    
    func activaButtonSave(){
        print(" activaButtonSave ")
        if cardpaySelect.payCodenum != nil &&
            cardpaySelect.payExpiry != nil &&
            cardpaySelect.payValue != nil &&
            cardpaySelect.payCountry != nil &&
            cardpaySelect.payEntity != nil{
            
            if cardpaySelect.payCodenum!.count == 16 &&
                cardpaySelect.payExpiry!.count == 4 &&
                cardpaySelect.payValue!.count == 3 &&
                cardpaySelect.payCountry!.count == 2{
                savepayBtn.isEnabled = true
                savepayBtn.alpha = 1
            }
            else{
                savepayBtn.isEnabled = false
                savepayBtn.alpha = 0.5
            }
        }
        else{
            savepayBtn.isEnabled = false
            savepayBtn.alpha = 0.5
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var maxLength : Int = 0
        if textField == cvvcardFieldText{
            maxLength = 3
        }
        else  if textField == datecardFieldText{
           
            let  char = string.cString(using: String.Encoding.utf8)!
            let isBackSpace = strcmp(char, "\\b")
            
            if (isBackSpace != -92) {
                if (textField.text?.count) == 2{
                    textField.text = "\(textField.text!)/"
                }
            }
            maxLength = 5
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
            self.activityActionStart(title : NSLocalizedString("a-action-lbl-loading", comment:""))
            UIView.transition(with: self.view,
                              duration:0.1,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.statusEdit = true
                                self.fieldColorEdit()},
                              completion: nil)

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.activityActionStop()
            }
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("payment-title-deletecard", comment:""), style: .default , handler:{ (UIAlertAction)in
            DispatchQueue.main.async {
                self.activityActionStart(title : NSLocalizedString("a-action-lbl-loading", comment:""))
                self.removeCardPay()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.cardpaySelect.dateOperation = self.dateFormat.dateConvertToString()
                self.activityActionStop()
            }
        }))
       
        alert.addAction(UIAlertAction(title: NSLocalizedString("photoprofile-buttontool-cancelphoto", comment:""), style: .cancel , handler:{ (UIAlertAction)in
            
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    func activityActionStart(title : String) {
        // You only need to adjust this frame to move it anywhere you want
        boxActivityView = UIView(frame: CGRect(x: view.frame.midX - 35, y: view.frame.midY - 40, width:50, height: 50))
        boxActivityView.backgroundColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0)
        //UIColor.lightGray
        boxActivityView.alpha = 0.9
        boxActivityView.layer.cornerRadius = 10
        //Here the spinnier is initialized
        activityView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityView.color = UIColor.black
        activityView.startAnimating()
        let textLabel = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
        textLabel.textColor = UIColor.black
        textLabel.text = ""
        boxActivityView.addSubview(activityView)
        boxActivityView.addSubview(textLabel)
        view.addSubview(boxActivityView)
    }
    
    func activityActionStop() {
        //When button is pressed it removes the boxView from screen
        self.boxActivityView.removeFromSuperview()
        self.activityView.stopAnimating()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "APCSearchViewController"{
            let something = segue.destination as! APCSearchViewController
            something.countryDto = self.countryDto!
            something.operationTypeController = GAViewController.APPayCard.rawValue
            something.cardpaySelect = self.cardpaySelect
        }
     }
    
    
    func validateCreditCard(){
        paymentService.getValidateCreditCard(paymentDto: cardpaySelect){(success, response, error) in
            if success == true{
                self.cardpaySelect.payStatus = GPConstants.validateCard.rawValue
                DispatchQueue.main.async {
                    self.findCardByCodnum(codNum: self.cardpaySelect.payCodenum!)
                }
            }
            else if success == false  && error == nil{
                self.cardpaySelect.payStatus = GPConstants.invalidCard.rawValue
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: NSLocalizedString("carpay-msghead-validation", comment:""), message: NSLocalizedString("cardpay-msgbody-validation", comment:""), preferredStyle: .alert)
                        
                    alertController.addAction(UIAlertAction(title: "OK", style: .default)
                    { action -> Void in
                        self.saveCardPay()
                    })
                    self.present(alertController, animated:  true)
                }
            }
            else if error != nil{
                print("validateCreditCard() --> NOK ")
                DispatchQueue.main.async {
                    let ac = UIAlertController(title: NSLocalizedString("error-title-failconnection", comment:""), message: NSLocalizedString("error-body-failconnection", comment:""), preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated:  true)
                }
            }
        }
    }
    
    
    func saveCardPay(){
        paymentService.postPaymentMethod(paymentDto: cardpaySelect){(success, response, error) in
        if success{
            self.performSegue(withIdentifier:"APPaySearchViewController", sender: self)
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
        self.activityActionStart(title: "")
        countryService.findDetailCountryByID(idcountry: codCountry){(success, response, error) in
            if success{
                DispatchQueue.main.async {
                    self.activityActionStop()
                    UIView.transition(with: self.view,
                                      duration:0.5,
                                      options: .transitionCrossDissolve,
                                      animations: {
                                        let country = response as! CountryBO
                                        self.countryDto = country
                                        self.countrycardImage.image = country.countryImage
                                        self.countrycardBtn.setTitle(country.name, for: .normal)
                                        self.cardpaySelect.payCountry = country.sigla
                                      },
                                      completion: nil)
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
    
    func findCardByCodnum(codNum : String){
        paymentService.getPaymentByNumcod(codnum: cardpaySelect.payCodenum!){(success, response, error) in
            if success == true{
               self.saveCardPay()
            }
            else  if success == false && error == nil{
                DispatchQueue.main.async {
                    let ac = UIAlertController(title: NSLocalizedString("carpay-msghead-validation", comment:""), message: NSLocalizedString("carpay-body-foundcard", comment:""), preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated:  true)
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
    
    func updateCardPay(){
        paymentService.putPaymentMethod(paymentDto: cardpaySelect){(success, response, error) in
            if success{
                self.performSegue(withIdentifier:"APPaySearchViewController", sender: self)
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
    
    func removeCardPay(){
        paymentService.removePaymentMethod(paymentDto: cardpaySelect){(success, response, error) in
            if success{
                self.performSegue(withIdentifier:"APPaySearchViewController", sender: self)
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
        activityActionStart(title : NSLocalizedString("a-action-lbl-loading", comment:""))
        cardpaySelect.dateOperation = dateFormat.dateConvertToString()
        // Operation Type : ADD NEW CARD PAY
        if cardpaySelect.operationTransaction == GPConstants.op_save.rawValue{
            validateCreditCard()
        }
        // Operation Type : EDIT CARD PAY
        else if cardpaySelect.operationTransaction == GPConstants.op_edit.rawValue{
            updateCardPay()
        }
    }

}


