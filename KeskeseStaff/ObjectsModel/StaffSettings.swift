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
    var waiter_call : Bool
    var admin_call : Bool
    var cash_out : Bool
}
