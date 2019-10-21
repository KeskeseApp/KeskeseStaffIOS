//
//  StaffSettings.swift
//  KeskeseStaff
//
//  Created by NI Vol on 9/16/19.
//  Copyright © 2019 Keskese. All rights reserved.
//

import Foundation

struct StaffSettings : Codable {
    var id : Int
    var join_schedule : Bool
    var leave_schedule : Bool
    var low_stars : Bool
    var high_stars : Bool
}
