//
//  LoginViewController.swift
//  SevenWindsStudioApp
//
//  Created by Ваня Сокол on 30.10.2024.
//

import UIKit

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
            
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 26),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            loginButton.heightAnchor.constraint(equalToConstant: 47),
        ])
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
