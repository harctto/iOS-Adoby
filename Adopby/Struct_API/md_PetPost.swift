//
//  PetPost_md.swift
//  Adopby
//
//  Created by Hatto on 23/3/2565 BE.
//

import Foundation

// MARK: - PetPosts
struct PetPost: Codable {
    let id, postID, petName, petType: String
        let petColor, petSex, petAge, petpostDescription: String
        let imgURL: String?
        let uid, dateCreate: String
        let v: Int

        enum CodingKeys: String, CodingKey {
            case id = "_id"
            case postID = "post_id"
            case petName = "pet_name"
            case petType = "pet_type"
            case petColor = "pet_color"
            case petSex = "pet_sex"
            case petAge = "pet_age"
            case petpostDescription = "description"
            case imgURL = "img_url"
            case uid
            case dateCreate = "date_create"
            case v = "__v"
        }
}


