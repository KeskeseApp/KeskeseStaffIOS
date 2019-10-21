//
//  FeedbackElem.swift
//  KeskeseStaff
//
//  Created by NI Vol on 9/24/19.
//  Copyright © 2019 Keskese. All rights reserved.
//

import Foundation

struct FeedbackElem : Codable {
    var id : Int
    var staff_name : String
    var coffee_spot : Int
    var comment : String
    var table_number : Int
    var date : String
    var seen : Bool
    var name : String?
    var phone : String?
}
