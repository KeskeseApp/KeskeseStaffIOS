//
//  StaffObj.swift
//  KeskeseStaff
//
//  Created by NI Vol on 8/23/19.
//  Copyright © 2019 Keskese. All rights reserved.
//

import UIKit

class StaffObj: NSObject {
    @IBOutlet weak var View: StaffVC!
    @IBOutlet weak var ChefView: TablesForCheffVC!
    
    func emoji(indexPath : IndexPath, viewIndex : Int) -> String {
        if viewIndex == 0{
            let data = View.tablesResponse[indexPath.row]
            return getEmotion(emotion: data.table.emotion, tableStatus: data.table.table_status)
        } else {
            let data = ChefView.tablesResponse[indexPath.row]
            return getEmotion(emotion: data.table.emotion, tableStatus: data.table.table_status)
        }
    }
    
    func status(indexPath : IndexPath, viewIndex : Int) -> String {
        if viewIndex == 0{
            let data = View.tablesResponse[indexPath.row]
            return getTableStatus(tableStatus: data.table.table_status)
        } else {
            let data = ChefView.tablesResponse[indexPath.row]
            return getTableStatusChef(tableStatus: data.table.table_status)
        }
        
    }
    
    func viewColor(indexPath : IndexPath, viewIndex : Int) -> UIColor {
        if viewIndex == 0{
            let data = View.tablesResponse[indexPath.row]
            return getCardColor(tableStatus: data.table.table_status)
        } else {
            let data = ChefView.tablesResponse[indexPath.row]
            return getCardColorChef(tableStatus: data.table.table_status)
        }
        
    }
   
}
