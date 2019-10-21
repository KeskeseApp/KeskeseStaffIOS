//
//  FeedBackCell.swift
//  KeskeseStaff
//
//  Created by NI Vol on 9/24/19.
//  Copyright © 2019 Keskese. All rights reserved.
//

import UIKit

class FeedBackCell: UITableViewCell {

    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var staffNameLbl: UILabel!
    @IBOutlet weak var commentIndexLbl: UILabel!
    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var BG: UIView!
    @IBOutlet weak var indexBG: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
