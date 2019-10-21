//
//  TableObj.swift
//  KeskeseStaff
//
//  Created by NI Vol on 8/23/19.
//  Copyright © 2019 Keskese. All rights reserved.
//

import UIKit

class TableObj: NSObject {

    @IBOutlet weak var View: TablesVC!
    @IBOutlet weak var MyTableView: MyTablesVC!
    
    
    func getStaff(userId : Int){
            KeskeseStaff.getStaff(userID: userId).responseJSON{
                (response) in
                switch response.result {
                case .success(_):
                    
                    let staffSpotUserList = response.data!.createList(type: StaffSpotUser.self)
                    if !staffSpotUserList.isEmpty{
                        let staffSpotUser = staffSpotUserList[0]
                                                    
                        staff = staffSpotUser.staff
                        spot = staffSpotUser.spot
                        
                        
                        
                    }
                    self.getTables()
                    
                    
                    break
                case .failure(let error):
                    self.MyTableView.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                    self.MyTableView.emptyV.internetProblrms(view: self.MyTableView.emptyV)
                    self.MyTableView.stopAnimating()
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
                
                tablesResponse = response.data!.createList(type: TableResponse.self)
                print("Pizd \(tablesResponse)")
                myTableResponse = self.sortMyTables(staffId: staff!.id!, tables: tablesResponse)
                self.MyTableView.stopAnimating()
                
                break
            case .failure(let error):
//                self.View.stopAnimating()
                self.MyTableView.emptyV.internetProblrms(view: self.MyTableView.emptyV)
//                self.View.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                print(error)
                break
            }
        }
        
    }
    
    func sortMyTables(staffId : Int, tables: [TableResponse]) -> [TableResponse]{
        self.MyTableView.reloadList()
        return tables.filter({ $0.staff.id == staffId})
    }
    
    func emoji(data : TableResponse) -> String {
        return getEmotion(emotion: data.table.emotion, tableStatus: data.table.table_status)
    }
    
    func status(data : TableResponse) -> String {
        return getTableStatus(tableStatus: data.table.table_status)
    }
    
    func viewColor(data : TableResponse) -> UIColor {
        return getCardColor(tableStatus: data.table.table_status)
    }

    
    
}
