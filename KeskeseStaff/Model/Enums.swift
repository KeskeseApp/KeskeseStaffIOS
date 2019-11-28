//
//  Enums.swift
//  KeskeseStaff
//
//  Created by NI Vol on 8/14/19.
//  Copyright © 2019 Keskese. All rights reserved.
//

import Foundation

typealias simpleFunc = ()  -> Void

enum TABLE_STATUSES{
    case EMPTY
    case NOT_EMPTY
    case NEW_ORDER
    case WAITER_CALL
    case ADMIN_CALL
    case CASH_OUT
    case CARD_OUT
    case DISH_READY
}

enum STAFF_STATUSES{
    case ADMIN
    case WAITER
    case CHEF
}

enum EMOJI{
    case EMPTY
    case SAD
    case OKAY
    case HAPPY
}

enum WAITER_NOTIFS{
    case JOIN_SHEDULE
    case LEFT_SHEDULE
    case BREAK
    case STARS
}

enum SPOT_STATUSES{
    case ON_SHEDULE
    case NOT_ON_SHEDULE
    case UNEMPLOYED
}

