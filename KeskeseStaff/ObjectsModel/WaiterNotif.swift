//
//  NotifElem.swift
//  KeskeseStaff
//
//  Created by NI Vol on 8/13/19.
//  Copyright © 2019 Keskese. All rights reserved.
//

import Foundation


struct NotifGuest : Codable {
    var id : Int
    var user : Int
    var type : String
    var table : TableInNotif
    var time : String
    var seen : Bool
}


