//
//  CheckoutCreditCardEditTableViewCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 1/3/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import UIKit

import ShopApp_Gateway

protocol CheckoutCreditCardEditTableCellDelegate: class {
    func tableViewCellDidTapEditCard(_ cell: CheckoutCreditCardEditTableViewCell)
}

class CheckoutCreditCardEditTableViewCell: UITableViewCell {
    @IBOutlet private weak var cardTypeImageView: UIImageView!
    @IBOutlet private weak var cardNumberLabel: UILabel!
    @IBOutlet private weak var expirationDateLabel: UILabel!
    @IBOutlet private weak var holderNameLabel: UILabel!
    @IBOutlet private weak var editButton: UIButton!
    
    weak var delegate: CheckoutCreditCardEditTableCellDelegate?
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        editButton?.setTitle("Button.Edit".localizable.uppercased(), for: .normal)
    }
    
    func configure(with creditCard: CreditCard) {
        cardNumberLabel.text = creditCard.maskedNumber
        expirationDateLabel.text = creditCard.expirationDateLocalized
        holderNameLabel.text = creditCard.holderName
        cardTypeImageView.image = UIImage(named: creditCard.cardImageName)
    }
    
    // MARK: - Actions
    
    @IBAction func editButtonDidPress(_ sender: UIButton) {
        delegate?.tableViewCellDidTapEditCard(self)
    }
}
