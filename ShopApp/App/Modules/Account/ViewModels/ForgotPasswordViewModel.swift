//
//  ForgotPasswordViewModel.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/2/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class ForgotPasswordViewModel: BaseViewModel {
    private let resetPasswordUseCase: ResetPasswordUseCase
    
    var emailText = Variable<String>("")
    var emailErrorMessage = PublishSubject<String>()
    var resetPasswordSuccess = PublishSubject<Bool>()
    
    var resetPasswordButtonEnabled: Observable<Bool> {
        return emailText.asObservable().map { email in
            email.hasAtLeastOneSymbol()
        }
    }
    var resetPasswordPressed: AnyObserver<Void> {
        return AnyObserver { [weak self] event in
            switch event {
            case .next:
                guard let strongSelf = self else {
                    return
                }
                strongSelf.checkCresentials()
            default:
                break
            }
        }
    }

    init(resetPasswordUseCase: ResetPasswordUseCase) {
        self.resetPasswordUseCase = resetPasswordUseCase
    }
    
    private func checkCresentials() {
        if emailText.value.isValidAsEmail() {
            resetPassword()
        } else {
            processErrors()
        }
    }
    
    private func processErrors() {
        let errorMessage = "Error.InvalidEmail".localizable
        emailErrorMessage.onNext(errorMessage)
    }
    
    private func resetPassword() {
        state.onNext(ViewState.make.loading(isTranslucent: true))
        resetPasswordUseCase.resetPassword(with: emailText.value) { [weak self] (success, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.state.onNext(.error(error: error))
            } else if success != nil {
                strongSelf.state.onNext(.content)
            }
            strongSelf.resetPasswordSuccess.onNext(error == nil && success == true)
        }
    }
    
    // MARK: - BaseViewModel
    
    override func tryAgain() {
        checkCresentials()
    }
}
