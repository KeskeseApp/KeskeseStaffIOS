//
//  TablesFoeCheffVC.swift
//  KeskeseStaff
//
//  Created by NI Vol on 29.10.2019.
//  Copyright © 2019 Keskese. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class TablesForCheffVC: UIViewController, UICollectionViewDelegate , UICollectionViewDataSource, IndicatorInfoProvider {
    
    @IBOutlet var model: StaffObj!
    @IBOutlet weak var collectionView: UICollectionView!
    var refresh : UIRefreshControl!
    
    var tablesResponse = [TableResponse]()
//    var staffTables = [StaffTable]()
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
           
           return IndicatorInfo(title : NSLocalizedString("Table", comment: ""))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadList), name: NSNotification.Name(rawValue: "load"), object: nil)

        collectionView.register(UINib(nibName: "tableElemCell", bundle: nil), forCellWithReuseIdentifier: "tableElemCell")
        
        
    }
    
     override func viewDidAppear(_ animated: Bool) {
        getTables()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tablesResponse.count
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let table = tablesResponse[indexPath.row]
                     let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tableElemCell", for: indexPath) as! tableElemCell
                     animateCollectionCell(cell: cell)
                     
        cell.statusLbl.backgroundColor = model.viewColor(indexPath: indexPath, viewIndex: 1)
        
        cell.tableNumber.backgroundColor = model.viewColor(indexPath: indexPath, viewIndex: 1)
        
        cell.tableNumber.text = String(table.table.number)
        
        cell.statusLbl.text = model.status(indexPath: indexPath, viewIndex: 1)
        cell.emotionLbl.text = ""
                     
        var avatar_url: URL
        if (table.staff.img != nil) {
                 cell.staffImgBG.isHidden = false
                cell.staffName.text = table.staff.name
//                    staffTables[staffTableIndex!].staff.name_small
                 if table.staff.img! != ""{
                    avatar_url = URL(string: table.staff.img!)!
                     cell.staffImage.kf.setImage(with: avatar_url)
                 } else {
                     cell.staffImage.image = nil
                 }

             } else {
                 cell.staffImgBG.isHidden = true
                 cell.staffImage.image = nil
 //                cell.statusLbl.backgroundColor = Color.dark
             }

         //            cell.tableNumperLbl.text = String(indexPath.row + 1)
                     
         return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let table = tablesResponse[indexPath.row]
        postWaiterNotif(table: table)
    }
    
    func postWaiterNotif(table : TableResponse){
        postNotifWaiter(user: table.staff.user, table: table.table.id).responseJSON{
            (response) in
            switch response.result {
            case .success(_):
                self.view.makeToast("Официант вызван")
                break
                
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    func getTables(){
        getTablesForSpot(spotID: spot.id).responseJSON{
            (response) in
            switch response.result {
            case .success(_):
                self.tablesResponse = response.data!.createList(type: TableResponse.self)
                self.collectionView.dataSource = self
                self.collectionView.delegate = self
                self.collectionView.reloadData()
                break
                
            case .failure(let error):
//                self.stopAnimating()
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
//                self.emptyV.internetProblrms(view: self.emptyV)
                print(error)
                break
            }
        }
    }
    
    @objc func reloadList(){
        
    }

}
