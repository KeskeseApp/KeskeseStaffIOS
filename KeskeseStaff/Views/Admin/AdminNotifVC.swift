//
//  AdminNotifVC.swift
//  KeskeseStaff
//
//  Created by NI Vol on 8/29/19.
//  Copyright © 2019 Keskese. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import XLPagerTabStrip

class AdminNotifVC: UIViewController, UITableViewDelegate , UITableViewDataSource , NVActivityIndicatorViewable, IndicatorInfoProvider {

    
    @IBOutlet var ModelObj: AdminNotifObj!
    
    @IBOutlet weak var tableView: UITableView!
    
    var notifList = [AdminNotif]()
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return IndicatorInfo(title : "Персонал")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "NotifCell", bundle: nil), forCellReuseIdentifier: "NotifCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ModelObj.getData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ModelObj.numberOfRowsInSection(selections: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = notifList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotifCell", for: indexPath) as!  NotifCell
        animate(cell: cell)
//        cell.indexLbl.text = String(data.staff)
        cell.timeLbl.text = data.time
        cell.typeLbl.text = "Вышел на Смену"
//            data.type
        waiterNotifs(type: data.type, view: cell.BG, statys: cell.statysLbl, seen: data.seen)
        cell.indexBG.borderColorV = cell.BG.borderColorV
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = CallBackVC()
//        cell.lastView = "admin"
//        cell.adminNotifData = notifList[indexPath.row]
//        presentPopup(popupVC: cell, mainVC: self)
        let data = notifList[indexPath.row]
        
        let successFunc = {
            self.notifList[indexPath.row].seen = !data.seen
            self.tableView.reloadData()
        }
        print("link \(!data.seen)")
        ModelObj.patchNotif(seen: !data.seen, elemId: data.id, success: successFunc)
    }
    
    
    
    func reloadList(){
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

}
