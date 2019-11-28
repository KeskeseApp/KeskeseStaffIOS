//
//  MyTablesVC.swift
//  KeskeseStaff
//
//  Created by NI Vol on 8/22/19.
//  Copyright © 2019 Keskese. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import NVActivityIndicatorView


class MyTablesVC: UIViewController, UICollectionViewDelegate , UICollectionViewDataSource, IndicatorInfoProvider,NVActivityIndicatorViewable, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var emptyV: EmptyView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var model: TableObj!

//    @IBOutlet weak var emptyV: EmptyView!
    
//    @IBOutlet weak var Activity: UIActivityIndicatorView!
    var refresh : UIRefreshControl!

    //    var tablesResponse = [TableResponse]()
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return IndicatorInfo(title : "Мои")
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        Activity.startAnimating()
        startAnimating(type : NVActivityIndicatorType.ballPulseSync)
        model.getStaff(userId: user.id!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshPage), name: NSNotification.Name(rawValue: "load"), object: nil)
        
        
        collectionView.register(UINib(nibName: "tableElemCell", bundle: nil), forCellWithReuseIdentifier: "tableElemCell")
        
//        reloadList()
        
        refresh = UIRefreshControl()
        refresh.backgroundColor = UIColor.clear
        refresh.addTarget(self, action: #selector(MyTablesVC.refreshPage), for: UIControl.Event.valueChanged)
        emptyV.reloadBtn.addTarget(self, action: #selector(refreshPage), for: .touchUpInside)
        collectionView.addSubview(refresh)
        
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        model.getTables()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
          super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIScreen.main.bounds.height <= 570{
            return CGSize(width: 140, height: 104)
        } else {
            return CGSize(width: 165, height: 104)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        emptyV.emptyList()
        emptyView(index: myTableResponse.count, view: emptyV)
        return myTableResponse.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = myTableResponse[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tableElemCell", for: indexPath) as! tableElemCell
        animateCollectionCell(cell: cell)
        cell.statusLbl.backgroundColor = model.viewColor(data: data)
        cell.tableNumber.backgroundColor = model.viewColor(data: data)
        cell.tableNumber.text = String(data.table.number)
        
        cell.statusLbl.text = model.status(data: data)
        cell.emotionLbl.text = model.emoji(data: data)
        
//        var avatar_url: URL
//
//        if (data.staff.id != nil) {
////            cell.staffName.text = data.staff.name_small
//            if data.staff.img != nil{
//                avatar_url = URL(string: data.staff.img!)!
//                cell.staffImage.kf.setImage(with: avatar_url)
//            } else {
//                cell.staffImage.image = nil
//            }
//            //                cell.statusLbl.backgroundColor = hexStringToUIColor(hex: staffTables[staffTableIndex!].staff.color!)
//        } else {
//            cell.staffName.text = "?"
//            cell.staffImage.image = nil
//            //                cell.statusLbl.backgroundColor = Color.dark
//        }
        
        cell.staffImgBG.isHidden = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let data = myTableResponse[indexPath.row]
        if data.table.table_status != "\(TABLE_STATUSES.EMPTY)"{
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
                            self.model.getStaff(userId: user.id!)
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
            
        }
    }
    
    
    func reloadList(){
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.refresh.endRefreshing()
        self.collectionView.reloadData()
    }
    
    @objc func refreshPage(){
        startAnimating(type : NVActivityIndicatorType.ballPulseSync)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.model.getStaff(userId: user.id!)
        })
        
        let tabBarControllerItems = self.tabBarController?.tabBar.items
        
        if let tabArray = tabBarControllerItems {
            self.tabBarItem = tabArray[0]
            self.tabBarItem.badgeValue = " "
        }
        emptyV.isHidden = true
//        reloadList()
    }
    

}
