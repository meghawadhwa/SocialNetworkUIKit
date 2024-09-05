//
//  LoginViewModelTests.swift
//  SocialNetworkUIKitTests
//
//  Created by Megha Wadhwa on 05/09/24.
//

@testable import SocialNetworkUIKit

import XCTest
import RxSwift
import RxCocoa


class LoginViewModelTests: XCTestCase {
    var viewModel: LoginViewModel!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        viewModel = LoginViewModel()
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        viewModel = nil
        disposeBag = nil
        super.tearDown()
    }

    func testIsLoginButtonEnabledWithValidEmailAndPassword() {
        // Given
        viewModel.email = "test@example.com"
        viewModel.password = "ValidPass1"
        
        // When
        let expectation = XCTestExpectation(description: "Login button should be enabled")
        viewModel.isLoginButtonEnabled
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { isEnabled in
                if isEnabled {
                    expectation.fulfill()
                }
            })
            .disposed(by: disposeBag)

        // Then
        wait(for: [expectation], timeout: 1.0)
    }

    func testIsLoginButtonEnabledWithInvalidEmail() {
        // Given
        viewModel.email = "invalid-email"
        viewModel.password = "ValidPass1"
        
        // When
        let expectation = XCTestExpectation(description: "Login button should be disabled due to invalid email")
        viewModel.isLoginButtonEnabled
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { isEnabled in
                if !isEnabled {
                    expectation.fulfill()
                }
            })
            .disposed(by: disposeBag)

        // Then
        wait(for: [expectation], timeout: 1.0)
    }

    func testIsLoginButtonEnabledWithShortPassword() {
        // Given
        viewModel.email = "test@example.com"
        viewModel.password = "short"
        
        // When
        let expectation = XCTestExpectation(description: "Login button should be disabled due to short password")
        viewModel.isLoginButtonEnabled
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { isEnabled in
                if !isEnabled {
                    expectation.fulfill()
                }
            })
            .disposed(by: disposeBag)

        // Then
        wait(for: [expectation], timeout: 1.0)
    }

    func testIsLoginButtonEnabledWithLongPassword() {
        // Given
        viewModel.email = "test@example.com"
        viewModel.password = "VeryLongPasswordThatIsInvalid"
        
        // When
        let expectation = XCTestExpectation(description: "Login button should be disabled due to long password")
        viewModel.isLoginButtonEnabled
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { isEnabled in
                if !isEnabled {
                    expectation.fulfill()
                }
            })
            .disposed(by: disposeBag)

        // Then
        wait(for: [expectation], timeout: 1.0)
    }
}
