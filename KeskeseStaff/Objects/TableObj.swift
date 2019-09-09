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
    
    func getTables(){
        getTablesForSpot(spotID: staff.spot!).responseJSON{
            (response) in
            switch response.result {
            case .success(_):
                tablesResponse = response.data!.createList(type: TableResponse.self)
                myTableResponse = self.sortMyTables(staffId: staff!.id!, tables: tablesResponse)
                self.View.stopAnimating()
                self.View.reloadList()
                
                break
            case .failure(let error):
                self.View.stopAnimating()
                self.View.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                print(error)
                break
            }
        }
        
    }
    
    func sortMyTables(staffId : Int, tables: [TableResponse]) -> [TableResponse]{
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
