//
//  CurrentData.swift
//  KeskeseStaff
//
//  Created by NI Vol on 8/5/19.
//  Copyright © 2019 Keskese. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

var user : ElementUser!
var staff : StaffUser!
var spot : Spot!
var tablesResponse = [TableResponse]()
var myTableResponse = [TableResponse]()
var indexForTabBar = 2
let defaults = UserDefaults.standard

func getTimeNow() -> String{
    let today = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "HH : mm"
    return formatter.string(from: today)
} 

private func seenView(view : UIView , seen : Bool , color : UIColor, button : UIButton){
    print(seen)
    if !seen{
        view.borderColorV = color
        button.backgroundColor = color
    } else{
        view.borderColorV = Color.dark
        button.backgroundColor = Color.dark
    }
}

func feedbackSeen(seen : Bool, bg : UIView , indexBG : UIView){
    if seen{
        
        bg.borderColorV = Color.dark
        indexBG.borderColorV = Color.dark
    } else {
        bg.borderColorV = Color.yellow
        indexBG.borderColorV = Color.yellow
    }
}

func tableStatuses(type : String, view : UIView, statys : UILabel, seen : Bool, button : UIButton){
    
        switch type {
        case "\(TABLE_STATUSES.ADMIN_CALL)" :
            statys.text = NSLocalizedString("CallA", comment: "")
            seenView(view: view, seen: seen, color: Color.yellow, button: button)
            
        case "\(TABLE_STATUSES.WAITER_CALL)" :
            statys.text = NSLocalizedString("CallW", comment: "")
            seenView(view: view, seen: seen, color: Color.yellow, button: button)
        case "\(TABLE_STATUSES.CASH_OUT)" :
            statys.text = NSLocalizedString("PayC", comment: "")
            seenView(view: view, seen: seen, color: Color.red, button: button)
        case "\(TABLE_STATUSES.CARD_OUT)" :
            statys.text = NSLocalizedString("PayCard", comment: "")
            seenView(view: view, seen: seen, color: Color.red, button: button)
        case "\(TABLE_STATUSES.DISH_READY)" :
            statys.text = "Заказ готов"
            seenView(view: view, seen: seen, color: Color.orange, button: button)
        default:
            seenView(view: view, seen: seen, color: Color.dark, button: button)
        }
    
}

func waiterNotifs(type : String, view : UIView, statys : UILabel, seen : Bool , button : UIButton){
    
    switch type {
    case "\(WAITER_NOTIFS.JOIN_SHEDULE)" :
        statys.text = NSLocalizedString("Join Shedule", comment: "")
        seenView(view: view, seen: seen, color: Color.green, button: button)
        
    case "\(WAITER_NOTIFS.LEFT_SHEDULE)" :
        statys.text = NSLocalizedString("Left Shedule", comment: "")
        seenView(view: view, seen: seen, color: Color.red, button: button)
    case "\(WAITER_NOTIFS.STARS)" :
        statys.text = NSLocalizedString("Rate", comment: "")
        seenView(view: view, seen: seen, color: Color.yellow, button: button)
    default:
        seenView(view: view, seen: seen, color: Color.dark, button: button)
    }
    
}

func getTableStatusChef(tableStatus: String) -> String{
    switch (tableStatus){
        
    case "\(TABLE_STATUSES.DISH_READY)" :
        return "Заказ готов"
//    case "\(TABLE_STATUSES.WAITER_CALL)" :
//        return NSLocalizedString("CallW", comment: "")
//    case "\(TABLE_STATUSES.ADMIN_CALL)":
//        return NSLocalizedString("CallA", comment: "")
//    case "\(TABLE_STATUSES.CARD_OUT)" :
//        return NSLocalizedString("PayCard", comment: "")
//    case "\(TABLE_STATUSES.CASH_OUT)" :
//        return NSLocalizedString("PayC", comment: "")
//    case "\(TABLE_STATUSES.NOT_EMPTY)" :
//        return NSLocalizedString("Busy", comment: "")
    default:
        return NSLocalizedString("Free", comment: "")
    }
}

func getTableStatus(tableStatus: String) -> String{
    switch (tableStatus){
        
    case "\(TABLE_STATUSES.NEW_ORDER)" :
        return NSLocalizedString("New Order", comment: "")
    case "\(TABLE_STATUSES.WAITER_CALL)" :
        return NSLocalizedString("CallW", comment: "")
    case "\(TABLE_STATUSES.ADMIN_CALL)":
        return NSLocalizedString("CallA", comment: "")
    case "\(TABLE_STATUSES.CARD_OUT)" :
        return NSLocalizedString("PayCard", comment: "")
    case "\(TABLE_STATUSES.CASH_OUT)" :
        return NSLocalizedString("PayC", comment: "")
    case "\(TABLE_STATUSES.NOT_EMPTY)" :
        return NSLocalizedString("Busy", comment: "")
    default:
        return NSLocalizedString("Free", comment: "")
    }
}

func getCardColorChef(tableStatus: String) -> UIColor{
        switch (tableStatus){
        case "\(TABLE_STATUSES.NEW_ORDER)" :
            return Color.yellow
//        case "\(TABLE_STATUSES.WAITER_CALL)",
//        "\(TABLE_STATUSES.ADMIN_CALL)":
//            return Color.yellow
//        case "\(TABLE_STATUSES.CARD_OUT)",
//        "\(TABLE_STATUSES.CASH_OUT)" :
//            return Color.red
//        case "\(TABLE_STATUSES.NOT_EMPTY)" :
//            return hexStringToUIColor(hex: "#424242")
//
//        case "\(TABLE_STATUSES.DISH_READY)" :
//            return Color.green
//
        default:
            return UIColor.black
    }
}

func getCardColor(tableStatus: String) -> UIColor{
        switch (tableStatus){
        case "\(TABLE_STATUSES.NEW_ORDER)" :
            return Color.green
        case "\(TABLE_STATUSES.WAITER_CALL)",
        "\(TABLE_STATUSES.ADMIN_CALL)":
            return Color.yellow
        case "\(TABLE_STATUSES.CARD_OUT)",
        "\(TABLE_STATUSES.CASH_OUT)" :
            return Color.red
        case "\(TABLE_STATUSES.NOT_EMPTY)" :
            return hexStringToUIColor(hex: "#424242")
            
        case "\(TABLE_STATUSES.DISH_READY)" :
            return Color.green
            
        default:
            return UIColor.black
    }
}

func getEmotionForFeedback(emotion: String) -> String{
    
    switch (emotion){
    case "\(EMOJI.HAPPY)" :
        return "😁"
    case "\(EMOJI.OKAY)":
        return "🙂"
    case "\(EMOJI.SAD)":
        return "😡"
    default:
        return ""
    }
}

func getEmotion(emotion: String, tableStatus: String) -> String{
    if tableStatus == "\(TABLE_STATUSES.EMPTY)"{
        return ""
    }
    switch (emotion){
    case "\(EMOJI.HAPPY)" :
        return "😁"
    case "\(EMOJI.OKAY)":
        return "🙂"
    case "\(EMOJI.SAD)":
        return "😡"
    default:
        return ""
    }
}

func setNotifsEnabled(enabled: Bool){
    let preferences = UserDefaults.standard
    preferences.set(enabled, forKey: "notifs_enabled")
    preferences.synchronize()
}

func isNotifsEnabled() -> Bool{
    let preferences = UserDefaults.standard
    
    let info = "notifs_enabled"
    
    if preferences.object(forKey: info) == nil {
        return true
    } else {
        return preferences.bool(forKey: info)
    }
}

func emptyView(index : Int, view : UIView){
    if index == 0{
        view.isHidden = false
    } else {
        view.isHidden = true
    }
}

func getStaffStatus(data : StaffUser) -> Bool{
    switch data.spot_status! {
    case "\(SPOT_STATUSES.ON_SHEDULE)":
        return true
    default:
        return true
    }
}

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}



