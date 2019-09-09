//
//  tableElemCell.swift
//  KeskeseStaff
//
//  Created by NI Vol on 8/12/19.
//  Copyright © 2019 Keskese. All rights reserved.
//

import UIKit

class tableElemCell: UICollectionViewCell {

    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var tableNumber: UILabel!
    @IBOutlet weak var emotionLbl: UILabel!
    
    @IBOutlet weak var staffImgBG: UIView!
    @IBOutlet weak var staffImage: UIImageView!
    @IBOutlet weak var staffName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
