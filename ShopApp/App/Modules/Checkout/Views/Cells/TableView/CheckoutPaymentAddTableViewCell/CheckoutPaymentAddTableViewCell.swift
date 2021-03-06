//
//  CheckoutPaymentAddTableViewCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/29/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol CheckoutPaymentAddCellDelegate: class {
    func tableViewCell(_ cell: CheckoutPaymentAddTableViewCell, didTapAdd paymentType: PaymentAddCellType)
}

enum PaymentAddCellType: Int {
    case type
    case card
    case billingAddress
    
    static let allValues = [type, card, billingAddress]
}

class CheckoutPaymentAddTableViewCell: UITableViewCell {
    @IBOutlet private weak var addPaymentButton: BlackButton!
    
    private var paymentRow: PaymentAddCellType = .type
    
    weak var delegate: CheckoutPaymentAddCellDelegate?
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    func configure(type: PaymentAddCellType) {
        paymentRow = type
        switch type {
        case PaymentAddCellType.type:
            addPaymentButton.setTitle("Button.AddPaymentType".localizable.uppercased(), for: .normal)
        case PaymentAddCellType.card:
            addPaymentButton.setTitle("Button.AddCard".localizable.uppercased(), for: .normal)
        case PaymentAddCellType.billingAddress:
            addPaymentButton.setTitle("Button.AddBillingAddress".localizable.uppercased(), for: .normal)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func addPaymentTapped(_ sender: BlackButton) {
        delegate?.tableViewCell(self, didTapAdd: paymentRow)
    }
}
