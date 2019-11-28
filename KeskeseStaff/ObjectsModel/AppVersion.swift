//
//  User.swift
//  KeskeseStaff
//
//  Created by NI Vol on 8/9/19.
//  Copyright © 2019 Keskese. All rights reserved.
//

import Foundation

struct AppVersion : Codable{
    var ios : String = ""
    
    func isLower() -> Bool{
        if ios.isEmpty{
            return false
        }
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        
        print("App - \(version)")
        
        let arrayNums = ios.components(separatedBy: ".")
        let arrayApp = version.components(separatedBy: ".")
        
        if arrayNums[0] > arrayApp[0]{
            return true
        }
        
        if arrayNums[1] > arrayApp[1]{
            return true
        }
        
        if arrayNums[2] > arrayApp[2]{
            return true
        }
        
        return false
    }
}
