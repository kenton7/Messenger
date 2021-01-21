//
//  ProfileViewModel.swift
//  Messenger
//
//  Created by Илья Кузнецов on 21.01.2021.
//

import Foundation

enum ProfileViewModelType {
    case info, logout
}

struct ProfileViewModel {
    let viewModelType: ProfileViewModelType
    let title: String
    let handler: (() -> Void)?
}
