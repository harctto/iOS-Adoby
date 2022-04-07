//
//  Users_md.swift
//  Adopby
//
//  Created by Hatto on 18/3/2565 BE.
//

import Foundation

// MARK: - Users
struct Users: Codable {
    let uid, username, firstname, surname: String!
    let address, userTel: String!

    enum CodingKeys: String, CodingKey {
        case uid, username, firstname, surname, address
        case userTel = "user_tel"
    }
}
