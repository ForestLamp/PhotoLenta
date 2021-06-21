//
//  SignUPController.swift
//  PhotoLenta
//
//  Created by Alex Ch. on 17.06.2021.
//

import UIKit
import Firebase

class SignUPController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imageSelected = false

    fileprivate let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.rgb(red: 149, green: 204, blue: 244).cgColor
        button.addTarget(self, action: #selector(selectPhoto), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func selectPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    fileprivate let emailTextField = UITextField.setupTextField(placeholder: "E-mail", hideText: false)
    fileprivate let fullTextField = UITextField.setupTextField(placeholder: "Full Name", hideText: false)
    fileprivate let userNameTextField = UITextField.setupTextField(placeholder: "Nick", hideText: false)
    fileprivate let passwordTextField = UITextField.setupTextField(placeholder: "Password", hideText: true)
    fileprivate let signUPButton = UIButton.setupButton(title: "Sign UP!", color: UIColor.rgb(red: 149, green: 204, blue: 244))

    fileprivate let alredyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        // first part of button
        let attributedTitle = NSMutableAttributedString(string: "Alredy have an account?  ", attributes: [.font:UIFont.systemFont(ofSize: 18), .foregroundColor: UIColor.lightGray])
        // second part of button
        attributedTitle.append(NSAttributedString(string: "Sing In!", attributes: [.font:UIFont.systemFont(ofSize: 18, weight: .heavy), .foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(goToSignIN), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func goToSignIN() {
        dismiss(animated: true, completion: nil)
    }
 // MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewComponents()
        setupNotificationObserver()
        setupTapGesture()
        handlers()
    }
    
// MARK: ImagePicker
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let profileImage = info[.editedImage] as? UIImage else {
            imageSelected = false
            return
        }
        
        imageSelected = true
        selectPhotoButton.layer.cornerRadius = selectPhotoButton.frame.width / 2
        selectPhotoButton.layer.masksToBounds = true
        selectPhotoButton.layer.backgroundColor = UIColor.black.cgColor
        selectPhotoButton.layer.borderWidth = 2
        selectPhotoButton.layer.borderColor = UIColor.black.cgColor
        selectPhotoButton.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        self.dismiss(animated: true, completion: nil)
    }
    
// MARK: Handler
    
    fileprivate func handlers() {
        emailTextField.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        fullTextField.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        userNameTextField.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        signUPButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
    }
    
    @objc fileprivate func handleSignUp() {
        print("SignUP")
        guard let email = emailTextField.text?.lowercased() else {return}
        guard let password = passwordTextField.text else {return}
        guard let fullName = fullTextField.text else {return}
        guard let userName = userNameTextField.text?.lowercased() else { return}
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, err) in
            if let err = err {
                print(err.localizedDescription)
                return
        }
            print("Registration complete.")
            
            guard let profileImage = self.selectPhotoButton.imageView?.image else {return}
            guard let uploadData = profileImage.jpegData(compressionQuality: 0.3) else {return}
            
            let fileName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_image").child(fileName)
            
            storageRef.putData(uploadData, metadata: nil) { (_, err) in
                if let err = err {
                    print(err.localizedDescription)
                    return
                }
                print("Upload is succes!")
                storageRef.downloadURL { (downLoadURL, err) in
                    guard let profileImageURL = downLoadURL?.absoluteString else { return}
                    if let err = err{
                        print("Profile image is nil! \(err.localizedDescription)")
                        return
                    }
                    print("URL catch!")
                    guard let uid = user?.user.uid else { return}
                    let dictionaryValues = ["name": fullName, "username": userName, "profileImegeURL": profileImageURL]
                    let values = [uid: dictionaryValues]
                    Firestore.firestore().collection("users").document(uid).setData(values) {(err) in
                        if let err = err {
                            print("Failed \(err.localizedDescription)")
                            return
                        }
                        print("Data succes saved!")
                    }
                    
                }
                
            }
            
        }
    }
    
    @objc fileprivate func formValidation() {
        guard
            emailTextField.hasText,
            fullTextField.hasText,
            userNameTextField.hasText,
            passwordTextField.hasText,
            imageSelected == true else {
            signUPButton.isEnabled = false
            signUPButton.backgroundColor = UIColor.rgb(red: 146, green: 204, blue: 244)
            return
        }
        signUPButton.isEnabled = true
        signUPButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
    }

    
    lazy var stackView = UIStackView(arrangedSubviews: [
    emailTextField,
    fullTextField,
    userNameTextField,
    passwordTextField,
    signUPButton
    ])
    
    fileprivate func configureViewComponents() {
        view.backgroundColor = .white
        
        view.addSubview(selectPhotoButton)
        navigationController?.navigationBar.isHidden = true
        selectPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 16, left: 0, bottom: 0, right: 0), size: .init(width: 250, height: 250))
        selectPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        selectPhotoButton.layer.cornerRadius = 250/2
        
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: selectPhotoButton.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 40, bottom: 0, right: 40), size: .init(width: 0, height: 280))
        
        view.addSubview(alredyHaveAccountButton)
        alredyHaveAccountButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 40, bottom: 10, right: 40))
    }
    
    // MARK: Keyboard
    
    fileprivate func setupNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc fileprivate func handleKeyboardShow(notification: Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        let bottomSpace = view.frame.height - stackView.frame.origin.y - stackView.frame.height
        let difference = keyboardFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 20)
   }
    @objc fileprivate func handleKeyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options:
            .curveEaseOut, animations: {
            self.view.transform = .identity
        }, completion: nil)
        
    }
    
    fileprivate func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    @ objc fileprivate func handleTapDismiss(){
        view.endEditing(true)
    }
}
