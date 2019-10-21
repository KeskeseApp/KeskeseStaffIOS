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
        
        return IndicatorInfo(title : NSLocalizedString("Guest", comment: ""))
    }
    
    @IBOutlet weak var emptyView: EmptyView!
    @IBOutlet weak var Activity: UIActivityIndicatorView!
    @IBOutlet var ModelObj: NotifListObj!
    
    @IBOutlet weak var tableView: UITableView!
    var refresh : UIRefreshControl!
    var notifList = [NotifGuest]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "NotifCell", bundle: nil), forCellReuseIdentifier: "NotifCell")
        
        refresh = UIRefreshControl()
        refresh.backgroundColor = UIColor.clear
        refresh.addTarget(self, action: #selector(WaiterNotifsForAdmin.refreshPage), for: UIControl.Event.valueChanged)
        emptyView.reloadBtn.addTarget(self, action: #selector(refreshPage), for: .touchUpInside)
        tableView.addSubview(refresh)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshPage), name: NSNotification.Name(rawValue: "load"), object: nil)
        Activity.startAnimating()
        ModelObj.getData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
          super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        emptyView.emptyList()
        KeskeseStaff.emptyView(index: notifList.count, view: emptyView)
        return notifList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = notifList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotifCell", for: indexPath) as!  NotifCell
        animate(cell: cell)
        cell.indexLbl.text = String(data.table.number)
        cell.timeLbl.text = data.time
//        cell.typeLbl.text = data.type
        tableStatuses(type: data.type, view: cell.BG, statys: cell.statysLbl, seen: data.seen, button: cell.confirmBtn)
        cell.indexBG.borderColorV = cell.BG.borderColorV
        cell.confirmBtn.isHidden = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = CallBackVC()
//        cell.lastView = "notif"
//        cell.notifData = notifList[indexPath.row]
//        presentPopup(popupVC: cell, mainVC: self)
        let data = notifList[indexPath.row]
        startAnimating(type : NVActivityIndicatorType.ballPulseSync)
        let successFunc = {
            self.notifList[indexPath.row].seen = !data.seen
            self.tableView.reloadData()
            self.stopAnimating()
            
        }
        ModelObj.patchNotif(seen: !data.seen, elemId: data.id, success: successFunc)
    }
    
    func reloadList(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.refresh.endRefreshing()
        stopAnimating()
        Activity.stopAnimating()
    }
    
    @objc func refreshPage(){
        ModelObj.getData()
        self.emptyView.isHidden = true
    }
    
}
