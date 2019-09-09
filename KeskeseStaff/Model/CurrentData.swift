//
//  CurrentData.swift
//  KeskeseStaff
//
//  Created by NI Vol on 8/5/19.
//  Copyright © 2019 Keskese. All rights reserved.
//

import Foundation
import UIKit

var user : ElementUser!
var staff : StaffUser!
var tablesResponse = [TableResponse]()
var myTableResponse = [TableResponse]()
let defaults = UserDefaults.standard

func getTimeNow() -> String{
    let today = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "HH : mm"
    return formatter.string(from: today)
} 

private func seenView(view : UIView , seen : Bool , color : UIColor){
    print(seen)
    if !seen{
        view.borderColorV = color
    } else{
        view.borderColorV = Color.dark
    }
}

func tableStatuses(type : String, view : UIView, statys : UILabel, seen : Bool){
    
        switch type {
        case "\(TABLE_STATUSES.ADMIN_CALL)" :
            statys.text = "Вызов Администратора"
            seenView(view: view, seen: seen, color: Color.yellow)
            
        case "\(TABLE_STATUSES.WAITER_CALL)" :
            statys.text = "Вызов Официанта"
            seenView(view: view, seen: seen, color: Color.yellow)
        case "\(TABLE_STATUSES.CASH_OUT)" :
            statys.text = "Оплата Наличкой"
            seenView(view: view, seen: seen, color: Color.red)
        case "\(TABLE_STATUSES.CARD_OUT)" :
            statys.text = "Оплата Картой"
            seenView(view: view, seen: seen, color: Color.red)
        default:
            seenView(view: view, seen: seen, color: Color.dark)
        }
    
}

func waiterNotifs(type : String, view : UIView, statys : UILabel, seen : Bool){
    
    switch type {
    case "\(WAITER_NOTIFS.JOIN_SHEDULE)" :
        statys.text = "Присоединился к Смене"
        seenView(view: view, seen: seen, color: Color.green)
        
    case "\(WAITER_NOTIFS.LEFT_SHEDULE)" :
        statys.text = "Вышел со Смены"
        seenView(view: view, seen: seen, color: Color.red)
    case "\(WAITER_NOTIFS.STARS)" :
        statys.text = "Оценка"
        seenView(view: view, seen: seen, color: Color.yellow)
    default:
        seenView(view: view, seen: seen, color: Color.dark)
    }
    
}

func getTableStatus(tableStatus: String) -> String{
    switch (tableStatus){
        
    case "\(TABLE_STATUSES.NEW_ORDER)" :
        return "Новый Заказ"
    case "\(TABLE_STATUSES.WAITER_CALL)" :
        return "Вызывает Официанта"
    case "\(TABLE_STATUSES.ADMIN_CALL)":
        return "Вызывает Администратора"
    case "\(TABLE_STATUSES.CARD_OUT)" :
        return "Оплата Картой"
    case "\(TABLE_STATUSES.CASH_OUT)" :
        return "Оплата Наличными"
    case "\(TABLE_STATUSES.NOT_EMPTY)" :
        return "Занят"
    default:
        return "Свободный"
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
        default:
            return Color.dark
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



