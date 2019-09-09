//
//  AdminNotif.swift
//  KeskeseStaff
//
//  Created by NI Vol on 8/29/19.
//  Copyright © 2019 Keskese. All rights reserved.
//

import Foundation

struct AdminNotif : Codable {
    var id : Int
    var type : String
    var stars : Int
//    var table : Int
    var staff : StaffInNotif
    var time : String?
    var seen: Bool
}

struct StaffInNotif : Codable {
    var name : String
    var name_small : String
    var id : Int
    var img : String
}
