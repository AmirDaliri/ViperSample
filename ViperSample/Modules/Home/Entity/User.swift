//
//  User.swift
//  ViperSample
//
//  Created by Amir Daliri on 8/16/22.
//

import Foundation

struct User {
    var userId: UserEnum?
}

enum UserEnum: CaseIterable {
    case emir, olivia, emma
}

// MARK: - Dummy Users
extension UserEnum {
    var name: String {
        switch self {
        case .emir:
            return "Amir"
        case .olivia:
            return "Olivia"
        case .emma:
            return "Emma"
        }
    }

    var avatar: String {
        switch self {
        case .emir:
            return "user-1"
        case .olivia:
            return "user-2"
        case .emma:
            return "user-3"
        }
    }

    var username: String {
        switch self {
        case .emir:
            return "@Amir"
        case .olivia:
            return "@olivia"
        case .emma:
            return "@emma"
        }
    }
}
