//
//  PreferenceUtils.swift
//  KeskeseStaff
//
//  Created by NI Vol on 8/27/19.
//  Copyright © 2019 Keskese. All rights reserved.
//

import Foundation

class PreferenceUtils {
    static private let preferences = UserDefaults.standard
    
    static private let TOKEN = "k_token"
    static private let USERNAME = "k_username"
    static private let PASSWORD = "k_password"
    
    static var token: String
    {
        get {
            return preferences.string(forKey: TOKEN) ?? ""
        }
        set {
            if newValue.isEmpty {
                preferences.set("", forKey: TOKEN)
            } else {
                if !newValue.contains("Token "){
                    preferences.set("Token \(newValue)", forKey: TOKEN)
                } else {
                    preferences.set(newValue, forKey: TOKEN)
                }
            }
            preferences.synchronize()
        }
    }
    
    static var username: String
    {
        get {
            return preferences.string(forKey: USERNAME) ?? ""
        }
        set {
            preferences.set(newValue, forKey: USERNAME)
            preferences.synchronize()
        }
    }
    
    static var password: String
    {
        get {
            return preferences.string(forKey: PASSWORD) ?? ""
        }
        set {
            preferences.set(newValue, forKey: PASSWORD)
            preferences.synchronize()
        }
    }
    
    static func clearData(){
        PreferenceUtils.username = ""
        PreferenceUtils.password = ""
        PreferenceUtils.token = ""
    }

}


