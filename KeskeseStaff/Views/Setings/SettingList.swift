//
//  SettingList.swift
//  KeskeseStaff
//
//  Created by NI Vol on 8/29/19.
//  Copyright © 2019 Keskese. All rights reserved.
//

import UIKit

class SettingList: UITableViewController {

    @IBOutlet weak var onShiftSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getStaffStatus()
        
        
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            presentPopup(popupVC: NotifSettingVC(), mainVC: self)
        }
        else if indexPath.row == 2 {
            performSegue(withIdentifier: "settingToStart", sender: nil)
            PreferenceUtils.clearData()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 && userType == "Официант"{
            return 0
        } else {
            return 50
        }
    }
    
    func getStaffStatus(){
        
    
        switch staff.spot_status! {
        case "\(SPOT_STATUSES.ON_SHEDULE)":
            self.postStaffStatus(type: "\(WAITER_NOTIFS.LEFT_SHEDULE)")
        case "\(SPOT_STATUSES.NOT_ON_SHEDULE)":
            self.postStaffStatus(type: "\(WAITER_NOTIFS.JOIN_SHEDULE)")
        default:
            print("Star")
        }

    }
    
    func postStaffStatus(type : String){
        postAdminNotif(staff : staff.id! ,type: type).responseJSON{
            (response) in
            switch response.result {
            case .success(_):
                
                print("huina \(response)")
                
                if type == "\(WAITER_NOTIFS.JOIN_SHEDULE)"{
                    self.onShiftSwitch.isOn = true
                    
                    let tabBarControllerItems = self.tabBarController?.tabBar.items
                    
                    if let tabArray = tabBarControllerItems {
                        self.tabBarItem = tabArray[0]
                        self.tabBarItem = tabArray[1]
                        
                        tabArray[0].isEnabled = true
                        tabArray[1].isEnabled = true
                    
                    }
                    
                    staff.spot_status = "\(SPOT_STATUSES.ON_SHEDULE)"
                } else {
                    self.onShiftSwitch.isOn = false
                    let tabBarControllerItems = self.tabBarController?.tabBar.items
                    
                    if let tabArray = tabBarControllerItems {
                        self.tabBarItem = tabArray[0]
                        self.tabBarItem = tabArray[1]
                        
                        tabArray[0].isEnabled = false
                        tabArray[11].isEnabled = false
                    }
                    staff.spot_status = "\(SPOT_STATUSES.NOT_ON_SHEDULE)"
                }
                
                //        staffActivity.viewModel.setOnSchedule(checkBox.isChecked, staffUser)
                
                break
                
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                print(error)
                break
            }
        }
    }

    @IBAction func patchOnShift(_ sender: Any) {
        
        
        getStaffStatus()
    }

}
