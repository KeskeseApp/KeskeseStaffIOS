//
//  TablesSelectionVC.swift
//  KeskeseStaff
//
//  Created by NI Vol on 8/2/19.
//  Copyright © 2019 Keskese. All rights reserved.
//

import UIKit
import Kingfisher
import NVActivityIndicatorView

class StaffVC: UIViewController, UICollectionViewDelegate , UICollectionViewDataSource , NVActivityIndicatorViewable, UICollectionViewDelegateFlowLayout {
    

    @IBOutlet var model: StaffObj!
    
    @IBOutlet weak var Activity: UIActivityIndicatorView!
    @IBOutlet weak var aceptBtn: UIButton!
    
    @IBOutlet weak var staffCV: UICollectionView!
    @IBOutlet weak var tablesCV: UICollectionView!
    
    var data = [Int : Any]()
    
     var tablesResponse = [TableResponse]()

    var staffSelection = false
    var refresh : UIRefreshControl!
    
    var staffSelectedIndex = IndexPath()
    
    @IBOutlet weak var emptyV: EmptyView!
    var staffData = [StaffUser]()
    var staffTables = [StaffTable]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshPage), name: NSNotification.Name(rawValue: "load"), object: nil)
        emptyV.reloadBtn.addTarget(self, action: #selector(refreshPage), for: .touchUpInside)
        tablesCV.register(UINib(nibName: "tableElemCell", bundle: nil), forCellWithReuseIdentifier: "tableElemCell")
        
        UI()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshPage), name: NSNotification.Name(rawValue: "load"), object: nil)
        Activity.startAnimating()
        startAnimating(type : NVActivityIndicatorType.ballPulseSync)
        getTables()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
          super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    func UI(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        refresh = UIRefreshControl()
        refresh.backgroundColor = UIColor.clear
        refresh.addTarget(self, action: #selector(StaffVC.refreshPage), for: UIControl.Event.valueChanged)
        
        tablesCV.addSubview(refresh)
        
        singleLine(view: staffCV, lineColor: Color.dark)
        
        
        
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
        var count : Int!

        if collectionView == staffCV{
            count = staffData.count
            return count
        } else if collectionView == tablesCV{
            count = tablesResponse.count
            emptyView(index: count, view: emptyV)
            return count
        }
        
        return count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == staffCV{
            let dataStaff = staffData[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "staffCV", for: indexPath) as! StaffCell
            animateCollectionCell(cell: cell)
            var avatar_url: URL
            
            cell.smallNameLbl.text = dataStaff.name_small
            if dataStaff.img != nil && dataStaff.img != ""{
                avatar_url = URL(string: dataStaff.img!)!
                cell.staffImage.isHidden = false
                cell.staffImage.kf.setImage(with: avatar_url)
            } else {
                cell.staffImage.image = nil
                cell.staffImage.isHidden = true
            }
            

            cell.nameLbl.text = dataStaff.name
            
            if dataStaff.isOnSchedule(){
                cell.onlineIndicatorView.backgroundColor = Color.green
            } else {
                cell.onlineIndicatorView.backgroundColor = Color.red
            }
            
            if staffSelectedIndex == indexPath {
                cell.imageBgView.borderColorV = Color.orange
            }
            else {
                
                cell.imageBgView.borderColorV = UIColor.white
            }
            
            return cell
        } else if collectionView == tablesCV{
            let table = tablesResponse[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tableElemCell", for: indexPath) as! tableElemCell
            animateCollectionCell(cell: cell)
            let staffTableIndex = staffTables.firstIndex(where: {$0.tableId == table.table.id})
            
            cell.statusLbl.backgroundColor = model.viewColor(indexPath: indexPath)
            cell.tableNumber.backgroundColor = model.viewColor(indexPath: indexPath)
            cell.tableNumber.text = String(table.table.number)
            cell.statusLbl.text = model.status(indexPath: indexPath)
            cell.emotionLbl.text = model.emoji(indexPath: indexPath)
            
            
            
            var avatar_url: URL
            if (staffTableIndex != nil) {
                cell.staffImgBG.isHidden = false
                cell.staffName.text = staffTables[staffTableIndex!].staff.name_small
                if staffTables[staffTableIndex!].staff.img != ""{
                    avatar_url = URL(string: staffTables[staffTableIndex!].staff.img!)!
                    cell.staffImage.kf.setImage(with: avatar_url)
                } else {
                    cell.staffImage.image = nil
                }
//                cell.statusLbl.backgroundColor = hexStringToUIColor(hex: staffTables[staffTableIndex!].staff.color!)
            } else {
                cell.staffImgBG.isHidden = true
                cell.staffImage.image = nil
//                cell.statusLbl.backgroundColor = Color.dark
            }

//            cell.tableNumperLbl.text = String(indexPath.row + 1)
            
            return cell
        }

        return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == staffCV{
            
            staffSelectedIndex = indexPath
            
            staffSelection = true
            aceptBtn.isHidden = false
        
            staffCV.reloadData()
            
        } else if collectionView == tablesCV {

            if staffSelection{
                
                let table = tablesResponse[indexPath.row]

                if (staffTables.firstIndex(where: {$0.tableId == table.table.id}) != nil) {
                    staffTables = staffTables.filter{$0.tableId != table.table.id}
                }
                else {
                    staffTables.append(StaffTable(tableId: table.table.id, staff: staffData[staffSelectedIndex.row]))
                }
                

                tablesCV.reloadData()
            }
        }

    }
    
    func getTables(){
        getTablesForSpot(spotID: spot.id).responseJSON{
            (response) in
            switch response.result {
            case .success(_):
                self.tablesResponse = response.data!.createList(type: TableResponse.self)
                self.getStaff()
                break
                
            case .failure(let error):
                self.stopAnimating()
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                self.emptyV.internetProblrms(view: self.emptyV)
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
                
                
                self.setupSelectedTableStaff()
                
                
                self.staffCV.delegate = self
                self.staffCV.dataSource = self
                self.tablesCV.delegate = self
                self.tablesCV.dataSource = self
                self.Activity.stopAnimating()
                self.stopAnimating()
                self.refresh.endRefreshing()
                self.tablesCV.reloadData()
                self.staffCV.reloadData()
                break
            case .failure(let error):
                self.stopAnimating()
                self.emptyV.internetProblrms(view: self.emptyV)
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                print(error)
                break
            }
        }
    }
    
    func setupSelectedTableStaff(){
        if !tablesResponse.isEmpty && !staffData.isEmpty{
                var tableStaffList = [StaffTable]()
                for staffResponse in staffData {
                    for tableId in staffResponse.tables!{
                        tableStaffList.append(StaffTable.init(tableId: tableId, staff: staffResponse))
                    }
                }
                staffTables = tableStaffList
                tablesCV.reloadData()
            
//            else{
//                for (tableResponse in tableList.value!!){
//                    val tableStaff = selectedTableStaffs.find { it.tableId == tableResponse.table.id }
//                    tableResponse.staff = tableStaff?.staff
//                }
//            }
        }
    }
    
    func patchTables(tables : [Int], staffId : Int){
        print("huina \(tables)")
        print("huina \(staffId)")

        patchTablesForStaff(tables: tables, staffID: staffId).responseJSON{
            (response) in
            switch response.result {
            case .success(_):
                self.setNewTablesForWaiter(staffUser: response.data!.create(type: StaffSpotUser.self).staff)
                print("huina \(response)")
                self.stopAnimating()
                break
                
            case .failure(let error):
                self.stopAnimating()
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                print(error)
                break
            }
        }
    }
    
    func setNewTablesForWaiter(staffUser : StaffUser){
        let index = staffData.firstIndex(where: {$0.id == staffUser.id})
        
        if index != nil{
            self.staffData[index!] = staffUser
            aceptBtn.isHidden = true
            
            staffSelectedIndex = IndexPath()
            staffCV.reloadData()
            staffSelection = false
        }
        
        
    }
    
    @IBAction func aceptBtn(_ sender: Any) {
        
//        self.patchTables(tables: [43, 45], staffId: 16)
//        return
        startAnimating(type : NVActivityIndicatorType.ballPulseSync)
        if !staffData.isEmpty{
            for staffResponse in staffData {
                var tableIds = [Int]()
                for elem in staffTables{
                    if elem.staff.id == staffResponse.id{
                        tableIds.append(elem.tableId)
                    }
                }
                self.patchTables(tables: tableIds, staffId: staffResponse.id!)
//                self.patchTables(tables: [43, 45], staffId: 16)
                
                
            }
        } else {
            
        }
    }
    
    @objc func refreshPage(){
        getTables()
        self.emptyV.isHidden = true
    }
}
