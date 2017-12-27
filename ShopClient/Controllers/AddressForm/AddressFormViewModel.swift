//
//  AddressFormViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/21/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class AddressFormViewModel: BaseViewModel {
    var countryText = Variable<String>("")
    var firstNameText = Variable<String>("")
    var lastNameText = Variable<String>("")
    var addressText = Variable<String>("")
    var addressOptionalText = Variable<String>("")
    var cityText = Variable<String>("")
    var stateText = Variable<String>("")
    var zipText = Variable<String>("")
    var phoneText = Variable<String>("")
    var shippingAddressAdded = PublishSubject<Bool>()
    var useDefaultShippingAddress = Variable<Bool>(false)
    
    var checkoutId: String!
    
    private var requiredTextFields: [Observable<String>] {
        get {
            return [countryText, firstNameText, lastNameText, addressText, cityText, stateText, zipText, phoneText].map({ $0.asObservable() })
        }
    }
    
    var isAddressValid: Observable<Bool> {
        return Observable.combineLatest(requiredTextFields, { (textFields) in
            return textFields.map({ $0.isEmpty == false }).filter({ $0 == false }).count == 0
        })
    }
    
    var submitTapped: AnyObserver<()> {
        return AnyObserver { [weak self] event in
            self?.submitAction()
        }
    }
    
    var useDefaultAddressTapped: AnyObserver<()> {
        return AnyObserver { [weak self] event in
            self?.updateCheckbox()
        }
    }
    
    private func submitAction() {
        state.onNext(.loading(showHud: true))
        Repository.shared.updateShippingAddress(with: checkoutId, address: getAddress()) { [weak self] (result, error) in
            if let error = error {
                self?.state.onNext(.error(error: error))
            }
            if let _ = result {
                self?.updateCustomerDefaultAddressIfNeeded()
            }
        }
    }
    
    private func updateCustomerDefaultAddressIfNeeded() {
        if useDefaultShippingAddress.value {
            updateCustomerDefaultAddress()
        } else {
            notifyAboutChanges()
        }
    }
    
    private func updateCustomerDefaultAddress() {
        Repository.shared.updateCustomerDefaultAddress(with: getAddress()) { [weak self] (success, error) in
            self?.notifyAboutChanges()
        }
    }
    
    private func notifyAboutChanges() {
        shippingAddressAdded.onNext(true)
        state.onNext(.content)
    }
    
    private func updateCheckbox() {
        useDefaultShippingAddress.value = !useDefaultShippingAddress.value
    }
 
    public func getAddress() -> Address {
        let address = Address()
        address.country = countryText.value.trimmingCharacters(in: .whitespaces)
        address.firstName = firstNameText.value.trimmingCharacters(in: .whitespaces)
        address.lastName = lastNameText.value.trimmingCharacters(in: .whitespaces)
        address.address = addressText.value.trimmingCharacters(in: .whitespaces)
        address.secondAddress = addressOptionalText.value.trimmingCharacters(in: .whitespaces)
        address.city = cityText.value.trimmingCharacters(in: .whitespaces)
        address.state = stateText.value.trimmingCharacters(in: .whitespaces)
        address.zip = zipText.value.trimmingCharacters(in: .whitespaces)
        address.phone = phoneText.value.trimmingCharacters(in: .whitespaces)

        return address
    }
}