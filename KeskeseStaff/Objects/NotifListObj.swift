//
//  NotifListObj.swift
//  KeskeseStaff
//
//  Created by NI Vol on 8/22/19.
//  Copyright © 2019 Keskese. All rights reserved.
//

import UIKit

class NotifListObj: NSObject{
    
    @IBOutlet weak var View: NotiffVC!
    @IBOutlet weak var AdminNotifView: WaiterNotifsForAdmin!
    
    func getDataForStaff(){
        
        getNotifListForStaff(userID : user!.id!).responseJSON{
            (response) in
            switch response.result {
            case .success(_):
                self.View.notifList = response.data!.createList(type: NotifGuest.self).sorted(by: { $0.id > $1.id})

                self.View.stopAnimating()
                self.View.reloadList()
                self.View.tableView.reloadData()
                break
            case .failure(let error):
                self.View.stopAnimating()
                self.View.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                print(error)
                break
            }
        }
    }
    
    func getData(){
        
        getAllNotifListForStaff(spotID: staff!.spot!).responseJSON{
            (response) in
            switch response.result {
            case .success(_):
                self.AdminNotifView.notifList = response.data!.createList(type: NotifGuest.self).sorted(by: { $0.id > $1.id})
                
                self.AdminNotifView.stopAnimating()
                self.AdminNotifView.reloadList()
                self.AdminNotifView.tableView.reloadData()
                break
            case .failure(let error):
                self.AdminNotifView.stopAnimating()
                self.AdminNotifView.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                print(error)
                break
            }
        }
    }
    
    func patchNotif(seen : Bool, elemId : Int, success: @escaping simpleFunc){
        
        
        patchWaiterNotif(seen: seen, elemId: elemId).responseJSON{
            (response) in
            switch response.result {
            case .success(_):
                
                print("huina \(response)")
                success()
                
                break
                
            case .failure(let error):
                
                print(error)
                break
            }
        }
    }
    
    func numberOfRowsInSection(selections : Int) -> Int {
        return self.View.notifList.count
    }
}
