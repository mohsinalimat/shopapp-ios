//
//  SettingsProvider.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/29/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

enum SettingsSection: Int {
    case promo
    
    static let allValues = [promo]
}

class SettingsTableProvider: NSObject, UITableViewDataSource {
    var promo: (description: String, state: Bool)?
    
    weak var delegate: SwitchTableCellDelegate?

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        guard promo != nil else {
            return 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SettingsSection.promo.rawValue:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case SettingsSection.promo.rawValue:
            return switchCell(with: tableView, indexPath: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    private func switchCell(with tableView: UITableView, indexPath: IndexPath) -> SwitchTableViewCell {
        let cell: SwitchTableViewCell = tableView.dequeueReusableCellForIndexPath(indexPath)
        cell.delegate = delegate
        if let promo = promo {
            cell.configure(with: indexPath, description: promo.description, state: promo.state)
        }
        return cell
    }
}
