//
//  Elements.swift
//  KeskeseStaff
//
//  Created by NI Vol on 8/5/19.
//  Copyright © 2019 Keskese. All rights reserved.
//

import Foundation

var userType : String!

struct StaffSpotUser : Codable {
    var spot : Spot?
    var staff : StaffUser
}

struct StaffUser : Codable{
    var id: Int?
    var user: Int?
    var name: String?
    var name_small: String?
    var img: String?
    var rate: Float?
    var code: String?
    var color: String?
    var staff_status: String?
    var spot_status: String?
    var tables : [Int]?
}

extension StaffUser{
    func isOnSchedule() -> Bool{
        switch self.spot_status! {
        case "\(SPOT_STATUSES.ON_SHEDULE)":
            return true
        default:
            return false
        }
    }
}

struct Spot : Codable {
    var name_other : String
    var id : Int
}

struct StaffUserInTable : Codable {
    var name: String?
    var id: Int?
    var user: Int?
    var img: String?
}
