//
//  Elements.swift
//  KeskeseStaff
//
//  Created by NI Vol on 8/5/19.
//  Copyright © 2019 Keskese. All rights reserved.
//

import Foundation

var userType : String!

struct StaffUser : Codable{
    var id: Int?
    var user: Int?
    var name: String?
    var name_small: String?
    var spot: Int?
    var img: String?
    var rate: Float?
    var code: String?
    var color: String?
    var staff_status: String?
    var spot_status: String?
    var tables: [Int]?
}

struct StaffUserInTable : Codable {
    var name: String?
    var id: Int?
    var user: Int?
    var img: String?
}
