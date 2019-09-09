//
//  WaiterNotifsForAdmin.swift
//  KeskeseStaff
//
//  Created by NI Vol on 8/31/19.
//  Copyright © 2019 Keskese. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import XLPagerTabStrip

class WaiterNotifsForAdmin: UIViewController , UITableViewDelegate , UITableViewDataSource , NVActivityIndicatorViewable, IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return IndicatorInfo(title : "Гости")
    }
    
    @IBOutlet var ModelObj: NotifListObj!
    
    @IBOutlet weak var tableView: UITableView!
    
    var notifList = [NotifGuest]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "NotifCell", bundle: nil), forCellReuseIdentifier: "NotifCell")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ModelObj.getData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = notifList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotifCell", for: indexPath) as!  NotifCell
        animate(cell: cell)
        cell.indexLbl.text = String(data.table.number)
        cell.timeLbl.text = data.time
        cell.typeLbl.text = data.type
        tableStatuses(type: data.type, view: cell.BG, statys: cell.statysLbl, seen: data.seen)
        cell.indexBG.borderColorV = cell.BG.borderColorV
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = CallBackVC()
//        cell.lastView = "notif"
//        cell.notifData = notifList[indexPath.row]
//        presentPopup(popupVC: cell, mainVC: self)
        let data = notifList[indexPath.row]
        
        let successFunc = {
            self.notifList[indexPath.row].seen = !data.seen
            self.tableView.reloadData()
        }
        ModelObj.patchNotif(seen: !data.seen, elemId: data.id, success: successFunc)
    }
    
    func reloadList(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
}
