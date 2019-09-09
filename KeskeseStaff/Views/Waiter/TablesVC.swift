//
//  TablesVC.swift
//  KeskeseStaff
//
//  Created by NI Vol on 8/15/19.
//  Copyright © 2019 Keskese. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import NVActivityIndicatorView

class TablesVC: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource, IndicatorInfoProvider, NVActivityIndicatorViewable{
    
    @IBOutlet var model: TableObj!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return IndicatorInfo(title : "Все")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(UINib(nibName: "tableElemCell", bundle: nil), forCellWithReuseIdentifier: "tableElemCell")
        
        startAnimating(type : NVActivityIndicatorType.ballPulseSync)
        
        model.getTables()
        

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tablesResponse.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = tablesResponse[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tableElemCell", for: indexPath) as! tableElemCell
        cell.statusLbl.backgroundColor = model.viewColor(data: data)
        cell.tableNumber.backgroundColor = model.viewColor(data: data)
        cell.tableNumber.text = String(data.table.number)
        cell.statusLbl.text = model.status(data: data)
        cell.emotionLbl.text = model.emoji(data: data)
        cell.staffImgBG.isHidden = true
        
        return cell
    }
    
    func reloadList(){
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = CallBackVC()
        cell.data = tablesResponse[indexPath.row]
        presentPopup(popupVC: cell, mainVC: self)
    }
}
