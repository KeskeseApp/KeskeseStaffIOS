//
//  TablesElem.swift
//  KeskeseStaff
//
//  Created by NI Vol on 8/14/19.
//  Copyright © 2019 Keskese. All rights reserved.
//

import Foundation


struct TableResponse : Codable{
    var table: Table
    var staff: StaffUserInTable
    var spot : SpotInTable
}

struct Table : Codable{
    var id: Int
    var spot: Int?
    var number: Int
    var table_status: String
    var order_status: String
    var emotion: String
}

struct SpotInTable : Codable {
    var id : Int
    var name : String
    var address : String
    var logo : String
}
