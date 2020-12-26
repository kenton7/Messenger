//
//  DataBaseManager.swift
//  Messenger
//
//  Created by Илья Кузнецов on 26.12.2020.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
}

// MARK: - Account Managment

extension DatabaseManager {
    
    //провверка есть ли уже в базе данных такой email или нет
    public func userExists(with email: String,
                           completion: @escaping ((Bool) -> Void)) {
        database.child(email).observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
            completion(true)
        })
    }
    
    /// Inserts new users to database
    public func insertUser(with user: ChatAppUser) {
        database.child(user.email).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName
        ])
    }
}

struct ChatAppUser {
    let firstName: String
    let lastName: String
    let email: String
    //let profilePictureUrl: String
}
