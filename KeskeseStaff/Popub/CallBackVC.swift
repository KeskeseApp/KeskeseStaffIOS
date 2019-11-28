//
//  CallBackVC.swift
//  KeskeseStaff
//
//  Created by NI Vol on 8/25/19.
//  Copyright © 2019 Keskese. All rights reserved.
//

import UIKit

class CallBackVC: UIViewController {

    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var tableIndexLbl: UILabel!
    @IBOutlet weak var callBackBtn: UIButton!
    @IBOutlet weak var bgView: UIView!
    
    var data : TableResponse!
    var notifData : NotifGuest!
    var adminNotifData : AdminNotif!
    
    var lastView : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UI()
    }
    
    func UI(){
        
        switch lastView {
        case "notif":
            setData(color: getCardColor(tableStatus: notifData.type), number: String(notifData.table?.number ?? 0), time: notifData.time)
            
        case "admin":
            setData(color: getCardColor(tableStatus: adminNotifData.type), number: String("adminNotifData.staff"), time: adminNotifData.time ?? "null")
        
        default:
            
            setData(color: getCardColor(tableStatus: data.table.table_status), number: String(data.table.number), time: "")
            
        }
        
    }
    
    func setData(color : UIColor, number : String , time : String){
        bgView.backgroundColor = color
        callBackBtn.backgroundColor = color
        tableIndexLbl.backgroundColor = color
        
        tableIndexLbl.text = number
        timeLbl.text = time
        
    }
    @IBAction func cancelBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func callBackBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
