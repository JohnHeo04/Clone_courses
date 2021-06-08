//
//  FireStorage.swift
//  LetsMeet
//
//  Created by John Hur on 2021/06/07.
//

import Foundation
import FirebaseStorage

// Firebase에 접근하는 변수 선언
let storage = Storage.storage()


class FileStorage {
    // 아래의 uploadImage class는 아무것도 return 하지 않음
    // 기본적으로 UIImage를 넣고 Directory에 있는 image를 받아 옴
    class func uploadImage(_ image: UIImage, directory: String, completion: @escaping(_ documentLink: String?) -> Void) {
        // 아래 Storage Dir를 storageRef에 저장함
        let storageRef = storage.reference(forURL: kFILEREFERENCE).child(directory)
        // class에 저장되는 UIImage를 압축해주기 위해 변수 생성, 0.6 = 오리지널 퀄리티를 60%로 압축함
        let imageData = image.jpegData(compressionQuality: 0.6)
        // 아래의 변수는 사진의 upload에 어떤 변화(Upload가 끝났을 때)가 있다면 계속해서 반영한다.
        var task: StorageUploadTask!
        // 더 이상의 사진 업로드가 멈춘다면 이 변수 또한 멈춤
        task = storageRef.putData(imageData!, metadata: nil, completion: { (metaData, error) in
            
            task.removeAllObservers()
            // 만약 에러가 없다면(nil) "error uploading image" 출력
            if error != nil {
                print("error uploading image", error!.localizedDescription)
                return
            }
            
            storageRef.downloadURL { (url, error) in
                
                guard let downloadUrl = url else {
                    completion(nil)
                    return
                }
                print("we have uploaded image to ", downloadUrl.absoluteString)
                // .absouluteString = 사용자의 파일이 String형태로 upload됨
                completion(downloadUrl.absoluteString)
            }
        })
    }
    // 사용자의 이미지를 Locally로 저장해 줌
    class func saveImageLocally(imageData: NSData, fileName: String) {
        // getDocumentsURL 함수는 아래에 표기 됨, 아래 참고
        var docURL = getDocumentsURL()
        
        docURL = docURL.appendingPathComponent(fileName, isDirectory: false)
        // access our image data
        // atomically : true = 만약 url쓰는데 성공했다면, 전에 있던 파일은 삭제하고 복사는 하지 않음
        imageData.write(to: docURL, atomically: true)
    }
    
}

func getDocumentsURL() -> URL {
    // 여러개의 URL을 return 시킨 다음, 마지막으로 last하나만 얻음
    let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
    
    return documentURL!
    
}

func fileInDocumentsDirectory(filename: String) -> String {
    let fileURL = getDocumentsURL().appendingPathComponent(filename)
    
    return fileURL.path
}

