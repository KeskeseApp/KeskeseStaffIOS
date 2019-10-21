//
//  StartVC.swift
//  KeskeseStaff
//
//  Created by NI Vol on 8/28/19.
//  Copyright © 2019 Keskese. All rights reserved.
//

import UIKit

class StartVC: UIViewController {

    @IBOutlet var emptyView: EmptyView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("0")
        emptyView.reloadBtn.addTarget(self, action: #selector(refreshPage), for: .touchUpInside)
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
                self.emptyView.internetProblrms(view: self.emptyView)
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
                } else {
                    self.performSegue(withIdentifier: "startToReg", sender: nil)
                }
                
//                self.postFcmDevice()
                
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                self.emptyView.internetProblrms(view: self.emptyView)
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
            userType = NSLocalizedString("Admin", comment: "")
        } else if type == "\(STAFF_STATUSES.WAITER)"{
            
            performSegue(withIdentifier: "startToGuest", sender: nil)
//            logVC.staffType = "waiter"
            userType = NSLocalizedString("Waiter", comment: "")
        }
    }
    
    @objc func refreshPage(){
        if PreferenceUtils.username != ""{
            print("1")
            self.getUser()
            
        } else {
            print("2")
            performSegue(withIdentifier: "startToReg", sender: nil)
        }
        emptyView.isHidden = true
    }
    
}
