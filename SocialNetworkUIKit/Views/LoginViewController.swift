//
//  LoginViewController.swift
//  SocialNetworkUIKit
//
//  Created by Megha Wadhwa on 05/09/24.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    // MARK: - UI Components
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - ViewModel
    private let viewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /// Disable swipe-to-dismiss
        self.isModalInPresentation = true
    }
    // MARK: - Setup UI
    private func setupUI() {
        self.title = "Login"
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Enter your email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Enter your password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        emailTextField.borderStyle = .bezel
        passwordTextField.borderStyle = .bezel
        passwordTextField.isSecureTextEntry = true
        loginButton.layer.cornerRadius = 8
        loginButton.isEnabled = false
        loginButton.backgroundColor = .gray
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.setTitleColor(.white, for: .disabled)
    }
    
    // MARK: - Setup Bindings
    private func setupBindings() {
        // Bind emailTextField's text to viewModel's emailSubject
        emailTextField.rx.text.orEmpty
            .bind(to: viewModel.emailSubject)
            .disposed(by: disposeBag)
        
        // Bind passwordTextField's text to viewModel's passwordSubject
        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.passwordSubject)
            .disposed(by: disposeBag)
        
        // Bind the login button's enabled state to viewModel's isLoginButtonEnabled observable
        viewModel.isLoginButtonEnabled
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isEnabled in
                self?.loginButton.isEnabled = isEnabled
                self?.loginButton.backgroundColor = isEnabled ? .blue : .gray
            })
            .disposed(by: disposeBag)
        
        // Handle login button tap
        loginButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}
