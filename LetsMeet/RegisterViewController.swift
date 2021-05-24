//
//  RegisterViewController.swift
//  LetsMeet
//
//  Created by John Hur on 2021/05/24.
//

import UIKit
import ProgressHUD

class RegisterViewController: UIViewController {
    
    //MARK: - IBOutlets
    // 스토리보드에서 그린 '회원 가입'화면 중 TextField를 아래의 코드로 연결을 해줌
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var genderSegmentOutlet: UISegmentedControl!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    //MARK: - Vars
    var isMale = true
    
    
    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .dark
        setupBackgroundTouch()
    }
    
    //MARK: - IBActions

    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        
        if isTextDataImputed() {
            registerUser()
        } else {
            ProgressHUD.showError("All fields are required!")
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func genderSegmentValueChanged(_ sender: UISegmentedControl) {
        
        // 사실 위에서 isMale 변수를 true로 선언해줬기 때문에, 뒤에 ? true : false를 붙일 필요없음
        isMale = sender.selectedSegmentIndex == 0
            //? true : false
        print(isMale)
        
    }
    
    
    //MARK: - Setup
    
    // 배경을 터치하면 키보드가 사라지게 됨
    private func setupBackgroundTouch() {
        backgroundImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        backgroundImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func backgroundTap() {
        dismissKeyboard()
    }
    
    //MARK: - Helpers
    // 배경을 누르면 사라졌던 키보드를 아래의 함수로 다시 호출하게 됨
    private func dismissKeyboard() {
        self.view.endEditing(false)
        
    }
    
    
    
    private func isTextDataImputed() -> Bool {
        // 가입화면 중 모든 TextField가 채워져있다면 에러가 발생하지 않음
        // && 하나라도 만족시키지 않으면 False의 else - "All fields are required!" 출력
        return  usernameTextField.text != "" && emailTextField.text != "" && cityTextField.text != "" && dateOfBirthTextField.text != "" && passwordTextField.text != "" && confirmPasswordTextField.text != ""
    }
    
    //MARK: - RegisterUser
    // 아래의 registerUser 함수는 위의 isTextDataImputed 함수 true가 체크 되고나서 실행이 됨
    private func registerUser() {
        
        FUser.registerUserWith(email: emailTextField.text!, password: passwordTextField.text!, userName: usernameTextField.text!, city: cityTextField.text!, isMale: isMale, dateOfBirth: Date(), completion: {
            error in
            
                print("callback")
                               
        })
    }
}
