//
//  Test.swift
//  Adopby
//
//  Created by Hatto on 16/3/2565 BE.
//

import Foundation

// MARK: - PetShop
struct PetShop: Codable {
    let id: String
    let shopID: Int
    let shopName, address, shopTel, serviceTime: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case shopID = "shop_id"
        case shopName = "shop_name"
        case address
        case shopTel = "shop_tel"
        case serviceTime = "service_time"
    }
}
