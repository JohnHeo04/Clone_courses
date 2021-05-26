//
//  FirebaseListener.swift
//  LetsMeet
//
//  Created by John Hur on 2021/05/26.
//

import Foundation
import Firebase

// Firebase로 부터 action: check 또는 어떤걸 fetch(불러오다)한걸 저장할거다
class FirebaseListener {
    
    static let shared = FirebaseListener()
    
    private init() {}
    
    //MARK: - FUser
    func downloadCurrentUserFromFirebase(userId: String, email: String) {
        // .User = Collection
        // Firestore Database에 사용자의 instances를 저장하는 과정
        FirebaseReference(.User).document(userId).getDocument { (snapshot, error) in
            // snapshot이 불가능할 경우 아무것도 return하지 않음
            guard let snapshot = snapshot else { return }
            // 계획대로 진행이 되고 snapshot을 가질 경우
            // 아래의 아래의 if문을 통해 존재하는지 check하기
            if snapshot.exists {
                
                let user - FUser(  )
                
            } else {
                //first login
                
            }
            
        }
    }
    
    
    
    
}
