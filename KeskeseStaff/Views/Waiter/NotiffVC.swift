//
//  NotiffVC.swift
//  KeskeseStaff
//
//  Created by NI Vol on 8/13/19.
//  Copyright © 2019 Keskese. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class NotiffVC: UIViewController, UITableViewDelegate , UITableViewDataSource , NVActivityIndicatorViewable {
    
    @IBOutlet var ModelObj: NotifListObj!
    @IBOutlet weak var Activity: UIActivityIndicatorView!
    
    @IBOutlet weak var tableView: UITableView!
    var refresh : UIRefreshControl!
    @IBOutlet weak var emptyV: EmptyView!
    
    var notifList = [NotifGuest]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshPage), name: NSNotification.Name(rawValue: "load"), object: nil)
        
        emptyV.reloadBtn.addTarget(self, action: #selector(refreshPage), for: .touchUpInside)
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        refresh = UIRefreshControl()
        refresh.backgroundColor = UIColor.clear
        refresh.addTarget(self, action: #selector(MyTablesVC.refreshPage), for: UIControl.Event.valueChanged)
        
        tableView.addSubview(refresh)
        
        tableView.register(UINib(nibName: "NotifCell", bundle: nil), forCellReuseIdentifier: "NotifCell")

    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshPage), name: NSNotification.Name(rawValue: "load"), object: nil)
        Activity.startAnimating()
        ModelObj.getDataForStaff()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
          super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        emptyV.emptyList()
        emptyView(index: ModelObj.numberOfRowsInSection(selections: section), view: emptyV)
        
        return ModelObj.numberOfRowsInSection(selections: section)
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
        cell.confirmBtn.tag = indexPath.row
        
        if data.seen{
            cell.confirmBtn.setTitle(NSLocalizedString("Close order", comment: "") , for: .normal)
        } else {
            cell.confirmBtn.setTitle(NSLocalizedString("Seen", comment: ""), for: .normal)
        }
        
        cell.confirmBtn.addTarget(self, action: #selector(confirmBtn(sender:)), for: .touchUpInside)
        
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
        Activity.stopAnimating()
        let tabBarControllerItems = self.tabBarController?.tabBar.items
        
        if let tabArray = tabBarControllerItems {
            self.tabBarItem = tabArray[0]
            self.tabBarItem.badgeValue = nil
        }
    
    }
    
    @objc func refreshPage(){
        startAnimating(type : NVActivityIndicatorType.ballPulseSync)
        ModelObj.getDataForStaff()
    }
    
    @objc func confirmBtn(sender : UIButton){
        
        let data = notifList[sender.tag]
        if data.seen{
            // start loading
            
            let alert = UIAlertController(title: "\(NSLocalizedString("Close order", comment: ""))?", message: "", preferredStyle: UIAlertController.Style.alert)
            
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: {action in
                self.startAnimating(type : NVActivityIndicatorType.ballPulseSync)
                unassignTable(old_staff_id: staff.id!, table_id: data.table.id)
                    .responseJSON{
                        (response) in
                        switch response.result {
                        case .success(_):
                            //                self.View.stopAnimating()
                            
                            self.ModelObj.getDataForStaff()
                            self.stopAnimating()
                            break
                            
                        case .failure(let error):
                            self.stopAnimating()
                            print(error)
                            break
                        }
                }
            }))
            alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
        } else {
            let successFunc = {
                self.notifList[sender.tag].seen = !data.seen
                self.tableView.reloadData()
                self.stopAnimating()
            }
            ModelObj.patchNotif(seen: !data.seen, elemId: data.id, success: successFunc)
        }
    }
}
