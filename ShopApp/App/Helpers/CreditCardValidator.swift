//
//  CreditCardValidator.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 2/6/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

class CreditCardValidator {
    private class var types: [CreditCardValidationType] {
        return [(name: "Amex", regex: "^3[47][0-9]{5,}$", imageName: "card_type_amex"),
                (name: "Visa", regex: "^4\\d{0,}$", imageName: "card_type_visa"),
                (name: "MasterCard", regex: "^5[1-5]\\d{0,14}$", imageName: "card_type_master_card"),
                (name: "Diners Club", regex: "^3(?:0[0-5]|[68][0-9])[0-9]{4,}$", imageName: "card_type_dc_card"),
                (name: "JCB", regex: "^(?:2131|1800|35[0-9]{3})[0-9]{3,}$", imageName: "card_type_jcb_card"),
                (name: "Discover", regex: "^6(?:011|5[0-9]{2})[0-9]{3,}$", imageName: "card_type_discover")]
    }
    
    class func cardTypeName(for cardNumber: String) -> String? {
        return type(for: cardNumber)?.name
    }
    
    class func cardImageName(for cardNumber: String) -> String? {
        return type(for: cardNumber)?.imageName
    }
    
    private class func type(for cardNumber: String) -> CreditCardValidationType? {
        for type in types {
            let predicate = NSPredicate(format: "SELF MATCHES %@", type.regex)
            if predicate.evaluate(with: cardNumber) {
                return type
            }
        }
        return nil
    }
}
