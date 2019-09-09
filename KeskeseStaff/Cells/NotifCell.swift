//
//  NotifCell.swift
//  KeskeseStaff
//
//  Created by NI Vol on 8/13/19.
//  Copyright © 2019 Keskese. All rights reserved.
//

import UIKit

class NotifCell: UITableViewCell {

    @IBOutlet weak var BG: UIView!
    @IBOutlet weak var indexBG: UIView!
    @IBOutlet weak var indexLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var statysLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
