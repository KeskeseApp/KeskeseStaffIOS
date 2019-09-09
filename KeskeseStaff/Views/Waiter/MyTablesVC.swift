//
//  MyTablesVC.swift
//  KeskeseStaff
//
//  Created by NI Vol on 8/22/19.
//  Copyright © 2019 Keskese. All rights reserved.
//

import UIKit
import XLPagerTabStrip


class MyTablesVC: UIViewController, UICollectionViewDelegate , UICollectionViewDataSource, IndicatorInfoProvider {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var model: TableObj!
    
    
//    var tablesResponse = [TableResponse]()
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return IndicatorInfo(title : "Мои")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "tableElemCell", bundle: nil), forCellWithReuseIdentifier: "tableElemCell")
        reloadList()

        print(model.sortMyTables(staffId: staff.id!, tables: tablesResponse))
//        model.getTables()
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myTableResponse.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = myTableResponse[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tableElemCell", for: indexPath) as! tableElemCell
        
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
    
    
    
    func reloadList(){
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
    }
    

}
