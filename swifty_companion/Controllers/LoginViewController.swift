//
//  LoginViewController.swift
//  swifty_companion
//
//  Created by Anisa Kapateva on 09.06.2023.
//

import Foundation
import Alamofire

protocol LoginViewControllerProtocol: AnyObject {
    func passFetchedModel(_ model: UserInfoDTO)
}

class LoginViewController: UIViewController, UITextFieldDelegate {
    weak var delegate: LoginViewControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginTextField.delegate = self
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        loginTextField.becomeFirstResponder()
    }
    
//    override var preferredFocusEnvironments: [UIFocusEnvironment] {
//        return [loginTextField]
//    }
    
    private var loginTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter login"
        textField.borderStyle = .roundedRect
        textField.isUserInteractionEnabled = true
        textField.keyboardType = .default
        textField.autocorrectionType = .no
        return textField
    }()
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        loginTextField.resignFirstResponder()
        let enteredText = loginTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        openUserInfoView(entered: enteredText)
        return true
    }
    
    func openUserInfoView(entered login: String) {
        guard !login.isEmpty else { return }
        let urlString = "users?filter[login]=" + ("\(login.lowercased()),\(login.uppercased())")
        Authentication.shared.fetchUserLogin(user: urlString, responceType: [UserModelDTO].self) { result in
            switch result {
            case .success(let model):
                print(model[0])
                let userInfoURL = "users/\(model[0].id)"

                Authentication.shared.fetchUserLogin(user: userInfoURL, responceType: UserInfoDTO.self) { result in
                    switch result {
                    case .success(let model):
                        DispatchQueue.main.async {
                            self.loginTextField.text = ""
                            let userInfoViewController = UserInfoViewController()
                            userInfoViewController.modalPresentationStyle = .overFullScreen
                            self.delegate = userInfoViewController
                            self.delegate?.passFetchedModel(model)
                            self.present(userInfoViewController, animated: true, completion: nil)
                            print(model)
                        }
                    case .failure(let err):
                        DispatchQueue.main.async {
                            print("Error while second fetch: USERINFODTO")
                            print(err)
                        }
                    }
                }
            case .failure(let err):
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: "Please make sure you enter the right student login")
                    print("Error while first fetch: USERMODELDTO. \(err.localizedDescription)")
                }
            }
        }
    }
}

extension LoginViewController {
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let button = UIAlertAction(title: "ok", style: .default)
        alertController.addAction(button)
        present(alertController, animated: true)
    }
    
    private func setup() {
        if let image = UIImage(named: "background.jpeg") {
            self.view.backgroundColor = UIColor(patternImage: image)
        } else {
            self.view.backgroundColor = .lightGray
        }
        view.addSubview(loginTextField)
        loginTextField.layer.cornerRadius = max(0, min(loginTextField.frame.height / 2, 10))
        loginTextField.translatesAutoresizingMaskIntoConstraints = false
        let width: CGFloat = 200.0
        let height: CGFloat = 50.0
        NSLayoutConstraint.activate([
            loginTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginTextField.widthAnchor.constraint(equalToConstant: width),
            loginTextField.heightAnchor.constraint(equalToConstant: height)
        ])
    }
}
