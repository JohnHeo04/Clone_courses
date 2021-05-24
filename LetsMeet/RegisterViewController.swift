//
//  RegisterViewController.swift
//  LetsMeet
//
//  Created by John Hur on 2021/05/24.
//

import UIKit

class RegisterViewController: UIViewController {
    
    //MARK: - IBOutlets

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var genderSegmentOutlet: UISegmentedControl!
    
    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: - IBActions

    @IBAction func backButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
    }
    
}
