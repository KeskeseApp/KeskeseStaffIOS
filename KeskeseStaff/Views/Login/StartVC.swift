//
//  StartVC.swift
//  KeskeseStaff
//
//  Created by NI Vol on 8/28/19.
//  Copyright © 2019 Keskese. All rights reserved.
//

import UIKit

class StartVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
//        PreferenceUtils.clearData()
        print("0")
        if PreferenceUtils.username != ""{
            print("1")
            self.getUser()
            
        } else {
            print("2")
            performSegue(withIdentifier: "startToReg", sender: nil)
        }
    }
    
    func getUser(){
        KeskeseStaff.getUser(username: PreferenceUtils.username).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
                user = response.data!.createList(type: ElementUser.self)[0]
                user.password = PreferenceUtils.password
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
                
//                self.postFcmDevice()
                
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
            performSegue(withIdentifier: "startToAdmin", sender: nil)
//            logVC.staffType = "admin"
            userType = "Администратор"
        } else if type == "\(STAFF_STATUSES.WAITER)"{
            
            performSegue(withIdentifier: "startToGuest", sender: nil)
//            logVC.staffType = "waiter"
            userType = "Официант"
        }
    }

}
