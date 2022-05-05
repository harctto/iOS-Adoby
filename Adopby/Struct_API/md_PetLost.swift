//
//  md_PetLost.swift
//  Adopby
//
//  Created by Hatto on 8/4/2565 BE.
//

import Foundation

// MARK: - PetlostElement
struct Petlost: Codable {
    let id, petID, petName, petType: String
    let petColor, petSex, petAge, petlostDescription: String
    let petAddress, status: String
    let imgURL: String
    let lastSeen, uid, dateCreate, price: String
    let v: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case petID = "pet_id"
        case petName = "pet_name"
        case petType = "pet_type"
        case petColor = "pet_color"
        case petSex = "pet_sex"
        case petAge = "pet_age"
        case petlostDescription = "description"
        case petAddress = "pet_address"
        case status
        case imgURL = "img_url"
        case lastSeen = "last_seen"
        case uid
        case dateCreate = "date_create"
        case price
        case v = "__v"
    }
}

