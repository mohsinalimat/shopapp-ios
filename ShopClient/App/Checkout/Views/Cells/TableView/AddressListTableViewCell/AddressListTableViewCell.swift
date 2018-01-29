//
//  AddressListTableViewCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/27/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol AddressListTableViewCellProtocol: class {
    func didTapSelect(with address: Address)
    func didTapEdit(with address: Address)
    func didTapDelete(with address: Address)
    func didTapDefault(with address: Address)
}

class AddressListTableViewCell: UITableViewCell {
    @IBOutlet private weak var customerNameLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var phoneLabel: UILabel!
    @IBOutlet private weak var selectButton: UIButton!
    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var deleteButton: UIButton!
    @IBOutlet private weak var defaultAddressButton: UIButton!
    
    private var address: Address!
    
    weak var delegate: AddressListTableViewCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        setupViews()
    }
    
    func configure(with address: Address, isSelected: Bool, isDefault: Bool) {
        self.address = address
        populateViews(with: address, isSelected: isSelected, isDefault: isDefault)
    }
        
    private func setupViews() {
        editButton.setTitle("Button.Edit".localizable.uppercased(), for: .normal)
        deleteButton.setTitle("Button.Delete".localizable.uppercased(), for: .normal)
        defaultAddressButton.setTitle("Button.Default".localizable.uppercased(), for: .normal)
    }
    
    private func populateViews(with address: Address, isSelected: Bool, isDefault: Bool) {
        customerNameLabel.text = address.fullName
        addressLabel.text = address.fullAddress
        if let phoneText = address.phone {
            let customerNameLocalized = "Label.Phone".localizable
            phoneLabel.text = String.localizedStringWithFormat(customerNameLocalized, phoneText)
        } else {
            phoneLabel.text = nil
        }
        selectButton.isSelected = isSelected
        deleteButton.isEnabled = !isSelected
        defaultAddressButton.isEnabled = !isDefault
    }
    
    // MARK: - Actions
    
    @IBAction func selectTapped(_ sender: UIButton) {
        delegate?.didTapSelect(with: address)
    }
    
    @IBAction func editTapped(_ sender: UIButton) {
        delegate?.didTapEdit(with: address)
    }
    
    @IBAction func deleteTapped(_ sender: UIButton) {
        delegate?.didTapDelete(with: address)
    }
    
    @IBAction func defaultAddressTapped(_ sender: UIButton) {
        delegate?.didTapDefault(with: address)
    }
}
