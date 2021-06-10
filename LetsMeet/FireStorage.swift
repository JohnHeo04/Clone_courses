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
    // 사진 여러장 업로드를 위한 함수
    class func uploadImages(_ images: [UIImage?], completion: @escaping(_ imagelinks: [String]) -> Void) {
        
        var uploadImagesCount = 0
        var imageLinkArray : [String] = []
        var nameSuffix = 0
        
        
        for image in images {
            
            let fileDirectory = "UserImages/" + FUser.currentId() + "/" + "\(nameSuffix)" + ".jpg"
            
            uploadImage(image!, directory: fileDirectory) { (imageLink) in
                
                if imageLink != nil {
                    
                    imageLinkArray.append(imageLink!)
                    uploadImagesCount += 1
                    
                    if uploadImagesCount == images.count {
                        completion(imageLinkArray)
                    }
                }
            }
            
            nameSuffix += 1
            
        }
    }

    
    class func downloadImage(imageUrl: String, completion: @escaping (_ image: UIImage?) -> Void) {
        // URL로 부터 File name 추출
        // 만약 이미지가 Local device에 check 된다면 다운로드 하지 않음
        // check되지 않으면 image 다운 -> local에 저장
//        print("url is", imageUrl)
        
        //MARK: - How to extract from URL
        // image 파일 이름을 추출하기 위해 아래의 멤소드 사용 '_(underbar)'에 의해 분리되어짐
        // 위처럼 쓰여지면 '언더바' 기준으로 두 가지로 나뉘어짐
        // 하지만 우리는 '언더바' 뒤를 쓸 예정
        // 고로 .last!
        // 다음, '?(Question Mark)' 기준으로 나누어줌
        // 결과, Optional("fjPYlFEIf9YemLlreiT3xMHx4o32.jpg")
        
        // 다시 한 번, .(Dot)을 기준으로 분리
        let imageFileName = ((imageUrl.components(separatedBy: "_").last!).components(separatedBy: "?").first)?.components(separatedBy: ".").first!
//        print(imageFileName)
        // Local Directory에 있는지 체크
        if fileExistAt(path: imageFileName!) {
            print("we have local file")
            // 클론 강의에선 뒤에 imageFilename에는 아무것도 하지 않았는데 여기선 안하면 왜 오류뜨는지 모르겠음
            if let contentsOfFile = UIImage(contentsOfFile: fileInDocumentsDirectory(filename: imageFileName!)) {
                completion(contentsOfFile)
            } else {
                print("couldn't generate image from local image")
                completion(nil)
            }
            
        } else {
            // download
//            print("Downloading")
            // 만약 빈 String이 아니라면 아무것도 다운 불가
            if imageUrl != "" {
                // URL String이 비어 있지 않다면 체크
                let documemntURL = URL(string: imageUrl)
                
                let downloadQueue = DispatchQueue(label: "downloadQueue")
                
                downloadQueue.async {
                    
                    let data = NSData(contentsOf: documemntURL!)
                    
                    if data != nil {
                        // 데이터 URL이 비어 있지 않다면
                        let imageToReturn = UIImage(data: data! as Data)
                        // 파일을 Local에다가 저장함
                        FileStorage.saveImageLocally(imageData: data!, fileName: imageFileName!)
                        
                        completion(imageToReturn)
                        
                    } else {
                        // 데이터베이스에 이미지가 없다면 아래 출력
                        print("no image in database")
                        completion(nil)
                    }
                    
                }
                
            } else {
                // 만약 Image Link가 없다면 다시 "avatar" placeHolder를 줌
                // Default 설정
                completion(nil)
            }
            
            
        }
        
        
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

func fileExistAt(path: String) -> Bool {
    // 파일이 존재하지 않을거라 default, 가정하고 false로 시작
    // 아래의 8줄 정도 되는 코드가 아래의 return ~로 깔끔한 정리가 됨
    
/*  정리 전 코드
    var doesExist = false
    
    let filePath = fileInDocumentsDirectory(filename: path)
    
    if FileManager.default.fileExists(atPath: filePath) {
        doesExist = true
    } else {
        doesExist = false
    }
    
    return doesExist
*/
    // 정리 후 코드, 위의 코드와 동일
    return FileManager.default.fileExists(atPath: fileInDocumentsDirectory(filename: path))
    
}

