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
                    
                }
                
            }
            
        }
        
    }

}
