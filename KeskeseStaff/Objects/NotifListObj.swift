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
        
//        getNotifListForStaff(userID : user!.id!).responseJSON{
//            (response) in
//            switch response.result {
//            case .success(_):
//                var notifs = response.data!.createList(type: NotifGuest.self).sorted(by: { $0.id > $1.id})
//
//                notifs.sort(by: { !$0.seen && $1.seen})
//
//
//                self.View.notifList.removeAll(keepingCapacity: false)
//                for notif in notifs{
//                    self.View.notifList.append(notif)
//                }
//
//                self.View.stopAnimating()
//                self.View.reloadList()
//
//                self.View.tableView.reloadData()
//                break
//            case .failure(let error):
//                self.View.stopAnimating()
//                self.View.Activity.stopAnimating()
//                self.View.emptyV.internetProblrms(view: self.View.emptyV)
//                self.View.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
//                print(error)
//                break
//            }
//        }
        
        getAllNotifListForStaff(spotID: spot.id).responseJSON{
            (response) in
            switch response.result {
            case .success(_):
                self.View.notifList = response.data!.createList(type: NotifGuest.self).sorted(by: { $0.id > $1.id})
                
                var notifs = response.data!.createList(type: NotifGuest.self).sorted(by: { $0.id > $1.id})
                
                notifs.sort(by: { !$0.seen && $1.seen})
                

                self.View.notifList.removeAll(keepingCapacity: false)
                for notif in notifs{
                    self.View.notifList.append(notif)
                }

//                self.AdminNotifView.stopAnimating()
                self.View.reloadList()
                                self.View.stopAnimating()
//                self.AdminNotifView.Activity.stopAnimating()
                self.View.tableView.reloadData()
                break
            case .failure(let error):
                self.View.stopAnimating()
                self.View.Activity.stopAnimating()
                self.View.emptyV.internetProblrms(view: self.View.emptyV)
                self.View.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                print(error)
                break
            }
        }
        
        
    }
    
    func getData(){
        
        getAllNotifListForStaff(spotID: spot.id).responseJSON{
            (response) in
            switch response.result {
            case .success(_):
                self.AdminNotifView.notifList = response.data!.createList(type: NotifGuest.self).sorted(by: { $0.id > $1.id})
                
                var notifs = response.data!.createList(type: NotifGuest.self).sorted(by: { $0.id > $1.id})
                
                notifs.sort(by: {!$0.seen && $1.seen})
                

                self.AdminNotifView.notifList.removeAll(keepingCapacity: false)
                for notif in notifs{
                    self.AdminNotifView.notifList.append(notif)
                }

                self.AdminNotifView.stopAnimating()
                self.AdminNotifView.reloadList()
                self.AdminNotifView.Activity.stopAnimating()
                self.AdminNotifView.tableView.reloadData()
                break
            case .failure(let error):
                self.AdminNotifView.stopAnimating()
                self.AdminNotifView.Activity.stopAnimating()
                self.AdminNotifView.emptyView.internetProblrms(view: self.AdminNotifView.emptyView)
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
//                self.View.stopAnimating()
//                print("huina \(response)")
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
