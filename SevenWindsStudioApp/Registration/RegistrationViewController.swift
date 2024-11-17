//
//  RegistrationViewController.swift
//  SevenWindsStudioApp
//
//  Created by Ваня Сокол on 30.10.2024.
//

import UIKit
import SnapKit

final class RegistrationViewController: UIViewController {
    
    private let emailLabel = CoffeeLabel(with: "e-mail")
    private let passwordLabel = CoffeeLabel(with: "Пароль")
    private let repeatPasswordLabel = CoffeeLabel(with: "Повторите пароль")
    private let emailTextField = CoffeeTextField(with: "example@example.ru")
    private let passwordTextField = CoffeeTextField(with: "******")
    private let repeatPasswordTextField = CoffeeTextField(with: "******")
    private let registrationButton = CoffeeButton(with: "Регистрация")
    private var password = ""
    private var repeatPassword = ""
    
    private var isMatchedPasswords: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Регистрация"
        
        setupUI()
        setupLayout()
    }
    
    private func setupUI() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        repeatPasswordTextField.delegate = self
        
        registrationButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
    }
    
    private func setupLayout() {
        let views = [
            emailLabel,
            passwordLabel,
            repeatPasswordLabel,
            emailTextField,
            passwordTextField,
            repeatPasswordTextField,
            registrationButton
        ]
        
        views.forEach { view.addSubview($0) }
        
        
        emailLabel.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(18)
            make.top.equalTo(view.snp.top).offset(278)
            make.trailing.equalTo(view.snp.trailing).offset(-18)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(18)
            make.top.equalTo(emailLabel.snp.bottom).offset(6)
            make.trailing.equalTo(view.snp.trailing).offset(-18)
            make.height.equalTo(47)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(18)
            make.top.equalTo(emailTextField.snp.bottom).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-18)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(18)
            make.top.equalTo(passwordLabel.snp.bottom).offset(6)
            make.trailing.equalTo(view.snp.trailing).offset(-18)
            make.height.equalTo(47)
        }
        
        repeatPasswordLabel.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(18)
            make.top.equalTo(passwordTextField.snp.bottom).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-18)
        }
        
        repeatPasswordTextField.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(18)
            make.top.equalTo(repeatPasswordLabel.snp.bottom).offset(6)
            make.trailing.equalTo(view.snp.trailing).offset(-18)
            make.height.equalTo(47)
        }

        registrationButton.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(18)
            make.top.equalTo(repeatPasswordTextField.snp.bottom).offset(26)
            make.trailing.equalTo(view.snp.trailing).offset(-18)
            make.height.equalTo(47)
        }
    }
    
    private func isValidPassword(password: String) -> Bool {
        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{6,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    @objc private func registerButtonTapped() {
        guard let email = emailTextField.text,
              !email.isEmpty
        else { return }
        
        print(password)
        print(repeatPassword)
        
        let viewController = LoginViewController()
        viewController.modalPresentationStyle = .fullScreen
        
        isMatchedPasswords = password == repeatPassword
        
        if !isMatchedPasswords {
            presentAlert(title: "Требования к паролю",
                         message: "Пароли должны совпадать",
                         actionTitle: "Закрыть")
        }
        
        if isMatchedPasswords && isValidPassword(password: password) {
            NetworkService.shared.register(with: email, and: password) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success:
                    self.present(viewController, animated: true)
                case .failure(let error):
                    print("Registration error: \(error)")
                }
            }
        } else {
            presentAlert(title: "Требования к паролю",
                         message: "Пароль должен содержать заглавный символ, прописной символ, число, длина 6+ символов",
                         actionTitle: "Закрыть")
        }
    }
}


extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            repeatPasswordTextField.becomeFirstResponder()
        } else if textField == repeatPasswordTextField {
            repeatPasswordTextField.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == passwordTextField {
            if string == "" {
                password.removeLast()
                return true
            }
            password += string
            passwordTextField.text = textField.text! + "*"
            return false
        } else if textField == repeatPasswordTextField {
            
            if string == "" {
                repeatPassword.removeLast()
                return true
            }
            repeatPassword += string
            repeatPasswordTextField.text = textField.text! + "*"
            return false
        } else {
            return true
        }
    }
}
