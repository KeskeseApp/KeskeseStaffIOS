//
//  SettingList.swift
//  KeskeseStaff
//
//  Created by NI Vol on 8/29/19.
//  Copyright © 2019 Keskese. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class SettingList: UITableViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var onShiftSwitch: UISwitch!
    
    var pressExite = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UI()
        
    }
    
    func UI(){
        
        switch staff.spot_status! {
        case "\(SPOT_STATUSES.ON_SHEDULE)":
            self.onShiftSwitch.isOn = true
            let tabBarControllerItems = self.tabBarController?.tabBar.items
            
            if let tabArray = tabBarControllerItems {
                self.tabBarItem = tabArray[0]
                self.tabBarItem = tabArray[1]
                
                tabArray[0].isEnabled = true
                tabArray[1].isEnabled = true
            }
        case "\(SPOT_STATUSES.NOT_ON_SHEDULE)":
            self.onShiftSwitch.isOn = false
            
            let tabBarControllerItems = self.tabBarController?.tabBar.items
            
            if let tabArray = tabBarControllerItems {
                self.tabBarItem = tabArray[0]
                self.tabBarItem = tabArray[1]
                
                tabArray[0].isEnabled = false
                tabArray[1].isEnabled = false
                
            }
            
        default:
            print("Star")
        }

    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            presentPopup(popupVC: NotifSettingVC(), mainVC: self)
        }
        else if indexPath.row == 3 {
            
            // create the alert
            let alert = UIAlertController(title: NSLocalizedString("Log out", comment: ""), message: "", preferredStyle: UIAlertController.Style.alert)
            
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: {action in
                
                self.pressExite = true
                self.postStaffStatus(type: "\(WAITER_NOTIFS.LEFT_SHEDULE)")
                PreferenceUtils.clearData()
                
            }))
            alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 0
        } else if indexPath.row == 1 && spot == nil{
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
                        tabArray[1].isEnabled = false
                    }
                    staff.spot_status = "\(SPOT_STATUSES.NOT_ON_SHEDULE)"
                }
                
                
                if self.pressExite{
                    
                    self.performSegue(withIdentifier: "settingToStart", sender: nil)
                    
                }
                //        staffActivity.viewModel.setOnSchedule(checkBox.isChecked, staffUser)
                self.stopAnimating()
                break
                
            case .failure(let error):
                
                self.stopAnimating()
                
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                print(error)
                break
            }
        }
    }

    @IBAction func patchOnShift(_ sender: Any) {
        
        startAnimating(type : NVActivityIndicatorType.ballPulseSync)
        getStaffStatus()
    }

}
