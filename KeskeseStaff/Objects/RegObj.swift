//
//  RegObj.swift
//  KeskeseStaff
//
//  Created by NI Vol on 7/31/19.
//  Copyright © 2019 Keskese. All rights reserved.
//

import UIKit
import Toast_Swift
import Alamofire
import Firebase
import SwiftyJSON


class RegObj: NSObject {
    
    var pass : String!
    var mail : String!
    var view : UIView!
    
    
    @IBOutlet weak var logVC: LoginVC!
    
    func getToketValue(completion: @escaping (_ error: NSError?) -> Void) {
        
        getToken(username: mail!, pass: pass!).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)
                
                if jsonData["token"] != JSON.null{
                    PreferenceUtils.token = jsonData["token"].string!
                    PreferenceUtils.username = self.mail
                    PreferenceUtils.password = self.pass
                    self.getUser()
                    
                } else {
                    
                    print(value)
                    self.view.makeToast("Електронная почта или пароль введены неправильно")
                    
                }
                break
            case .failure(let error):
                
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                print(error)
                break
            }
        }
    }
    
    
    
    func getUser(){
        KeskeseStaff.getUser(username: mail!).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
                user = response.data!.createList(type: ElementUser.self)[0]
                user.password = self.pass
                self.getStaff(userId: user.id!)
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                print(error)
                break
            }
        }
    }
    
    func getStaff(userId : Int){
        KeskeseStaff.getStaff(userID: userId).responseJSON{
            (response) in
            switch response.result {
            case .success(_):
                
                staff = response.data!.createList(type: StaffUser.self)[0]
                
                self.staffType(type: staff.staff_status!)
                
                self.postFcmDevice()
                
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                print(error)
                break
            }
        }
    }
    
    func postFcmDevice(){
        KeskeseStaff.postFcmDevice(name: user.first_name!,
                                   userId: user.id!,
                              fcmToken: Messaging.messaging().fcmToken!).responseJSON { (response) in
                                switch response.result {
                                case .success(let value):
                                    print(value)
                                    self.logVC.goNext()
                                    break
                                case .failure(let error):
                                    self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                                    print(error)
                                    break
                                }
        }
    }
    func staffType(type : String){
        print(type)
        if type == "\(STAFF_STATUSES.ADMIN)"{
            logVC.staffType = "admin"
            userType = "Администратор"
        } else if type == "\(STAFF_STATUSES.WAITER)"{
            logVC.staffType = "waiter"
            userType = "Официант"
        }
    }
}
