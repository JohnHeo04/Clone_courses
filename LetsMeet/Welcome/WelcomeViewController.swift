//
//  WelcomeViewController.swift
//  LetsMeet
//
//  Created by John Hur on 2021/05/24.
//

import UIKit
import ProgressHUD

class WelcomeViewController: UIViewController {
    
    //MARK: - IBOutlets
    // 스토리보드에 그린 TextField를 이쪽 swift와 연결해줌
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    
    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .dark
        // 키보드가 켜진 상태에서 위의 빈화면을 클릭하게 되면 키보드가 사라지는 함수 설정
        // 함수 자세한 설정은 아래에서 볼 수 있음
        setupBackgroundTouch()

    }
    
    
    //MARK: - IBACtions
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        // 'Forget Password?'를 눌렀을 때
        // 만약 emailTextField가 비워져있지 않다면 "" 비워져있다면 API ProgessHUD중 Error "Please ~"를 출력
        if emailTextField.text != "" {
            // reset password
            FUser.resetPassword(email: emailTextField.text!) { (error) in
                
                if error != nil {
                    
                    ProgressHUD.showError(error!.localizedDescription)
                } else {
                    ProgressHUD.showSuccess("Please check your email!")
                }
            }
            
        } else {
            // show error
            ProgressHUD.showError("Please insert your email addreess")
        }
        
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        // 'Login' Button을 눌렀을 때 
        // 만약 emailTextField와 passwordTextField 둘 다 비워져있지 않다면 "" 출력
        // 둘 다 비워져있다면 "All ~"를 출력함
        if emailTextField.text != "" && passwordTextField.text != ""{
            //login
            ProgressHUD.show()
            
            FUser.loginUserWith(email: emailTextField.text!, password: passwordTextField.text!) { (error, isEmailVerified) in
                
                if error != nil {
                    
                    ProgressHUD.showError(error!.localizedDescription)
                } else if isEmailVerified {
//                    print("go to app")
                    // enter the application
                    
                    ProgressHUD.dismiss()
                    self.goToApp()
                } else {
                    
                    ProgressHUD.showError("Please verify your email!")
                }
                
            }
            
        } else {
            ProgressHUD.showError("All fields are required!")
        }
        
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
    
    
    //MARK: - Navigation
    private func goToApp() {
        
        let mainView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "MainView") as! UITabBarController
        
        // 로그인 다음화면에서 나오는 화면을 full screen으로 계속해서 설정하게 해놓음
        mainView.modalPresentationStyle = .fullScreen
        self.present(mainView, animated: true, completion: nil)
        
    }
    
}
