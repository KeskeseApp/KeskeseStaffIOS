//
//  NotifSettingVC.swift
//  KeskeseStaff
//
//  Created by NI Vol on 9/4/19.
//  Copyright © 2019 Keskese. All rights reserved.
//

import UIKit
import Alamofire

class NotifSettingVC: UIViewController {
    @IBOutlet weak var highRateSwitch: UISwitch!
    @IBOutlet weak var lowRateSwitch: UISwitch!
    @IBOutlet weak var joinShiftSwitch: UISwitch!
    @IBOutlet weak var leftShiftSwich: UISwitch!
    
    var settings : StaffSettings!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       getData()
    }
    
    func getData(){
        getStaffSettings(staffId: staff!.id!).responseJSON{
            (response) in
            switch response.result {
            case .success(_):
                print("zoibav \(self.highRateSwitch.isOn)")
                self.settings = response.data!.createList(type: StaffSettings.self)[0]
                
                self.setSettings()
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                print(error)
                break
            }
        }
    }
    
    func setSettings(){
        highRateSwitch.isOn = settings.waiter_call
        lowRateSwitch.isOn = settings.admin_call
        joinShiftSwitch.isOn = settings.cash_out
    }
    
    func patchSettings(){
        KeskeseStaff.patchStaffSettings(settings: settings, staffId: settings.id).responseJSON{
            (response) in
            switch response.result {
            case .success(_):
                self.dismiss(animated: true, completion: nil)
                print("Settings PATCHED")
                
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                self.dismiss(animated: true, completion: nil)
                print(error)
                break
            }
        }
    }
    
    
    @IBAction func doneBtn(_ sender: Any) {
        settings.admin_call = lowRateSwitch.isOn
        settings.cash_out = joinShiftSwitch.isOn
        settings.waiter_call = highRateSwitch.isOn
    
        print(self.highRateSwitch.isOn)
        print(self.lowRateSwitch.isOn)
        print(self.joinShiftSwitch.isOn)
        
        patchSettings()
        
    }
    
    @IBAction func highRateSwitch(_ sender: Any) {
        
    }
    @IBAction func lowRateSwitch(_ sender: Any) {
        
    }
    
    @IBAction func joinShiftSwitch(_ sender: Any) {
        
    }
    @IBAction func leftShiftSwitch(_ sender: Any) {
        
    }
}
