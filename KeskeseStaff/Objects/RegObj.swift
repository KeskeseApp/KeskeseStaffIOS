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
                    
                    self.getUser()
                    
                } else {
                    
                    print(value)
                    self.logVC.stopAnimating()
                    self.view.makeToast("Електронная почта или пароль введены неправильно")
                    
                }
                break
            case .failure(let error):
                self.logVC.stopAnimating()
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
                self.logVC.stopAnimating()
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
                
                let staffSpotUserList = response.data!.createList(type: StaffSpotUser.self)
                if !staffSpotUserList.isEmpty{
                
                    let staffSpotUser = staffSpotUserList[0]
                    staff = staffSpotUser.staff
                    spot = staffSpotUser.spot
                    
                    self.staffType(type: staff.staff_status!)
                    
                    self.postFcmDevice()
                    
                } else {
                    
                }
               
                break
            case .failure(let error):
                self.logVC.stopAnimating()
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
                                    self.saveData()
                                    self.logVC.goNext()
                                    break
                                case .failure(let error):
                                    self.logVC.stopAnimating()
                                    self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                                    print(error)
                                    break
                                }
        }
    }
    
    func saveData(){
        PreferenceUtils.username = self.mail
        PreferenceUtils.password = self.pass
    }
    
    func staffType(type : String){
        print(type)
        if type == "\(STAFF_STATUSES.ADMIN)"{
            logVC.staffType = "admin"
            userType = NSLocalizedString("Admin", comment: "")
        } else if type == "\(STAFF_STATUSES.WAITER)"{
            logVC.staffType = "waiter"
            userType = NSLocalizedString("Waiter", comment: "")
        } else if type == "\(STAFF_STATUSES.CHEF)"{
            logVC.staffType = "Chef"
            userType = NSLocalizedString("Waiter", comment: "")
        }
    }
}
