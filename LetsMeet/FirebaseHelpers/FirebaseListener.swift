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
                // if문에서 걸린다면 이미 User가 Firebase Database에 이미 가입해 있다는걸 의미함
                // 아래의 snapshot은 Document타입의 snapshot을 의미함, 그리고 이건 Firebase로부터 인증 받음 - 그리고 접근함
                let user = FUser(_dictionary: snapshot.data() as! NSDictionary)
                // 사용자의 object를 locally로 저장함
                user.saveUserLocally()
                
                user.getUserAvatarFromFirestore { (didSet) in
                    
                }
                
                
            } else {
                //first login
                // 회원가입 후 첫번째 로그인 하게되는 기능
                // User default에 User의 object가 있다면 첫번째로 체크하게 됨
                if let user = userDefaults.object(forKey: kCURRENTUSER) {
                    // 아래의 구문으로 Firebase에 저장할 수 있음
                    // 아래 뒤에있는 saveUserToFireStore()함수를 FUser에다가 만듦
                    FUser(_dictionary: user as! NSDictionary).saveUserToFireStore()
                }
                
            }
            
        }
    }
    // 사용자 사진을 다운받기 위한 쿼리를 짜는 함수 구현
    func downloadUserFromFirebase(isInitialLoad: Bool, limit: Int, lastDocumentSnapshot: DocumentSnapshot?, completion: @escaping (_ users: [FUser], _ snapshot: DocumentSnapshot?) -> Void ) {
        
        var query: Query!
        var users: [FUser] = []
        
        if isInitialLoad {
            query = FirebaseReference(.User).order(by: kREGISTEREDDATE, descending:  false).limit(to: limit)
            print("first \(limit) users loading")
            
            
        } else {
            
            if lastDocumentSnapshot != nil {
                query = FirebaseReference(.User).order(by: kREGISTEREDDATE, descending:  false).limit(to: limit).start(afterDocument: lastDocumentSnapshot!)
                
                print("next \(limit) user loading")
                
            } else {
                print("last snapshot is nil")
                
            }
        }
        
        if query != nil {
            
            query.getDocuments { (snapShot, error) in
                
                guard let snapshot = snapShot else { return }
                
                if !snapshot.isEmpty {
                    
                    for userData in snapshot.documents {
                        
                        let userObject = userData.data() as NSDictionary
                        
                        if !(FUser.currentUser()?.likedIdArray?.contains(userObject[kOBJECTID] as! String) ?? false) && FUser.currentId() != userObject[kOBJECTID] as! String {
                            
                            users.append(FUser(_dictionary: userObject))
                        }
                    }
                    
                    completion(users, snapshot.documents.last!)
                    
                } else {
                    print("no more users to fetch")
                    completion(users, nil)
                    
                }
                
            }
            
        } else {
            completion(users, nil)
        }
        
     
    }
    
}
