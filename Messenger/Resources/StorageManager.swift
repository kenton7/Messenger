//
//  StorageManager.swift
//  Messenger
//
//  Created by Илья Кузнецов on 02.01.2021.
//

import Foundation
import FirebaseStorage

///Allows you to get, fetch and upload files to firebase storage
final class StorageManager {
    static let shared = StorageManager()
    
    private init() {}
    
    private let storage = Storage.storage().reference()
    
    /*
     /images/kuznecov94-gmail-com_profile_picture.png
     */
    
    public typealias UploadPictureCompletion = (Result<String, Error>) -> Void
    
    /// загружаем картинку юзера в firebase storage и возвращаем completion с url string для скачивания
    public func uploadProfilePicture(with data: Data,
                                     fileName: String,
                                     completion: @escaping UploadPictureCompletion) {
        storage.child("images/\(fileName)").putData(data, metadata: nil, completion: { [weak self] metadata, error in
            
            guard let strongSelf = self else { return }
            
            guard error == nil else {
                //failed
                print("failed to upload data to firebase for picture")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            strongSelf.storage.child("images/\(fileName)").downloadURL(completion: { url, error in
                guard let url = url else {
                    print("Failed to get download URL")
                    completion(.failure(StorageErrors.failedToGetDownloadUrl))
                    return
                }
                let urlString = url.absoluteString
                print("download url = \(urlString)")
                completion(.success(urlString))
            })
        })
    }
    /// Upload image that will be sent in a conversation message
    public func uploadMessagePhoto(with data: Data,
                                     fileName: String,
                                     completion: @escaping UploadPictureCompletion) {
        storage.child("message_images/\(fileName)").putData(data, metadata: nil, completion: { [weak self] metadata, error in
            guard error == nil else {
                //failed
                print("failed to upload data to firebase for picture")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            self?.storage.child("message_images/\(fileName)").downloadURL(completion: { url, error in
                guard let url = url else {
                    print("Failed to get download URL")
                    completion(.failure(StorageErrors.failedToGetDownloadUrl))
                    return
                }
                let urlString = url.absoluteString
                print("download url = \(urlString)")
                completion(.success(urlString))
            })
        })
    }
    
    /// Upload video that will be sent in a conversation message
    public func uploadMessageVideo(with fileUrl: URL,
                                     fileName: String,
                                     completion: @escaping UploadPictureCompletion) {
        storage.child("message_videos/\(fileName)").putFile(from: fileUrl, metadata: nil, completion: { [weak self] metadata, error in
            guard error == nil else {
                //failed
                print("failed to upload video file to firebase for video")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            self?.storage.child("message_images/\(fileName)").downloadURL(completion: { url, error in
                guard let url = url else {
                    print("Failed to get download URL")
                    completion(.failure(StorageErrors.failedToGetDownloadUrl))
                    return
                }
                let urlString = url.absoluteString
                print("download url = \(urlString)")
                completion(.success(urlString))
            })
        })
    }
    
    public enum StorageErrors: Error {
        case failedToUpload
        case failedToGetDownloadUrl
    }
    
    public func downloadURL(for path: String, completion: @escaping (Result<URL, Error>) -> Void) {
        let reference = storage.child(path)
        
        reference.downloadURL(completion: { url, error in
            guard let url = url, error == nil else {
                completion(.failure(StorageErrors.failedToGetDownloadUrl))
                return
            }
            completion(.success(url))
        })
    }
}
