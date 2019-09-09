//
//  ProfileVC.swift
//  KeskeseStaff
//
//  Created by NI Vol on 8/16/19.
//  Copyright © 2019 Keskese. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController, UITableViewDelegate {

    @IBOutlet weak var profileImageBtn: UIButton!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var codeLbl: UILabel!
    @IBOutlet weak var workPlaceLbl: UILabel!
    @IBOutlet weak var statysLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userData()
        
    }
    
    func userData(){
        nameLbl.text = staff.name
        statysLbl.text = "Статус : \(userType!)"
        codeLbl.text = staff.code
    }

}
