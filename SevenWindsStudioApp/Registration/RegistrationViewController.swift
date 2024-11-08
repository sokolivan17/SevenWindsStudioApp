//
//  RegistrationViewController.swift
//  SevenWindsStudioApp
//
//  Created by Ваня Сокол on 30.10.2024.
//

import UIKit

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
        
        NSLayoutConstraint.activate([
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            emailLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 278),
            emailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 6),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            emailTextField.heightAnchor.constraint(equalToConstant: 47),
            
            passwordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 6),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            passwordTextField.heightAnchor.constraint(equalToConstant: 47),
            
            repeatPasswordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            repeatPasswordLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            repeatPasswordLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            
            repeatPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            repeatPasswordTextField.topAnchor.constraint(equalTo: repeatPasswordLabel.bottomAnchor, constant: 6),
            repeatPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            repeatPasswordTextField.heightAnchor.constraint(equalToConstant: 47),
            
            registrationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            registrationButton.topAnchor.constraint(equalTo: repeatPasswordTextField.bottomAnchor, constant: 26),
            registrationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            registrationButton.heightAnchor.constraint(equalToConstant: 47),
        ])
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
