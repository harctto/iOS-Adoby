//
//  md_Hospitals.swift
//  Adopby
//
//  Created by Hatto on 7/4/2565 BE.
//

import Foundation

// MARK: - Hospital
struct Hospital: Codable {
    let id: String
    let hospitalID: Int
    let hospitalName, address, hospitalTel, serviceTime: String
    let latitude, longitude: Double

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case hospitalID = "hospital_id"
        case hospitalName = "hospital_name"
        case address
        case hospitalTel = "hospital_tel"
        case serviceTime = "service_time"
        case latitude, longitude
    }
}
