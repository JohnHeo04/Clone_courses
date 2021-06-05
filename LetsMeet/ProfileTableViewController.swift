//
//  ProfileTableViewController.swift
//  LetsMeet
//
//  Created by John Hur on 2021/06/02.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    //MARK: - IBOutlets
    
    @IBOutlet weak var profileCellBackgroundView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var aboutMeView: UIView!
    @IBOutlet weak var nameAgeLabel: UILabel!
    @IBOutlet weak var cityCountryLabel: UILabel!
    @IBOutlet weak var aboutMeTextView: UITextView!
    
    @IBOutlet weak var jobTextField: UITextField!
    
    @IBOutlet weak var professionTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var lookingForTextField: UITextField!
    
    //MARK: - Vars
    // 편집모드가 아닐때는 편집 불가 상태로 바꾸는 변수
    var editingMode = false
    
    
    
    //MARK: - ViewLifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 31.프로필화면의 Round기능이 버그인가 했지만 아래의 메소드를 활성화 시켜야 Round가 적용되는 것을 찾음
        overrideUserInterfaceStyle = .light
        
        setupBackgrounds()
        
        // 만약 FUser의 '현재 사용자'가 nil로 비어있다면 아래 loadUserData() 함수 활성
        if FUser.currentUser() != nil {
            loadUserData()
            updateEditingMode()
        }
        
    }
    //  프로필에 있는 섹션들을 없앰
    //  return 0으로 반환하여 각 테이블에 있는 Section을 없애줌
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    
    
    //MARK: - IBActions

    @IBAction func settingsButtonPressed(_ sender: Any) {
        
        showEditOptions()
    }
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        
        showPictureOptions()
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        // toggle()은 on or off 스위치 형태로 켰다 껐다 해주는 기능
        editingMode.toggle()
        updateEditingMode()
        // 아래는 if문과 비슷함 - editingMode가 true라면 showKeyboard() 활성, : false라면 hideKeyboard() 활성
        editingMode ? showKeyboard() : hideKeyboard()
        showSaveButton()
    }
    // 아래의 함수 기능은
    @objc func editUserData() {
        
        let user = FUser.currentUser()!
        
        user.about = aboutMeTextView.text
        user.jobTitle = jobTextField.text ?? ""
        user.profession = professionTextField.text ?? ""
        user.isMale = genderTextField.text == "Male"
        user.city = cityTextField.text ?? ""
        user.country = countryTextField.text ?? ""
        user.lookingFor = lookingForTextField.text ?? ""
        user.height = Double(heightTextField.text ?? "0") ?? 0.0
    }
    
    //MARK: - Setup
    private func setupBackgrounds() {
        
        profileCellBackgroundView.clipsToBounds = true
        profileCellBackgroundView.layer.cornerRadius = 100
        profileCellBackgroundView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        //
        aboutMeTextView.layer.cornerRadius = 10
        
    }
    // 'Save' 버튼 만드는 함수
    // 만약 편집 모드 라면 saveButton이 생기고, 아니라면 사라짐
    private func showSaveButton() {
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(editUserData))
        
        navigationItem.rightBarButtonItem = editingMode ? saveButton : nil
    }
    
    //MARK: - LoadUserData
    private func loadUserData() {
        // 현재 사용자의 데이터를 불러오는 함수
        let currentUser = FUser.currentUser()!
        // 년도를 빼면 '-' 마이너스가 발생하지만 여기서 절대값 abs를 써주게 되면 '-' 제거값이 화면에 표기됨
        nameAgeLabel.text = currentUser.username + ", \(abs(currentUser.dateOfBirth.interval(ofComponent: .year, fromDate: Date())))"
        
        
        cityCountryLabel.text = currentUser.country + ", " + currentUser.city
        aboutMeTextView.text = currentUser.about != "" ? currentUser.about : "A little bit about me..."
        jobTextField.text = currentUser.jobTitle
        professionTextField.text = currentUser.profession
        genderTextField.text = currentUser.isMale ? "Male" : "Female"
        cityTextField.text = currentUser.city
        countryTextField.text = currentUser.country
        heightTextField.text = "\(currentUser.height)"
        lookingForTextField.text = currentUser.lookingFor
        avatarImageView.image = UIImage(named: "avatar")
        //TODO: set avatar picture.
    }
    
    
    
    //MARK: - Editing Mode
    private func updateEditingMode() {
        // 아래 height과 lookingFor에 계속 'Fatal Error : Thread 1'오류가 나서 계속 방황하다가 윗쪽에서 'Storyboard'와 위쪽 변수명이 끊긴걸 발견하고 다시 이어줌 😤
        aboutMeTextView.isUserInteractionEnabled = editingMode
        jobTextField.isUserInteractionEnabled = editingMode
        professionTextField.isUserInteractionEnabled = editingMode
        genderTextField.isUserInteractionEnabled = editingMode
        cityTextField.isUserInteractionEnabled = editingMode
        countryTextField.isUserInteractionEnabled = editingMode
        heightTextField.isUserInteractionEnabled = editingMode
        lookingForTextField.isUserInteractionEnabled = editingMode
    }
    
    
    //MARK: - Helpers
    private func showKeyboard() {
        self.aboutMeTextView.becomeFirstResponder()
    }
    
    private func hideKeyboard() {
        self.view.endEditing(false)
    }
    
    //MARK: - AlertController
    // 사용자의 사진 변경을 눌렀을 때 활성화 되는 함수
    // 아래의 함수는 위의 IBActions에서 활성 시킴
    private func showPictureOptions() {
        
        let alertController = UIAlertController(title: "Upload Picture", message: "You can change your Avatar or upload more picture", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Change Avatar", style: .default, handler: { (alert) in
            
            print("change avatar")
        }))
        
        alertController.addAction(UIAlertAction(title: "Upload Pictures", style: .default, handler: { (alert) in
            
            print("upload pictures")
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    
    private func showEditOptions() {
        
        let alertController = UIAlertController(title: "Edit Account", message: "You are about to edit sensitive information about your account", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Change Email", style: .default, handler: { (alert) in
            
            print("Change Email")
        }))
        
        alertController.addAction(UIAlertAction(title: "Change Name", style: .default, handler: { (alert) in
            
            print("Change Name")
        }))
        
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (alert) in
            
            print("Log Out")
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        
        self.present(alertController, animated: true, completion: nil)
        
        
    }

    
}
