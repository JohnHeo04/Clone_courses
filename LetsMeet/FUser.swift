//
//  FUser.swift
//  LetsMeet
//
//  Created by John Hur on 2021/05/24.
//

import Foundation
import Firebase

// 한 유저가 같은 ID를 가지고 있다면 체크하는 class protocol
// Equatable은 Protocol임
class FUser: Equatable {
    
    // lhs = left hand side, rhs = right hand side
    static func == (lhs: FUser, rhs: FUser) -> Bool {
        lhs.objectId == rhs.objectId
    }
    
    let objectId: String = ""
    
    
    
    class func registerUserWith(email: String, password: String, userName: String, city: String, isMale: Bool, dateOfBirth: Date, completion: @escaping (_ error: Error?) -> Void) {
        
        // 아래의 정보는 Firebase에 제공하는 정보
        Auth.auth().createUser(withEmail: email, password: password) { authData, error in
            
            
            completion(error)
            
            if error == nil {
                // 오류가 없다면 오류가 없다, nil을 보내게 된다.
                authData!.user.sendEmailVerification { (error) in
                    print("auth email verificaiton sent", error?.localizedDescription)
                }
                
                //create user in database
            }
            
        }
        
    }

}
