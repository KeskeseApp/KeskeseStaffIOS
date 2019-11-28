//
//  StaffForChefVC.swift
//  KeskeseStaff
//
//  Created by NI Vol on 31.10.2019.
//  Copyright © 2019 Keskese. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class StaffForChefVC: UIViewController, IndicatorInfoProvider, UICollectionViewDelegate, UICollectionViewDataSource {

    
    @IBOutlet weak var collectionView: UICollectionView!
    var staffData = [StaffUser]()
    var refresh : UIRefreshControl!
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return IndicatorInfo(title : NSLocalizedString("Staff", comment: ""))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(reloadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        
        refresh = UIRefreshControl()
        refresh.backgroundColor = UIColor.clear
        refresh.addTarget(self, action: #selector(StaffForChefVC.reloadList), for: UIControl.Event.valueChanged)
        
        collectionView.addSubview(refresh)
        collectionView.register(UINib(nibName: "tableElemCell", bundle: nil), forCellWithReuseIdentifier: "tableElemCell")
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getStaff()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return staffData.count
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
         let dataStaff = staffData[indexPath.row]
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tableElemCell", for: indexPath) as! tableElemCell
        
//        cell.tableNumber.isHidden = true
        cell.emotionLbl.isHidden = true
        cell.tableNumber.text = ""
        
        if dataStaff.isOnSchedule(){
            cell.tableNumber.backgroundColor = Color.green
        } else {
            cell.tableNumber.backgroundColor = Color.red
        }
        
        animateCollectionCell(cell: cell)
        var avatar_url: URL
        
        cell.staffName.text = dataStaff.name_small
        if dataStaff.img != nil && dataStaff.img != ""{
            avatar_url = URL(string: dataStaff.img!)!
            cell.staffImage.isHidden = false
            cell.staffImage.kf.setImage(with: avatar_url)
        } else {
            cell.staffImage.image = nil
            cell.staffImage.isHidden = true
        }

        cell.statusLbl.text = dataStaff.name
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let staff = staffData[indexPath.row]
        postWaiterNotif(staff: staff)
    }
    
    func postWaiterNotif(staff : StaffUser){
        postNotifWaiter(user: staff.user!, table: nil).responseJSON{
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
    
    
    
    func getStaff(){
        getStaffForSpot(spotID: spot.id).responseJSON{
            (response) in
            switch response.result {
            case .success(_):
                
                var staffResp = response.data!.createList(type: StaffSpotUser.self)
                    
                    staffResp.sort(by: { $0.staff.isOnSchedule() && !$1.staff.isOnSchedule() })
                

                
                
                self.staffData.removeAll(keepingCapacity: false)
                for staff in staffResp{
                    self.staffData.append(staff.staff)
                }
                
                self.collectionView.dataSource = self
                self.collectionView.delegate = self
                
                self.refresh.endRefreshing()
                self.collectionView.reloadData()
                break
            case .failure(let error):
//                self.stopAnimating()
//                self.emptyV.internetProblrms(view: self.emptyV)
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                print(error)
                break
            }
        }
    }
    
    
    @objc func reloadList(){
        getStaff()
    }

}
