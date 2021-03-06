//
//  ProductOptionHeaderView.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/2/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class ProductOptionHeaderView: UICollectionReusableView {
    @IBOutlet private weak var optionNameLabel: UILabel!
    
    // MARK: - Setup
    
    func configure(with title: String) {
        optionNameLabel.text = String.localizedStringWithFormat("Label.Product.OptionTitle".localizable, title)
    }
}
