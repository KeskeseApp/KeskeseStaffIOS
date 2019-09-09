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
    
    func emoji(indexPath : IndexPath) -> String {
        let data = View.tablesResponse[indexPath.row]
        return getEmotion(emotion: data.table.emotion, tableStatus: data.table.table_status)
    }
    
    func status(indexPath : IndexPath) -> String {
        let data = View.tablesResponse[indexPath.row]
        return getTableStatus(tableStatus: data.table.table_status)
    }
    
    func viewColor(indexPath : IndexPath) -> UIColor {
        let data = View.tablesResponse[indexPath.row]
        return getCardColor(tableStatus: data.table.table_status)
    }
}
