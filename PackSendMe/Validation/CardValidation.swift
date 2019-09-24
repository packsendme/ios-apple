//
//  CardValidation.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 12/09/2019.
//  Copyright © 2019 Ricardo Marzochi. All rights reserved.
//

import UIKit


enum CardType: String {
    case Unknown, AmericanCard, VisaCard, MasterCard, DinersCard, DiscoverCard, JCBCard, EloCard, HiperCard, UnionPayCard
    
    static let allCards = [AmericanCard, VisaCard, MasterCard, DinersCard, DiscoverCard, JCBCard, EloCard, HiperCard, UnionPayCard]
    
    var regex : String {
        switch self {
        case .AmericanCard:
            return "^3[47][0-9]{5,}$"
        case .VisaCard:
            return "^4[0-9]{6,}([0-9]{3})?$"
        case .MasterCard:
            return "^(5[1-5][0-9]{4}|677189)[0-9]{5,}$"
        case .DinersCard:
            return "^3(?:0[0-5]|[68][0-9])[0-9]{4,}$"
        case .DiscoverCard:
            return "^6(?:011|5[0-9]{2})[0-9]{3,}$"
        case .JCBCard:
            return "^(?:2131|1800|35[0-9]{3})[0-9]{3,}$"
        case .UnionPayCard:
            return "^(62|88)[0-9]{5,}$"
        case .HiperCard:
            return "^(606282|3841)[0-9]{5,}$"
        case .EloCard:
            return "^((((636368)|(438935)|(504175)|(451416)|(636297))[0-9]{0,10})|((5067)|(4576)|(4011))[0-9]{0,12})$"
        default:
            return ""
        }
    }
}

class CardValidation: UITextField{
    
    //func postPaymentMethod(paymentDto : PaymentAccountDto, completion: @escaping (Bool, Any?, Error?) -> Void){
    
    func typeCreditCard(numcard : String) -> CardType {
    
        var type: CardType = .Unknown
        
        let numberOnly = numcard.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        
        // detect card type
        for card in CardType.allCards {
            if (matchesRegex(regex: card.regex, text: numberOnly)) {
                type = card
                break
            }
        }
        return type
    }
        
    
    
    func validateCreditCardFormat(numcard : String) -> (type: CardType, valid: Bool) {
            // Get only numbers from the input string
            let input = numcard
           // let numberOnly = input.stringByReplacingOccurrencesOfString("[^0-9]", withString: "", options: .RegularExpressionSearch)
            
            let numberOnly = input.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
            
            
            var type: CardType = .Unknown
            var formatted = ""
            var valid = false
            
            // detect card type
            for card in CardType.allCards {
                if (matchesRegex(regex: card.regex, text: numberOnly)) {
                    type = card
                    break
                }
            }
            
            // check validity
            valid = luhnCheck(number: numberOnly)
            
            // format
            var formatted4 = ""
            for character in numberOnly.characters {
                if formatted4.characters.count == 4 {
                    formatted += formatted4 + " "
                    formatted4 = ""
                }
                formatted4.append(character)
            }
            
            formatted += formatted4 // the rest
            
            // return the tuple
            return (type, valid)
        }
        
        func matchesRegex(regex: String!, text: String!) -> Bool {
            do {
                let regex = try NSRegularExpression(pattern: regex, options: [.caseInsensitive])
                let nsString = text as NSString
                let match = regex.firstMatch(in: text, options: [], range: NSMakeRange(0, nsString.length))
                return (match != nil)
            } catch {
                return false
            }
        }
        
        func luhnCheck(number: String) -> Bool {
            var sum = 0
            let digitStrings = number.characters.reversed().map { String($0) }
            
            for tuple in digitStrings.enumerated() {
                guard let digit = Int(tuple.element) else { return false }
                let odd = tuple.offset % 2 == 1
                
                switch (odd, digit) {
                case (true, 9):
                    sum += 9
                case (true, 0...8):
                    sum += (digit * 2) % 9
                default:
                    sum += digit
                }
            }
            
            return sum % 10 == 0
        }
}
