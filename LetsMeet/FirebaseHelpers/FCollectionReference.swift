//
//  FCollectionReference.swift
//  LetsMeet
//
//  Created by John Hur on 2021/05/26.
//

import Foundation
// Firebase의 Database임
import FirebaseFirestore


enum FCollectionReference: String {
    case User
    
}


func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    // root directory를 가짐
    return Firestore.firestore().collection(collectionReference.rawValue)
}
