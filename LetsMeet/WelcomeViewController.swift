//
//  WelcomeViewController.swift
//  LetsMeet
//
//  Created by John Hur on 2021/05/24.
//

import UIKit

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
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
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
    
    
}
