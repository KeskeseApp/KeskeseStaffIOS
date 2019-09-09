//
//  ChoiceLoginMethodVC.swift
//  KeskeseStaff
//
//  Created by NI Vol on 8/1/19.
//  Copyright © 2019 Keskese. All rights reserved.
//

import UIKit

class ChoiceLoginMethodVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("age \(defaults.integer(forKey: "Age"))")
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }


}
