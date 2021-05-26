//
//  FUser.swift
//  LetsMeet
//
//  Created by John Hur on 2021/05/24.
//

import Foundation
import Firebase
import UIKit

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
        // objectId가 String형태 일지도 모른다. 다만 경우에 따라서 String이 아닐 수 있으므로 "" 텅 빈 String 형태로 둔다.
        // 고로 App은 충돌하지 않음
        // 우리의 compiler가 우리의 dictionary에 접근해서 objectId를 얻고 거기에 int가 있을지도 모른다.
        // 만약 우리가 as!로 강제 string타입을 가졌다면 App이 충돌했을지도 모름
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
    }
    
    //MARK: - Login
    class func loginUserWith(email: String, password: String, completion: @escaping (_ error: Error?, _ isEmailVerivied: Bool) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            
            
            if error == nil {
                // 어떠한 error도 나지 않는다면 Log-in 성공한다.
                if authDataResult!.user.isEmailVerified {
                    
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
    // 사용자 default에 접근함
    func saveUserLocally() {
        
        
        userDefaults.setValue(self.userDictionary as! [String: Any], forKey: kCURRENTUSER)
        userDefaults.synchronize()
    }
    

}
