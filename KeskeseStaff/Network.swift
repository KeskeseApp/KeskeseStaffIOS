//
//  Network.swift
//  KeskeseStaff
//
//  Created by NI Vol on 8/1/19.
//  Copyright © 2019 Keskese. All rights reserved.
//

import Foundation
import Alamofire


let BASE_URL = "https://hookahgo.app"

let REGISTER_USER = "\(BASE_URL)/api/customers/add_new_staff/"
let TOKEN_URL = "\(BASE_URL)/api/customers/api-token-auth/"
let FCM_URL = "\(BASE_URL)/api/customers/fcm_devices/"
let ALL_TABLES = "\(BASE_URL)/api/customers/tables/"
let ALL_STAFF = "\(BASE_URL)/api/customers/staff/"
let USERS_URL = "\(BASE_URL)/api/customers/user/"
let WAITER_NOTIF = "\(BASE_URL)/api/customers/waiter_notifications/"
let ADMIN_NOTIF =  "\(BASE_URL)/api/customers/admin_notifications/"



var header : HTTPHeaders{
    get {
        return [
        "Authorization": PreferenceUtils.token
        ]
    }
}

func getToken(username : String, pass : String) -> DataRequest{
    
    let params: [String: Any] = [
        "username": username,
        "password": pass
    ]
    
    return Alamofire.request(TOKEN_URL,
                             method: .post,
                             parameters: params,
                             encoding: URLEncoding(),
                             headers: nil)
}

func postFcmDevice(name: String, userId: Int, fcmToken: String) -> DataRequest{
    let params: [String: Any] = [
//        "name": name,
        "user": userId,
        "active" : true,
        "device_id" : "",
        "registration_id" : fcmToken ,
        "type" : "ios"
    ]

    return Alamofire.request(FCM_URL,
                             method: .post,
                             parameters: params,
                             encoding: URLEncoding(),
                             headers: header)
}

func postAdminNotif(staff : Int, type : String) -> DataRequest{
    let link = "\(ADMIN_NOTIF)"
    let params: Parameters = [
        "staff" : staff,
        "type" : type,
        "stars" : 0,
        "seen" : false,
        "time" : getTimeNow()
        
    ]
    
    return Alamofire.request(link,
                             method: .post,
                             parameters: params,
                             encoding: JSONEncoding(),
                             headers: header)
}

func patchWaiterNotif(seen : Bool, elemId : Int) -> DataRequest{
    let link = "\(WAITER_NOTIF)\(elemId)/"
    print("link \(link)")
    let params = [
                "seen" : seen
    ]
    
    return Alamofire.request(link, method: .patch,
                             parameters: params , encoding: JSONEncoding(),
                             headers : header)
}

func patchAdminNotif(seen : Bool, elemId : Int) -> DataRequest{
    let link = "\(ADMIN_NOTIF)\(elemId)/"
    
    let params : Parameters = [
        "seen" : seen
    ]
    
    return Alamofire.request(link, method: .patch,
                             parameters: params , encoding: JSONEncoding(),
                             headers : header)
}

func patchTablesForStaff(tables : [Int] , staffID : Int) -> DataRequest{
    let link = "\(ALL_STAFF)\(staffID)/"

    let params = [
        "tables" : tables
    ]
    
    print("API neparam \(tables.asParameters())")
    
    return Alamofire.request(link, method: .patch,
                             parameters: params , encoding: JSONEncoding(),
                             headers : header)
}

func getTablesForSpot(spotID : Int) -> DataRequest{
    let link = "\(ALL_TABLES)?spot_id=\(spotID)"
    return Alamofire.request(link, method: .get,
                             parameters: nil, encoding: URLEncoding(),
                             headers : header)
}

func getNotifListForStaff(userID : Int) -> DataRequest{
    let link = "\(WAITER_NOTIF)?user_id=\(userID)"
    print("link \(link)")
    return Alamofire.request(link, method: .get,
                             parameters: nil, encoding: URLEncoding(),
                             headers : header)
}

func getAllNotifListForStaff(spotID : Int) -> DataRequest{
    let link = "\(WAITER_NOTIF)?spot_id=\(spotID)"
    print("link \(link)")
    return Alamofire.request(link, method: .get,
                             parameters: nil, encoding: URLEncoding(),
                             headers : header)
}

func getNotifListForAdmin(spotID : Int) -> DataRequest{
    let link = "\(ADMIN_NOTIF)?spot_id=\(spotID)"
    print("link \(link)")
    return Alamofire.request(link, method: .get,
                             parameters: nil, encoding: URLEncoding(),
                             headers : header)
}

func getStaffForSpot(spotID : Int) -> DataRequest{
    let link = "\(ALL_STAFF)?spot_id=\(spotID)"
    return Alamofire.request(link, method: .get,
                             parameters: nil, encoding: URLEncoding(),
                             headers : header)
}

func getStaff(userID : Int) -> DataRequest{
    let link = "\(ALL_STAFF)?user_id=\(userID)"
    return Alamofire.request(link, method: .get,
                             parameters: nil, encoding: URLEncoding(),
                             headers : header)
}

func getUser(username : String) -> DataRequest{
    let url = "\(USERS_URL)?username=\(username)"
    return Alamofire.request(url,
                             method: .get,
                             parameters: nil,
                             encoding: URLEncoding(),
                             headers: header)
}

//path
//func patchTablesForStaff(staff: ElementAllStaff) -> DataRequest{
//    let link = "\(ALL_STAFF)\(staff)/"
//    let toPatch = ElementOrder()
//    toPatch.status = order.status
//    toPatch.canceled_barista_message = order.canceled_barista_message
//    return Alamofire.request(link, method: .patch , parameters: toPatch.toPatch(), encoding: URLEncoding(), headers : header)
//}

func registerUser(username : String, pass : String , first_name : String) -> DataRequest{
    
    let params: [String: Any] = [
        "username": username,
        "password": pass,
        "first_name": first_name
//        "img": img
        
    ]
    
    return Alamofire.request(REGISTER_USER,
                             method: .post,
                             parameters: params,
                             encoding: URLEncoding(),
                             headers: nil)
}
