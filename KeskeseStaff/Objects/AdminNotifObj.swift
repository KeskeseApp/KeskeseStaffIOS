//
//  AdminNotifObj.swift
//  KeskeseStaff
//
//  Created by NI Vol on 8/29/19.
//  Copyright © 2019 Keskese. All rights reserved.
//

import UIKit

class AdminNotifObj: NSObject {
    @IBOutlet weak var View: AdminNotifVC!
    
    func getData(){
        
        getNotifListForAdmin(spotID: staff.spot!).responseJSON{
            (response) in
            switch response.result {
            case .success(_):
                self.View.notifList = response.data!.createList(type: AdminNotif.self).sorted(by: { $0.id > $1.id})
                
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
    
    func patchNotif(seen : Bool, elemId : Int, success: @escaping simpleFunc){
        patchAdminNotif(seen: seen, elemId: elemId).responseJSON{
            (response) in
            switch response.result {
            case .success(_):
                //                self.setNewTablesForWaiter(staffUser: response.data!.create(type: StaffUser.self))
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
