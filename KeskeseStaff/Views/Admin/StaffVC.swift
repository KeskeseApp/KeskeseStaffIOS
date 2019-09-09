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

class StaffVC: UIViewController, UICollectionViewDelegate , UICollectionViewDataSource , NVActivityIndicatorViewable {
    

    @IBOutlet var model: StaffObj!
    
    @IBOutlet weak var aceptBtn: UIButton!
    
    @IBOutlet weak var staffCV: UICollectionView!
    @IBOutlet weak var tablesCV: UICollectionView!
    
    var data = [Int : Any]()
    
     var tablesResponse = [TableResponse]()

    var staffSelection = false
    
    var staffSelectedIndex = IndexPath()
    
    var staffData = [StaffUser]()
    var staffTables = [StaffTable]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tablesCV.register(UINib(nibName: "tableElemCell", bundle: nil), forCellWithReuseIdentifier: "tableElemCell")
        
        UI()
        getTables()
    }
    
    func UI(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        singleLine(view: staffCV, lineColor: Color.dark)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        var count : Int!

        if collectionView == staffCV{
            count = staffData.count
            return count
        } else if collectionView == tablesCV{
            count = tablesResponse.count
            return count
        }
        return count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == staffCV{
            let dataStaff = staffData[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "staffCV", for: indexPath) as! StaffCell
            
            var avatar_url: URL
            
            cell.smallNameLbl.text = dataStaff.name_small
            if dataStaff.img != nil{
                avatar_url = URL(string: dataStaff.img!)!
                cell.staffImage.kf.setImage(with: avatar_url)
            } else {
                cell.staffImage.image = nil
            }
            

            if staffSelectedIndex == indexPath {
                cell.cellBGView.borderColorV = Color.orange
            }
            else {
                
                cell.cellBGView.borderColorV = UIColor.white
            }
            
            return cell
        } else if collectionView == tablesCV{
            let table = tablesResponse[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tableElemCell", for: indexPath) as! tableElemCell
            
            let staffTableIndex = staffTables.firstIndex(where: {$0.tableId == table.table.id})
            
            cell.statusLbl.backgroundColor = model.viewColor(indexPath: indexPath)
            cell.tableNumber.backgroundColor = model.viewColor(indexPath: indexPath)
            cell.tableNumber.text = String(table.table.number)
            cell.statusLbl.text = model.status(indexPath: indexPath)
            cell.emotionLbl.text = model.emoji(indexPath: indexPath)
            var avatar_url: URL
            if (staffTableIndex != nil) {
                cell.staffName.text = staffTables[staffTableIndex!].staff.name_small
                if staffTables[staffTableIndex!].staff.img != nil{
                    avatar_url = URL(string: staffTables[staffTableIndex!].staff.img!)!
                    cell.staffImage.kf.setImage(with: avatar_url)
                } else {
                    cell.staffImage.image = nil
                }
//                cell.statusLbl.backgroundColor = hexStringToUIColor(hex: staffTables[staffTableIndex!].staff.color!)
            } else {
                cell.staffName.text = "?"
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
        getTablesForSpot(spotID: 6).responseJSON{
            (response) in
            switch response.result {
            case .success(_):
                self.tablesResponse = response.data!.createList(type: TableResponse.self)
                self.getStaff()
                break
                
            case .failure(let error):
                self.stopAnimating()
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                print(error)
                break
            }
        }
    }
    
    func getStaff(){
        getStaffForSpot(spotID: 6).responseJSON{
            (response) in
            switch response.result {
            case .success(_):
                
                self.staffData = response.data!.createList(type: StaffUser.self)
                
                self.setupSelectedTableStaff()
                self.staffCV.delegate = self
                self.staffCV.dataSource = self
                self.tablesCV.delegate = self
                self.tablesCV.dataSource = self
                self.stopAnimating()
                self.tablesCV.reloadData()
                self.staffCV.reloadData()
                break
            case .failure(let error):
                self.stopAnimating()
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                print(error)
                break
            }
        }
    }
    
    func setupSelectedTableStaff(){
        if !tablesResponse.isEmpty && !staffData.isEmpty{
            if staffTables.isEmpty {
                var tableStaffList = [StaffTable]()
                for staffResponse in staffData {
                    for tableId in staffResponse.tables!{
                        tableStaffList.append(StaffTable.init(tableId: tableId, staff: staffResponse))
                    }
                }
                staffTables = tableStaffList
                tablesCV.reloadData()
            }
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
                self.setNewTablesForWaiter(staffUser: response.data!.create(type: StaffUser.self))
                print("huina \(response)")

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
        print("huina \(staffUser)")
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
        }
    }
}
