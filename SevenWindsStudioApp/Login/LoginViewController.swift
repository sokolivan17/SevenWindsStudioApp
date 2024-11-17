//
//  LoginViewController.swift
//  SevenWindsStudioApp
//
//  Created by Ваня Сокол on 30.10.2024.
//

import UIKit
import SnapKit

final class LoginViewController: UIViewController {
    
    private let emailLabel = CoffeeLabel(with: "e-mail")
    private let passwordLabel = CoffeeLabel(with: "Пароль")
    private let emailTextField = CoffeeTextField(with: "example@example.ru")
    private let passwordTextField = CoffeeTextField(with: "******")
    private let loginButton = CoffeeButton(with: "Войти")
    private var password = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Вход"
        navigationItem.backButtonTitle = ""
        
        setupUI()
        setupLayout()
    }
    
    private func setupUI() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = false
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    private func setupLayout() {
        let views = [
            emailLabel,
            passwordLabel,
            emailTextField,
            passwordTextField,
            loginButton
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
        
        loginButton.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(18)
            make.top.equalTo(passwordTextField.snp.bottom).offset(26)
            make.trailing.equalTo(view.snp.trailing).offset(-18)
            make.height.equalTo(47)
        }
    }
    
    @objc private func loginButtonTapped() {
        guard let email = emailTextField.text,
              let securedPassword = passwordTextField.text,
              !email.isEmpty && !securedPassword.isEmpty
        else { return }
        
        print(password)
        
        NetworkService.shared.login(with: email, and: password) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let answer):
                let viewController = LocationsViewController()
                UserDefaults.standard.setValue(answer.token, forKey: "token")
                self.navigationController?.pushViewController(viewController, animated: true)
            case .failure(let error):
                print("Login error: \(error)")
                let viewController = RegistrationViewController()
                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated: true)
            }
        }
    }
}


extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
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
        } else {
            return true
        }
    }
}
