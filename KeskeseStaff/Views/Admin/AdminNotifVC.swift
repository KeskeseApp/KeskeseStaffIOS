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
    @IBOutlet weak var emptyV: EmptyView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var refresh : UIRefreshControl!
    
    @IBOutlet weak var Activity: UIActivityIndicatorView!
    var notifList = [AdminNotif]()
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return IndicatorInfo(title : NSLocalizedString("Staff", comment: ""))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        tableView.register(UINib(nibName: "NotifCell", bundle: nil), forCellReuseIdentifier: "NotifCell")
        
        refresh = UIRefreshControl()
        refresh.backgroundColor = UIColor.clear
        refresh.addTarget(self, action: #selector(AdminNotifVC.refreshPage), for: UIControl.Event.valueChanged)
        
        tableView.addSubview(refresh)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Activity.startAnimating()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshPage), name: NSNotification.Name(rawValue: "load"), object: nil)
        ModelObj.getData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
          super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        emptyView(index: ModelObj.numberOfRowsInSection(selections: section), view: emptyV)
        return ModelObj.numberOfRowsInSection(selections: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = notifList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotifCell", for: indexPath) as!  NotifCell
        animate(cell: cell)
        cell.indexBG.isHidden = true
        cell.timeLbl.text = data.time
//        cell.typeLbl.text = "Вышел на Смену"
//            data.type
        cell.namelbl.isHidden = false
        cell.namelbl.text = data.staff.name
        waiterNotifs(type: data.type, view: cell.BG, statys: cell.statysLbl, seen: data.seen, button: cell.confirmBtn)
        cell.indexBG.borderColorV = cell.BG.borderColorV
//        cell.confirmBtn.isHidden = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = CallBackVC()
//        cell.lastView = "admin"
//        cell.adminNotifData = notifList[indexPath.row]
//        presentPopup(popupVC: cell, mainVC: self)
        let data = notifList[indexPath.row]
        startAnimating(type : NVActivityIndicatorType.ballPulseSync)
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
        self.refresh.endRefreshing()
        
    }
    
    @objc func refreshPage(){
        ModelObj.getData()
    }

}
