//
//  ProfileTableViewController.swift
//  LetsMeet
//
//  Created by John Hur on 2021/06/02.
//

import UIKit
// 아래의 Gallery는 오픈소스
import Gallery
import ProgressHUD

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
    var uploadingAvatar = true
    
    var avatarImage: UIImage?
    var gallery: GalleryController!
    
    var alertTextField: UITextField!
    
    //MARK: - ViewLifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 31.프로필화면의 Round기능이 버그인가 했지만 아래의 메소드를 활성화 시켜야 Round가 적용되는 것을 찾음
        overrideUserInterfaceStyle = .light
        // 현재 여기 생명주기
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
        
        // 사용자가 입력한 정보가 실시간으로 'Firebase'에 업데이트 되는 함수
        if avatarImage != nil {
            //upload new avarat
            //save user
            // Firebase에 avatarLink가 생겨남
            // Storage에 사진 파일이 업로드 됨
            uploadAvatar(avatarImage!) { (avatarLink) in
                
                user.avatarLink = avatarLink ?? ""
                user.avatar = self.avatarImage
                
                self.saveUserData(user: user)
                // 'save'버튼 클릭시 사용자의 데이터를 프로필 아래에 업데이트
                self.loadUserData()
            }
            
        } else {
            //save
            saveUserData(user: user)
            loadUserData()
        }
        
        editingMode = false
        updateEditingMode()
        showSaveButton()
    }
    
    private func saveUserData(user: FUser) {
        
        user.saveUserLocally()
        user.saveUserToFireStore()
        
        
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
        
        FileStorage.downloadImage(imageUrl: currentUser.avatarLink) { (image) in
            
        }

        
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
        avatarImageView.image = UIImage(named: "avatar")?.circleMasked
        //TODO: set avatar picture.
        avatarImageView.image = currentUser.avatar?.circleMasked
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
    
    //MARK: - FileStorage
    
    private func uploadAvatar(_ image: UIImage, completion: @escaping (_ avatarLink: String?) -> Void) {
        
        ProgressHUD.show()
        // 아래 변수는 Firebase Dir에 저장할 변수명 'Avatars/FirstPicture.jpg' 식으로 저장됨
        let fileDirectory = "Avatars/ _" + FUser.currentId() + ".jpg"
        // avatarLink를 받아 옴 ->
        FileStorage.uploadImage(image, directory: fileDirectory) { (avatarLink) in
            
            ProgressHUD.dismiss()
            // save file locally
            FileStorage.saveImageLocally(imageData: image.jpegData(compressionQuality: 0.8)! as NSData, fileName: FUser.currentId())
            completion(avatarLink)
        }
        
    }
    
    private func uploadImages(images: [UIImage?]) {
        // Loading Spinning bar
        ProgressHUD.show()
        // upload images return the links to us
        FileStorage.uploadImages(images) { (imageLinks) in
            
            ProgressHUD.show()
            
            let currentUser = FUser.currentUser()!
            
            currentUser.imageLinks = imageLinks
            
            self.saveUserData(user: currentUser)
            
            
        }
        
    }
    
    //MARK: - Gallery
    
    private func showGallery(forAvatar: Bool) {
        
        uploadingAvatar = forAvatar
        
        self.gallery = GalleryController()
        self.gallery.delegate = self
        Config.tabsToShow = [.imageTab, .cameraTab]
        Config.Camera.imageLimit = forAvatar ? 1 : 10
        Config.initialTab = .imageTab
        
        self.present(gallery, animated: true, completion: nil)
        
    }
    
    
    
    //MARK: - AlertController
    // 사용자의 사진 변경을 눌렀을 때 활성화 되는 함수
    // 아래의 함수는 위의 IBActions에서 활성 시킴
    private func showPictureOptions() {
        
        let alertController = UIAlertController(title: "Upload Picture", message: "You can change your Avatar or upload more picture", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Change Avatar", style: .default, handler: { (alert) in
            
            self.showGallery(forAvatar: true)
        }))
        
        alertController.addAction(UIAlertAction(title: "Upload Pictures", style: .default, handler: { (alert) in
            
            self.showGallery(forAvatar: false)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    
    private func showEditOptions() {
        
        let alertController = UIAlertController(title: "Edit Account", message: "You are about to edit sensitive information about your account", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Change Email", style: .default, handler: { (alert) in
            
            self.showChangeField(value: "Email")
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Change Name", style: .default, handler: { (alert) in
            
            self.showChangeField(value: "Name")
        }))
        
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (alert) in
            
            self.logOutUser()
            
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    //MARK: - Func : Show change Field
    private func showChangeField(value: String) {
        
        let alertView = UIAlertController(title: "Updating \(value)", message: "Please write your \(value)", preferredStyle: .alert)
        
        alertView.addTextField { (textField) in
            // 아래의 변수는 global variable
            self.alertTextField = textField
            self.alertTextField.placeholder = "New \(value)"
        }
        
        alertView.addAction(UIAlertAction(title: "Update", style: .destructive, handler: { (action) in
            
//            print("updating \(value)")
            self.updateUserWith(value: value)
        }))
        
        alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertView, animated: true, completion: nil)
    }
    
    //MARK: - Change user info
    
    private func updateUserWith(value: String) {
        // 만약 email을 업데이트 할 때, 비어있으면 안됨
        // 또한 user name이 20자 이내(?)
        if alertTextField.text != "" {
            // 아래는 if, else문 대신 한 줄로 작성한 if 문
            value == "Email" ? changeEmail() : changeUserName()
        } else {
            ProgressHUD.showError("\(value) is empty")
            
        }
    }
    // 보안상의 이유로 이메일 변경은 이름 변경보다 다소 복잡함
    private func changeEmail() {
        // Firebase의 'Authentication'에 새로운 메일 인증이 완료됨
        FUser.currentUser()?.updateUserEmail(newEmail: alertTextField.text!, completion: { (error) in
            if error == nil {
                if let currentUser = FUser.currentUser() {
                    currentUser.email = self.alertTextField.text!
                    self.saveUserData(user: currentUser)
                }
                
                ProgressHUD.showSuccess("Success!")
            } else {
                ProgressHUD.showError(error!.localizedDescription)
                
            }
        })
        
    }
    
    private func changeUserName() {
//        print("Changing name to \(alertTextField.text!)")
        // 만약 현재 유저가 FUser에 들어있다면~
        if let currentUser = FUser.currentUser() {
            currentUser.username = alertTextField.text!
            // 위에서 currentUser을 업데이트 한다면, 아래에서 저장한다.
            saveUserData(user: currentUser)
            // 새로고침 하여 User Name을 불러옴
            loadUserData()
        }
    }
    
    //MARK: - LogOut
    
    private func logOutUser() {
        
        FUser.logOutCurrentUser { (error) in
            // 아래의 코드는 'Closure'
            // 만약 로그아웃에 성공하면 'Login View'로 넘어감
            // 실패하면 error를 보여줌
            if error == nil {
                
                let loginView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "loginView")
                
                DispatchQueue.main.async {
                    
                    loginView.modalPresentationStyle = .fullScreen
                    self.present(loginView, animated: true, completion: nil)
                }
                
            } else {
                ProgressHUD.showError(error!.localizedDescription)
            }
            
        }
        
    }
    
}

extension ProfileTableViewController: GalleryControllerDelegate {
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        if images.count > 0 {
            
            if uploadingAvatar {
                
                images.first!.resolve { (icon) in
                    
                    if icon != nil {
                        
                        self.editingMode = true
                        self.showSaveButton()
                        // 아래의 .circleMasked가 둥글게 만들어 줌
                        self.avatarImageView.image = icon?.circleMasked
                        self.avatarImage = icon
                    } else {
                        ProgressHUD.showError("Couldn't select image!")
                    }
                }
                
            } else {
                
                Image.resolve(images: images) { (resolvedImages) in
                    
                    self.uploadImages(images: resolvedImages)
                    
                    
                }
                
            }
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}




