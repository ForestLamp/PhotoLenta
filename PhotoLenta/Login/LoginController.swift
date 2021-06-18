//
//  LoginController.swift
//  PhotoLenta
//
//  Created by Alex Ch. on 17.06.2021.
//

import UIKit
import Firebase

class LoginController: UIViewController {

    //MARK: - Properties
    
    private let logoContainerView: UIView = {
        let view = UIView()
        let logoImageView = UIImageView(image:#imageLiteral(resourceName: "logo2-removebg-preview"))
        logoImageView.contentMode = .scaleAspectFill
        logoImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 400, height: 250))
        view.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175)
        view.addSubview(logoImageView)
        return view
    }()
    
    private let emailTextField = UITextField.setupTextField(placeholder: "E-mail", hideText: false)
    
    private let passwordTextField = UITextField.setupTextField(placeholder: "Password", hideText: true)
    
    private let loginButton = UIButton.setupButton(title: "Login", color: UIColor.rgb(red: 149, green: 204, blue: 244))
    
    private let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        // first part of button
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [.font:UIFont.systemFont(ofSize: 18), .foregroundColor: UIColor.lightGray])
        // second part of button
        attributedTitle.append(NSAttributedString(string: "Sing UP!", attributes: [.font:UIFont.systemFont(ofSize: 18, weight: .heavy), .foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(goToSignUP), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func goToSignUP() {
        let signUPController = SignUPController()
        let navController = UINavigationController(rootViewController: signUPController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewComponents()
        setupTapGesture()
        handlers()
        
    }
    
    fileprivate func handlers() {
        emailTextField.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
    }
    
    @objc fileprivate func handleLogin(){
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, err ) in
            if let err = err {
                print("Failed login with error: \(err.localizedDescription)")
                return
            }
            print("Successfuly signed user in")
            let mainTabVC = MainTabVC()
            mainTabVC.modalPresentationStyle = .fullScreen
            self.present(mainTabVC, animated: true, completion: nil)
        }
        
    }
    
    @objc fileprivate func formValidation() {
        guard
            emailTextField.hasText,
            passwordTextField.hasText
            else {
            self.loginButton.isEnabled = false
            self.loginButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
            return
        }
        loginButton.isEnabled = true
        loginButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
    }
    
    fileprivate func configureViewComponents() {
        view.backgroundColor = .black
        view.addSubview(logoContainerView)

        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: logoContainerView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 250, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 180))
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 40, bottom: 10, right: 40))
    }
// MARK: Keyboard
    
    fileprivate func setupTapGesture(){
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    @objc fileprivate func handleTapDismiss(){
        view.endEditing(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}
