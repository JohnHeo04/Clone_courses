//
//  FUser.swift
//  LetsMeet
//
//  Created by John Hur on 2021/05/24.
//

import Foundation
import Firebase
import UIKit
//import Fi

// 한 유저가 같은 ID를 가지고 있다면 체크하는 class protocol
// Equatable은 Protocol임
class FUser: Equatable {
    
    // lhs = left hand side, rhs = right hand side
    static func == (lhs: FUser, rhs: FUser) -> Bool {
        lhs.objectId == rhs.objectId
    }
    // objectID는 변하면 안 돼서 let 선언
    // 다른 변수는 변경할 수 있으므로 var 선언해서 추후에도 변경할 수 있도록 함
    let objectId: String
    var email: String
    var username: String
    var dateOfBirth: Date
    var isMale: Bool
    var avatar: UIImage?
    var profession: String
    var jobTitle: String
    var about: String
    var city: String
    var country: String
    var height: Double
    var lookingFor: String
    // 사용자가 첫번째 보여지는 프로필 사진
    var avatarLink: String
    
    var likedIdArray: [String]?
    // 사용자에게 avatarLink사진 이후 보여지는 "여러" 프로필 사진
    var imageLinks: [String]?
    // 사용자가 가입을 하게되면 시간을 찍어줌
    let registeredDate = Date()
    // 사용자에게 Push 알림을 보내는 변수
    var pushId: String?
    
    // 'NS'는 obj-c로부터 온거임
    // conrol + I = 자동 들여쓰기
    // shift + option = 드래그 하여 let,var를 self로 한번에 고치기 가능
    var userDictionary: NSDictionary {
        
        return NSDictionary(objects: [
                                    self.objectId,
                                    self.email,
                                    self.username,
                                    self.dateOfBirth,
                                    self.isMale,
                                    self.profession,
                                    self.jobTitle,
                                    self.about,
                                    self.city,
                                    self.country,
                                    self.height,
                                    self.lookingFor,
                                    self.avatarLink,
                                    
                                    self.likedIdArray ?? [],
                                    self.imageLinks ?? [],
                                    self.registeredDate,
                                    self.pushId ?? ""
            
            ],
            // objects와 forKeys에서 순서는 굉장히 중요함
            // objects의 순서와 forKeys 순서는 같은 순서로 움직임
            // ex) objects의 첫 번째는 forKeys의 첫 번째와 매칭이 됨 
            forKeys: [kOBJECTID as NSCopying,
                    kEMAIL as NSCopying,
                    kUSERNAME as NSCopying,
                    kDATEOFBIRTH as NSCopying,
                    kISMALE as NSCopying,
                    kPROFESSION as NSCopying,
                    kJOBTITLE as NSCopying,
                    kABOUT as NSCopying,
                    kCITY as NSCopying,
                    kCOUNTRY as NSCopying,
                    kHEIGHT as NSCopying,
                    kLOOKINGFOR as NSCopying,
                    kAVATARLINK as NSCopying,
                    kLIKEDIDARRAY as NSCopying,
                    kIMAGELINKS as NSCopying,
                    kREGISTEREDDATE as NSCopying,
                    kPUSHID as NSCopying
                
                
                ])
        
    }
    
    //MARK: - Inits
    // 아래는 위의 변수들을 초기 선언해줌
    // 사용자의 첫 번째 초기 값을 설정해줌
    init(_objectId: String, _email: String, _username: String, _city: String, _dateOfBirth: Date, _isMale: Bool, _avatarLink: String = "") {
        
        objectId = _objectId
        email = _email
        username = _username
        dateOfBirth = _dateOfBirth
        isMale = _isMale
        profession = ""
        jobTitle = ""
        about = ""
        city = _city
        country = ""
        height = 0.0
        lookingFor = ""
        avatarLink = _avatarLink
        likedIdArray = []
        imageLinks = []
        
    }
    
    init(_dictionary: NSDictionary) {
        // as! String 은 강제로 String타입으로 형변환 함
        // 그러나 경우에 따라 사용자가 objectId를 가지지 않을경우 앱에서 충돌을 일으키게 됨
        // 해결책 : as? 로 해결이 가능함
        //  또한 '??' 를 붙여서 만약 string이 아닐 경우 "" 빈 string형태로 바꿔줌
        objectId = _dictionary[kOBJECTID] as? String ?? ""
        email = _dictionary[kEMAIL] as? String ?? ""
        username = _dictionary[kUSERNAME] as? String ?? ""
        isMale = _dictionary[kISMALE] as? Bool ?? true
        profession = _dictionary[kPROFESSION] as? String ?? ""
        jobTitle = _dictionary[kJOBTITLE] as? String ?? ""
        about = _dictionary[kABOUT] as? String ?? ""
        city = _dictionary[kCITY] as? String ?? ""
        country = _dictionary[kCOUNTRY] as? String ?? ""
        height = _dictionary[kHEIGHT] as? Double ?? 0.0
        lookingFor = _dictionary[kLOOKINGFOR] as? String ?? ""
        avatarLink = _dictionary[kAVATARLINK] as? String ?? ""
        likedIdArray = _dictionary[kLIKEDIDARRAY] as? [String]
        imageLinks = _dictionary[kIMAGELINKS] as? [String]
        pushId = _dictionary[kPUSHID] as? String ?? ""
        
        // 모든 Data를 안전하게 지키는 법
        if let date = _dictionary[kDATEOFBIRTH] as? Timestamp {
            // 아래의 dataValue()함수는 Firebase로부터 가져옴
            // 아래의 object는 timestamp로부터 date를 가져옴
            dateOfBirth = date.dateValue()
        } else {
            // 만약 사용자가 만든 date Of Birth가 오류를 일으키거나 뭔가를 놓쳤다면 현재의 Date를 생성한다.
            // 아래의 ?? 를 optional이라 부름
            dateOfBirth = _dictionary[kDATEOFBIRTH] as? Date ?? Date()
        }
        // 프로필의 기본 이미지 설정을 만약 남자라면 'mPlaceholder' 출력 아니라면 'fPlaceholder' 출력
        let placeHolder = isMale ? "mPlaceholder" : "fPlaceholder"
        // Dictionary에 Avatar image를 set하기 위한
        avatar = UIImage(named: placeHolder)
        
    }
    
    //MARK: - Returning current user
    
    class func currentId() -> String {
        return Auth.auth().currentUser!.uid
        
    }
    // 현재 사용자를 인증하는 함수
    // 만약 userDefaults에 forKey, kCURRENTUSER가 있다면 userDictionary는 유효함
    // 만약 없다면 nil 아무것도 반환하지 않음
    class func currentUser() -> FUser? {
        
        if Auth.auth().currentUser != nil {
            if let userDictionary = userDefaults.object(forKey: kCURRENTUSER) {
                return FUser(_dictionary: userDictionary as! NSDictionary)
            }
            
        }
        
        return nil
    }
    
    
    
    //MARK: - Login
    class func loginUserWith(email: String, password: String, completion: @escaping (_ error: Error?, _ isEmailVerivied: Bool) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            
            
            if error == nil {
                // 어떠한 error도 나지 않는다면 Log-in 성공한다.
                if authDataResult!.user.isEmailVerified {
                    
                    FirebaseListener.shared.downloadCurrentUserFromFirebase(userId: authDataResult!.user.uid, email: email)
                    //check if user exists in Firebase
                    completion(error, true)
                } else {
                    print("Email not verified")
                    completion(error, false)
                    
                }
                
            } else {
                // 로그인 하지 않았을 때 false 반환
                //test
            }
        }
        
//        FirebaseReference(.User)
    }
    
    
    //MARK: - Register
    
    class func registerUserWith(email: String, password: String, userName: String, city: String, isMale: Bool, dateOfBirth: Date, completion: @escaping (_ error: Error?) -> Void) {
        
        // 아래의 정보는 Firebase에 제공하는 정보
        Auth.auth().createUser(withEmail: email, password: password) { authData, error in
            
            
            completion(error)
            
            if error == nil {
                // 오류가 없다면 오류가 없다, nil을 보내게 된다.
                authData!.user.sendEmailVerification { (error) in
                    print("auth email verificaiton sent", error?.localizedDescription)
                }
                
                if authData?.user != nil {
                    // 아래의 let 변수는 위의 class에 제공함
                    let user = FUser(_objectId: authData!.user.uid, _email: email, _username: userName, _city: city, _dateOfBirth: dateOfBirth, _isMale: isMale)
                    // 위의 user를 저장하기 위해 아래에 ???가를 만들것임
                    
                    user.saveUserLocally()
                }
            }
        }
    }
    
    //MARK: - Resend Links
    
    class func resetPasswordFor(email: String, completion: @escaping (_ error: Error?) -> Void) {
        
        Auth.auth().currentUser?.reload(completion: { (error) in
            
            Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                
                completion(error)
            })
        })
        
    }
    
    
    
    //MARK: - Save user funcs
    // 사용자 default에 접근함
    func saveUserLocally() {
        
        
        userDefaults.setValue(self.userDictionary as! [String: Any], forKey: kCURRENTUSER)
        userDefaults.synchronize()
    }
    
    func saveUserToFireStore() {
        // Firebase의 reference에 접근하게 됨, - 'Firestore Database'에 접근
        // 지금의 func는 위의 class안에 속해 있다.
        // 아래의 self는 FUser Class에 속한다.
        // 아래의 구문을 통해 우리의 Firebase에 저장한다.
        // 첫 번째 버전 함수, 각각의 Firebase 함수들은 뭔가를 얻거나 저장한다.
        
        // Firebase의 함수들은 두가지 버전을 가지고 있음
        // 1. 저장하기, 어떠한 에러 핸들링도 없음
        // 2. callback(회신, 재통보) 기능)
//        FirebaseReference(.User).document(self.objectId).setData(self.userDictionary as! [String : Any])
        //위의 코드가 더 간결하지만 앱의 안정성을 고려해 error에 대한 해결방안까지 넣어줌
        FirebaseReference(.User).document(self.objectId).setData(self.userDictionary as! [String : Any]) { (error) in
            
            if error != nil {
                print(error!.localizedDescription)
            }
        }
        
    }

}
