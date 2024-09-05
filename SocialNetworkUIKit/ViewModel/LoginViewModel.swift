//
//  LoginViewModel.swift
//  SocialNetwork
//
//  Created by Megha Wadhwa on 02/09/24.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel: ObservableObject {
    // Inputs
    @Published var email: String = "" {
        didSet {
            emailSubject.accept(email)
        }
    }
    
    @Published var password: String = "" {
        didSet {
            passwordSubject.accept(password)
        }
    }
    
    let emailSubject = BehaviorRelay<String>(value: "")
    let passwordSubject = BehaviorRelay<String>(value: "")
    
    /// This variable helps is an observable which combines the latest values from emailSubject & loginSubject
    var isLoginButtonEnabled: Observable<Bool> {
        return Observable
            .combineLatest(emailSubject, passwordSubject)
            .map { [weak self] email, password in
                guard let self = self else { return false }
                return self.validateEmail(email) && self.validatePassword(password)
            }
            .distinctUntilChanged()
    }
    
    private let disposeBag = DisposeBag()
    
    /// This function helps in checking the validity of email by checking email regex
    /// - Parameter email:  latest email text
    private func validateEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    /// This function helps in checking the validity of password by checking its count
    /// - Parameter password:  latest password text
    private func validatePassword(_ password: String) -> Bool {
        return password.count >= 8 && password.count <= 15
    }
}
